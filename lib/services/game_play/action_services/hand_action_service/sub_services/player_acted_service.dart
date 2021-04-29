import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class PlayerActedService {
  PlayerActedService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    var playerActed = data['playerActed'];
    int seatNo = playerActed['seatNo'];

    // show a prompt regarding last player action
    final gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    final seat = gameState.getSeat(context, seatNo);

    final action = seat.player.action;
    action.setAction(playerActed);
    // play the bet-raise sound effect
    if (action.action == HandActions.BET ||
        action.action == HandActions.RAISE ||
        action.action == HandActions.CALL) {
      Audio.play(
        context: context,
        assetFile: AppAssets.betRaiseSound,
      );
    } else if (action.action == HandActions.FOLD) {
      Audio.play(
        context: context,
        assetFile: AppAssets.foldSound,
      );
    } else if (action.action == HandActions.CHECK) {
      Audio.play(
        context: context,
        assetFile: AppAssets.checkSound,
      );
    }
    int stack = playerActed['stack'];
    if (stack != null) {
      seat.player.stack = stack;
    }
    // before showing the prompt --> turn off the highlight on other players
    gameState.resetActionHighlight(context, -1);
  }
}
