import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/milliseconds_counter.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/switch.dart';

class DealerChoiceSelection {
  GameType gameType;
  bool doubleBoard = false;
}

class DealerChoicePrompt extends StatefulWidget {
  final List<GameType> listOfGameTypes;
  final Duration duration;
  final Function onSelect;

  DealerChoicePrompt(this.listOfGameTypes, this.duration, this.onSelect);

  @override
  State<DealerChoicePrompt> createState() => _DealerChoicePromptState();

  static Future<DealerChoiceSelection> prompt({
    @required List<GameType> listOfGameTypes,
    @required Duration timeLimit,
  }) async {
    int sec = timeLimit.inSeconds;
    bool dismissed = false;
    DealerChoiceSelection result = await showDialog<DealerChoiceSelection>(
      context: navigatorKey.currentContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColorsNew.newDialogBgColor.withAlpha(100),
          content: StatefulBuilder(
            builder: (context, localState) {
              Future.delayed(
                  Duration(milliseconds: timeLimit.inSeconds * 1000 + 250), () {
                if (!dismissed) {
                  dismissed = true;
                  int random = math.Random().nextInt(listOfGameTypes.length);
                  Navigator.of(context).pop();
                }
              });

              return DealerChoicePrompt(listOfGameTypes, timeLimit,
                  (GameType gameType, bool doubleBoard) {
                DealerChoiceSelection ret = DealerChoiceSelection();
                ret.doubleBoard = doubleBoard;
                ret.gameType = gameType;
                dismissed = true;
                Navigator.of(context).pop(ret);
              });
            },
          ),
        );
      },
    );
    if (result == null) {
      result = DealerChoiceSelection();
      result.gameType = listOfGameTypes[0];
      result.doubleBoard = false;
    }

    return result;
  }
}

class _DealerChoicePromptState extends State<DealerChoicePrompt> {
  bool doubleBoard = false;

  String printDuration(Duration duration) {
    if (duration.inSeconds <= 0) {
      return '0';
    }
    return "${duration.inSeconds}";
  }

  double minOf(double a, double b) {
    return a > b ? b : a;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.getTheme(context);
    final parentSize = Screen.size;
    final maxWidth = 520.0;

    List<String> gameTypes = [
      'NLH',
      'NLH DB',
      '4 Card PLO',
      '4 Card PLO DB',
      '5 Card PLO',
      '5 Card PLO DB',
      '6 Card PLO',
      '6 Card PLO DB',
      '4 Card\nHi-Lo',
      '5 Card\nHi-Lo',
      '6 Card\nHi-Lo',
    ];
    return Container(
      //height: minOf(parentSize.width * 0.90, maxWidth * 0.90),
      width: minOf(parentSize.width, maxWidth),
      //decoration: AppStylesNew.BgGreenRadialGradient,
      decoration: BoxDecoration(
        color: appTheme.primaryColorWithDark(),
        border: Border.all(
          color: appTheme.accentColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // padding: EdgeInsets.symmetric(
      //   horizontal: 8.pw,
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Choose a game',
              style: AppDecorators.getAccentTextStyle(theme: appTheme),
            ),
          ),
          // SwitchWidget2(
          //     label: 'Double board',
          //     value: doubleBoard,
          //     onChange: (v) {
          //       doubleBoard = v;
          //     }),
          Flexible(
            child: Container(
                width: minOf(parentSize.width,
                    maxWidth), //MediaQuery.of(context).size.width * 0.7,
                // height: MediaQuery.of(context).size.height * 0.4,
                margin: EdgeInsets.only(
                  top: 8.ph,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  itemCount: gameTypes.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: appTheme.primaryColor,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        if (this.widget.onSelect != null) {
                          GameType gameType = GameType.UNKNOWN;
                          bool doubleBoard = false;
                          String chosenGame = gameTypes[index];
                          if (chosenGame == 'NLH') {
                            gameType = GameType.HOLDEM;
                          } else if (chosenGame == 'NLH DB') {
                            gameType = GameType.HOLDEM;
                            doubleBoard = true;
                          } else if (chosenGame == '4 Card PLO') {
                            gameType = GameType.PLO;
                          } else if (chosenGame == '4 Card PLO DB') {
                            gameType = GameType.PLO;
                            doubleBoard = true;
                          } else if (chosenGame == '5 Card PLO') {
                            gameType = GameType.FIVE_CARD_PLO;
                          } else if (chosenGame == '5 Card PLO DB') {
                            gameType = GameType.FIVE_CARD_PLO;
                            doubleBoard = true;
                          } else if (chosenGame == '6 Card PLO') {
                            gameType = GameType.SIX_CARD_PLO;
                          } else if (chosenGame == '6 Card PLO DB') {
                            gameType = GameType.SIX_CARD_PLO;
                            doubleBoard = true;
                          } else if (chosenGame == '4 Card Hi-Lo') {
                            gameType = GameType.PLO_HILO;
                          } else if (chosenGame == '5 Card Hi-Lo') {
                            gameType = GameType.FIVE_CARD_PLO_HILO;
                          } else if (chosenGame == '6 Card Hi-Lo') {
                            gameType = GameType.SIX_CARD_PLO_HILO;
                          }

                          this.widget.onSelect(gameType, doubleBoard);
                          // this.widget.onSelect(
                          //     widget.listOfGameTypes[index], doubleBoard);
                        }
                      },
                      // icon: Image.asset(
                      //     GameModelNew.getGameTypeImageAssetFromEnum(
                      //         widget.listOfGameTypes[index]),
                      //     width: 24,
                      //     height: 24),
                      child: Text(
                        //"${gameTypeShortStr(widget.listOfGameTypes[index])}",
                        gameTypes[index],
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.dp,
                          color: AppColorsNew.newGreenButtonColor,
                          height: 0.9,
                        ),
                      ),
                    );
                  },
                )),
          ),
          Divider(
            color: AppColorsNew.yellowAccentColor,
            height: 32,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: appTheme.primaryColor),
            onPressed: () {
              if (this.widget.onSelect != null) {
                int random =
                    math.Random().nextInt(widget.listOfGameTypes.length);
                if (this.widget.onSelect != null) {
                  this
                      .widget
                      .onSelect(widget.listOfGameTypes[random], doubleBoard);
                }
              }
            },
            child: Text(
              'Random',
              //textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.dp,
                color: AppColorsNew.newGreenButtonColor,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          CountdownMs(
              key: UniqueKey(),
              totalSeconds: this.widget.duration.inSeconds,
              currentSeconds: 0,
              build: (_, time) {
                int remainingTime = time ~/ 1000;
                return RichText(
                  text: TextSpan(
                    text: printDuration(Duration(seconds: remainingTime)),
                    style: TextStyle(
                        color: AppColorsNew.yellowAccentColor, fontSize: 18.dp),
                  ),
                );
              }),
          AppDimensionsNew.getVerticalSizedBox(16),
        ],
      ),
    );
  }
}
