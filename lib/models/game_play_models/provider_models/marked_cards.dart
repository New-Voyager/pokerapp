import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class MarkedCards extends ChangeNotifier {
  Map<String, bool> _cardHash;

  MarkedCards() {
    _cardHash = Map();
  }

  clear() {
    _cardHash.clear();
    notifyListeners();
  }

  mark(CardObject cardObject) {
    if (isMarked(cardObject))
      _cardHash.remove(cardObject.cardHash);
    else
      _cardHash[cardObject.cardHash] = true;

    notifyListeners();
  }

  bool isMarked(CardObject cardObject) => _cardHash.containsKey(
        cardObject.cardHash,
      );
}
