import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/milliseconds_counter.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class DealerChoicePrompt extends StatelessWidget {
  final List<GameType> listOfGameTypes;
  final Duration duration;
  final Function onSelect;

  DealerChoicePrompt(this.listOfGameTypes, this.duration, this.onSelect);

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    if (duration.inSeconds <= 0) {
      return '0';
    }
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //return "$twoDigitMinutes:$twoDigitSeconds";
    return "${duration.inSeconds}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Choose a game',
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
                        //dismissed = true;
                        //Navigator.of(context).pop(listOfGameTypes[index]);
                        if (this.onSelect != null) {
                          this.onSelect(listOfGameTypes[index]);
                        }
                      },
                      borderRadius: BorderRadius.circular(32.pw),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        width: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
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
                                GameModelNew.getGameTypeImageAssetFromEnum(
                                    listOfGameTypes[index]),
                                height: 32,
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
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // dismissed = true;
                        int random =
                            math.Random().nextInt(listOfGameTypes.length);
                        if (this.onSelect != null) {
                          this.onSelect(listOfGameTypes[random]);
                        }
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
                    CountdownMs(
                        key: UniqueKey(),
                        totalSeconds: this.duration.inSeconds,
                        currentSeconds: 0,
                        build: (_, time) {
                          int remainingTime = time ~/ 1000;
                          return RichText(
                            text: TextSpan(
                              text: printDuration(
                                  Duration(seconds: remainingTime)),
                              style: TextStyle(
                                  color: AppColorsNew.yellowAccentColor,
                                  fontSize: 18.dp),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
          AppDimensionsNew.getVerticalSizedBox(16),
        ],
      ),
    );
  }

  static Future<GameType> prompt({
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
        AppTheme theme = AppTheme.getTheme(context);
        return AlertDialog(
          backgroundColor: AppColorsNew.newDialogBgColor.withAlpha(100),
          content: StatefulBuilder(
            builder: (context, localState) {
              Future.delayed(
                  Duration(milliseconds: timeLimit.inSeconds * 1000 + 250), () {
                if (!dismissed) {
                  dismissed = true;
                  int random = math.Random().nextInt(listOfGameTypes.length);
                  Navigator.of(context).pop(listOfGameTypes[random]);
                }
              });

              return DealerChoicePrompt(listOfGameTypes, timeLimit,
                  (GameType gameType) {
                dismissed = true;
                Navigator.of(context).pop(gameType);
              });
            },
          ),
        );
      },
    );
    log('GameType: ${result.toJson()}');
    return result ?? GameType.HOLDEM;
  }
}
