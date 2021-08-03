import 'package:flutter/widgets.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;

const String FOLD = 'FOLD';
const String CALL = 'CALL';
const String CHECK = 'CHECK';
const String BET = 'BET';
const String RAISE = 'RAISE';
const String ALLIN = 'ALLIN';

class AvailableAction {
  String actionName;
  int actionValue;
  int minActionValue;

  AvailableAction({
    @required this.actionName,
    this.actionValue,
    this.minActionValue,
  });
}

class Option {
  String text;
  int amount;

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

  int _minRaiseAmount;
  int _maxRaiseAmount;
  int _callAmount = 0;
  int _allInAmount = 0;

  List<Option> _options;

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
    playerAction._minRaiseAmount = seatAction['minRaiseAmount'] ?? 2;
    playerAction._maxRaiseAmount = seatAction['maxRaiseAmount'];

    playerAction._options = seatAction['betOptions']
        ?.map<Option>((var data) => Option.fromJson(data))
        ?.toList();

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
    yourAction._minRaiseAmount = seatAction.minRaiseAmount.toInt();
    yourAction._maxRaiseAmount = seatAction.maxRaiseAmount.toInt();
    yourAction._callAmount = seatAction.callAmount.toInt();
    yourAction._allInAmount = seatAction.allInAmount.toInt();
    yourAction._options = [];
    for (final option in seatAction.betOptions) {
      Option betOption =
          Option(amount: option.amount.toInt(), text: option.text);
      yourAction._options.add(betOption);
    }
    yourAction._actions = [];
    for (final availableAction in seatAction.availableActions) {
      AvailableAction action = AvailableAction(
        actionName: availableAction.name,
      );

      if (availableAction == proto.ACTION.ALLIN) {
        action.actionValue =
            seatAction.allInAmount.toInt() - seatAction.seatInSoFar.toInt();
      } else if (availableAction == proto.ACTION.CALL) {
        action.actionValue =
            seatAction.callAmount.toInt() - seatAction.seatInSoFar.toInt();
      } else if (availableAction == proto.ACTION.RAISE) {
        action.minActionValue = seatAction.minRaiseAmount.toInt();
      }
      yourAction._actions.add(action);
    }

    return yourAction;
  }

  List<AvailableAction> get actions => _actions;
  List<Option> get options => _options;

  int get minRaiseAmount => _minRaiseAmount;
  int get maxRaiseAmount => _maxRaiseAmount;
  int get callAmount => _callAmount;
  int get allInAmount => _allInAmount;
  int get seatNo => _seatNo;

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
