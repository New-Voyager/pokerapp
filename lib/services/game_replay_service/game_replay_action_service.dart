import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';

class GameReplayActionService {
  GameReplayActionService._();

  static void takeAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    assert(context != null);

    switch (action.actionType) {
      case GameReplayActionType.card_distribution:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.pre_flop_started:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.player_action:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.flop_started:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.river_started:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.turn_started:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.showdown:
        // TODO: Handle this case.
        break;
      case GameReplayActionType.declare_winner:
        // TODO: Handle this case.
        break;
    }
  }
}
