import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';

class TableState extends ChangeNotifier {
  /* This object holds the table status, pot chips, and community cards */

  String _tableStatus;
  List<int> _potChips;
  int _potUpdatesChips;
  List<CardObject> _communityCards;

  TableState({
    String tableStatus,
    List<int> potChips,
    int potUpdatesChips,
    List<CardObject> communityCards,
  }) {
    this._tableStatus = tableStatus;
    this._potChips = potChips;
    this._communityCards = communityCards;
    this._potUpdatesChips = potUpdatesChips;
  }

  /* public methods for updating values into our TableState */
  void updateTableStatus(String tableStatus) {
    if (this._tableStatus == tableStatus) return;

    this._tableStatus = tableStatus;
    notifyListeners();
  }

  // todo: add the another potUpdate
  void updatePotChips({List<int> potChips, int potUpdatesChips}) {
    if (this._potChips == potChips) return;
    if (this._potUpdatesChips == potUpdatesChips) return;

    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
    notifyListeners();
  }

  void addCommunityCard(CardObject card) {
    if (this._communityCards == null) this._communityCards = List<CardObject>();
    this._communityCards.add(card);
    notifyListeners();
  }

  void updateCommunityCardsSilent(List<CardObject> cards) {
    this._communityCards = cards;
  }

  void updateCommunityCards(List<CardObject> cards) {
    this._communityCards = cards;
    notifyListeners();
  }

  /* this method highlights all community cards */
  void highlightCards(List<int> rawCards) {
    for (int i = 0; i < _communityCards.length; i++) {
      String label = _communityCards[i].label;
      String suit = _communityCards[i].suit;

      int rawCardNumber = CardHelper.getRawCardNumber('$label$suit');
      if (rawCards.any((rc) => rc == rawCardNumber))
        _communityCards[i].highlight = true;
    }
  }

  /* getters */
  String get tableStatus => _tableStatus;
  List<int> get potChips => _potChips;
  int get potChipsUpdates => _potUpdatesChips;
  List<CardObject> get cards => _communityCards;
}
