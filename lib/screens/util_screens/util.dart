import 'dart:developer';
import 'dart:math' as math;

//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/gql_errors.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:provider/provider.dart';

showAlertDialog(BuildContext context, String title, String message) {
  // set up the button
  Widget okButton = ElevatedButton(
    child: Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    backgroundColor: AppColorsNew.cardBackgroundColor,
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showError(BuildContext context, {GqlError error, String message}) {
  // translate to other languages here
  if (error != null) {
    message = error.message;
  }

  // set up the button
  Widget okButton = ElevatedButton(
    child: Text("Close"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Error'),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showWaitlistInvitation(
    BuildContext context, String message, int duration) async {
  AppTheme theme = AppTheme.getTheme(context);
  final res = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: theme.fillInColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.accentColor,
        ),
      ),
      buttonPadding: EdgeInsets.all(16),
      title: Text('Waitlist'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
        ],
      ),
      actions: [
        RoundRectButton(
          text: 'No',
          theme: theme,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        RoundRectButton(
          text: 'Yes',
          theme: theme,
          onTap: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    ),
  );
  final ret = res as bool;
  return ret ?? false;
}

// showWaitlistStatus(BuildContext context, String message, int duration) async {
//   Flushbar flush;
//   flush = Flushbar(
//     flushbarPosition: FlushbarPosition.TOP,
//     flushbarStyle: FlushbarStyle.FLOATING,
//     reverseAnimationCurve: Curves.decelerate,
//     forwardAnimationCurve: Curves.bounceInOut,
//     backgroundColor: Colors.red,
//     //boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
//     backgroundGradient: LinearGradient(colors: [Colors.black, Colors.blueGrey]),
//     isDismissible: false,
//     duration: Duration(seconds: duration),
//     icon: Icon(
//       Icons.queue_play_next,
//       color: Colors.greenAccent,
//     ),
//     mainButton: Material(
//       // pause button (round)
//       borderRadius: BorderRadius.circular(50), // change radius size
//       color: Colors.black12, //button colour
//       child: InkWell(
//         splashColor: Colors.white, // inkwell onPress colour
//         child: SizedBox(
//           width: 35, height: 35, //customisable size of 'button'
//           child: Icon(
//             Icons.close_rounded,
//             color: Colors.blue,
//             size: 16,
//           ),
//         ),
//         onTap: () {
//           flush.dismiss();
//         }, // or use onPressed: () {}
//       ),
//     ),
//     showProgressIndicator: false,
//     progressIndicatorBackgroundColor: Colors.blueGrey,
//     titleText: Text(
//       "Waitlist Seating",
//       style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 15.0,
//           color: Colors.white,
//           fontFamily: "ShadowsIntoLightTwo"),
//     ),
//     messageText: Text(
//       message,
//       style: TextStyle(
//           fontSize: 12.0,
//           color: Colors.green,
//           fontFamily: "ShadowsIntoLightTwo"),
//     ),
//   )..show(context);
// }

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  if (duration.inSeconds <= 0) {
    return '0:00';
  }
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

Future<GameType> showGameSelectorDialog({
  @required List<GameType> listOfGameTypes,
  @required Duration timeLimit,
}) async {
  AppTextScreen _appScreenText = getAppTextScreen("showGameSelectorDialog");

  log("LENGTH : ${listOfGameTypes.length}");
  int sec = timeLimit.inSeconds;
  bool dismissed = false;
  final GameType result = await showDialog(
    context: navigatorKey.currentContext,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColorsNew.newDialogBgColor.withAlpha(100),
        content: StatefulBuilder(
          builder: (context, localState) {
            Future.delayed(Duration(seconds: 1), () {
              if (sec <= 1) {
                //int random = math.Random().nextInt(listOfGameTypes.length);
                dismissed = true;

                Navigator.of(context).pop(GameType.UNKNOWN);
              } else {
                if (!dismissed) {
                  localState(() {
                    sec--;
                  });
                }
              }
            });

            return Container(
              decoration: AppStylesNew.BgGreenRadialGradient,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _appScreenText['ChooseAGameTypeForTheNextHand'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    //height: MediaQuery.of(context).size.height*0.4,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        listOfGameTypes.length,
                        (index) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                dismissed = true;
                                Navigator.of(context)
                                    .pop(listOfGameTypes[index]);
                              },
                              borderRadius: BorderRadius.circular(32.pw),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                width: 64,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColorsNew
                                                  .newGreenButtonColor,
                                              spreadRadius: 2,
                                              blurRadius: 1,
                                              offset: Offset(1, 0)),
                                        ],
                                        color: AppColorsNew.darkGreenShadeColor,
                                      ),
                                      child: Image.asset(
                                        GameModelNew
                                            .getGameTypeImageAssetFromEnum(
                                                listOfGameTypes[index]),
                                        height: 56,
                                      ),
                                    ),
                                    Text(
                                      "${gameTypeShortStr(listOfGameTypes[index])}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10.dp,
                                        color: AppColorsNew.newGreenButtonColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Divider(
                    color: AppColorsNew.yellowAccentColor,
                    height: 8,
                    endIndent: 16,
                    indent: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                dismissed = true;
                                int random = math.Random()
                                    .nextInt(listOfGameTypes.length);
                                Navigator.of(context)
                                    .pop(listOfGameTypes[random]);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                width: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColorsNew.newGreenButtonColor,
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(1, 0)),
                                  ],
                                  color: AppColorsNew.darkGreenShadeColor,
                                ),
                                child: Image.asset(
                                  AppAssetsNew.pathDefaultTypeImage,
                                  height: 56,
                                ),
                              ),
                            ),
                            Text(
                              "Random Game",
                              style: TextStyle(
                                fontSize: 10.dp,
                                color: AppColorsNew.newGreenButtonColor,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RichText(
                              text: TextSpan(
                                text: printDuration(Duration(seconds: sec)),
                                style: TextStyle(
                                    color: AppColorsNew.yellowAccentColor,
                                    fontSize: 12.dp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppDimensionsNew.getVerticalSizedBox(16),
                ],
              ),
            );
          },
        ),
      );
    },
  );

  return result ?? GameType.HOLDEM;
}

