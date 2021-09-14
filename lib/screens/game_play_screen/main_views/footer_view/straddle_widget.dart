import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/widgets/straddle_dialog.dart';
import 'package:provider/provider.dart';

class StraddleWidget extends StatelessWidget {
  final GameState gameState;
  StraddleWidget(this.gameState);

  @override
  Widget build(BuildContext context) {
    return Consumer<StraddlePromptState>(
        builder: (_, straddlePromptState, ___) {
      final gameState = GameState.getState(context);
      if (gameState.customizationMode) {
        return Container();
      }
      return Align(
        child: Transform.scale(
          scale: 0.80,
          child: StraddleDialog(
            straddlePrompt: gameState.straddlePrompt,
            gameState: gameState,
            onSelect: (List<bool> optionAutoValue) {
              final straddleOption = optionAutoValue[0];
              final autoStraddle = optionAutoValue[1];
              final straddleChoice = optionAutoValue[2];

              // put the settings in the game state settings
              gameState.config.straddleOption = straddleOption;
              gameState.config.autoStraddle = autoStraddle;

              if (straddleChoice != null) {
                gameState.straddlePrompt = false;
                straddlePromptState.notify();

                if (straddleChoice == true) {
                  // act now
                  log('Player wants to straddle');
                  final gameContextObject = context.read<GameContextObject>();
                  HandActionProtoService.takeAction(
                    gameContextObject: gameContextObject,
                    gameState: gameState,
                    action: AppConstants.STRADDLE,
                    amount: 2 * gameState.gameInfo.bigBlind,
                  );
                } else {
                  log('Player does not want to straddle');
                  // show action buttons
                  gameState.showAction(true);
                }
              }
            },
          ),
        ),
      );
    });
  }
}
