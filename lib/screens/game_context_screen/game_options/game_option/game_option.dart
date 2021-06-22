import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/option_item_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'seat_change_bottom_sheet.dart';
import 'waiting_list.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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

  void onLeave() {
    Alerts.showNotification(
        titleText: "LEAVE",
        leadingIcon: Icons.time_to_leave,
        subTitleText: AppStringsNew.leaveGameNotificationText);
    // Dismisses bottomsheet
    Navigator.of(context).pop();
    GameService.leaveGame(this.gameCode);
  }

  void onEndGame() {
    Alerts.showNotification(
        titleText: "ENDED",
        leadingIcon: Icons.close,
        subTitleText: AppStringsNew.gameEndNotificationText);
    // showSimpleNotification(
    //   Text(''),
    //   position: NotificationPosition.top,
    //   duration: Duration(seconds: 10),
    // );
    // We need to broadcast to all the players
    Navigator.of(context).pop();

    GameService.endGame(this.gameCode);
  }

  void onPause() {
    Alerts.showNotification(
        titleText: "PAUSE",
        leadingIcon: Icons.pause_circle_outline,
        subTitleText: AppStringsNew.pauseGameNotificationText);
    Navigator.of(context).pop();

    GameService.pauseGame(this.gameCode);
  }

  void onBreak() {
    Alerts.showNotification(
        titleText: "BREAK",
        leadingIcon: Icons.time_to_leave,
        subTitleText: AppStringsNew.breakGameNotificationText);
    Navigator.of(context).pop();

    //Alerts.showNotification(text: 'Your break will start after this hand');

    GameService.takeBreak(this.gameCode);
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
    gameInfo = await GameService.getGameInfo(gameCode);
    if (gameInfo != null) {
      setState(() {
        isFetching = false;
      });
    }
    log("-=-= ${gameInfo.sessionTime}");
    log("-=-= ${gameInfo.runningTime}");
    log("-=-= ${gameInfo.noHandsPlayed}");
    log("-=-= ${gameInfo.noHandsWon}");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchGameInfo();
    });
    gameCode = widget.gameCode;
    gameActions = [
      OptionItemModel(
          title: "Standup",
          iconData: Icons.exit_to_app_sharp,
          onTap: (context) {
            this.onLeave();
          }),
      OptionItemModel(
          title: "Break",
          iconData: Icons.shop,
          onTap: (context) {
            this.onBreak();
          }),
      OptionItemModel(title: "Reload"),
    ];

    if (widget.isAdmin) {
      gameActions.add(OptionItemModel(
          title: "Pause",
          iconData: Icons.pause,
          onTap: (context) {
            this.onPause();
          }));

      gameActions.add(OptionItemModel(
          title: "Terminate",
          iconData: Icons.cancel_outlined,
          onTap: (context) {
            this.onEndGame();
          }));
    }

    gameSecondaryOptions = [
      OptionItemModel(
          title: "Game Stats",
          name: "Analyze your performance",
          image: "assets/images/casino.png",
          backGroundColor: AppColors.gameOption1,
          onTap: (context) {}),
      OptionItemModel(
        title: "Seat Change",
        image: "assets/images/casino.png",
        name: "Request seat change",
        backGroundColor: AppColors.gameOption2,
        onTap: (context) async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) {
              return SeatChangeBottomSheet(
                  widget.gameState, widget.gameCode, widget.playerUuid);
            },
          );
        },
      ),
    ];

    gameSecondaryOptions.add(OptionItemModel(
        title: "Waiting List",
        image: "assets/images/casino.png",
        name: "Add to waiting list",
        backGroundColor: AppColors.gameOption3,
        onTap: (context) async {
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return WaitingListBottomSheet(
                    widget.gameState, widget.gameCode, widget.playerUuid);
              });
        }));
  }

  Widget _buildCheckBox({
    @required String text,
    @required bool value,
    @required void onChange(bool _),
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SwitchWidget(
        label: text,
        value: value,
        onChange: (value) {
          onChange(value);
        },
      ),
    );
  }

  Widget _buildOtherGameOptions() => Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckBox(
                text: 'Muck Losing Hand',
                value: widget.gameState.gameInfo.playerMuckLosingHand,
                onChange: (bool v) async {
                  await GameService.updateGameConfig(widget.gameState.gameCode,
                      muckLosingHand: v);
                  widget.gameState.gameInfo.playerMuckLosingHand = v;
                  setState(() {});
                }),
            _buildCheckBox(
              text: 'Prompt run it twice',
              value: widget.gameState.gameInfo.playerRunItTwice,
              onChange: (bool v) async {
                await GameService.updateGameConfig(widget.gameState.gameCode,
                    runItTwicePrompt: v);
                widget.gameState.gameInfo.playerRunItTwice = v;
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: 'Game Sounds',
              value: widget.gameState.settings.gameSound,
              onChange: (bool v) async {
                widget.gameState.settings.gameSound = v;
                widget.gameState.gameHiveStore
                    .putGameSettings(widget.gameState.settings);
                log('In toggle button widget, gameSounds = ${widget.gameState.settings.gameSound}');
                setState(() {});
              },
            ),
            widget.gameState.gameInfo.audioConfEnabled ?? false
                ? _buildCheckBox(
                    text: 'Audio Conference',
                    value: widget.gameState.settings.audioConf,
                    onChange: (bool v) async {
                      widget.gameState.settings.audioConf = v;
                      widget.gameState.janusEngine.joinLeaveAudioConference();
                      widget.gameState.gameHiveStore
                          .putGameSettings(widget.gameState.settings);
                      log('In toggle button widget, audioConf = ${widget.gameState.settings.audioConf}');
                      setState(() {});
                    },
                  )
                : SizedBox(),
            _buildCheckBox(
              text: 'Animations',
              value: widget.gameState.settings.animations,
              onChange: (bool v) async {
                widget.gameState.settings.animations = v;
                widget.gameState.gameHiveStore
                    .putGameSettings(widget.gameState.settings);
                log('In toggle button widget, animations = ${widget.gameState.settings.animations}');
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: 'Show Chat',
              value: widget.gameState.settings.showChat,
              onChange: (bool v) async {
                widget.gameState.settings.showChat = v;
                widget.gameState.gameHiveStore
                    .putGameSettings(widget.gameState.settings);
                log('In toggle button widget, showChat = ${widget.gameState.settings.showChat}');
                widget.gameState.getCommunicationState().showTextChat = v;
                widget.gameState.getCommunicationState().notify();
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: 'Straddle Off',
              value: widget.gameState.settings.straddleOption,
              onChange: (bool v) async {
                widget.gameState.settings.straddleOption = v;
                widget.gameState.gameHiveStore
                    .putGameSettings(widget.gameState.settings);
                log('In toggle button widget, straddleOption = ${widget.gameState.settings.straddleOption}');
                setState(() {});
              },
            ),
            _buildCheckBox(
              text: 'Auto Straddle',
              value: widget.gameState.settings.autoStraddle,
              onChange: (bool v) async {
                widget.gameState.settings.autoStraddle = v;
                widget.gameState.gameHiveStore
                    .putGameSettings(widget.gameState.settings);
                log('In toggle button widget, autoStraddle = ${widget.gameState.settings.autoStraddle}');
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.only(top: 16),
              width: double.infinity,
              decoration: AppStylesNew.actionRowDecoration,
              child: Wrap(
                alignment: WrapAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...gameActions.map((e) => gameActionItem(e)).toList(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: AppStylesNew.actionRowDecoration,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Elapsed", style: AppStylesNew.labelTextStyle),
                          isFetching
                              ? CircularProgressWidget(
                                  showText: false,
                                  height: 24,
                                )
                              : Text(
                                  "${DataFormatter.timeFormat(gameInfo.runningTime)}",
                                  style: AppStylesNew.valueTextStyle),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Hands", style: AppStylesNew.labelTextStyle),
                          isFetching
                              ? CircularProgressWidget(
                                  showText: false,
                                  height: 24,
                                )
                              : Text("${gameInfo.noHandsPlayed}",
                                  style: AppStylesNew.valueTextStyle),
                        ],
                      )
                    ],
                  ),
                  AppDimensionsNew.getVerticalSizedBox(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Session", style: AppStylesNew.labelTextStyle),
                          isFetching
                              ? CircularProgressWidget(
                                  showText: false,
                                  height: 24,
                                )
                              : Text(
                                  "${DataFormatter.timeFormat(gameInfo.sessionTime)}",
                                  style: AppStylesNew.valueTextStyle),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Won", style: AppStylesNew.labelTextStyle),
                          isFetching
                              ? CircularProgressWidget(
                                  showText: false,
                                  height: 24,
                                )
                              : Text("${gameInfo.noHandsWon}",
                                  style: AppStylesNew.valueTextStyle),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            AppDimensionsNew.getVerticalSizedBox(10),
            Container(
              decoration: AppStylesNew.actionRowDecoration,
              child: _buildOtherGameOptions(),
            ),
            AppDimensionsNew.getVerticalSizedBox(10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: AppStylesNew.actionRowDecoration,
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gameSecondaryOptions.length,
                itemBuilder: (context, index) {
                  return gameSecondaryOptionItem(
                    gameSecondaryOptions[index],
                    context,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 2,
                    color: AppColorsNew.newBackgroundBlackColor,
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
      OptionItemModel optionItemModel, BuildContext context) {
    return ListTile(
      onTap: () => optionItemModel.onTap(context),
      title: Text(
        optionItemModel.title,
      ),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: optionItemModel.backGroundColor,
        ),
        padding: EdgeInsets.all(5),
        child: Image.asset(
          optionItemModel.image,
          height: 32.ph,
          width: 32.pw,
          color: Colors.white,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColorsNew.newGreenButtonColor,
      ),
      subtitle: optionItemModel.name != null
          ? Text(
              optionItemModel.name,
              style: AppStylesNew.labelTextStyle,
            )
          : Container(),
    );
  }

  gameActionItem(OptionItemModel optionItemModel) {
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
                color: AppColorsNew.newGreenButtonColor,
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                optionItemModel.iconData ?? Icons.message,
                size: 20.pw,
                color: AppColorsNew.darkGreenShadeColor,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                optionItemModel.title,
                style: AppStylesNew.labelTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
