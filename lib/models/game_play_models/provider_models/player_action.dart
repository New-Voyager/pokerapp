import 'package:flutter/foundation.dart';

class Action {
  String actionName;
  int actionValue;
  int minActionValue;

  Action({
    @required this.actionName,
    this.actionValue,
    this.minActionValue,
  });
}

const String FOLD = 'FOLD';
const String CALL = 'CALL';
const String CHECK = 'CHECK';
const String BET = 'BET';
const String RAISE = 'RAISE';
const String ALLIN = 'ALLIN';

class PlayerAction {
  List<Action> _actions;

  PlayerAction(var seatAction) {
    _actions = List<Action>();

    seatAction['availableActions']
        .map<String>((s) => s.toString())
        .forEach((String actionName) {
      Action action = Action(
        actionName: actionName,
      );

      switch (actionName) {
        case CALL:
          action.actionValue = seatAction['callAmount'];
          break;
        case RAISE:
          action.minActionValue = seatAction['minRaiseAmount'];
          break;
        case ALLIN:
          action.actionValue = seatAction['allInAmount'];
          break;
      }

      _actions.add(action);
    });
  }

  List<Action> get actions => _actions;
}
