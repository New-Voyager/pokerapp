import 'package:flutter/foundation.dart';

enum GameReplayActionType {
  card_distribution,
  pre_flop_started,
  player_action,
  flop_started,
  river_started,
  turn_started,
  showdown,
  declare_winner,
}

class GameReplayAction {
  GameReplayActionType _gameReplayActionType;
  dynamic _actionData;

  GameReplayAction({
    @required GameReplayActionType gameReplayActionType,
    dynamic actionData,
  }) {
    this._gameReplayActionType = gameReplayActionType;
    this._actionData = actionData;
  }

  GameReplayActionType get actionType => _gameReplayActionType;

  dynamic get actionData => _actionData;
}
