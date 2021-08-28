import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
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

  GameOption(this.gameState, this.gameCode, this.playerUuid, this.isAdmin);

  @override
  _GameOptionState createState() => _GameOptionState();
}

class _GameOptionState extends State<GameOption> {
  String gameCode;
  bool isFetching = true;
  List<OptionItemModel> gameActions;
  double height;
  GameInfoModel gameInfo;
  bool closed = false;
  AppTextScreen _appScreenText;
  GameSettingsInput _gameSettings;
  bool audioConfEnabled = false;
  bool straddleEnabled = false;
  bool bombPotEnabled = false;

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  void onLeave() async {
    // Dismisses bottomsheet
    Navigator.of(context).pop();
    if (widget.gameState.running) {
      Alerts.showNotification(
          titleText: _appScreenText['game'],
          svgPath: 'assets/images/casino.svg',
          subTitleText: _appScreenText['youWillStandupAfterThisHand']);
      GameService.leaveGame(this.gameCode);
    }

    if (!widget.gameState.running) {
      await GameService.leaveGame(this.gameCode);
      widget.gameState.refresh(context);
    }
  }

  void onEndGame() async {
    Navigator.of(context).pop();
    if (widget.gameState.isGameRunning) {
      Alerts.showNotification(
          titleText: _appScreenText['game'],
          svgPath: 'assets/images/casino.svg',
          subTitleText: _appScreenText['theGameWillEndAfterThisHand']);
      // We need to broadcast to all the players
      GameService.endGame(this.gameCode);
    } else {
      await GameService.endGame(this.gameCode);
      widget.gameState.refresh(context);
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
    Navigator.of(context).pop();

    // get current player's stack
    final me = widget.gameState.me(context);

    if (me != null) {
      if (me.stack >= widget.gameState.gameInfo.buyInMax) {
        showAlertDialog(context, "${_appScreenText['reload']}",
            _appScreenText['stackIsGreaterThankMaxBuyIn']);
        return;
      }
      int reloadMax = widget.gameState.gameInfo.buyInMax - me.stack;
      int reloadMin = 1;
      /* use numeric keyboard to get reload value */
      double value = await NumericKeyboard2.show(
        context,
        title: 'Reload ($reloadMin - $reloadMax)',
        min: reloadMin.toDouble(),
        max: reloadMax.toDouble(),
      );

      if (value == null) return;

      GameService.reload(gameCode, value.toInt());
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

  _fetchGameInfo() async {
    // Fetch gameSettings from server
    _gameSettings = await GameService.getGameSettings(gameCode);
    if (_gameSettings == null) {
      return;
    }

    gameInfo = await GameService.getGameInfo(gameCode);
    if (gameInfo != null) {
      if (closed) return;
      setState(() {
        isFetching = false;
      });
    }
    audioConfEnabled = gameInfo.audioConfEnabled;
    straddleEnabled = gameInfo.utgStraddleAllowed;
    // TODO modify gameinfo class to have bombpot variable
    bombPotEnabled = true;
    log("-=-= ${gameInfo.sessionTime}");
    log("-=-= ${gameInfo.runningTime}");
    log("-=-= ${gameInfo.noHandsPlayed}");
    log("-=-= ${gameInfo.noHandsWon}");
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("gameOption");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchGameInfo();
    });
    gameCode = widget.gameCode;
    gameActions = [
      OptionItemModel(
        title: _appScreenText['standup'],
        iconData: Icons.exit_to_app_sharp,
        onTap: (context) {
          this.onLeave();
        },
      ),
      OptionItemModel(
        title: _appScreenText['reload'],
        iconData: Icons.shop,
        onTap: (context) {
          this.onReload();
        },
      ),
    ];

    if (widget.gameState.running) {
      gameActions.add(
        OptionItemModel(
          title: _appScreenText['break'],
          iconData: Icons.shop,
          onTap: (context) {
            this.onBreak();
          },
        ),
      );
      if (widget.isAdmin) {
        gameActions.add(
          OptionItemModel(
            title: _appScreenText['pause'],
            iconData: Icons.pause,
            onTap: (context) {
              this.onPause();
            },
          ),
        );
      }
    }

    if (widget.isAdmin) {
      gameActions.add(OptionItemModel(
          title: _appScreenText['terminate'],
          iconData: Icons.cancel_outlined,
          onTap: (context) {
            this.onEndGame();
          }));
    }

    gameSecondaryOptions = [
      OptionItemModel(
        title: _appScreenText['seatChange'],
        image: "assets/images/casino.png",
        name: _appScreenText['requestSeatChange'],
        backGroundColor: Colors.redAccent,
        onTap: (context) async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) {
              return SeatChangeBottomSheet(
                widget.gameState,
                widget.gameCode,
                widget.playerUuid,
              );
            },
          );
        },
      ),
    ];

    gameSecondaryOptions.add(
      OptionItemModel(
          title: _appScreenText['waitingList'],
          image: "assets/images/casino.png",
          name: _appScreenText['addToWaitingList'],
          backGroundColor: Colors.blue,
          onTap: (context) async {
            await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  return WaitingListBottomSheet(
                      widget.gameState, widget.gameCode, widget.playerUuid);
                });
          }),
    );
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

  Widget _buildOtherGameOptions(AppTheme theme) => Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckBox(
                text: _appScreenText['muckLosingHand'],
                value: widget.gameState.gameInfo.playerMuckLosingHand,
                onChange: (bool v) async {
                  await GameService.updateGameConfig(widget.gameState.gameCode,
                      muckLosingHand: v);
                  // setting the value saves it to local storage too
                  widget.gameState.gameInfo.playerMuckLosingHand = v;
                  if (closed) return;
                  setState(() {});
                }),
            _buildCheckBox(
              text: _appScreenText['promptRunItTwice'],
              value: widget.gameState.gameInfo.playerRunItTwice,
              onChange: (bool v) async {
                await GameService.updateGameConfig(widget.gameState.gameCode,
                    runItTwicePrompt: v);
                // setting the value saves it to local storage too
                widget.gameState.gameInfo.playerRunItTwice = v;
                if (closed) return;
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: _appScreenText['gameSounds'],
              value: widget.gameState.settings.gameSound,
              onChange: (bool v) async {
                // setting the value saves it to local storage too
                widget.gameState.settings.gameSound = v;
                log('In toggle button widget, gameSounds = ${widget.gameState.settings.gameSound}');
                if (closed) return;
                setState(() {});
              },
            ),
            widget.gameState.gameInfo.audioConfEnabled ?? false
                ? _buildCheckBox(
                    text: _appScreenText['audioConference'],
                    value: widget.gameState.settings.audioConf,
                    onChange: (bool v) async {
                      // setting the value saves it to local storage too
                      widget.gameState.settings.audioConf = v;
                      widget.gameState.janusEngine.joinLeaveAudioConference();
                      log('In toggle button widget, audioConf = ${widget.gameState.settings.audioConf}');
                      if (closed) return;
                      setState(() {});
                    },
                  )
                : SizedBox(),
            _buildCheckBox(
              text: _appScreenText['animations'],
              value: widget.gameState.settings.animations,
              onChange: (bool v) async {
                // setting the value saves it to local storage too
                widget.gameState.settings.animations = v;
                log('In toggle button widget, animations = ${widget.gameState.settings.animations}');
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: _appScreenText['animations'],
              value: widget.gameState.settings.showChat,
              onChange: (bool v) async {
                // setting the value saves it to local storage too
                widget.gameState.settings.showChat = v;
                log('In toggle button widget, showChat = ${widget.gameState.settings.showChat}');
                widget.gameState.getCommunicationState().showTextChat = v;
                widget.gameState.getCommunicationState().notify();
                setState(() {});
              },
            ),

            /* show straddle off and auto straddle options ONLY when the UTG STRADDLE is on */
            widget.gameState.gameInfo.utgStraddleAllowed
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // straddle off
                      _buildCheckBox(
                        text: _appScreenText['straddle'],
                        value: widget.gameState.settings.straddleOption,
                        onChange: (bool v) async {
                          // setting the value saves it to local storage too
                          widget.gameState.settings.straddleOption = v;
                          log('In toggle button widget, straddleOption = ${widget.gameState.settings.straddleOption}');
                          if (closed) return;
                          setState(() {});
                        },
                      ),

                      // auto straddle
                      _buildCheckBox(
                        text: _appScreenText['autoStraddle'],
                        value: widget.gameState.settings.autoStraddle,
                        onChange: (bool v) async {
                          if (v) {
                            await FirebaseAnalytics().logEvent(
                                name: "Auto_Straddle",
                                parameters: {
                                  "name": "Auto Straddle is turned ON"
                                });
                          }
                          // setting the value saves it to local storage too
                          widget.gameState.settings.autoStraddle = v;
                          log('In toggle button widget, autoStraddle = ${widget.gameState.settings.autoStraddle}');
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );

  Widget _buildBasicGameOptions({
    @required final bool isPlaying,
    @required final AppTheme theme,
  }) {
    return !isPlaying
        ? SizedBox.shrink()
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(top: 16),
            width: double.infinity,
            decoration: AppDecorators.tileDecorationWithoutBorder(theme),
            child: Wrap(
              alignment: WrapAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...gameActions.map((e) => gameActionItem(e, theme)).toList(),
              ],
            ),
          );
  }

  Future<void> updateGameSettings() async {
    final res = await GameService.updateGameSettings(gameCode, _gameSettings);
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
                                    _gameSettings.bombPotIntervalInSecs,
                                values: [15, 30, 60, 90, 120],
                                onSelect: (int value) {
                                  _gameSettings.bombPotIntervalInSecs = value;
                                },
                              ),

                              // every hand
                              _buildCheckBox(
                                text: 'Every Hand',
                                value: _gameSettings.bombPotEveryHand,
                                onChange: (bool v) async {
                                  _gameSettings.bombPotEveryHand = v;
                                  if (closed) return;
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

            // TODO: SHOW THE FOLLOWING WIDGET, ONLY IF BOMB POT IS ACTIVE
            // bomb pot relates settings, SHOW only if bomb pot is ENABLED

            // results wait
            _buildCheckBox(
              text: 'Fun Animations',
              value: widget.gameState.settings.animations ?? true,
              onChange: (bool v) async {
                widget.gameState.settings.animations = v;
                if (closed) return;
                setState(() {});
              },
            ),

// TODO : Chat option already in Player Settings

            // results wait label
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // label
                Container(
                  margin:
                      EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    'Pause each result (in seconds)',
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),

                // result wait
                RadioListWidget(
                  defaultValue: _gameSettings.pauseEachResultInSecs,
                  values: [3, 5, 10, 15],
                  onSelect: (int value) async {
                    _gameSettings.pauseEachResultInSecs = value;
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

  Widget _buildPlayerSettingOptions(AppTheme theme) {
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
            // Muck loosing hand
            _buildCheckBox(
                text: _appScreenText['muckLosingHand'],
                value: widget.gameState.gameInfo.playerMuckLosingHand,
                onChange: (bool v) async {
                  await GameService.updateGameConfig(widget.gameState.gameCode,
                      muckLosingHand: v);
                  // setting the value saves it to local storage too
                  widget.gameState.gameInfo.playerMuckLosingHand = v;
                  if (closed) return;
                  setState(() {});
                }),

            // Run it twice
            _buildCheckBox(
              text: _appScreenText['promptRunItTwice'],
              value: _gameSettings.runItTwiceAllowed,
              onChange: (bool v) async {
                // await GameService.updateGameConfig(widget.gameState.gameCode,
                //     runItTwicePrompt: v);
                // setting the value saves it to local storage too
                _gameSettings.runItTwiceAllowed = v;
                await GameService.updateGameSettings(gameCode, _gameSettings);
                widget.gameState.gameInfo.playerRunItTwice = v;
                if (closed) return;
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: _appScreenText['gameSounds'],
              value: widget.gameState.settings.gameSound,
              onChange: (bool v) async {
                // setting the value saves it to local storage too
                widget.gameState.settings.gameSound = v;
                log('In toggle button widget, gameSounds = ${widget.gameState.settings.gameSound}');
                if (closed) return;
                setState(() {});
              },
            ),

            Visibility(
              visible: widget.gameState.gameInfo.audioConfEnabled ?? true,
              child: _buildCheckBox(
                text: _appScreenText['audioConference'],
                value: widget.gameState.settings.audioConf,
                onChange: (bool v) async {
                  // setting the value saves it to local storage too
                  widget.gameState.settings.audioConf = v;
                  widget.gameState.janusEngine.joinLeaveAudioConference();
                  log('In toggle button widget, audioConf = ${widget.gameState.settings.audioConf}');
                  if (closed) return;
                  setState(() {});
                },
              ),
            ),

            /* show straddle off and auto straddle options ONLY when the UTG STRADDLE is on */
            // Straddle Checkbox
            // TODO remove hardcoded value
            Visibility(
              visible:
                  true, // widget.gameState.gameInfo.utgStraddleAllowed ?? true,
              child: Container(
                decoration: widget.gameState.settings.straddleOption ?? true
                    ? AppDecorators.tileDecorationWithoutBorder(theme)
                    : BoxDecoration(),
                child: Column(
                  children: [
                    _buildCheckBox(
                      text: _appScreenText['straddle'],
                      value: widget.gameState.settings.straddleOption,
                      onChange: (bool v) async {
                        // setting the value saves it to local storage too
                        //  TODO Need straddle in serverside.

                        widget.gameState.settings.straddleOption = v;
                        log('In toggle button widget, straddleOption = ${widget.gameState.settings.straddleOption}');
                        if (closed) return;
                        setState(() {});
                      },
                    ),

                    // Need variable for tracking auto choice.
                    Visibility(
                      visible: widget.gameState.settings.straddleOption,
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        child: // auto straddle
                            _buildCheckBox(
                          text: _appScreenText['autoStraddle'],
                          value: widget.gameState.settings.autoStraddle,
                          onChange: (bool v) async {
                            if (v) {
                              await FirebaseAnalytics().logEvent(
                                  name: "Auto_Straddle",
                                  parameters: {
                                    "name": "Auto Straddle is turned ON"
                                  });
                            }
                            // setting the value saves it to local storage too
                            widget.gameState.settings.autoStraddle = v;
                            log('In toggle button widget, autoStraddle = ${widget.gameState.settings.autoStraddle}');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // need local variable for bombpot in gameInfo
            Visibility(
              visible: true, //gameInfo.bombPot,
              child: _buildCheckBox(
                text: "Participate in bomb pot",
                value: true, //widget.gameState.settings.bombpot,
                onChange: (bool v) async {
                  // setting the value saves it to local storage too
                  _gameSettings.bombPotEnabled = v;
                  await updateGameSettings();
                  // widget.gameState.settings.bombPot = v;
                  log('In toggle button widget, gameSounds = ${widget.gameState.settings.gameSound}');
                  if (closed) return;
                  setState(() {});
                },
              ),
            ),

            _buildCheckBox(
              text: "Chat",
              value: widget.gameState.settings.showChat ??
                  false, //widget.gameState.settings.bombpot,
              onChange: (bool v) {
                // setting the value saves it to local storage too
                widget.gameState.settings.showChat = v;
                // widget.gameState.settings.bombPot = v;
                log('In toggle button widget, gameSounds = ${widget.gameState.settings.gameSound}');
                if (closed) return;
                setState(() {});
              },
            ),

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

    if (_gameSettings == null) {
      return CircularProgressWidget();
    }

    // when I am HOST and PLAYING the game
    if (isPlaying && isHost) {
      return DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                // build the basic game options
                child: _buildBasicGameOptions(
                  isPlaying: isPlaying,
                  theme: theme,
                ),
              ),
              SliverToBoxAdapter(
                // show tabs for game and player settings
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Text('Game Settings'),
                    ),
                    Tab(
                      child: Text('Player Settings'),
                    ),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: theme.accentColor,
                  labelColor: theme.secondaryColorWithLight(),
                  unselectedLabelColor: theme.secondaryColorWithDark(),
                ),
              ),
            ];
          },

          // show game and player settings body
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              // game settings to be shown here
              // 1. allow seat change player
              // 2. allow waiting list
              // 3. bomb pot
              // 4. audio conference
              // 5. pause time after each result
              _buildGameSettingOptions(theme),

              // player settings to be shown here
              // 1. muck losing hand
              // 2. straddle
              // 3. audio conference
              // 4. run it twice
              _buildPlayerSettingOptions(theme),
            ],
          ),
        ),
      );
    }

    // if I am HOST only - show game settings option
    else if (isHost) {
      return _buildGameSettingOptions(theme);
    }

    // if I am PLAYING only - show player settings option
    else {
      return _buildPlayerSettingOptions(theme);
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // game options - standup, reload, break, pause...
            !isPlaying
                ? SizedBox.shrink()
                : Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.only(top: 16),
                    width: double.infinity,
                    decoration:
                        AppDecorators.tileDecorationWithoutBorder(theme),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...gameActions
                            .map((e) => gameActionItem(e, theme))
                            .toList(),
                      ],
                    ),
                  ),

            // game stats - elapsed time, won, hands...
            Container(
              padding: EdgeInsets.all(16),
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_appScreenText['elapsed'],
                              style: AppDecorators.getSubtitle3Style(
                                  theme: theme)),
                          isFetching
                              ? CircularProgressWidget(
                                  showText: false,
                                  height: 24,
                                )
                              : Text(
                                  "${DataFormatter.timeFormat(gameInfo.runningTime)}",
                                  style: AppDecorators.getHeadLine4Style(
                                          theme: theme)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _appScreenText['hands'],
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
                          ),
                          isFetching
                              ? CircularProgressWidget(
                                  showText: false,
                                  height: 24,
                                )
                              : Text(
                                  "${gameInfo.noHandsPlayed}",
                                  style: AppDecorators.getHeadLine4Style(
                                          theme: theme)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                        ],
                      )
                    ],
                  ),
                  AppDimensionsNew.getVerticalSizedBox(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !isPlaying
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_appScreenText['session'],
                                    style: AppDecorators.getSubtitle3Style(
                                        theme: theme)),
                                isFetching
                                    ? CircularProgressWidget(
                                        showText: false,
                                        height: 24,
                                      )
                                    : Text(
                                        "${DataFormatter.timeFormat(gameInfo.sessionTime)}",
                                        style: AppDecorators.getHeadLine4Style(
                                                theme: theme)
                                            .copyWith(
                                                fontWeight: FontWeight.w700)),
                              ],
                            ),
                      !isPlaying
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _appScreenText['won'],
                                  style: AppDecorators.getSubtitle3Style(
                                      theme: theme),
                                ),
                                isFetching
                                    ? CircularProgressWidget(
                                        showText: false,
                                        height: 24,
                                      )
                                    : Text("${gameInfo.noHandsWon}",
                                        style: AppDecorators.getHeadLine4Style(
                                                theme: theme)
                                            .copyWith(
                                                fontWeight: FontWeight.w700)),
                              ],
                            )
                    ],
                  ),
                ],
              ),
            ),

            // sep
            AppDimensionsNew.getVerticalSizedBox(10),

            // tap to bet VS swipe to bet
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // main text
                        Text(
                          _appScreenText['betAction'],
                          style: AppDecorators.getHeadLine4Style(theme: theme),
                        ),
                        // hint text
                        Text(
                          '(${_appScreenText['appliedInNextAction']})',
                          style: AppDecorators.getSubtitle1Style(theme: theme),
                        ),
                      ],
                    ),
                  ),

                  // tap / swipe button
                  // false ==> swipe is active
                  Expanded(
                    child: CupertinoSegmentedControl<bool>(
                      borderColor: theme.accentColor,
                      selectedColor: theme.accentColor,
                      unselectedColor: theme.fillInColor,
                      groupValue: HiveDatasource.getInstance
                          .getBox(BoxType.USER_SETTINGS_BOX)
                          .get('isTapForBetAction?', defaultValue: false),
                      children: {
                        false: Text(_appScreenText['swipe'],
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme)),
                        true: Text(_appScreenText['tap'],
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme)),
                      },
                      onValueChanged: (bool v) async {
                        await HiveDatasource.getInstance
                            .getBox(BoxType.USER_SETTINGS_BOX)
                            .put('isTapForBetAction?', v);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Container(
            //   padding: EdgeInsets.all(10),
            //   decoration: AppStylesNew.actionRowDecoration,
            //   child: _buildCheckBox(
            //       text: 'Bet Action',
            //       inactiveText: 'Swipe',
            //       activeText: 'Tap',
            //       value: HiveDatasource.getInstance
            //           .getBox(BoxType.USER_SETTINGS_BOX)
            //           .get('isTapForBetAction?', defaultValue: false),
            //       onChange: (bool v) async {
            //         HiveDatasource.getInstance
            //             .getBox(BoxType.USER_SETTINGS_BOX)
            //             .put(
            //               'isTapForBetAction?',
            //               v,
            //             );
            //       }),
            // ),

            // sep
            AppDimensionsNew.getVerticalSizedBox(10),

            // game settings
            Container(
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: _buildOtherGameOptions(theme),
            ),

            // sep
            AppDimensionsNew.getVerticalSizedBox(10),

            //game secondary options
            Container(
              padding: EdgeInsets.all(10),
              decoration: AppDecorators.tileDecorationWithoutBorder(theme),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gameSecondaryOptions.length,
                itemBuilder: (context, index) {
                  return gameSecondaryOptionItem(
                    gameSecondaryOptions[index],
                    context,
                    theme,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 2,
                    color: theme.secondaryColor,
                    endIndent: 24,
                    indent: 24,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
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

  gameActionItem(OptionItemModel optionItemModel, AppTheme theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          if (optionItemModel.onTap != null) {
            optionItemModel.onTap(context);
          }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.accentColor,
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                optionItemModel.iconData ?? Icons.message,
                size: 20.pw,
                color: theme.primaryColorWithDark(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                optionItemModel.title,
                style: AppDecorators.getSubtitle3Style(theme: theme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
