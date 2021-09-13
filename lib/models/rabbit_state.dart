import 'package:flutter/widgets.dart';
import 'package:pokerapp/proto/hand.pb.dart';
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;

import 'package:pokerapp/resources/app_constants.dart';

class RabbitState extends ChangeNotifier {
  bool get show => _show;
  bool _show;

  HandStatus get wonAt => _wonAt;
  HandStatus _wonAt;

  List<int> get communityCards => _communityCards;
  List<int> _communityCards = [];

  int get handNo => _handNo;
  int _handNo;

  List<int> get myCards => _myCards;
  List<int> _myCards = [];

  List<int> get revealedCards => _revealedCards;
  List<int> _revealedCards = [];

  RabbitState() {
    _show = false;
  }

  void _clear() {
    _show = false;
    _wonAt = null;
    _communityCards = [];
    _handNo = null;
    _myCards = [];
    _revealedCards = [];
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

  void putResult(HandStatus wonAt, int handNo, List<int> communityCards,
      List<int> mycards) {
    if (wonAt != HandStatus.FLOP && wonAt != HandStatus.TURN) return;
    _show = true;
    _communityCards = communityCards;
    _myCards = myCards;
    _handNo = handNo;
    // fill revealed cards
    if (wonAt == HandStatus.FLOP) {
      // we already have 3 cards at table
      _revealedCards = _communityCards.sublist(3);
    } else if (wonAt == HandStatus.TURN) {
      // we already have 4 cards at table
      _revealedCards = _communityCards.sublist(4);
    }

    notifyListeners();
  }

  void putResultProto(proto.HandResultClient result,
      {List<int> myCards = const []}) {
    if (result == null) return _clear();
    // if run it twice, do nothing
    if (result.boards.length >= 2) return;

    // if wonAt is not FLOP or TURN, we dont proceed
    if (result.wonAt != HandStatus.FLOP && result.wonAt != HandStatus.TURN)
      return;

    // fill in the values
    _show = true;
    _wonAt = wonAt;
    _handNo = result.handNum;
    _communityCards = result.boards[0].cards;
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
