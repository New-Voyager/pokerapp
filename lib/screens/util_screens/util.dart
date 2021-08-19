import 'dart:developer';
import 'dart:math' as math;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/gql_errors.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

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

showWaitlistStatus(BuildContext context, String message, int duration) async {
  Flushbar flush;
  flush = Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.bounceInOut,
    backgroundColor: Colors.red,
    //boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    backgroundGradient: LinearGradient(colors: [Colors.black, Colors.blueGrey]),
    isDismissible: false,
    duration: Duration(seconds: duration),
    icon: Icon(
      Icons.queue_play_next,
      color: Colors.greenAccent,
    ),
    mainButton: Material(
      // pause button (round)
      borderRadius: BorderRadius.circular(50), // change radius size
      color: Colors.black12, //button colour
      child: InkWell(
        splashColor: Colors.white, // inkwell onPress colour
        child: SizedBox(
          width: 35, height: 35, //customisable size of 'button'
          child: Icon(
            Icons.close_rounded,
            color: Colors.blue,
            size: 16,
          ),
        ),
        onTap: () {
          flush.dismiss();
        }, // or use onPressed: () {}
      ),
    ),
    showProgressIndicator: false,
    progressIndicatorBackgroundColor: Colors.blueGrey,
    titleText: Text(
      "Waitlist Seating",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
    messageText: Text(
      message,
      style: TextStyle(
          fontSize: 12.0,
          color: Colors.green,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
  )..show(context);
}

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
                      AppStringsNew.chooseGameTitleNextHand,
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

  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(40, 70), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );

  double menuItemHeight = 40;
  final mySeat = gameState.mySeat(context);
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
    items: <PopupMenuEntry>[
      (mySeat != null)
          ? PopupMenuItem(
              height: menuItemHeight,
              value: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Note",
                  ),
                  Icon(
                    Icons.note,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                ],
              ),
            )
          : PopupMenuItem(child: SizedBox.shrink(), height: 0),
      (mySeat != null)
          ? PopupMenuItem(
              value: 1,
              height: menuItemHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Animation"),
                  Icon(
                    Icons.note,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                  // Lottie.asset(
                  //   'assets/animations/chicken.json',
                  //   height: 32,
                  //   width: 32,
                  //   controller: _controller,
                  //   onLoaded: (composition) {
                  //     // Configure the AnimationController with the duration of the
                  //     // Lottie file and start the animation.
                  //     _controller
                  //       ..duration = composition.duration
                  //       ..forward();
                  //   },
                  // ),
                ],
              ),
            )
          : PopupMenuItem(child: SizedBox.shrink(), height: 0),
      (gameState.currentPlayer.isAdmin())
          ? PopupMenuItem(
              value: 2,
              height: menuItemHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Mute",
                  ),
                  Icon(
                    Icons.volume_off,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                ],
              ),
            )
          : PopupMenuItem(child: SizedBox.shrink(), height: 0),
      (gameState.currentPlayer.isAdmin())
          ? PopupMenuItem(
              value: 3,
              height: menuItemHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Kick",
                  ),
                  Icon(
                    Icons.ios_share,
                    color: AppColorsNew.yellowAccentColor,
                  ),
                ],
              ),
            )
          : PopupMenuItem(
              child: SizedBox.shrink(),
              height: 0,
            ),
    ],
  ).then<void>((delta) async {
    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)

    if (delta != null) {
      switch (delta) {
        case 0:
          // Handling note selection
          log('user selected NOTE option');
          final savedNotes =
              await GameService.getNotesForUser(seat.player.playerUuid);

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
                    )),
                backgroundColor: AppColorsNew.newDialogBgColor,
                title: Row(
                  children: [
                    Icon(
                      Icons.note,
                      color: AppColorsNew.labelColor,
                    ),
                    AppDimensionsNew.getHorizontalSpace(8),
                    Text(
                      AppStringsNew.notesTitleText,
                      style: AppStylesNew.labelTextStyle,
                    )
                  ],
                ),
                content: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: AppStringsNew.enterTextHint,
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
                        RoundedColorButton(
                          text: AppStringsNew.cancelButtonText,
                          textColor: AppColorsNew.newRedButtonColor,
                          backgroundColor: Colors.transparent,
                          borderColor: AppColorsNew.newRedButtonColor,
                          onTapFunction: () => Navigator.of(context).pop(),
                        ),
                        RoundedColorButton(
                          text: AppStringsNew.saveButtonText,
                          textColor: AppColorsNew.darkGreenShadeColor,
                          backgroundColor: AppColorsNew.newGreenButtonColor,
                          borderColor: AppColorsNew.darkGreenShadeColor,
                          onTapFunction: () =>
                              Navigator.of(context).pop(_controller.text),
                        ),
                      ],
                    ),
                    AppDimensionsNew.getVerticalSizedBox(16),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              );
            },
          );
          if (data != null) {
            // API Call to save notes
            final res =
                await GameService.setNotesForUser(seat.player.playerUuid, data);
            if (res) {
              Alerts.showNotification(
                  titleText: AppStringsNew.notesSavedAlertText);
            }
          }
          break;

        // Animation
        case 1:
          final data = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 10,
                contentPadding: EdgeInsets.zero,
                content: ProfilePopup(
                  seat: gameState.popupSelectedSeat,
                ),
              );
            },
          );

          if (data == null) return;
          // log("SEATNO1:: ${widget.gameState.myState.seatNo}");
          // log("SEATNO2:: ${widget.gameState.getMyState(context).seatNo}");
          // log("SEAT FROM:: ${widget.gameState.me(context).seatNo}");
          // log("SEAT TO:: ${widget.gameState.popupSelectedSeat.serverSeatPos}");

          gameState.gameComService.gameMessaging.sendAnimation(
            gameState.me(context)?.seatNo,
            seat.serverSeatPos,
            data['animationID'],
          );
          break;

// Mute option
        case 2:
          log('user selected mute option');
          break;

        // Kickoption
        case 3:
          log('calling kickPlayer with ${gameState.gameCode} and ${seat.player.playerUuid}');
          PlayerService.kickPlayer(gameState.gameCode, seat.player.playerUuid);
          Alerts.showNotification(
              titleText: AppStringsNew.kickedAlertMessage,
              duration: Duration(seconds: 5));
          break;
      }
    }
    gameState.dismissPopup(context);
  });
}
