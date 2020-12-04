import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class TableState with ChangeNotifier {
  /* This object holds the table status, pot chips, and community cards */

  String _tableStatus;
  int _potChips;
  List<CardObject> _communityCards;

  TableState({
    String tableStatus,
    int potChips,
    List<CardObject> communityCards,
  }) {
    this._tableStatus = tableStatus;
    this._potChips = potChips;
    this._communityCards = communityCards;
  }

  /* public methods for updating values into our TableState */
  void updateTableStatus(String tableStatus) {
    if (this._tableStatus == tableStatus) return;

    this._tableStatus = tableStatus;
    notifyListeners();
  }

  void updatePostChips(int potChips) {
    if (this._potChips == potChips) return;

    this._potChips = potChips;
    notifyListeners();
  }

  void updateCommunityCards(List<CardObject> cards) {
    this._communityCards = cards;
    notifyListeners();
  }

  /* getters */
  String get tableStatus => _tableStatus;
  int get potChips => _potChips;
  List<CardObject> get cards => _communityCards;
}