showPlayerPopup(context, GlobalKey seatKey, GameState gameState, Seat seat) {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject();
  final RenderBox button = seatKey.currentContext.findRenderObject();
  final gameState = GameState.getState(context);
  AppTextScreen _appScreenText = getAppTextScreen("showPlayerPopup");

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(40, 70), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  double menuItemHeight = 40;
  final mySeat = gameState.mySeat;
  List<PopupMenuItem> items = [];
  int noteIdx = -1;
  int animationIdx = -1;
  int kickIdx = -1;
  int muteIdx = -1;
  if (mySeat != null) {
    noteIdx = items.length;
    items.add(PopupMenuItem(
      height: menuItemHeight,
      value: noteIdx,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _appScreenText['note'],
          ),
          Icon(
            Icons.note,
            color: AppColorsNew.yellowAccentColor,
          ),
        ],
      ),
    ));
    if (gameState.gameSettings.funAnimations ?? true) {
      animationIdx = items.length;
      items.add(PopupMenuItem(
        value: animationIdx,
        height: menuItemHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _appScreenText['animation'],
            ),
            Icon(
              Icons.note,
              color: AppColorsNew.yellowAccentColor,
            ),
          ],
        ),
      ));
    }
  }
  if (gameState.currentPlayer.isAdmin()) {
    kickIdx = items.length;
    items.add(PopupMenuItem(
      value: kickIdx,
      height: menuItemHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _appScreenText['kick'],
          ),
          Icon(
            Icons.ios_share,
            color: AppColorsNew.yellowAccentColor,
          ),
        ],
      ),
    ));

    muteIdx = items.length;
    items.add(PopupMenuItem(
      value: muteIdx,
      height: menuItemHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _appScreenText['mute'],
          ),
          Icon(
            Icons.volume_off,
            color: AppColorsNew.yellowAccentColor,
          ),
        ],
      ),
    ));
  }

  if (items.length == 0) {
    return;
  }

  showMenu(
    context: context,
    color: AppColorsNew.actionRowBgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: AppColorsNew.newBorderColor,
      ),
    ),
    position: position,
    items: items,
  ).then<void>((delta) async {
    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)

    if (delta != null) {
      if (delta == noteIdx) {
        handleNotesPopup(context, seat);
      } else if (delta == animationIdx) {
        final AppTheme theme = AppTheme.getTheme(context);
        final Map data = await showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) {
            //final theme = AppTheme.getTheme(context);
            return Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                child: ListenableProvider(
                    create: (_) {
                      return ValueNotifier<bool>(false);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.only(
                          bottom: 24, top: 8, right: 8, left: 8),
                      // width: MediaQuery.of(context).size.width * 0.70,
                      // height: 200.ph,
                      decoration:
                          AppDecorators.bgRadialGradient(theme).copyWith(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.accentColor, width: 3),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // diamond widget
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.cancel,
                                  color: theme.accentColor,
                                ),
                              ),
                              Consumer<ValueNotifier<bool>>(
                                  builder: (_, __, ___) => NumDiamondWidget(
                                      gameState.gameHiveStore)),
                            ],
                          ),

                          // sep
                          const SizedBox(height: 8.0),
                          /* hand number */

                          ProfilePopup(),
                          AppDimensionsNew.getVerticalSizedBox(32),

                          // show REVEAL button / share button
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                                "Note : For each animation, 2 diamonds will be deducted!"),
                          ),
                        ],
                      ),
                    )),
              ),
            );
          },
          transitionBuilder: (context, anim1, anim2, child) {
            return SlideTransition(
              position: Tween(begin: Offset(0.2, 1), end: Offset(0, 0))
                  .animate(anim1),
              child: child,
            );
          },
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 300),
        );

        //  await showModalBottomSheet(
        //   context: context,
        //   builder: (context) {
        //     final theme = AppTheme.getTheme(context);
        //     return Container(
        //       decoration: AppDecorators.bgRadialGradient(theme),
        //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //       child: ProfilePopup(
        //         seat: gameState.popupSelectedSeat,
        //       ),
        //     );
        //   },
        // );

        if (data == null) return;
        // log("SEATNO1:: ${widget.gameState.myState.seatNo}");
        // log("SEATNO2:: ${widget.gameState.getMyState(context).seatNo}");
        // log("SEAT FROM:: ${widget.gameState.me(context).seatNo}");
        // log("SEAT TO:: ${widget.gameState.popupSelectedSeat.serverSeatPos}");

        gameState.gameComService.gameMessaging.sendAnimation(
          gameState.me?.seatNo,
          seat.serverSeatPos,
          data['animationID'],
        );
      } else if (delta == muteIdx) {
      } else if (delta == kickIdx) {
        PlayerService.kickPlayer(gameState.gameCode, seat.player.playerUuid);
        Alerts.showNotification(
            titleText: _appScreenText['playerWillBeRemovedAfterThisHand'],
            duration: Duration(seconds: 5));
      }
      gameState.dismissPopup();
    }
  });
}

