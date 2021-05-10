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
  int _flipSpeed;
  String _rankStr;

  // // animation variables
  // bool _animateBoard1Flop;
  // bool _animateBoard1Turn;
  // bool _animateBoard1River;
  // bool _animateBoard1; // all the 5 cards (run it twice)
  //
  // bool _animateBoard2Flop;
  // bool _animateBoard2Turn;
  // bool _animateBoard2River;
  // bool _animateBoard2; // all the 5 cards (run it twice)

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
    this._flipSpeed = 500;
  }

  void clear() {
    _board1?.clear();
    _board2?.clear();
    _potChips?.clear();
    _potUpdatesChips = null;
    _tableStatus = AppConstants.CLEAR;
    _flipSpeed = 500;
    _rankStr = null;
    // _animateBoard1 = false;
    // _animateBoard1Flop = false;
    // _animateBoard1Turn = false;
    // _animateBoard1River = false;
    // _animateBoard2 = false;
    // _animateBoard2Flop = false;
    // _animateBoard2Turn = false;
    // _animateBoard2River = false;
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

  // void river(int boardIndex, CardObject card) {
  //   if (boardIndex == 1) {
  //     if (this._board1.length >= 5) {
  //       return;
  //     }
  //     this._board1.add(card);
  //   }
  // }
  //
  // void setAnimateBoard1(bool animate) {
  //   this._animateBoard1 = animate;
  // }
  //
  // void setAnimateBoard1Flop(bool animate) {
  //   this._animateBoard1Flop = animate;
  // }
  //
  // void setAnimateBoard1Turn(bool animate) {
  //   this._animateBoard1Turn = animate;
  // }
  //
  // void setAnimateBoard1River(bool animate) {
  //   this._animateBoard1River = animate;
  // }
  //
  // void setAnimateBoard2(bool animate) {
  //   this._animateBoard2 = animate;
  // }
  //
  // void setAnimateBoard2Flop(bool animate) {
  //   this._animateBoard2Flop = animate;
  // }
  //
  // void setAnimateBoard2Turn(bool animate) {
  //   this._animateBoard2Turn = animate;
  // }
  //
  // void setAnimateBoard2River(bool animate) {
  //   this._animateBoard2River = animate;
  // }
  //
  // get animateBoard1 {
  //   return this._animateBoard1;
  // }
  //
  // get animateBoard1Flop {
  //   return this._animateBoard1Flop;
  // }
  //
  // get animateBoard1Turn {
  //   return this._animateBoard1Turn;
  // }
  //
  // get animateBoard1River {
  //   return this._animateBoard1River;
  // }
  //
  // get animateBoard2 {
  //   return this._animateBoard2;
  // }
  //
  // get animateBoard2Flop {
  //   return this._animateBoard2Flop;
  // }
  //
  // get animateBoard2Turn {
  //   return this._animateBoard2Turn;
  // }
  //
  // get animateBoard2River {
  //   return this._animateBoard2River;
  // }

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
    if (boardIndex == 1) {
      for (int i = 0; i < _board1.length; i++) _board1[i].highlight = false;
    } else if (boardIndex == 2) {
      for (int i = 0; i < _board1.length; i++) _board2[i].highlight = false;
    }
  }

  /* this method highlights all community cards */
  void highlightCardsSilent(int boardIndex, List<int> rawCards) {
    if (boardIndex == 1) {
      if (_board1 == null) return;

      for (int i = 0; i < _board1.length; i++) {
        String label = _board1[i].label;
        String suit = _board1[i].suit;

        int rawCardNumber = CardHelper.getRawCardNumber('$label$suit');
        if (rawCards.any((rc) => rc == rawCardNumber))
          _board1[i].highlight = true;
      }
    } else if (boardIndex == 2) {
      for (int i = 0; i < _board2.length; i++) {
        String label = _board2[i].label;
        String suit = _board2[i].suit;

        int rawCardNumber = CardHelper.getRawCardNumber('$label$suit');
        if (rawCards.any((rc) => rc == rawCardNumber))
          _board2[i].highlight = true;
      }
    }
  }

  /* getters */
  String get rankStr => _rankStr;
  String get tableStatus => _tableStatus;
  List<int> get potChips => _potChips;
  int get potChipsUpdates => _potUpdatesChips;
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
