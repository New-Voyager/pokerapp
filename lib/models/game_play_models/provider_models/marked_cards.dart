import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class MarkedCards extends ChangeNotifier {
  Map<String, CardObject> _cardHash;
  List<int> _cardsSent;

  MarkedCards() {
    _cardHash = Map();
    _cardsSent = [];
  }

  void clear() {
    _cardHash.clear();
    _cardsSent = [];
  }

  List<CardObject> getCards() {
    List<CardObject> cards = [];
    for (final card in _cardHash.values) {
      if (_cardsSent.indexOf(card.cardNum) == -1) {
        cards.add(card);
      }
    }
    return cards;
  }

  void cardsSent(List<int> cards) {
    _cardsSent.addAll(cards);
  }

  void markAll(List<CardObject> cardObjects) {
    clear();

    for (final co in cardObjects) {
      _cardHash[co.cardHash] = co;
    }

    notifyListeners();
  }

  void mark(CardObject cardObject, bool isResultOut) {
    if (isMarked(cardObject)) {
      // if we have got result, you cannot remove a card
      if (isResultOut) return;
      _cardHash.remove(cardObject.cardHash);
    } else
      _cardHash[cardObject.cardHash] = cardObject;

    notifyListeners();
  }

  bool isMarked(CardObject cardObject) => _cardHash.containsKey(
        cardObject.cardHash,
      );
}
