import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';

class TableState extends ChangeNotifier {
  /* This object holds the game status, table status, pot chips, and community cards */
  String _gameStatus;
  String _tableStatus;
  List<double> _potChips;
  double _potUpdatesChips;
  List<CardObject> _board1;
  List<CardObject> _board2;
  int _flipSpeed;
  String _rankStr;
  bool _twoBoardsNeeded;
  int _potToHighlight;
  bool _dimPots;
  bool dimBoard1;
  bool dimBoard2;
  String get whichWinner => _whichWinner;
  String _whichWinner;

  // This flag is used when processing query current state response
  // if we are in middle of hand result animation, wait for the next hand
  // to update the table
  bool resultInProgress = false;

  bool get showCardsShuffling => _showCardsShuffling;
  bool _showCardsShuffling;

  final math.Random r = math.Random();

  int get tableRefresh => _tableRefresh;
  int _tableRefresh;

  int get communityCardRefresh => _communityCardRefresh;
  int _communityCardRefresh;

  TableState({
    String tableStatus,
    List<double> potChips,
    double potUpdatesChips,
    List<CardObject> communityCards,
  }) {
    this.clear();
    this._tableStatus = tableStatus;
    this._potChips = potChips;
    this._board1 = communityCards;
    this._potUpdatesChips = potUpdatesChips;
    this._flipSpeed = 500;
    this._twoBoardsNeeded = false;
    this._showCardsShuffling = false;
    this.dimBoard1 = false;
    this.dimBoard2 = false;
  }

  void clear() {
    _dimPots = false;
    _board1?.clear();
    _board2?.clear();
    _potChips?.clear();
    _potUpdatesChips = null;
    _flipSpeed = 500;
    _rankStr = null;
    _twoBoardsNeeded = false;
    _potToHighlight = -1;
    _whichWinner = null;
    this.dimBoard1 = false;
    this.dimBoard2 = false;
  }

  void notifyAll() => notifyListeners();

  void setWhichWinner(String whichWinner) {
    _whichWinner = whichWinner;
    notifyAll();
  }

  void updateCardShufflingAnimation(bool animate) {
    _showCardsShuffling = animate;
    _tableStatus = AppConstants.TABLE_STATUS_GAME_RUNNING;
    notifyListeners();
  }

  void refreshTable() {
    const _100crore = 1000000000;
    _tableRefresh = r.nextInt(_100crore);
    // notifyListeners();
  }

  void refreshCommunityCards({bool colorCards = false}) {
    const _100crore = 1000000000;
    _communityCardRefresh = r.nextInt(_100crore);

    List<CardObject> _tempBoard = [];
    _board1.forEach((card) {
      _tempBoard.add(CardHelper.getCard(card.cardNum, colorCards: colorCards));
    });
    _board1 = _tempBoard;

    _tempBoard.clear();

    _board2.forEach((card) {
      _tempBoard.add(CardHelper.getCard(card.cardNum, colorCards: colorCards));
    });
    _board2 = _tempBoard;
    notifyListeners();
  }

  void updatePotToHighlightSilent(int potIdx) {
    _potToHighlight = potIdx;
  }

  void updateTwoBoardsNeeded(bool b) {
    this._twoBoardsNeeded = b;
  }

  bool get dimPots => _dimPots;

  void dimPotsSilent(bool b) {
    _dimPots = b;
  }

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

  void updatePotChipsSilent({List<double> potChips, double potUpdatesChips}) {
    this._potChips = potChips;
    this._potUpdatesChips = potUpdatesChips;
  }

  void updatePotChipUpdatesSilent(double potUpdatesChips) {
    this._potUpdatesChips = potUpdatesChips;
  }

  void setBoardCards(int boardIndex, List<CardObject> cards) {
    if (boardIndex == 1) {
      if (cards.length > 5) {
        this._board1 = cards.sublist(0, 5);
      } else {
        this._board1 = cards;
      }
    } else if (boardIndex == 2) {
      if (cards.length > 5) {
        this._board2 = cards.sublist(0, 5);
      } else {
        this._board2 = cards;
      }
    }
  }

  void updateRankStrSilent(String rankStr) {
    this._rankStr = rankStr;
  }

  void addFlopCards(int boardIndex, List<CardObject> cards) {
    if (boardIndex == 1) {
      if (_board1 == null) _board1 = [];
      _board1.clear();

      if (this._board1.length >= 3) {
        return;
      }
      this._board1.addAll(cards);
    } else if (boardIndex == 2) {
      if (_board2 == null) _board2 = [];
      _board2.clear();

      if (this._board2.length >= 3) {
        return;
      }
      this._board2.addAll(cards);
    }
  }

