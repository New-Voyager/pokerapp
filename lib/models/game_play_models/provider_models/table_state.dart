import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

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
  void updatePostChips({List<int> potChips, int potUpdatesChips}) {
    if (this._potChips == potChips) return;
    if (this._potUpdatesChips == potUpdatesChips) return;

    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
    notifyListeners();
  }

  void updateCommunityCards(List<CardObject> cards) {
    this._communityCards = cards;
    notifyListeners();
  }

  /* getters */
  String get tableStatus => _tableStatus;
  List<int> get potChips => _potChips;
  int get potChipsUpdates => _potUpdatesChips;
  List<CardObject> get cards => _communityCards;
}
