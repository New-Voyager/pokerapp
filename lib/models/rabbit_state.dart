import 'package:flutter/widgets.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;
import 'package:pokerapp/proto/enums.pb.dart' as proto;

import 'package:pokerapp/resources/app_constants.dart';

class RabbitState extends ChangeNotifier {
  bool get show => _show;
  bool _show;

  String get wonAt => _wonAt;
  String _wonAt;

  List<int> get communityCards => _communityCards;
  List<int> _communityCards;

  int get handNo => _handNo;
  int _handNo;

  List<int> get myCards => _myCards;
  List<int> _myCards;

  List<int> get revealedCards => _revealedCards;
  List<int> _revealedCards;

  RabbitState() {
    _show = false;
  }

  void _clear() {
    _show = false;
    _wonAt = null;
    _communityCards = null;
    _handNo = null;
    _myCards = null;
    _revealedCards = null;
    notifyListeners();
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void resultDone() {
    _show = false;
    notifyListeners();
  }

  void putResult(var result, {List<int> myCards = const []}) {
    if (result == null) return _clear();

    result = result['handResult'];

    final handLog = result['handLog'];

    // if run it twice, do nothing
    final bool isRunItTwice = handLog['runItTwice'] as bool;

    if (isRunItTwice) return;

    final String wonAt = handLog['wonAt'];

    // if wonAt is not FLOP or TURN, we dont proceed
    if (wonAt != AppConstants.FLOP && wonAt != AppConstants.TURN) return;

    // fill in the values
    _show = true;
    _wonAt = wonAt;
    _handNo = int.parse(result['handNum'].toString());
    _communityCards =
        result['boardCards'].map<int>((e) => int.parse(e.toString())).toList();
    _myCards = myCards;

    // fill revealed cards
    if (wonAt == AppConstants.FLOP) {
      // we already have 3 cards at table
      _revealedCards = _communityCards.sublist(3);
    } else if (wonAt == AppConstants.TURN) {
      // we already have 4 cards at table
      _revealedCards = _communityCards.sublist(4);
    }

    notifyListeners();
  }

  void putResultProto(proto.HandResult result, {List<int> myCards = const []}) {
    if (result == null) return _clear();
    final handLog = result.handLog;

    // if run it twice, do nothing
    final bool isRunItTwice = handLog.runItTwice;

    if (isRunItTwice) return;

    final String wonAt = handLog.wonAt.name;

    // if wonAt is not FLOP or TURN, we dont proceed
    if (wonAt != AppConstants.FLOP && wonAt != AppConstants.TURN) return;

    // fill in the values
    _show = true;
    _wonAt = wonAt;
    _handNo = result.handNum;
    _communityCards = result.boardCards;
    _myCards = myCards;

    // fill revealed cards
    if (wonAt == AppConstants.FLOP) {
      // we already have 3 cards at table
      _revealedCards = _communityCards.sublist(3);
    } else if (wonAt == AppConstants.TURN) {
      // we already have 4 cards at table
      _revealedCards = _communityCards.sublist(4);
    }

    notifyListeners();
  }

  RabbitState copy() {
    final newRs = RabbitState();
    newRs._show = this._show;
    newRs._wonAt = this._wonAt;
    newRs._communityCards = this._communityCards;
    newRs._handNo = this._handNo;
    newRs._myCards = this._myCards;
    newRs._revealedCards = this._revealedCards;

    return newRs;
  }
}
