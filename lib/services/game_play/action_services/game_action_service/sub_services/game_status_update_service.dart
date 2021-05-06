import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/board_service.dart';
import 'package:provider/provider.dart';

class GameStatusUpdateService {
  GameStatusUpdateService._();

  /*
    {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"ACTIVE","tableStatus":"WAITING_TO_BE_STARTED"}}
    {"gameId":"90","gameCode":"CG-Z44IXIK44KWKBQW","messageType":"GAME_STATUS","status":{"status":"PAUSED","tableStatus":"GAME_RUNNING"}}
  */

  static void updateStatus({
    BuildContext context,
    var status,
  }) {
    String tableStatus = status['tableStatus'];
    String gameStatus = status['status'];

    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    final GameContextObject gameContext =
        Provider.of<GameContextObject>(context, listen: false);

    final tableState = gameState.getTableState(context);

    tableState.updateTableStatusSilent(tableStatus);
    tableState.updateGameStatusSilent(gameStatus);

    if (tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING) {
      /* QUERY_CURRENT_HAND is done here, only after making sure,
      * that the game is running.
      * This is done to get update of the game */
      gameContext.handActionService.queryCurrentHand();
    } else if (gameStatus == AppConstants.GAME_ENDED) {
      // end the game
      log("111GameStatus : $gameStatus in gamestatusupdate service");
      tableState.updateTableStatusSilent(AppConstants.GAME_ENDED);
      BoardService.reset(context);
    } else if (gameStatus == AppConstants.GAME_PAUSED) {
      // paused the game
      tableState.updateTableStatusSilent(AppConstants.GAME_PAUSED);
      BoardService.reset(context);
    }

    tableState.notifyAll();
  }
}
