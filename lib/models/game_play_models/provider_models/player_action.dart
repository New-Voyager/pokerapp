import 'package:flutter/widgets.dart';

const String FOLD = 'FOLD';
const String CALL = 'CALL';
const String CHECK = 'CHECK';
const String BET = 'BET';
const String RAISE = 'RAISE';
const String ALLIN = 'ALLIN';

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

class Option {
  String text;
  int amount;

  Option.fromJson(var data) {
    this.text = data['text'];
    this.amount = data['amount'];
  }
}

class PlayerAction {
  int _seatNo;
  List<Action> _actions;

  int _minRaiseAmount;
  int _maxRaiseAmount;

  List<Option> _options;

  PlayerAction(int seatNo, var seatAction) {
    _seatNo = seatNo;

    /*
      {
        ...
        ...
        "seatAction": {
          "seatNo": 1,
          "availableActions": ["FOLD", "CALL", "BET", "ALLIN"],
          "callAmount": 2,
          "minRaiseAmount": 4,
          "maxRaiseAmount": 30,
          "allInAmount": 30,
          "betOptions": [{
            "text": "3BB",
            "amount": 6
          }, {
            "text": "5BB",
            "amount": 10
          }, {
            "text": "10BB",
            "amount": 20
          }, {
            "text": "All-In",
            "amount": 30
          }]
        }
      }
    */

    // FIXME: MIN RAISE AMOUNT VALUE NOT RECEIVING?
    this._minRaiseAmount = seatAction['minRaiseAmount'] ?? 2;
    this._maxRaiseAmount = seatAction['maxRaiseAmount'];

    _options = seatAction['betOptions']
        ?.map<Option>((var data) => Option.fromJson(data))
        ?.toList();

    _actions = [];
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
  List<Option> get options => _options;

  int get minRaiseAmount => _minRaiseAmount;
  int get maxRaiseAmount => _maxRaiseAmount;
  int get seatNo => _seatNo;
}
