import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/game_status_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/high_hand_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/player_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/sub_services/table_update_service.dart';

class GameActionService {
  GameActionService._();

  // only one method is exposed - handle
  static void handle({
    @required String message,
    // we need the context, to update the UI using Provider
    @required BuildContext context,
  }) {
    assert(message != null && message.isNotEmpty);
    assert(context != null);

    var data = jsonDecode(message);

    String messageType = data['messageType'];
    debugPrint('Game: $message');
    // delegate further actions to sub services as per messageType
    switch (messageType) {
      case AppConstants.PLAYER_UPDATE:
        return PlayerUpdateService.handle(
          context: context,
          data: data,
        );

      case AppConstants.TABLE_UPDATE:
        return TableUpdateService.handle(
          context: context,
          data: data,
        );

      case AppConstants.HIGH_HAND:
        return HighHandService.handle(
          context: context,
          data: data['highHand'],
          showNotification: true,
        );

      case AppConstants.GAME_STATUS:
        return GameStatusUpdateService.updateStatus(
          context: context,
          status: data['status'],
        );
    }
  }
}
