import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class YourActionService {
  YourActionService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    /* play an sound effect alerting the user */
    Audio.play(
      context: context,
      assetFile: AppAssets.playerTurnSound,
    );

    var seatAction = data['seatAction'];

    String gameID = data['gameId'].toString();
    int seatNo = int.parse(data['seatNo'].toString());

    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.setAction(context, seatNo, seatAction);
    gameState.showAction(context, true);
  }
}