handleNotesPopup(BuildContext context, Seat seat) async {
  AppTextScreen _appScreenText = getAppTextScreen("showPlayerPopup");
  final savedNotes = await GameService.getNotesForUser(seat.player.playerUuid);

  final data = await showDialog(
    context: context,
    builder: (context) {
      // Fetch text from API
      TextEditingController _controller =
          TextEditingController(text: savedNotes);
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColorsNew.newBorderColor,
          ),
        ),
        backgroundColor: AppColorsNew.newDialogBgColor,
        title: Row(
          children: [
            Icon(
              Icons.note,
              color: AppColorsNew.labelColor,
            ),
            AppDimensionsNew.getHorizontalSpace(8),
            Text(
              _appScreenText['notes'],
              style: AppStylesNew.labelTextStyle,
            )
          ],
        ),
        content: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _appScreenText['enterTextHere'],
                fillColor: AppColorsNew.actionRowBgColor,
                filled: true,
                border: InputBorder.none,
              ),
              minLines: 5,
              maxLines: 8,
            ),
            AppDimensionsNew.getVerticalSizedBox(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoundRectButton(
                  text: _appScreenText['cancel'],
                  // theme:theme,
                  onTap: () => Navigator.of(context).pop(),
                ),
                RoundRectButton(
                  text: _appScreenText['save'],
                  onTap: () => Navigator.of(context).pop(_controller.text),
                ),
              ],
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      );
    },
  );
  if (data != null) {
    // API Call to save notes
    final res = await GameService.setNotesForUser(seat.player.playerUuid, data);
    if (res) {
      Alerts.showNotification(
        titleText: _appScreenText['notesSaved'],
      );
    }
  }
}
