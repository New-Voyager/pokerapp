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

  // animation variables
  bool _animateBoard1Flop;
  bool _animateBoard1Turn;
  bool _animateBoard1River;
  bool _animateBoard1; // all the 5 cards (run it twice)

  bool _animateBoard2Flop;
  bool _animateBoard2Turn;
  bool _animateBoard2River;
  bool _animateBoard2; // all the 5 cards (run it twice)

  TableState({
    String tableStatus,
    List<int> potChips,
    int potUpdatesChips,
    List<CardObject> communityCards,
  }) {
    this.clear();
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
    _animateBoard1 = false;
    _animateBoard1Flop = false;
    _animateBoard1Turn = false;
    _animateBoard1River = false;
    _animateBoard2 = false;
    _animateBoard2Flop = false;
    _animateBoard2Turn = false;
    _animateBoard2River = false;
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
    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
  }

  // // this method flips all the cards after a short delay
  // void flipCards() async {
  //   for (int i = 0; i < this.cards.length; i++) {
  //     cards[i].flipCard();
  //     notifyListeners();
  //     await Future.delayed(AppConstants.communityCardPushDuration);
  //   }
  // }
  //
  // void flipLastCard() {
  //   this.cards.last.flipCard();
  // }

  void setBoardCards(int boardIndex, List<CardObject> cards) {
    if (boardIndex == 1) {
      // WHY THIS? DOES'NT MAKE SENSE WITH THE NEXT IF cards.length > 5 it will never be reached
      // if (this._board1.length >= 3) {
      //   return;
      // }
      if (cards.length > 5) {
        this._board1 = cards.sublist(0, 5);
      } else {
        this._board1 = cards;
      }
    }
  }

  void addFlopCards(int boardIndex, List<CardObject> cards) {
    if (boardIndex == 1) {
      if (this._board1.length >= 3) {
        return;
      }
      this._board1.addAll(cards);
    }
  }

  void addTurnOrRiverCard(int boardIndex, CardObject card) {
    if (boardIndex == 1) {
      /* prevent calling this method, if there are less than 4 cards */
      if (this._board1.length < 3 || this._board1.length == 5) {
        return;
      }
      this._board1.add(card);
    }
  }

  // void river(int boardIndex, CardObject card) {
  //   if (boardIndex == 1) {
  //     if (this._board1.length >= 5) {
  //       return;
  //     }
  //     this._board1.add(card);
  //   }
  // }

  void setAnimateBoard1(bool animate) {
    this._animateBoard1 = animate;
  }

  void setAnimateBoard1Flop(bool animate) {
    this._animateBoard1Flop = animate;
  }

  void setAnimateBoard1Turn(bool animate) {
    this._animateBoard1Turn = animate;
  }

  void setAnimateBoard1River(bool animate) {
    this._animateBoard1River = animate;
  }

  void setAnimateBoard2(bool animate) {
    this._animateBoard2 = animate;
  }

  void setAnimateBoard2Flop(bool animate) {
    this._animateBoard2Flop = animate;
  }

  void setAnimateBoard2Turn(bool animate) {
    this._animateBoard2Turn = animate;
  }

  void setAnimateBoard2River(bool animate) {
    this._animateBoard2River = animate;
  }

  get animateBoard1 {
    return this._animateBoard1;
  }

  get animateBoard1Flop {
    return this._animateBoard1Flop;
  }

  get animateBoard1Turn {
    return this._animateBoard1Turn;
  }

  get animateBoard1River {
    return this._animateBoard1River;
  }

  get animateBoard2 {
    return this._animateBoard2;
  }

  get animateBoard2Flop {
    return this._animateBoard2Flop;
  }

  get animateBoard2Turn {
    return this._animateBoard2Turn;
  }

  get animateBoard2River {
    return this._animateBoard2River;
  }

  List<CardObject> getBoard1Flop() {
    return this._board1.sublist(0, 3);
  }

  CardObject getBoard1Turn() {
    return this._board1[3];
  }

  CardObject getBoard1River() {
    return this._board1[4];
  }

  List<CardObject> getBoard2Flop() {
    return this._board2.sublist(0, 3);
  }

  CardObject getBoard2Turn() {
    return this._board2[3];
  }

  CardObject getBoard2River() {
    return this._board2[4];
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
