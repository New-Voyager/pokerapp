import 'package:pokerapp/models/game_play_models/provider_models/player_action/action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action/option.dart';

const String FOLD = 'FOLD';
const String CALL = 'CALL';
const String CHECK = 'CHECK';
const String BET = 'BET';
const String RAISE = 'RAISE';
const String ALLIN = 'ALLIN';

class PlayerAction {
  int _seatNo;
  List<Action> _actions;

  int _minRaiseAmount;
  int _maxRaiseAmount;

  List<Option> _options;

  PlayerAction(int seatNo, var seatAction) {
    _seatNo = seatNo;
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
