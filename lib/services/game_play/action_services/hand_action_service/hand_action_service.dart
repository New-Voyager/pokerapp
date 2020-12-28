import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/deal_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/result_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/stage_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/new_hand_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/next_action_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/player_acted_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/query_hand_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/your_action_service.dart';

class HandActionService {
  HandActionService._();

  static void handle({
    BuildContext context,
    String message,
  }) {
    assert(context != null);
    assert(message != null && message.isNotEmpty);

    var data = jsonDecode(message);

    String messageType = data['messageType'];

    // delegate further actions to sub services as per messageType
    switch (messageType) {
      case AppConstants.RESULT:
        return ResultService.handle(
          context: context,
          data: data,
        );

      case AppConstants.NEW_HAND:
        return NewHandService.handle(
          context: context,
          data: data,
        );

      case AppConstants.DEAL:
        return DealService.handle(
          context: context,
          data: data,
        );

      case AppConstants.QUERY_CURRENT_HAND:
        return QueryHandUpdateService.handle(
          context: context,
          data: data,
        );

      case AppConstants.NEXT_ACTION:
        return NextActionService.handle(
          context: context,
          data: data,
        );

      case AppConstants.PLAYER_ACTED:
        return PlayerActedService.handle(
          context: context,
          data: data,
        );

      case AppConstants.YOUR_ACTION:
        return YourActionService.handle(
          context: context,
          data: data,
        );

      case AppConstants.FLOP:
        return StageUpdateService.handle(
          context: context,
          data: data,
          key: 'flop',
        );

      case AppConstants.TURN:
        return StageUpdateService.handle(
          context: context,
          data: data,
          key: 'turn',
        );

      case AppConstants.RIVER:
        return StageUpdateService.handle(
          context: context,
          data: data,
          key: 'river',
        );
    }
  }
}
