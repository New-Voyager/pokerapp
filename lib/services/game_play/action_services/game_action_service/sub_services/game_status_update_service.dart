import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/board_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:provider/provider.dart';

class GameStatusUpdateService {
  GameStatusUpdateService._();

  static void updateStatus({
    BuildContext context,
    var status,
  }) {
    String tableStatus = status['tableStatus'];
    String gameStatus = status['status'];
    Provider.of<TableState>(
      context,
      listen: false,
    ).updateTableStatus(tableStatus);

    if (tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING) {
      /* QUERY_CURRENT_HAND is done here, only after making sure,
      * that the game is running.
      * This is done to get update of the game */

      String gameCode = Provider.of<ValueNotifier<GameInfoModel>>(
        context,
        listen: false,
      ).value.gameCode;

      GameService.queryCurrentHand(
        gameCode,
        Provider.of<Function(String)>(
          context,
          listen: false,
        ),
      );
    } else if (gameStatus == AppConstants.GAME_ENDED) {
      // end the game
      Provider.of<TableState>(
        context,
        listen: false,
      ).updateTableStatus(AppConstants.GAME_ENDED);
      BoardService.reset(context);
    }
  }
}
