import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/game_player_settings.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:provider/provider.dart';

import 'seat_change_bottom_sheet.dart';
import 'waiting_list.dart';

class GameOption extends StatefulWidget {
  final String gameCode;
  final String playerUuid;
  final bool isAdmin;
  final GameState gameState;
  final GameContextObject gameContextObject;
  final bool focusOnWaitingList;

  GameOption(this.gameContextObject, this.gameState, this.gameCode,
      this.playerUuid, this.isAdmin, this.focusOnWaitingList);

  @override
  _GameOptionState createState() => _GameOptionState(gameState);
}

class _GameOptionState extends State<GameOption> {
  String gameCode;
  bool isFetching = true;
  List<OptionItemModel> gameActions;
  double height;
  GameInfoModel gameInfo;
  bool closed = false;
  AppTextScreen _appScreenText;
  GameSettings _gameSettings;
  GamePlayerSettings _gamePlayerSettings;
  bool audioConfEnabled = false;
  bool straddleEnabled = false;
  bool bombPotEnabled = false;

  _GameOptionState(GameState gameState) {
    this._gameSettings = gameState.gameSettings;
    this.gameInfo = gameState.gameInfo;
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  void onLeave() async {
    // Dismisses bottomsheet
    Navigator.of(context).pop();

    if (widget.gameState.isGameRunning) {
      GameService.leaveGame(this.gameCode);

      Alerts.showNotification(
        titleText: _appScreenText['game'],
        svgPath: 'assets/images/casino.svg',
        subTitleText: _appScreenText['youWillStandupAfterThisHand'],
      );
    } else {
      await GameService.leaveGame(this.gameCode);
      widget.gameState.refresh();
    }
  }

  void onEndGame() async {
    Navigator.of(context).pop();
    if (widget.gameState.isGameRunning) {
      GameService.endGame(this.gameCode);
    } else {
      await GameService.endGame(this.gameCode);
      widget.gameState.refresh();
    }
  }

  void onPause() {
    Alerts.showNotification(
        titleText: _appScreenText['pause'],
        leadingIcon: Icons.pause_circle_outline,
        subTitleText: _appScreenText['theGameWillPauseAfterThisHand']);
    Navigator.of(context).pop();

    GameService.pauseGame(this.gameCode);
  }

  void onBreak() {
    Alerts.showNotification(
        titleText: _appScreenText['break'],
        leadingIcon: Icons.time_to_leave,
        subTitleText: _appScreenText['takeBreakAfterThisHand']);
    Navigator.of(context).pop();
    GameService.takeBreak(this.gameCode);
  }

  void onReload() async {
    // get current player's stack
    final me = widget.gameState.me;

    if (me != null) {
      if (me.stack >= widget.gameState.gameInfo.buyInMax) {
        Navigator.of(context).pop();
        showAlertDialog(context, "${_appScreenText['reload']}",
            _appScreenText['stackIsGreaterThankMaxBuyIn']);
        return;
      }
      double reloadMax = widget.gameState.gameInfo.buyInMax - me.stack;
      int reloadMin = 1;
      /* use numeric keyboard to get reload value */
      double value = await NumericKeyboard2.show(
        context,
        title: 'Reload ($reloadMin - $reloadMax)',
        min: reloadMin.toDouble(),
        max: reloadMax.toDouble(),
        decimalAllowed: gameInfo.chipUnit == ChipUnit.CENT,
      );

      if (value == null) return;

      final ret = await GameService.reload(gameCode, value);
      if (!ret.approved) {
        if (ret.insufficientCredits) {
          String message =
              'Not enough credits available. Available credits: ${DataFormatter.chipsFormat(ret.availableCredits)}';
          await showErrorDialog(context, 'Credits', message);
        } else if (ret.pendingRequest) {
          await showErrorDialog(context, 'Reload',
              'There is a pending reload request. Cannot make another request.');
        } else if (ret.waitingForApproval) {
          await showErrorDialog(context, 'Reload',
              'Your reload request is pending for host approval.');
        }
      } else {
        if (ret.appliedNextHand) {
          // show notification
          Alerts.showNotification(
              titleText: 'Reload',
              subTitleText: 'Reload is approved. Applied in next hand.');
        }
      }
      Navigator.of(context).pop();
    }
  }

  void onResume() {
    // final snackBar = SnackBar(
    //   content: Text('Resume game is not implemented'),
    //   duration: Duration(seconds: 30),
    //   backgroundColor: Colors.black38,
    // );
    // Scaffold.of(context).showSnackBar(snackBar);

    //GameService.resumeGame(this.gameCode);
  }

  List<OptionItemModel> gameSecondaryOptions;

  Future<void> _fetchGameInfo() async {
    gameInfo = await GameService.getGameInfo(gameCode);
    if (gameInfo != null) {
      audioConfEnabled = gameInfo.audioConfEnabled;
      straddleEnabled = gameInfo.utgStraddleAllowed;
    }
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("gameOption");
    gameCode = widget.gameCode;
    _gameSettings = widget.gameState.gameSettings;
    _gamePlayerSettings = widget.gameState.playerSettings;
    gameSecondaryOptions = [];
    _fetchGameInfo().then((value) {
      isFetching = false;
      setState(() {});
    });
  }

  Widget _buildCheckBox({
    @required String text,
    @required bool value,
    @required void onChange(bool _),
    String activeText = 'On',
    String inactiveText = 'Off',
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SwitchWidget(
        activeText: activeText,
        inactiveText: inactiveText,
        label: text,
        value: value,
        onChange: (value) {
          onChange(value);
        },
      ),
    );
  }

  Widget _buildBasicGameOptions({
    @required final bool isPlaying,
    @required final bool isHost,
    @required final AppTheme theme,
  }) {
    //List<OptionItemModel> gameActions = [];
    List<Widget> gameActions = [];

    if (isPlaying) {
      gameActions.addAll([
        CircleImageButton(
          theme: theme,
          caption: _appScreenText['standup'],
          icon: Icons.exit_to_app_sharp,
          onTap: () async {
            final response = await showPrompt(
              context,
              'Standup',
              "Do you want to leave the game?",
              positiveButtonText: 'Yes',
              negativeButtonText: 'No',
            );
            if (response == true) {
              this.onLeave();
            }
          },
        ),
      ]);
      gameActions.add(SizedBox(width: 20));
      // gameActions.addAll([
      //   OptionItemModel(
      //     title: _appScreenText['standup'],
      //     iconData: Icons.exit_to_app_sharp,
      //     onTap: (context) {
      //       this.onLeave();
      //     },
      //   ),
      // ]);
      final me = widget.gameState.me;
      if (me != null && me.stack < widget.gameState.gameInfo.buyInMax) {
        gameActions.add(
          CircleImageButton(
            theme: theme,
            caption: _appScreenText['reload'],
            icon: Icons.shop,
            onTap: () {
              this.onReload();
            },
          ),
        );
        gameActions.add(SizedBox(width: 20));
      }
    }

    if (widget.gameState.isGameRunning) {
      if (isPlaying) {
        gameActions.add(
          CircleImageButton(
            theme: theme,
            caption: _appScreenText['break'],
            svgAsset: 'assets/images/game/break.svg',
            onTap: () {
              this.onBreak();
            },
          ),
        );
        gameActions.add(SizedBox(width: 20));
      }

      if (isHost) {
        gameActions.add(
          CircleImageButton(
            theme: theme,
            caption: _appScreenText['pause'],
            icon: Icons.pause,
            onTap: () {
              this.onPause();
            },
          ),
        );
        gameActions.add(SizedBox(width: 20));
      }
    }

    if (isHost) {
      gameActions.add(
        CircleImageButton(
          theme: theme,
          caption: _appScreenText['terminate'],
          icon: Icons.cancel,
          onTap: () async {
            final response = await showPrompt(
                context, 'End Game', "Do you want to end the game?",
                positiveButtonText: 'Yes', negativeButtonText: 'No');
            if (response != null && response == true) {
              this.onEndGame();
            }
          },
        ),
      );
      gameActions.add(SizedBox(width: 20));
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 16),
      width: double.infinity,
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      child: Wrap(
        alignment: WrapAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: gameActions,
      ),
    );
  }

