import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';

class TableState extends ChangeNotifier {
  /* This object holds the game status, table status, pot chips, and community cards */
  String _gameStatus;
  String _tableStatus;
  List<int> _potChips;
  int _potUpdatesChips;
  List<CardObject> _board1;
  List<CardObject> _board2;

  TableState({
    String tableStatus,
    List<int> potChips,
    int potUpdatesChips,
    List<CardObject> communityCards,
  }) {
    this._tableStatus = tableStatus;
    this._potChips = potChips;
    this._board1 = communityCards;
    this._potUpdatesChips = potUpdatesChips;
  }

  void clear() {
    _board1 = [];
    _board2 = [];
    _potChips = [];
    _potUpdatesChips = null;
  }

  void notifyAll() => notifyListeners();

  /* public methods for updating values into our TableState */
  void updateTableStatusSilent(String tableStatus) {
    if (this._tableStatus == tableStatus) return;
    this._tableStatus = tableStatus;
  }

  /* public methods for updating values into Game status */
  void updateGameStatusSilent(String gameStatus) {
    if (this._gameStatus == gameStatus) return;
    this._gameStatus = gameStatus;
  }

  void updatePotChipsSilent({List<int> potChips, int potUpdatesChips}) {
    if (this._potChips == potChips) return;
    if (this._potUpdatesChips == potUpdatesChips) return;

    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
  }

  // this method flips all the cards after a short delay
  void flipCards() async {
    log('Community cards: ${this.cards.length}');
    for (int i = 0; i < this.cards.length; i++) {
      cards[i].flipCard();
      notifyListeners();
      await Future.delayed(AppConstants.communityCardPushDuration);
    }
  }

  void flipLastCard() {
    log('Community cards: ${this.cards.length}');
    this.cards.last.flipCard();
  }

  void setBoard(int boardIndex, List<CardObject> cards) {
    if (boardIndex == 1) {
      if (this._board1.length >= 3) {
        return;
      }
      if (cards.length > 5) {
        this._board1 = cards.sublist(0, 5);
      } else {
        this._board1 = cards;
      }
    }
  }

  void flop(int boardIndex, List<CardObject> cards) {
    if (boardIndex == 1) {
      if (this._board1.length >= 3) {
        return;
      }
      this._board1 = cards;
    }
  }

  void turn(int boardIndex, CardObject card) {
    if (boardIndex == 1) {
      if (this._board1.length >= 4) {
        return;
      }      
      this._board1.add(card);
    }
  }

  void river(int boardIndex, CardObject card) {
    if (boardIndex == 1) {
      if (this._board1.length >= 5) {
        return;
      }      
      this._board1.add(card);
    }
  }

  /* this method highlights all community cards */
  void highlightCardsSilent(List<int> rawCards) {
    if (_board1 == null) return;
    for (int i = 0; i < _board1.length; i++) {
      String label = _board1[i].label;
      String suit = _board1[i].suit;

      int rawCardNumber = CardHelper.getRawCardNumber('$label$suit');
      if (rawCards.any((rc) => rc == rawCardNumber))
        _board1[i].highlight = true;
    }
  }

  /* getters */
  String get tableStatus => _tableStatus;
  List<int> get potChips => _potChips;
  int get potChipsUpdates => _potUpdatesChips;
  List<CardObject> get cards => _board1;

  bool get gamePaused {
    if (_gameStatus == AppConstants.GAME_PAUSED) {
      return true;
    }
    return false;
  }

  bool get gameEnded {
    if (_gameStatus == AppConstants.GAME_ENDED) {
      return true;
    }
    return false;
  }

  bool get gameActive {
    if (_gameStatus == AppConstants.GAME_ACTIVE) {
      return true;
    }
    return false;
  }

}
