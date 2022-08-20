import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_screens/game_info_screen.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/multi_game_selection.dart';
import 'package:pokerapp/widgets/poker_dialog_box.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/text_input_widget.dart';
import 'package:pokerapp/widgets/texts.dart';

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
          Visibility(
            visible: widget.gameState.isAdmin(),
            child: Positioned(
              right: 70,
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    if (!widget.gameState.tableState.gamePaused) {
                      showErrorDialog(context, 'Change',
                          'Game should be paused to change settings');
                      return;
                    }
                    showSettingsDialog(widget.gameState, theme);
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

  void showSettingsDialog(GameState gameState, AppTheme theme) {
    var actionTimeouts = [
      '10s',
      '15s',
      '20s',
      '30s',
    ];

    var gameTypes = [
      'NLH',
      'PLO',
      '5 Card PLO',
      '6 Card PLO',
      'ROE',
      // "Dealer's Choice",
    ];

    List<GameType> selectedGames = [];
    int actionTimeout = gameState.gameInfo.actionTime;
    String actionTimeoutStr = '${actionTimeout}s';
    int actionTimeoutIdx = actionTimeouts.indexOf(actionTimeoutStr);
    if (actionTimeoutIdx == -1) {
      actionTimeoutIdx = 2;
    }

    double rakeCap = gameState.gameInfo.tipsCap;
    double rakePercentage = gameState.gameInfo.tipsPercentage;

    bool hiLo = false;
    GameType gameType =
        GameTypeSerialization.fromJson(gameState.gameInfo.gameType);
    String gameTypeStr = '';
    if (gameType == GameType.PLO_HILO ||
        gameType == GameType.FIVE_CARD_PLO_HILO ||
        gameType == GameType.SIX_CARD_PLO_HILO) {
      hiLo = true;
    }

    if (gameType == GameType.HOLDEM) {
      gameTypeStr = 'NLH';
    } else if (gameType == GameType.PLO || gameType == GameType.PLO_HILO) {
      gameTypeStr = 'PLO';
      gameType = GameType.PLO;
    } else if (gameType == GameType.FIVE_CARD_PLO ||
        gameType == GameType.FIVE_CARD_PLO_HILO) {
      gameTypeStr = '5 Card PLO';
      gameType = GameType.FIVE_CARD_PLO;
    } else if (gameType == GameType.SIX_CARD_PLO ||
        gameType == GameType.SIX_CARD_PLO_HILO) {
      gameTypeStr = '6 Card PLO';
      gameType = GameType.SIX_CARD_PLO;
    } else if (gameType == GameType.DEALER_CHOICE) {
      gameTypeStr = "Dealer's Choice";
    } else if (gameType == GameType.ROE) {
      gameTypeStr = "ROE";
    }

    selectedGames.add(GameType.PLO);
    selectedGames.add(GameType.HOLDEM);

    PokerDialogBox.show(
      context,
      title: "Change Settings",
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
                      child: LabelText(label: 'Action Timeout', theme: theme)),
                  Flexible(
                    flex: 6,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioToggleButtonsWidget<String>(
                            onSelect: (int index) {},
                            values: actionTimeouts,
                            defaultValue: actionTimeoutIdx,
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
                defaultValue: gameTypeStr,
                wrap: true,
                values: gameTypes,
                onSelect: (String value) {
                  if (value == 'NLH') {
                    gameType = GameType.HOLDEM;
                  } else if (value == 'PLO') {
                    gameType = GameType.PLO;
                  } else if (value == '5 Card PLO') {
                    gameType = GameType.FIVE_CARD_PLO;
                  } else if (value == '6 Card PLO') {
                    gameType = GameType.SIX_CARD_PLO;
                  } else if (value == 'ROE') {
                    gameType = GameType.ROE;
                  } else if (value == 'Dealers Choice') {
                    gameType = GameType.DEALER_CHOICE;
                  }
                  setState(() {});
                },
              ),
              /* sep */
              NewGameSettings2.sepV8,

              /* Hi Lo*/
              (gameType == GameType.PLO ||
                      gameType == GameType.FIVE_CARD_PLO ||
                      gameType == GameType.SIX_CARD_PLO)
                  ? _buildRadio(
                      label: "Hi-Lo",
                      value: hiLo,
                      onChange: (bool b) {
                        hiLo = b;
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
                      flex: 3, child: LabelText(label: 'Tips', theme: theme)),
                  Flexible(
                    flex: 7,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 3,
                          child: TextInputWidget(
                            value: rakePercentage,
                            small: true,
                            trailing: '%', //appScreenText['bb'],
                            title: appScreenText["tipsPercent"],
                            minValue: 0,
                            maxValue: 50,
                            decimalAllowed:
                                gameState.gameInfo.chipUnit == ChipUnit.CENT,
                            onChange: (value) {
                              rakePercentage = value;
                            },
                          ),
                        ),
                        NewGameSettings2.sepH10,
                        Text('Cap:'),
                        NewGameSettings2.sepH10,
                        Flexible(
                          flex: 3,
                          child: TextInputWidget(
                            key: UniqueKey(),
                            value: rakeCap,
                            small: true,
                            decimalAllowed:
                                gameState.gameInfo.chipUnit == ChipUnit.CENT,
                            title: appScreenText['maxTips'],
                            trailing: '', // appScreenText['bb'],
                            minValue: 0,
                            maxValue: -1,
                            onChange: (value) {
                              rakeCap = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              (gameType == GameType.ROE || gameType == GameType.DEALER_CHOICE)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelText(label: 'Choose Games', theme: theme),
                        MultiGameSelection(
                          [
                            GameType.HOLDEM,
                            GameType.PLO,
                            GameType.PLO_HILO,
                            GameType.FIVE_CARD_PLO,
                            GameType.FIVE_CARD_PLO_HILO,
                            GameType.SIX_CARD_PLO,
                            GameType.SIX_CARD_PLO_HILO,
                          ],
                          onSelect: (games) {
                            for (var gameType in games) {
                              if (selectedGames.indexOf(gameType) == -1) {
                                selectedGames.add(gameType);
                              }
                            }
                            //selectedGames.addAll(games);
                          },
                          onRemove: (game) {
                            selectedGames.remove(game);
                          },
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              NewGameSettings2.sepV20,
              ButtonWidget(
                text: 'Change',
                onTap: () async {
                  GameSettings settings = GameSettings();
                  settings.actionTime = actionTimeout;
                  settings.rakeCap = rakeCap;
                  settings.rakePercentage = rakePercentage;
                  if (gameType == GameType.ROE) {
                    settings.roeGames = selectedGames;
                  } else if (gameType == GameType.DEALER_CHOICE) {
                    settings.dealerChoiceGames = selectedGames;
                  }
                  if (hiLo) {
                    if (gameType == GameType.PLO) {
                      gameType = GameType.PLO_HILO;
                    } else if (gameType == GameType.FIVE_CARD_PLO) {
                      gameType = GameType.FIVE_CARD_PLO_HILO;
                    } else if (gameType == GameType.SIX_CARD_PLO) {
                      gameType = GameType.SIX_CARD_PLO_HILO;
                    }
                  }
                  final loadingDialog = LoadingDialog();
                  try {
                    settings.gameType = gameType;
                    loadingDialog.show(
                        context: context, loadingText: 'Updating...');
                    await GameSettingsService.updateGameSettings(
                        gameState.gameCode, settings);
                    loadingDialog.dismiss(context: context);
                    Navigator.pop(context);
                  } catch (err) {
                    loadingDialog.dismiss(context: context);
                    showErrorDialog(context, 'Error', 'Update failed');
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