  Future<void> _delay(int times) => Future.delayed(
        Duration(
          milliseconds:
              AppConstants.communityCardAnimationDuration.inMilliseconds *
                  times,
        ),
      );

  /* THIS METHOD IS ONLY USED WHEN WE RUN INTO A RUN IT TWICE SCENARIO */
  Future<void> addAllCommunityCardsForRunItTwiceScenario(
    int boardIndex,
    List<CardObject> cards,
  ) async {
    _flipSpeed = 200;
    /* set empty cards to the community cards */
    if (cards.isEmpty) {
      if (boardIndex == 1) this._board1 = [];
      if (boardIndex == 2) this._board2 = [];

      notifyAll();
      return;
    }

    if (boardIndex == 1) {
      if (_board1 == null || _board1.isEmpty) {
        /* add all cards sequentially */

        _board1 = [];

        /* add the flop cards first */
        addFlopCards(1, cards.sublist(0, 3));
        notifyAll();

        /* wait for the duration */
        await _delay(1);

        /* add turn cards */
        addTurnOrRiverCard(1, cards[3]);
        notifyAll();

        /* wait for the duration */
        await _delay(1);

        /* finally, add the river cards */
        addTurnOrRiverCard(1, cards.last);
        notifyAll();
      } else if (_board1.length == 3) {
        /* flop cards are added, just need to add turn and river cards sequentially */

        /* add turn cards */
        addTurnOrRiverCard(1, cards[3]);
        notifyAll();

        /* wait for the duration */
        await _delay(1);

        /* finally, add the river cards */
        addTurnOrRiverCard(1, cards.last);
        notifyAll();
      } else if (_board1.length == 4) {
        /* cards till turn are added, just need to add river cards  */
        addTurnOrRiverCard(1, cards.last);
        notifyAll();
      } else {
        return;
      }
    } else if (boardIndex == 2) {
      /* need to add all the cards - one by one */

      _board2 = [];

      /* add the flop cards first */
      addFlopCards(2, cards.sublist(0, 3));
      notifyAll();

      /* wait for the duration */
      await _delay(1);

      /* add turn cards */
      addTurnOrRiverCard(2, cards[3]);
      notifyAll();

      /* wait for the duration */
      await _delay(1);

      /* finally, add the river cards */
      addTurnOrRiverCard(2, cards.last);
      notifyAll();
    }
  }

  void addTurnOrRiverCard(int boardIndex, CardObject card) {
    if (boardIndex == 1) {
      /* prevent calling this method, if there are less than 4 cards */
      if (this._board1 == null ||
          this._board1.length < 3 ||
          this._board1.length == 5) {
        return;
      }
      this._board1.add(card);
    } else if (boardIndex == 2) {
      /* prevent calling this method, if there are less than 4 cards */
      if (this._board2 == null ||
          this._board2.length < 3 ||
          this._board2.length == 5) {
        return;
      }
      this._board2.add(card);
    }
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

  /* un highlight board cards */
  void unHighlightCardsSilent(int boardIndex) {
    if (boardIndex == 1 && _board1 != null) {
      for (final card in _board1) {
        card.highlight = false;
        card.dim = false;
        // log('completed: un highlighting cards from board 1');
      }
    } else if (boardIndex == 2 && _board2 != null) {
      for (final card in _board2) {
        card.highlight = false;
        card.dim = false;
      }
    }
  }

  /* this method highlights all community cards */
  void highlightCardsSilent(int boardIndex, List<int> rawCards) {
    if (boardIndex == 1) {
      if (_board1 == null) return;

      /* dim all the cards, THEN highlight the NEEDED cards */
      for (final card in _board1) card.dim = true;
      for (int i = 0; i < _board1.length; i++) {
        int rawCardNumber = _board1[i].cardNum;
        if (rawCards.any((rc) => rc == rawCardNumber))
          _board1[i].highlight = true;
      }
    } else if (boardIndex == 2) {
      /* dim all the cards, THEN highlight the NEEDED cards */
      for (final card in _board2) card.dim = true;

      for (int i = 0; i < _board2.length; i++) {
        int rawCardNumber = _board2[i].cardNum;
        if (rawCards.any((rc) => rc == rawCardNumber))
          _board2[i].highlight = true;
      }
    }
  }

  /* getters */
  bool get twoBoardsNeeded => _twoBoardsNeeded;
  String get rankStr => _rankStr;
  String get tableStatus => _tableStatus;
  String get gameStatus => _gameStatus;
  int get potToHighlight => _potToHighlight;
  List<double> get potChips => _potChips;
  double get potChipsUpdates => _potUpdatesChips;
  List<CardObject> get cards => _board1;
  List<CardObject> get cardsOther => _board2;

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

  int get flipSpeed {
    return this._flipSpeed;
  }
}
