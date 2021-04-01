import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
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
    final player = gameState.fromSeat(context, seatNo);
    //player.highlight = false;
    // show the status message
    player.status = "${playerActed['action']}"; 

    String action = playerActed['action'];

    // check if player folded
    if (action == AppConstants.FOLD) {
      player.playerFolded = true;
    }

    // play the bet-raise sound effect
    if (action == AppConstants.BET ||
        action == AppConstants.RAISE ||
        action == AppConstants.CALL)
      Audio.play(
        context: context,
        assetFile: AppAssets.betRaiseSound,
      );

    if (action == AppConstants.FOLD)
      Audio.play(
        context: context,
        assetFile: AppAssets.foldSound,
      );

    if (action == AppConstants.CHECK)
      Audio.play(
        context: context,
        assetFile: AppAssets.checkSound,
      );

    int amount = playerActed['amount'];
    if (amount != null)
      player.coinAmount = amount;

    int stack = playerActed['stack'];
    if (stack != null)
      player.stack = stack;
    // before showing the prompt --> turn off the highlight on other players
    gameState.resetActionHighlight(context, -1);
  }
}
