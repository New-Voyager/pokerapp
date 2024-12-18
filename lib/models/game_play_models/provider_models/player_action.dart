import 'package:flutter/widgets.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/hand.pbenum.dart';

const String FOLD = 'FOLD';
const String CALL = 'CALL';
const String CHECK = 'CHECK';
const String BET = 'BET';
const String RAISE = 'RAISE';
const String ALLIN = 'ALLIN';

class AvailableAction {
  String actionName;
  double actionValue;
  double minActionValue;

  AvailableAction({
    @required this.actionName,
    this.actionValue,
    this.minActionValue,
  });
}

class Option {
  String text;
  double amount;

  Option({
    @required this.text,
    @required this.amount,
  });

  Option.fromJson(var data) {
    this.text = data['text'];
    this.amount = data['amount'];
  }

  static Option get sample {
    return Option.fromJson({
      'text': 'Bet',
      'amount': 34,
    });
  }
}

class PlayerAction {
  int _seatNo;
  List<AvailableAction> _actions;

  double _minRaiseAmount;
  double _maxRaiseAmount;
  double _callAmount = 0;
  double _allInAmount = 0;
  double _raiseAmount = 0;
  double _potAmount = 0;
  double _seatInSoFar = 0;
  double _ploPotAmount = 0;
  List<Option> _options;
  bool _raise = false;

  PlayerAction();

  factory PlayerAction.fromJson(int seatNo, var seatAction) {
    PlayerAction playerAction = PlayerAction();
    playerAction._seatNo = seatNo;

    /*
      {
        ...
        ...playerAction
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
    playerAction._minRaiseAmount = seatAction['minRaiseAmount'] ?? 2.0;
    playerAction._maxRaiseAmount = seatAction['maxRaiseAmount'];

    playerAction._options = seatAction['betOptions']
        ?.map<Option>((var data) => Option.fromJson(data))
        ?.toList();
    playerAction._raiseAmount = seatAction['raiseAmount'] ?? 0;
    playerAction._potAmount = seatAction['potAmount'] ?? 0;
    playerAction._actions = [];
    seatAction['availableActions']
        .map<String>((s) => s.toString())
        .forEach((String actionName) {
      AvailableAction action = AvailableAction(
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

      playerAction._actions.add(action);
    });
    return playerAction;
  }

  factory PlayerAction.fromProto(int seatNo, proto.NextSeatAction seatAction) {
    PlayerAction yourAction = PlayerAction();
    yourAction._seatNo = seatNo;
    yourAction._minRaiseAmount = seatAction.minRaiseAmount;
    yourAction._maxRaiseAmount = seatAction.maxRaiseAmount;
    yourAction._callAmount = seatAction.callAmount;
    yourAction._allInAmount = seatAction.allInAmount;
    yourAction._raiseAmount = seatAction.raiseAmount;
    yourAction._seatInSoFar = seatAction.seatInSoFar;
    yourAction._ploPotAmount = 0;
    yourAction._potAmount = seatAction.potAmount;

    yourAction._raise = false;
    for (final action in seatAction.availableActions) {
      if (action == ACTION.RAISE) {
        yourAction._raise = true;
      }
    }
    // if (yourAction._raiseAmount == yourAction._callAmount) {
    //   yourAction._raiseAmount = 0;
    // }

    yourAction._options = [];
    for (final option in seatAction.betOptions) {
      Option betOption = Option(amount: option.amount, text: option.text);
      if (option.text == '100%') {
        //ourAction._potAmount = option.amount;
      }
      if (option.text == 'Pot') {
        yourAction._ploPotAmount = option.amount;
      }

      yourAction._options.add(betOption);
    }
    if (yourAction._potAmount == 0) {
      yourAction._potAmount = seatAction.maxRaiseAmount;
    }
    yourAction._actions = [];
    for (final availableAction in seatAction.availableActions) {
      AvailableAction action = AvailableAction(
        actionName: availableAction.name,
      );

      if (availableAction == proto.ACTION.ALLIN) {
        action.actionValue = seatAction.allInAmount - seatAction.seatInSoFar;
      } else if (availableAction == proto.ACTION.CALL) {
        action.actionValue = seatAction.callAmount - seatAction.seatInSoFar;
      } else if (availableAction == proto.ACTION.RAISE) {
        action.minActionValue = seatAction.minRaiseAmount;
      }
      yourAction._actions.add(action);
    }

    return yourAction;
  }

  List<AvailableAction> get actions => _actions;
  List<Option> get options => _options;

  double get minRaiseAmount => _minRaiseAmount;
  double get maxRaiseAmount => _maxRaiseAmount;
  double get callAmount => _callAmount;
  double get allInAmount => _allInAmount;
  int get seatNo => _seatNo;
  double get raiseAmount => _raiseAmount;
  double get potAmount => _potAmount;
  double get seatInSoFar => _seatInSoFar;
  double get ploPotAmount => _ploPotAmount;
  bool get raiseAvailable => _raise;

  void sort() {
    List<AvailableAction> sortedActions = [];
    // fold
    // check
    // call
    // bet/raise
    // all in
    List<String> actionOrder = [
      FOLD,
      CHECK,
      CALL,
      BET,
      RAISE,
      ALLIN,
    ];
    for (final action in actionOrder) {
      final found = _actions.firstWhere((e) => e.actionName == action,
          orElse: () => null);
      if (found != null) {
        sortedActions.add(found);
      }
    }
    _actions = sortedActions;
  }
}
