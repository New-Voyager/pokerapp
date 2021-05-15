import 'dart:developer';
import 'dart:math' as math;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/ingame_settings/game_type_select.dart';
import 'package:pokerapp/services/gql_errors.dart';

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

String getPlayerNameBySeatNo({HandLogModelNew handLogModel, int seatNo}) {
  final res = handLogModel.hand.playersInSeats
      .firstWhere((element) => element.seatNo == seatNo, orElse: () => null);
  return res == null ? "Player" : res.name;
}

Future<GameType> showGameSelectorDialog({
  @required List<GameType> listOfGameTyeps,
  @required Duration timeLimit,
}) async {
  log("LENGTH : ${listOfGameTyeps.length}");
  int sec = timeLimit.inSeconds;

  final GameType result = await showDialog(
    context: navigatorKey.currentContext,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.cardBackgroundColor,
        title: Text(
          "Choose a game type for the next hand",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, localState) {
            log("SECONDS : $sec");
            Future.delayed(Duration(seconds: 1), () {
              if (sec == 1) {
                int random = math.Random().nextInt(listOfGameTyeps.length);
                Navigator.of(context).pop(listOfGameTyeps[random]);
              } else {
                localState(() {
                  sec--;
                });
              }
            });

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  //height: MediaQuery.of(context).size.height*0.4,
                  child: Wrap(
                    children: List.generate(
                      listOfGameTyeps.length,
                      (index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          width: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(listOfGameTyeps[index]);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.appAccentColor),
                                  child: Image.asset(
                                    AppAssets.cardsImage,
                                    height: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "${gameTypeStr(listOfGameTyeps[index])}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.appAccentColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Spinning in ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "${Duration(seconds: sec).inMinutes} : ${Duration(seconds: sec).inSeconds} sec",
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              int random =
                                  math.Random().nextInt(listOfGameTyeps.length);
                              Navigator.of(context)
                                  .pop(listOfGameTyeps[random]);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.appAccentColor),
                              child: Image.asset(
                                AppAssets.cardsImage,
                                height: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Spin",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.appAccentColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "*Spinning randomly selects game type.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      );
    },
  );

  return result ?? GameType.HOLDEM;
}
