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
import 'package:pokerapp/widgets/radio_list_widget.dart';
import 'package:pokerapp/widgets/switch_widget.dart';

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
            if (isSelected[0]) {
              title = 'Next Hand';
            }
            if (isSelected[1]) {
              title = 'Every Hand';
            }
            if (isSelected[2]) {
              title = 'Stop';
            }

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
                    ToggleButtons(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('Off',
                                style: TextStyle(
                                    color: isSelected[0]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('Next Hand',
                                style: TextStyle(
                                    color: isSelected[1]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('Every Hand',
                                style: TextStyle(
                                    color: isSelected[2]
                                        ? Colors.black
                                        : theme.accentColor))),
                      ],
                      isSelected: isSelected,
                      selectedColor: Colors.black,
                      fillColor: theme.accentColor,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = false;
                          }
                          isSelected[index] = true;
                        });
                      },
                    ),
                    // sep
                    SizedBox(height: 10.ph),
                    // bomb pot bet size
                    AppLabel('Bet Size', theme),

                    RadioListWidget<int>(
                      defaultValue: bombPotBet,
                      values: NewGameConstants.BOMB_POT_BET_SIZE,
                      onSelect: (int value) {
                        bombPotBet = value;
                      },
                    ),

                    SwitchWidget(
                      value: doubleBoardBombPot,
                      label: 'Double Board',
                      onChange: (bool value) {
                        doubleBoardBombPot = value;
                      },
                    ),

                    ToggleButtons(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('NLH',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gameSelected[0]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('PLO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gameSelected[1]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('5 Card\nPLO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gameSelected[2]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('PLO\nHi-Lo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gameSelected[3]
                                        ? Colors.black
                                        : theme.accentColor))),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text('5 Card\nPLO Hi-Lo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gameSelected[4]
                                        ? Colors.black
                                        : theme.accentColor))),
                      ],
                      isSelected: gameSelected,
                      selectedColor: Colors.black,
                      fillColor: theme.accentColor,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < gameSelected.length; i++) {
                            gameSelected[i] = false;
                          }
                          gameSelected[index] = true;
                        });
                      },
                    ),
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
      if (gameSelected[0]) {
        gameType = GameType.HOLDEM;
      } else if (gameSelected[1]) {
        gameType = GameType.PLO;
      } else if (gameSelected[2]) {
        gameType = GameType.PLO_HILO;
      } else if (gameSelected[3]) {
        gameType = GameType.FIVE_CARD_PLO;
      } else if (gameSelected[4]) {
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
