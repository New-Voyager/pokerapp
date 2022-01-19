import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/child_widgets.dart';
import 'package:pokerapp/widgets/multi_game_selection.dart';
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch.dart';
import 'package:pokerapp/widgets/switch_widget.dart';
import 'package:pokerapp/widgets/texts.dart';

/* this dialog handles the timer, as well as the messages sent to the server, when on tapped / on dismissed */
class BombPotDialog {
  /* method available to the outside */
  static Future<bool> prompt({
    @required BuildContext context,
    @required String gameCode,
    @required GameState gameState,
  }) async {
    final theme = AppTheme.getTheme(context);
    List<bool> isSelected = [];
    isSelected.add(false);
    isSelected.add(true);
    isSelected.add(false);

    List<bool> gameSelected = [];
    gameSelected.add(false);
    gameSelected.add(true);
    gameSelected.add(false);
    gameSelected.add(false);
    gameSelected.add(false);

    int bombPotBet = 5;
    bool doubleBoardBombPot = true;
    int selectedGameType = 1; // PLO

    final bool ret = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          final theme = AppTheme.getTheme(context);
          TextEditingController creditsController = TextEditingController();
          creditsController.text = '';

          return StatefulBuilder(builder: (context, setState) {
            String dialogTitle = 'Run Bomb Pot';

            String title = '';
            int selectedIndex = 1;
            if (isSelected[0]) {
              title = 'Next Hand';
              selectedIndex = 0;
            }
            if (isSelected[1]) {
              title = 'Every Hand';
              selectedIndex = 1;
            }
            if (isSelected[2]) {
              title = 'Stop';
              selectedIndex = 2;
            }

            List<String> bombPotSelection = [
              "Off",
              "Next Hand",
              "Every Hand",
            ];

            List<String> gameTypes = [
              "NLH",
              "PLO",
              "Hi-Lo",
              "5 Card PLO",
              "5 Card Hi-Lo",
            ];
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: Container(
                // height: MediaQuery.of(context).size.height * 0.5,
                // margin: EdgeInsets.all(16),
                padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
                decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.accentColor, width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppLabel(dialogTitle, theme),
                    // sep
                    SizedBox(height: 10.ph),
                    RadioToggleButtonsWidget<String>(
                        values: bombPotSelection,
                        onSelect: (value) {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = false;
                          }
                          isSelected[value] = true;
                        },
                        defaultValue: selectedIndex),
                    // sep
                    SizedBox(height: 8.ph),

                    // bomb pot bet size
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LabelText(label: 'Bet Size', theme: theme),
                          RadioListWidget<int>(
                            defaultValue: bombPotBet,
                            values: NewGameConstants.BOMB_POT_BET_SIZE,
                            onSelect: (int value) {
                              bombPotBet = value;
                            },
                          )
                        ]),
                    SizedBox(height: 8.ph),
                    SwitchWidget2(
                      value: doubleBoardBombPot,
                      label: 'Double Board',
                      onChange: (bool value) {
                        doubleBoardBombPot = value;
                      },
                    ),
                    SizedBox(height: 8.ph),
                    RadioToggleButtonsWidget<String>(
                        values: gameTypes,
                        onSelect: (value) {
                          selectedGameType = value;
                        },
                        defaultValue: selectedGameType),

                    // GameTypeSelectionWidget(listOfGameTypes: [
                    //   GameType.HOLDEM,
                    //   GameType.PLO,
                    //   GameType.PLO_HILO,
                    //   GameType.FIVE_CARD_PLO,
                    //   GameType.FIVE_CARD_PLO_HILO,
                    // ], theme: theme, onSelect: () {}),

                    SizedBox(height: 10.ph),

                    /* yes / no button */
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /* no button */
                          RoundRectButton(
                            onTap: () {
                              Navigator.pop(
                                context,
                                false,
                              );
                            },
                            text: "Close",
                            theme: theme,
                          ),

                          /* divider */
                          SizedBox(width: 10.ph),

                          /* true button */
                          RoundRectButton(
                            onTap: () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            text: "Apply",
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
    if (ret) {
      log('bomb pot: $ret');
      GameType gameType = GameType.UNKNOWN;
      if (selectedGameType == 0) {
        gameType = GameType.HOLDEM;
      } else if (selectedGameType == 1) {
        gameType = GameType.PLO;
      } else if (selectedGameType == 2) {
        gameType = GameType.PLO_HILO;
      } else if (selectedGameType == 3) {
        gameType = GameType.FIVE_CARD_PLO;
      } else if (selectedGameType == 4) {
        gameType = GameType.FIVE_CARD_PLO_HILO;
      }

      if (isSelected[0]) {
        // off
        await GameSettingsService.updateBombPot(gameCode, enableBombPot: false);
      } else if (isSelected[1]) {
        // next hand
        await GameSettingsService.updateBombPot(gameCode,
            gameType: gameType,
            bombPotNextHand: true,
            bombPotBet: bombPotBet,
            doubleBoardBombPot: doubleBoardBombPot);
      } else if (isSelected[2]) {
        // every hand
        await GameSettingsService.updateBombPot(gameCode,
            gameType: gameType,
            enableBombPot: true,
            bombPotEveryHand: true,
            bombPotBet: bombPotBet,
            doubleBoardBombPot: doubleBoardBombPot);
      }
    }
    return ret;
  }
}
