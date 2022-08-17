import 'package:flutter/material.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/proto/enums.pbserver.dart';
import 'package:pokerapp/screens/game_screens/game_info_screen.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/multi_game_selection.dart';
import 'package:pokerapp/widgets/poker_dialog_box.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:pokerapp/enums/game_type.dart' as GameTypeEnum;

class GameInfoBottomSheet extends StatefulWidget {
  final GameState gameState;

  const GameInfoBottomSheet({Key key, this.gameState}) : super(key: key);

  @override
  _GameInfoBottomSheetState createState() => _GameInfoBottomSheetState();
}

class _GameInfoBottomSheetState extends State<GameInfoBottomSheet> {
  double height;

  double ratio = 2;

  AppTextScreen appScreenText;

  String gameType;

  @override
  void initState() {
    appScreenText = getAppTextScreen("newGameSettings2");

    super.initState();
  }

  Widget _buildSeperator(AppTheme theme) => Container(
        color: theme.fillInColor,
        width: double.infinity,
        height: 1.0,
      );

  Widget _buildRadio({
    @required bool value,
    @required String label,
    @required void Function(bool v) onChange,
    @required AppTheme theme,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /* switch */
          SwitchWidget2(
            label: label,
            value: value,
            onChange: onChange,
          ),

          /* seperator */
          _buildSeperator(theme),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    height = MediaQuery.of(context).size.height;
    return Container(
      height: height / ratio,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 13,
              ),
              Expanded(
                child: GameInfoScreen(
                  gameState: widget.gameState,
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (ratio == 2) {
                      ratio = 1.5;
                    } else {
                      ratio = 2;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.accentColor,
                  ),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    ratio == 2 ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: theme.primaryColorWithDark(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 70,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  PokerDialogBox.show(
                    context,
                    title: "Game Settings",
                    content: StatefulBuilder(
                        // You need this, notice the parameters below:
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NewGameSettings2.sepV20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: LabelText(
                                        label: 'Action time out',
                                        theme: theme)),
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RadioToggleButtonsWidget<String>(
                                          onSelect: (int index) {
                                            // if (index == 0) {
                                            //   gmp.chipUnit = ChipUnit.DOLLAR;
                                            // } else {
                                            //   gmp.chipUnit = ChipUnit.CENT;
                                            // }
                                          },
                                          // defaultValue:
                                          //     gmp.chipUnit == ChipUnit.DOLLAR
                                          //         ? 0
                                          //         : 1,
                                          values: [
                                            '10s',
                                            '15s',
                                            '20s',
                                            '30s',
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            NewGameSettings2.sepV8,
                            LabelText(label: 'Game Type', theme: theme),
                            RadioListWidget<String>(
                              defaultValue: 'PLO',
                              wrap: true,
                              values: [
                                'NLH',
                                'PLO',
                                '5 Card PLO',
                                '6 Card PLO',
                                'ROE',
                                'Dealers Choice',
                              ],
                              onSelect: (String value) {
                                if (value == 'NLH') {
                                  // gmp.settings.gameType = GameType.PLO;
                                  gameType = GameType.HOLDEM.name;
                                } else if (value == 'PLO') {
                                  // gmp.settings.gameType = GameType.PLO_HILO;
                                  gameType = GameType.PLO.name;
                                } else if (value == '5 Card PLO') {
                                  // gmp.settings.gameType = GameType.FIVE_CARD_PLO;
                                  gameType = GameType.FIVE_CARD_PLO.name;
                                } else if (value == '6 Card PLO') {
                                  // gmp.settings.gameType = GameType.SIX_CARD_PLO;
                                  gameType = GameType.SIX_CARD_PLO.name;
                                } else if (value == 'ROE') {
                                  // gmp.settings.gameType =
                                  // GameType.SIX_CARD_PLO_HILO;
                                  gameType = GameTypeEnum.GameType.ROE.name;
                                } else if (value == 'Dealers Choice') {
                                  // gmp.settings.gameType =
                                  // GameType.SIX_CARD_PLO_HILO;
                                  gameType =
                                      GameTypeEnum.GameType.DEALER_CHOICE.name;
                                }
                                print(gameType + "shfsf");
                                // determinePlayerCounts(gmp);
                                setState(() {});

                                print(gameType == GameType.PLO.name ||
                                    gameType == GameType.FIVE_CARD_PLO.name ||
                                    gameType == GameType.SIX_CARD_PLO.name);
                              },
                            ),
                            /* sep */
                            NewGameSettings2.sepV8,

                            /* UTG straddle */
                            (gameType == GameType.PLO.name ||
                                    gameType == GameType.FIVE_CARD_PLO.name ||
                                    gameType == GameType.SIX_CARD_PLO.name)
                                ? _buildRadio(
                                    label: "Hi-Lo",
                                    // value: gmp.straddleAllowed,
                                    value: false,
                                    onChange: (bool b) {
                                      // gmp.straddleAllowed = b;
                                    },
                                    theme: theme,
                                  )
                                : SizedBox.shrink(),
                            /* tips */
                            NewGameSettings2.sepV8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child:
                                        LabelText(label: 'Tips', theme: theme)),
                                Flexible(
                                  flex: 7,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: TextInputWidget(
                                          // value: gmp.rakePercentage,
                                          small: true,
                                          //label: appScreenText['min'],
                                          trailing: '%', //appScreenText['bb'],
                                          title: appScreenText["tipsPercent"],
                                          minValue: 0,
                                          maxValue: 50,
                                          // decimalAllowed:
                                          //     gmp.chipUnit == ChipUnit.CENT,
                                          // onChange: (value) {
                                          //   gmp.rakePercentage = value;
                                          // },
                                        ),
                                      ),
                                      NewGameSettings2.sepH10,
                                      Text('Cap:'),
                                      NewGameSettings2.sepH10,
                                      Flexible(
                                        flex: 3,
                                        child: TextInputWidget(
                                          key: UniqueKey(),
                                          // value: gmp.rakeCap,
                                          small: true,
                                          // decimalAllowed:
                                          //     gmp.chipUnit == ChipUnit.CENT,
                                          title: appScreenText['maxTips'],
                                          trailing: '', // appScreenText['bb'],
                                          minValue: 0,
                                          maxValue: -1,
                                          // onChange: (value) {
                                          //   gmp.rakeCap = value;
                                          // },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            (gameType == GameTypeEnum.GameType.ROE.name ||
                                    gameType ==
                                        GameTypeEnum
                                            .GameType.DEALER_CHOICE.name)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LabelText(
                                          label: 'Choose Games', theme: theme),
                                      MultiGameSelection(
                                        [
                                          GameTypeEnum.GameType.HOLDEM,
                                          GameTypeEnum.GameType.PLO,
                                          GameTypeEnum.GameType.PLO_HILO,
                                          GameTypeEnum.GameType.FIVE_CARD_PLO,
                                          GameTypeEnum
                                              .GameType.FIVE_CARD_PLO_HILO,
                                          GameTypeEnum.GameType.SIX_CARD_PLO,
                                          GameTypeEnum
                                              .GameType.SIX_CARD_PLO_HILO,
                                        ],
                                        onSelect: (games) {
                                          // if (widget.mainGameType == GameType.ROE) {
                                          //   gmp.settings.roeGames.addAll(games);
                                          // } else {
                                          //   gmp.settings.dealerChoiceGames.addAll(games);
                                          // }
                                          // determinePlayerCounts(gmp);
                                        },
                                        onRemove: (game) {
                                          // if (widget.mainGameType == GameType.ROE) {
                                          //   gmp.settings.roeGames.remove(game);
                                          // } else {
                                          //   gmp.settings.dealerChoiceGames.remove(game);
                                          // }
                                          // determinePlayerCounts(gmp);
                                        },
                                        // existingChoices:
                                        //     widget.gameState.currentHandGameType == GameType.ROE
                                        //         ? gmp.settings.roeGames
                                        //         : gmp.settings.dealerChoiceGames),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            NewGameSettings2.sepV20,
                            ButtonWidget(
                              text: 'Save',
                              onTap: () {
                                // if (gmp.buyInMax < gmp.buyInMin) {
                                //   Alerts.showNotification(
                                //     titleText:
                                //         appScreenText['gameCreationFailed'],
                                //     subTitleText:
                                //         appScreenText['checkBuyinRange'],
                                //     duration: Duration(seconds: 5),
                                //   );
                                //   return;
                                // } else {
                                //   Navigator.pop(context, gmp);
                                // }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: theme.accentColor),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: theme.primaryColorWithDark(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: theme.accentColor),
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: theme.primaryColorWithDark(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
