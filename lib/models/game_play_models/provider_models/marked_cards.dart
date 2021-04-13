import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class MarkedCards extends ChangeNotifier {
  Map<String, CardObject> _cardHash;

  MarkedCards() {
    _cardHash = Map();
  }

  void clear() {
    _cardHash.clear();
  }

  List<CardObject> getCards() {
    List<CardObject> _cards = [];
    _cardHash.forEach((_, card) => _cards.add(card));
    return _cards;
  }

  void mark(CardObject cardObject) {
    if (isMarked(cardObject))
      _cardHash.remove(cardObject.cardHash);
    else
      _cardHash[cardObject.cardHash] = cardObject;

    notifyListeners();
  }

  bool isMarked(CardObject cardObject) => _cardHash.containsKey(
        cardObject.cardHash,
      );
}