  Future<void> updateGameSettings() async {
    final res =
        await GameSettingsService.updateGameSettings(gameCode, _gameSettings);
    if (res) {
      Alerts.showNotification(titleText: "Settings updated!");
    }
  }

  Future<void> updateGamePlayerSettings() async {
    final res = await GameSettingsService.updateGamePlayerSettings(
        gameCode, _gamePlayerSettings);
    if (res) {
      Alerts.showNotification(titleText: "Settings updated!");
    }
  }

  Widget _buildGameSettingOptions(AppTheme theme) {
    if (_gameSettings == null) {
      return CircularProgressWidget();
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
// TODO : Audio conference is already in player settings. do we need here also?
            AppDimensionsNew.getVerticalSizedBox(8),
            // Show chat only if he is admin
            Visibility(
              visible: widget.isAdmin,
              child: _buildCheckBox(
                text: "Audio Conference",
                value: gameInfo.audioConfEnabled,
                onChange: (bool v) {
                  gameInfo.audioConfEnabled = v;
                },
              ),
            ),

            _buildCheckBox(
              text: 'Double board every hand',
              value: _gameSettings.doubleBoardEveryHand,
              onChange: (bool v) async {
                _gameSettings.doubleBoardEveryHand = v;
                await updateGameSettings();

                if (closed) return;
                setState(() {});
              },
            ),
            Container(
              decoration: _gameSettings.seatChangeAllowed
                  ? AppDecorators.tileDecorationWithoutBorder(theme)
                  : BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // allow player seat change
                  _buildCheckBox(
                    text: 'Allow player seat change',
                    value: _gameSettings.seatChangeAllowed,
                    onChange: (bool v) async {
                      _gameSettings.seatChangeAllowed = v;
                      await updateGameSettings();

                      if (closed) return;
                      setState(() {});
                    },
                  ),

                  // Prompt timeout
                  Visibility(
                      visible: _gameSettings.seatChangeAllowed,
                      child: Container(
                        padding: EdgeInsets.only(left: 16, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prompt timeout"),
                            RadioListWidget(
                                defaultValue: _gameSettings.seatChangeTimeout,
                                values: [10, 15, 20, 30],
                                onSelect: (int val) async {
                                  _gameSettings.seatChangeTimeout = val;
                                  await updateGameSettings();
                                  if (closed) return;
                                  setState(() {});
                                }),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            // allow waiting list
            _buildCheckBox(
              text: 'Allow waiting list',
              value: _gameSettings.waitlistAllowed,
              onChange: (bool v) async {
                _gameSettings.waitlistAllowed = v;
                await updateGameSettings();

                if (closed) return;
                setState(() {});
              },
            ),

            // bomb pot
            Container(
              decoration: _gameSettings.bombPotEnabled
                  ? AppDecorators.tileDecorationWithoutBorder(theme)
                  : BoxDecoration(),
              child: Column(
                children: [
                  _buildCheckBox(
                    text: 'Bomb Pot',
                    value: _gameSettings.bombPotEnabled,
                    onChange: (bool v) async {
                      _gameSettings.bombPotEnabled = v;
                      if (_gameSettings.bombPotIntervalInSecs == 0) {
                        _gameSettings.bombPotIntervalInSecs = 30 * 60;
                      }
                      await updateGameSettings();
                      if (closed) return;
                      setState(() {});
                    },
                  ),
                  _gameSettings.bombPotEnabled
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // choose interval label
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 10.0, left: 10.0, right: 10.0),
                                child: Text(
                                  'Choose Interval',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                              ),
                              // choose interval
                              RadioListWidget(
                                defaultValue:
                                    _gameSettings.bombPotInterval == null
                                        ? 30
                                        : _gameSettings.bombPotInterval,
                                values: [2, 15, 30, 60, 90, 120],
                                onSelect: (int value) async {
                                  _gameSettings.bombPotInterval = value;
                                  await updateGameSettings();
                                },
                              ),
                              // choose bomb pot size
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 10.0, left: 10.0, right: 10.0),
                                child: Text(
                                  'Bomb Pot Bet Size (x BB)',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                              ),
                              // choose interval
                              RadioListWidget(
                                defaultValue: _gameSettings.bombPotBet == null
                                    ? 5
                                    : _gameSettings.bombPotBet,
                                values: [2, 5, 10, 15, 20],
                                onSelect: (int value) async {
                                  _gameSettings.bombPotBet = value;
                                  await updateGameSettings();
                                },
                              ),

                              // every hand
                              _buildCheckBox(
                                text: 'Every Hand',
                                value: _gameSettings.bombPotEveryHand,
                                onChange: (bool v) async {
                                  _gameSettings.bombPotEveryHand = v;
                                  if (closed) return;
                                  await updateGameSettings();
                                  setState(() {});
                                },
                              ),

                              // double board
                              _buildCheckBox(
                                text: 'Double Board',
                                value: _gameSettings.doubleBoardBombPot,
                                onChange: (bool v) async {
                                  _gameSettings.doubleBoardBombPot = v;
                                  if (closed) return;
                                  await updateGameSettings();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            AppDimensionsNew.getVerticalSizedBox(8),
            // break allowed
            Container(
              decoration: _gameSettings.breakAllowed
                  ? AppDecorators.tileDecorationWithoutBorder(theme)
                  : BoxDecoration(),
              child: Column(
                children: [
                  _buildCheckBox(
                    text: 'Player Break Allowed',
                    value: _gameSettings.breakAllowed,
                    onChange: (bool v) async {
                      _gameSettings.breakAllowed = v;
                      if (_gameSettings.breakLength == null ||
                          _gameSettings.breakLength == 0) {
                        _gameSettings.breakLength = 3;
                      }
                      await updateGameSettings();
                      if (closed) return;
                      setState(() {});
                    },
                  ),
                  _gameSettings.breakAllowed
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // choose interval label
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 10.0, left: 10.0, right: 10.0),
                                child: Text(
                                  'Break Length (in mins)',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                              ),
                              // choose interval
                              RadioListWidget(
                                defaultValue: _gameSettings.breakLength == null
                                    ? 3
                                    : _gameSettings.breakLength,
                                values: [1, 3, 5, 10, 15],
                                onSelect: (int value) async {
                                  _gameSettings.breakLength = value;
                                  await updateGameSettings();
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),

            AppDimensionsNew.getVerticalSizedBox(8),
            _buildCheckBox(
              text: 'Run It Twice Allowed',
              value: _gameSettings.runItTwiceAllowed ?? false,
              onChange: (bool v) async {
                _gameSettings.runItTwiceAllowed = v;
                if (closed) return;
                await updateGameSettings();
                setState(() {});
              },
            ),

            AppDimensionsNew.getVerticalSizedBox(8),
            // show animations
            _buildCheckBox(
              text: 'Fun Animations',
              value: _gameSettings.funAnimations ?? false,
              onChange: (bool v) async {
                _gameSettings.funAnimations = v;
                if (closed) return;
                await updateGameSettings();
                setState(() {});
              },
            ),
            AppDimensionsNew.getVerticalSizedBox(8),

            // show animations
            _buildCheckBox(
              text: 'Show Chat',
              value: _gameSettings.chat ?? false,
              onChange: (bool v) async {
                _gameSettings.chat = v;
                if (closed) return;
                await updateGameSettings();
                setState(() {});
              },
            ),

            // ROE GAMES
            Visibility(
              visible: widget.gameState.gameInfo.gameType == "ROE",
              child: ListTile(
                title: Text(
                  "ROE games",
                  style: AppDecorators.getHeadLine4Style(theme: theme),
                ),
                subtitle: Text(
                  HelperUtils.buildGameTypeStrFromList(
                      [GameType.HOLDEM, GameType.PLO]),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.mode_edit_rounded),
                  onPressed: () async {
                    final res = await Alerts.showChooseGamesDailog(
                        [GameType.HOLDEM, GameType.PLO],
                        context,
                        theme,
                        widget.gameState.gameSettings.dealerChoiceOrbit,
                        gameState: widget.gameState,
                        valueChangeFunction: () => updateGameSettings());

                    if (res != null && res.isNotEmpty) {
                      widget.gameState.gameSettings.roeGames = res;
                      await updateGameSettings();
                      setState(() {});
                    }
                  },
                ),
              ),
            ),

// DEALER CHOICE GAMES
            Visibility(
              visible: widget.gameState.gameInfo.gameType == "DEALER_CHOICE",
              child: ListTile(
                title: Text(
                  "Dealer Games",
                  style: AppDecorators.getHeadLine4Style(theme: theme),
                ),
                subtitle: Text(
                  HelperUtils.buildGameTypeStrFromList(
                      [GameType.HOLDEM, GameType.PLO]),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.mode_edit_rounded),
                  onPressed: () async {
                    final res = await Alerts.showChooseGamesDailog(
                        [GameType.HOLDEM, GameType.PLO],
                        context,
                        theme,
                        widget.gameState.gameSettings.dealerChoiceOrbit,
                        gameState: widget.gameState,
                        valueChangeFunction: () => updateGameSettings());

                    if (res != null && res.isNotEmpty) {
                      widget.gameState.gameSettings.dealerChoiceGames = res;
                      await updateGameSettings();
                      setState(() {});
                    }
                  },
                ),
              ),
            ),

            AppDimensionsNew.getVerticalSizedBox(8),
            // results wait label
            AppDimensionsNew.getVerticalSizedBox(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // label
                Container(
                  margin:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    'Pause showdown (in seconds)',
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),

                // result wait
                RadioListWidget(
                  defaultValue: _gameSettings.resultPauseTime,
                  values: [3, 5, 10, 15],
                  onSelect: (int value) async {
                    _gameSettings.resultPauseTime = value;
                    await updateGameSettings();
                    if (closed) {
                      return;
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingList(AppTheme theme) {
    return WaitingListBottomSheet(widget.gameState, widget.gameState.gameCode,
        widget.gameState.currentPlayerUuid);
  }

  Widget _buildLabel(String label, AppTheme theme) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          label,
          style: AppDecorators.getHeadLine4Style(theme: theme),
        ),
      );

  Widget _buildPlayerSettingOptions(AppTheme theme) {
    if (_gameSettings == null) {
      return CircularProgressWidget();
    }
    List<Widget> children = [];

    if (widget.gameState.audioConfEnabled) {
      children.add(_buildCheckBox(
          text: 'Participate in Audio Conference',
          value: widget.gameState.playerLocalConfig.inAudioConference ?? false,
          onChange: (bool v) async {
            widget.gameState.playerLocalConfig.inAudioConference = v;
            if (v) {
              // join
              widget.gameContextObject.joinAudio(context).then((v) {
                widget.gameState.gameMessageService.sendMyInfo();
              });
            } else {
              widget.gameContextObject?.leaveAudio();
            }

            widget.gameState.communicationState.notify();
            if (closed) return;
            setState(() {});
          }));
    }

    // Muck loosing hand
    children.add(_buildCheckBox(
        text: _appScreenText['muckLosingHand'],
        value: widget.gameState.playerSettings.muckLosingHand ?? false,
        onChange: (bool v) async {
          await GameService.updateGameConfig(widget.gameState.gameCode,
              muckLosingHand: v);
          // setting the value saves it to local storage too
          widget.gameState.playerSettings.muckLosingHand = v;
          //update player settings to server.
          _gamePlayerSettings.muckLosingHand = v;
          await updateGamePlayerSettings();
          if (closed) return;
          setState(() {});
        }));

    if (widget.gameState.gameSettings.runItTwiceAllowed) {
      // Run it twice
      children.add(_buildCheckBox(
        text: _appScreenText['promptRunItTwice'],
        value: _gamePlayerSettings.runItTwiceEnabled,
        onChange: (bool v) async {
          _gamePlayerSettings.runItTwiceEnabled = v;
          await updateGamePlayerSettings();
          if (closed) return;
          setState(() {});
        },
      ));
    }

    // Game sounds
    children.add(_buildCheckBox(
      text: _appScreenText['gameSounds'],
      value: widget.gameState.playerLocalConfig.gameSound,
      onChange: (bool v) async {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.gameSound = v;
        log('In toggle button widget, gameSounds = ${widget.gameState.playerLocalConfig.gameSound}');
        if (closed) return;
        setState(() {});
      },
    ));

    // show Check/fold
    children.add(_buildCheckBox(
      text: _appScreenText['gameCheckFold'],
      value: widget.gameState.playerLocalConfig.showCheckFold,
      onChange: (bool v) async {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.showCheckFold = v;
        log('In toggle button widget, Show Check Fold = ${widget.gameState.playerLocalConfig.showCheckFold}');
        if (closed) return;
        setState(() {});
      },
    ));

    bool showHandStrength =
        true; //widget.gameState.playerLocalConfig.showHandRank;
    if (!widget.gameState.gameSettings.showHandRank) {
      showHandStrength = false;
    }
    if (showHandStrength) {
      // show Hand Rank
      children.add(_buildCheckBox(
        text: _appScreenText['handRank'],
        value: widget.gameState.playerLocalConfig.showHandRank,
        onChange: (bool v) async {
          // setting the value saves it to local storage too
          widget.gameState.playerLocalConfig.showHandRank = v;
          log('In toggle button widget, Show Hank Rank = ${widget.gameState.playerLocalConfig.showHandRank}');
          if (closed) return;
          setState(() {});
        },
      ));
    }

    // color cards
    children.add(_buildCheckBox(
      text: _appScreenText['colorCards'],
      value: widget.gameState.playerLocalConfig.colorCards,
      onChange: (bool v) async {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.colorCards = v;
        log('In toggle button widget, Color Cards = ${widget.gameState.playerLocalConfig.colorCards}');
        if (closed) return;
        setState(() {});
        widget.gameState.tableState.notifyAll();
        // widget.gameState.tableState.refreshCommunityCards(colorCards: v);
        widget.gameState.redrawFooter();
      },
    ));

    // show ReArrage
    children.add(_buildCheckBox(
      text: _appScreenText['showRearrange'],
      value: widget.gameState.playerLocalConfig.showRearrange,
      onChange: (bool v) async {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.showRearrange = v;
        log('In toggle button widget, Show showRearrange = ${widget.gameState.playerLocalConfig.showRearrange}');
        if (closed) return;
        setState(() {});
      },
    ));

    // Animations
    children.add(_buildCheckBox(
      text: 'Animations',
      value: widget.gameState.playerLocalConfig.animations,
      onChange: (bool v) async {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.animations = v;
        log('In toggle button widget, animations = ${widget.gameState.playerLocalConfig.animations}');
        if (closed) return;
        setState(() {});
      },
    ));

    // // tap to bet VS swipe to bet
    // children.add(Container(
    //   width: double.infinity,
    //   padding: EdgeInsets.all(10),
    //   decoration: AppStylesNew.actionRowDecoration,
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // main text
    //             const Text(
    //               'Bet Action',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 18.0,
    //               ),
    //             ),
    //             // hint text
    //             const Text(
    //               '(applied in next action)',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 13.0,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),

    //       // tap / swipe button
    //       // false ==> swipe is active
    //       Expanded(
    //         child: CupertinoSegmentedControl<bool>(
    //           borderColor: theme.accentColor, //const Color(0xff40D876),
    //           selectedColor: theme.secondaryColor, //const Color(0xff40D876),
    //           groupValue:
    //               widget.gameState.playerLocalConfig.tapOrSwipeBetAction,
    //           children: {
    //             false: Text('Swipe', style: TextStyle(fontSize: 18.0)),
    //             true: Text('Tap', style: TextStyle(fontSize: 18.0)),
    //           },
    //           onValueChanged: (bool v) async {
    //             widget.gameState.playerLocalConfig.tapOrSwipeBetAction = v;
    //             await updateGamePlayerSettings();
    //             log('In toggle button widget, tapOrSwipeBetAction = ${widget.gameState.playerLocalConfig.tapOrSwipeBetAction}');
    //             if (closed) return;
    //             setState(() {});
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // ));

    /* show straddle off and auto straddle options ONLY when the UTG STRADDLE is on */

    // UTG straddle
    if (widget.gameState.gameInfo.utgStraddleAllowed) {
      children.add(Container(
        decoration: widget.gameState.gameInfo.utgStraddleAllowed ?? false
            ? AppDecorators.tileDecorationWithoutBorder(theme)
            : BoxDecoration(),
        child: Column(
          children: [
            _buildCheckBox(
              text: 'UTG Straddle',
              value: widget.gameState.playerLocalConfig.straddle,
              onChange: (bool v) async {
                widget.gameState.playerLocalConfig.straddle = v;
                if (!v) {
                  _gamePlayerSettings.autoStraddle = false;
                }
                await updateGamePlayerSettings();
                log('In toggle button widget, straddleOption = ${widget.gameState.playerLocalConfig.straddle}');
                if (closed) return;
                setState(() {});
              },
            ),
            widget.gameState.playerLocalConfig.straddle
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // choose interval label
                        Container(
                          margin: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          child: _buildCheckBox(
                            text: 'Auto',
                            value: widget.gameState.playerSettings.autoStraddle,
                            onChange: (bool v) async {
                              widget.gameState.playerSettings.autoStraddle = v;
                              _gamePlayerSettings.autoStraddle = v;
                              await updateGamePlayerSettings();
                              log('In toggle button widget, straddleOption = ${widget.gameState.playerLocalConfig.straddle}');
                              if (closed) return;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ));
    }

    if (gameInfo.buttonStraddleAllowed) {
      int straddleRange = gameInfo.buttonStraddleBet - 2;
      if (straddleRange == 0) {
        // only 2x bb straddle is available
        children.add(_buildCheckBox(
          text: 'Button Straddle',
          value: _gamePlayerSettings.buttonStraddle,
          onChange: (bool v) async {
            // setting the value saves it to local storage too
            _gamePlayerSettings.buttonStraddle = v;
            if (closed) return;
            setState(() {});
          },
        ));
      } else {
        children.add(
          Container(
            decoration: _gamePlayerSettings.buttonStraddle
                ? AppDecorators.tileDecorationWithoutBorder(theme)
                : BoxDecoration(),
            child: Column(
              children: [
                _buildCheckBox(
                  text: 'Button Straddle',
                  value: _gamePlayerSettings.buttonStraddle,
                  onChange: (bool v) async {
                    _gamePlayerSettings.buttonStraddle = v;
                    await updateGamePlayerSettings();
                    if (closed) return;
                    setState(() {});
                  },
                ),
                _gamePlayerSettings.buttonStraddle
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: ListenableProvider<ValueNotifier<double>>(
                            create: (_) => ValueNotifier<double>(
                                  _gamePlayerSettings.buttonStraddleBet
                                      .toDouble(),
                                ),
                            builder: (BuildContext context, _) {
                              final valueNotifierVal =
                                  context.read<ValueNotifier<double>>();
                              return Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: _buildLabel(
                                          'Straddle Bet (x BB)', theme)),
                                  Text(
                                    _gamePlayerSettings.buttonStraddleBet
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  ValueListenableBuilder<double>(
                                      valueListenable: valueNotifierVal,
                                      builder: (_, double straddleAmount, __) {
                                        return Slider(
                                          value: _gamePlayerSettings
                                              .buttonStraddleBet
                                              .toDouble(),
                                          // thumbColor: theme.accentColor,
                                          activeColor: theme.secondaryColor,
                                          inactiveColor:
                                              theme.primaryColorWithDark(),
                                          min: 2,
                                          max: gameInfo.buttonStraddleBet
                                              .toDouble(),
                                          divisions:
                                              gameInfo.buttonStraddleBet - 2,
                                          label: _gamePlayerSettings
                                              .buttonStraddleBet
                                              .round()
                                              .toString(),
                                          onChanged: (double value) async {
                                            _gamePlayerSettings
                                                    .buttonStraddleBet =
                                                value.toInt();
                                            updateGamePlayerSettings()
                                                .then((value) {
                                              if (closed) return;
                                              setState(() {});
                                            });
                                          },
                                        );
                                      })
                                ],
                              );
                            }))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      }
    }

    // need local variable for bombpot in gameInfo
    // children.add(Visibility(
    //   visible: widget.gameState.gameInfo.buttonStraddleAllowed,
    //   child: _buildCheckBox(
    //     text: "Button Straddle",
    //     value: _gamePlayerSettings.buttonStraddle,
    //     onChange: (bool v) async {
    //       // setting the value saves it to local storage too
    //       _gamePlayerSettings.buttonStraddle = v;
    //       widget.gameState.playerSettings.buttonStraddle = v;
    //       await updateGamePlayerSettings();
    //       if (closed) return;
    //       setState(() {});
    //     },
    //   ),
    // ));

    // need local variable for bombpot in gameInfo
    children.add(Visibility(
      visible: widget.gameState.gameSettings.bombPotEnabled,
      child: _buildCheckBox(
        text: "Participate in Bomb Pot",
        value: _gamePlayerSettings.bombPotEnabled,
        onChange: (bool v) async {
          // setting the value saves it to local storage too
          _gamePlayerSettings.bombPotEnabled = v;
          widget.gameState.playerSettings.bombPotEnabled = v;
          await updateGamePlayerSettings();
          // widget.gameState.config.bombPot = v;
          log('In toggle button widget, gameSounds = ${widget.gameState.playerLocalConfig.gameSound}');
          if (closed) return;
          setState(() {});
        },
      ),
    ));

    // Chat setting
    children.add(_buildCheckBox(
      text: _appScreenText['chat'],
      value: widget.gameState.playerLocalConfig.showChat ??
          false, //widget.gameState.config.bombpot,
      onChange: (bool v) {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.showChat = v;
        // widget.gameState.config.bombPot = v;
        log('In toggle button widget, gameSounds = ${widget.gameState.playerLocalConfig.gameSound}');
        if (closed) return;
        setState(() {});
        widget.gameState.communicationState.notify();
      },
    ));

    // Vibration setting
    children.add(_buildCheckBox(
      text: _appScreenText['vibration'],
      value: widget.gameState.playerLocalConfig.vibration ??
          false, //widget.gameState.config.bombpot,
      onChange: (bool v) {
        // setting the value saves it to local storage too
        widget.gameState.playerLocalConfig.vibration = v;
        // widget.gameState.config.bombPot = v;
        log('In toggle button widget, gameSounds = ${widget.gameState.playerLocalConfig.gameSound}');
        if (closed) return;
        setState(() {});
        widget.gameState.communicationState.notify();
      },
    ));

// Participate in audio conference
    // _buildCheckBox(
    //   text: "Participate in Audio conference",
    //   value: widget.gameState.playerSettings.audioConf,
    //   onChange: (bool v) {
    //     widget.gameState.config.audioConf = v;
    //   },
    // ),
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...children,
            // seat change & waiting list settings
            ...gameSecondaryOptions
                .map(
                  (gameSecondaryOption) => gameSecondaryOptionItem(
                    gameSecondaryOption,
                    context,
                    theme,
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    final theme = AppTheme.getTheme(context);

    final bool isPlaying = widget.gameState.isPlaying;
    final bool isHost = context.read<GameContextObject>().isHost();

    if (_gameSettings == null || isFetching) {
      return CircularProgressWidget();
    }

    if (gameInfo == null) {
      return Center(
        child: const Text(
          'Game Ended',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    // add children
    List<Widget> children = [];
    List<Widget> tabs = [];
    int defaultIndex = 0;
    // ishost?, can change game settings
    if (isHost) {
      tabs.add(
        Tab(
          icon: Icon(Icons.settings),
          text: "Game",
        ),
      );
      children.add(
          // game settings to be shown here
          // 1. allow seat change player
          // 2. allow waiting list
          // 3. bomb pot
          // 4. audio conference
          // 5. pause time after each result
          _buildGameSettingOptions(theme));
    }

    if (isPlaying) {
      tabs.add(Tab(
        icon: Icon(Icons.settings),
        text: "Player",
      ));
      children.add(
          // player settings to be shown here
          // 1. muck losing hand
          // 2. straddle
          // 3. audio conference
          // 4. run it twice
          _buildPlayerSettingOptions(theme));
    }

    bool waitinglistAllowed = gameInfo.waitlistAllowed;
    if (waitinglistAllowed) {
      tabs.add(Tab(
        icon: Icon(Icons.queue),
        text: "Queue",
      ));
      children.add(_buildWaitingList(theme));
      if (widget.focusOnWaitingList) {
        defaultIndex = tabs.length - 1;
      }
    }

    if (_gameSettings.seatChangeAllowed) {
      tabs.add(Tab(
        icon: SvgPicture.asset('assets/images/game/transfer-up.svg',
            color: theme.accentColor),
        text: "Seat Change",
      ));
      children.add(SeatChangeBottomSheet(
        widget.gameState,
        widget.gameCode,
        widget.playerUuid,
      ));
    }

    if (children.length >= 1 && (isHost || isPlaying)) {
      return DefaultTabController(
        length: tabs.length,
        initialIndex: defaultIndex,
        child: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                // build the basic game options
                child: _buildBasicGameOptions(
                  isPlaying: isPlaying,
                  isHost: isHost,
                  theme: theme,
                ),
              ),
              SliverToBoxAdapter(
                // show tabs for game and player settings
                // child: TabBar(
                //   physics: const BouncingScrollPhysics(),
                //   tabs: tabs,
                //   indicatorSize: TabBarIndicatorSize.label,
                //   indicatorColor: theme.accentColor,
                //   //labelColor: theme.secondaryColorWithLight(),
                //   unselectedLabelColor: theme.secondaryColorWithDark(),
                // ),
                child: Center(
                    child: ButtonsTabBar(
                  backgroundColor: theme.accentColor,
                  unselectedBackgroundColor: Colors.black,
                  labelStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                      color: theme.accentColor, fontWeight: FontWeight.bold),
                  borderWidth: 2,
                  unselectedBorderColor: theme.accentColor,
                  radius: 30,
                  tabs: tabs,
                  contentPadding: EdgeInsets.all(10),
                  physics: ScrollPhysics(),
                  height: 50,
                )),
              ),
            ];
          },

          // show game and player settings body
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: children,
          ),
        ),
      );
    } else {
      return children[0];
    }
  }

  gameSecondaryOptionItem(
    OptionItemModel optionItemModel,
    BuildContext context,
    AppTheme theme,
  ) {
    return ListTile(
      onTap: () => optionItemModel.onTap(context),
      title: Text(
        optionItemModel.title,
        style: AppDecorators.getHeadLine4Style(theme: theme),
      ),
      leading: Container(
        decoration: AppDecorators.tileDecorationWithoutBorder(theme)
            .copyWith(color: optionItemModel.backGroundColor),
        padding: EdgeInsets.all(5),
        child: Image.asset(
          optionItemModel.image,
          height: 32.ph,
          width: 32.pw,
          color: theme.supportingColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: theme.accentColor,
      ),
      subtitle: optionItemModel.name != null
          ? Text(
              optionItemModel.name,
              style: AppDecorators.getSubtitle1Style(theme: theme),
            )
          : Container(),
    );
  }
}
