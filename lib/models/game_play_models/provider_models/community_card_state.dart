import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import '../../../resources/app_constants.dart';

const kTotalCards = 5;
const kGap = 4.0;
const kDoubleBoardWidthFactor = 0.10;
const kSingleBoardHeightFactor = 0.66;
const kSpecialBoardHeightFactor = 0.50;

extension RectHelper on Rect {
  Offset get position => Offset(left, top);
}

enum CommunityCardBoardState { SINGLE, DOUBLE, RIT }

class CardState extends ChangeNotifier {
  Offset position;
  Offset startPos;
  Size size;
  int cardId;
  int cardNo;
  // GlobalKey<AppFlipCardState> flipKey;
  bool isFaced;
  bool hide;
  bool fade = false;
  bool useStartPos = false;
  bool slide = false;
  bool flip = false;
  CardState({
    @required this.startPos,
    @required this.position,
    @required this.size,
    @required this.cardNo,
    @required this.cardId,
    // @required this.flipKey,
    this.isFaced = false,
    this.hide = true,
  });

  void reset() {
    cardNo = 0;
    hide = true;
    flip = false;
    fade = false;
    useStartPos = false;
    slide = false;
  }

  void notify() {
    notifyListeners();
  }
}

/// this class holds the card sizes & positions for different community card configurations
class CommunityCardState extends ChangeNotifier {
  GameState gameState;

  CommunityCardState(this.gameState);

  bool _initialized = false;
  bool hide = true;

  bool _doubleBoard = false;
  List<CardState> singleBoard = []; // 1, 2, 3, 4, 5
  List<CardState> doubleBoard = []; // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

  List<CardState> ritBoardFlop = []; // 1, 2, 3
  List<CardState> ritBoardFlop1 = []; // 4, 5
  List<CardState> ritBoardFlop2 = []; // 6, 7

  List<CardState> ritBoardTurn = []; // 1, 2, 3, 4
  List<CardState> ritBoardTurn1 = []; // 5
  List<CardState> ritBoardTurn2 = []; // 6

  final List<int> _highlightedCards = [];
  List<int> get highlightCards => _highlightedCards;

  void markHighlightCards(List<int> hc) {
    _highlightedCards.clear();
    _highlightedCards.addAll(hc);
    notifyListeners();
  }

  void resetHighlightCards() {
    _highlightedCards.clear();
    notifyListeners();
  }

  bool _isFlopDone = false;
  bool _isTurnDone = false;
  bool _isRiverDone = false;
  List<int> board1Cards = [];
  List<int> board2Cards = [];

  void refresh() {
    if (!_initialized) {
      return;
    }
    log('CommunityCardState: CommunityCardState::refresh _isFlopDone: $_isFlopDone _isTurnDone: $_isTurnDone _isRiverDone: $_isRiverDone board1Cards: $board1Cards board2Cards: $board2Cards');
    if (board1Cards.length > 0) {
      addBoardCardsWithoutAnimating(board1: board1Cards, board2: board2Cards);
    }
    //notifyListeners();
  }

  Rect _getCardDimen(CommunityCardBoardState boardState, int cardId) {
    switch (boardState) {
      case CommunityCardBoardState.SINGLE:
        return getSingleBoardCardDimens(cardId);

      case CommunityCardBoardState.DOUBLE:
        return getDoubleBoardCardDimens(cardId);

      case CommunityCardBoardState.RIT:
        return getRitBoardCardDimens(cardId);
    }

    return getSingleBoardCardDimens(cardId);
  }

  Map<int, CardState> cardStateCache = {};

  CardState _getCardStateFromCardNo(
    Offset startPos,
    int cNo, {
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
    int cardId = 1,
  }) {
    final cardDimen = _getCardDimen(boardState, cardId);
    final cardState = CardState(
      startPos: startPos,
      position: cardDimen.position,
      cardId: cardId,
      size: cardDimen.size,
      cardNo: cNo,
    );
    cardStateCache[cardId] = cardState;
    return cardState;
  }

  Future<void> _delay() => Future.delayed(
        AppConstants.communityCardWaitDuration,
      );

  Future<void> _delayFA() => Future.delayed(
        AppConstants.communityCardFlipAnimationDuration,
      );

  Future<void> _addFlopCards(
    List<int> board, {
    int startWith = 1,
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
    bool animate = true,
  }) async {
    int firstCardIndex = startWith - 1;
    int secondCardIndex = startWith;
    int thirdCardIndex = startWith + 1;
    List<CardState> _board;
    if (boardState == CommunityCardBoardState.DOUBLE) {
      _board = doubleBoard;
    } else {
      _board = singleBoard;
    }

    for (int i = firstCardIndex; i < (firstCardIndex + board.length); i++) {
      _board[i].cardNo = board[i - (firstCardIndex)];
      if (animate) {
        _board[i].hide = true;
      } else {
        // show the card
        _board[i].hide = false;
      }
      _board[i].notify();
    }
    if (animate) {
      await _delay();
      // show the 3rd card
      _board[thirdCardIndex].slide = false;
      _board[secondCardIndex].slide = false;
      _board[thirdCardIndex].hide = false;
      _board[thirdCardIndex].useStartPos = true;
      _board[thirdCardIndex].flip = true;
      _board[thirdCardIndex].notify();
      await _delay();
      _board[secondCardIndex].useStartPos = true;
      _board[secondCardIndex].notify();

      _board[thirdCardIndex].flip = false;
      _board[secondCardIndex].useStartPos = false;
      _board[thirdCardIndex].useStartPos = false;
      _board[secondCardIndex].slide = true;
      _board[thirdCardIndex].slide = true;
      for (int i = firstCardIndex; i < firstCardIndex + board.length; i++) {
        _board[i].hide = false;
        _board[i].notify();
      }
      await _delay();
      for (int i = firstCardIndex; i < firstCardIndex + board.length; i++) {
        _board[i].useStartPos = false;
        _board[i].slide = false;
        _board[i].flip = false;
      }
    }
  }

  // Future<void> addFlopCards2(
  //   List<int> board, {
  //   int startWith = 1,
  //   List<CardState> cardState,
  // }) async {
  //   int firstCardIndex = startWith - 1;
  //   int secondCardIndex = startWith;
  //   int thirdCardIndex = startWith + 1;

  //   for (int i = firstCardIndex; i < (firstCardIndex + board.length); i++) {
  //     cardState[i].cardNo = board[i - (firstCardIndex)];
  //     cardState[i].hide = true;
  //     cardState[i].notify();
  //   }
  //   await _delay();
  //   // show the 3rd card
  //   cardState[thirdCardIndex].slide = false;
  //   cardState[secondCardIndex].slide = false;
  //   cardState[thirdCardIndex].hide = false;
  //   cardState[thirdCardIndex].useStartPos = true;
  //   cardState[thirdCardIndex].flip = true;
  //   cardState[thirdCardIndex].notify();
  //   await _delay();
  //   cardState[secondCardIndex].useStartPos = true;
  //   cardState[secondCardIndex].notify();

  //   cardState[thirdCardIndex].flip = false;
  //   cardState[secondCardIndex].useStartPos = false;
  //   cardState[thirdCardIndex].useStartPos = false;
  //   cardState[secondCardIndex].slide = true;
  //   cardState[thirdCardIndex].slide = true;
  //   for (int i = firstCardIndex; i < firstCardIndex + board.length; i++) {
  //     cardState[i].hide = false;
  //     cardState[i].notify();
  //   }
  //   await _delay();
  //   for (int i = firstCardIndex; i < firstCardIndex + board.length; i++) {
  //     cardState[i].useStartPos = false;
  //     cardState[i].slide = false;
  //     cardState[i].flip = false;
  //   }

  //   _isFlopDone = true;
  // }

  Future<void> addFlopCards({
    @required final List<int> board1,
    final List<int> board2,
  }) async {
    log('CommunityCardState: CommunityCardState::addFlopCards ${board1} board2: ${board2}');

    assert(board1.length == 3, 'Board 1: Only 3 cards to be added in Flop');
    final bool isDoubleBoard = board2 != null;
    if (isDoubleBoard) {
      assert(board2.length == 3, 'Board 2: Only 3 cards to be added in Flop');
    }
    this.board1Cards.addAll(board1);
    if (board2 != null) {
      this.board2Cards.addAll(board2);
    }

    if (isDoubleBoard) {
      _doubleBoard = true;
      _addFlopCards(
        board1,
        startWith: 1,
        boardState: CommunityCardBoardState.DOUBLE,
      );
      await _addFlopCards(
        board2,
        startWith: 6,
        boardState: CommunityCardBoardState.DOUBLE,
      );
    } else {
      await _addFlopCards(board1);
    }

    _isFlopDone = true;
  }

  Future<void> _addTurnCard(
    int cardNo, {
    int startWith = 4,
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
    bool animate = true,
  }) async {
    int cardIndex = startWith - 1;
    List<CardState> _board;

    if (boardState == CommunityCardBoardState.DOUBLE) {
      _board = doubleBoard;
    } else {
      _board = singleBoard;
    }
    _board[cardIndex].cardNo = cardNo;
    _board[cardIndex].hide = false;
    _board[cardIndex].flip = animate;
    _board[cardIndex].notify();

    await _delay();
  }

  // Future<void> addTurnCard2(
  //   int cardNo, {
  //   int startWith = 4,
  //   List<CardState> cardState,
  // }) async {
  //   int cardIndex = startWith - 1;

  //   cardState[cardIndex].cardNo = cardNo;
  //   cardState[cardIndex].hide = false;
  //   cardState[cardIndex].flip = true;
  //   cardState[cardIndex].notify();
  //   _isTurnDone = true;
  //   await _delay();
  // }

  /// single board -> 4
  /// double board -> 4, 9
  void addTurnCard({
    @required int board1Card,
    final int board2Card,
  }) async {
    final bool isDoubleBoard = board2Card != null;
    board1Cards.add(board1Card);
    if (isDoubleBoard) {
      board2Cards.add(board2Card);
      _addTurnCard(
        board1Card,
        startWith: 4,
        boardState: CommunityCardBoardState.DOUBLE,
      );
      await _addTurnCard(
        board2Card,
        startWith: 9,
        boardState: CommunityCardBoardState.DOUBLE,
      );
    } else {
      _addTurnCard(
        board1Card,
        startWith: 4,
        boardState: CommunityCardBoardState.SINGLE,
      );
      //await _delay();
      // _delay().then((value) {
      //   singleBoard[3].flip = false;
      // }).onError((error, stackTrace) {});

      //await _addTurnCard(board1Card);
    }
    log('CommunityCardState: CommunityCardState::addTurnCard ${board1Cards} board2: ${board2Cards}');

    _isTurnDone = true;
  }

  Future<void> _addRiverCard(int cardNo,
      {int startWith = 5,
      CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
      bool animate = true}) async {
    int cardIndex = startWith - 1;
    List<CardState> _board;
    if (boardState == CommunityCardBoardState.DOUBLE) {
      _board = doubleBoard;
    } else {
      _board = singleBoard;
    }

    _board[cardIndex].cardNo = cardNo;
    _board[cardIndex].hide = false;
    _board[cardIndex].flip = animate;
    _board[cardIndex].notify();

    await _delay();
  }

  /// single board -> 5
  /// double board -> 5, 10
  void addRiverCard({
    @required int board1Card,
    final int board2Card,
  }) async {
    final bool isDoubleBoard = board2Card != null;
    board1Cards.add(board1Card);

    if (isDoubleBoard) {
      board2Cards.add(board2Card);
      _addRiverCard(
        board1Card,
        startWith: 5,
        boardState: CommunityCardBoardState.DOUBLE,
      );
      await _addRiverCard(
        board2Card,
        startWith: 10,
        boardState: CommunityCardBoardState.DOUBLE,
      );
    } else {
      _addRiverCard(
        board1Card,
        startWith: 5,
        boardState: CommunityCardBoardState.SINGLE,
      );
    }
    log('CommunityCardState: CommunityCardState::addRiverCard ${board1Cards} board2: ${board2Cards}');
  }

  /// cards -> 6, 8 (as 1, 2, 3, 4 are common) & (5, 7 are reserved for Turn case)
  Future<void> _runItTwiceAfterTurn(int c1, int c2) async {
    final card1State = _getCardStateFromCardNo(null, c1,
        cardId: 5,
        boardState: CommunityCardBoardState.RIT); // 5 -> before RIT dimen

    final card2State = _getCardStateFromCardNo(null, c2,
        cardId: 8,
        boardState: CommunityCardBoardState.RIT); // 5 -> before RIT dimen

    ritBoardTurn1[0].startPos = card1State.startPos;
    ritBoardTurn1[0].position = card1State.position;
    ritBoardTurn1[0].cardNo = c1;
    ritBoardTurn1[0].hide = true;
    ritBoardTurn1[0].notify();

    ritBoardTurn2[0].startPos = card2State.startPos;
    ritBoardTurn2[0].position = card2State.position;
    ritBoardTurn2[0].cardNo = c2;
    ritBoardTurn2[0].hide = true;
    ritBoardTurn2[0].notify();

    await _delayFA();

    var cardDimen = _getCardDimen(CommunityCardBoardState.RIT, 7);
    ritBoardTurn1[0].position = cardDimen.position;
    ritBoardTurn1[0].size = cardDimen.size;
    ritBoardTurn1[0].slide = false;
    ritBoardTurn1[0].hide = false;
    ritBoardTurn1[0].useStartPos = true;
    ritBoardTurn1[0].flip = false;
    ritBoardTurn1[0].notify();

    cardDimen = _getCardDimen(CommunityCardBoardState.RIT, 9);
    ritBoardTurn2[0].position = cardDimen.position;
    ritBoardTurn2[0].size = cardDimen.size;
    ritBoardTurn2[0].slide = false;
    ritBoardTurn2[0].hide = false;
    ritBoardTurn2[0].useStartPos = true;
    ritBoardTurn2[0].flip = true;
    ritBoardTurn2[0].notify();
  }

  Future<List<CardState>> _displayTwoConsecutiveCards({
    @required List<int> cards,
    @required int cardIdStartsWith,
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
  }) async {
    int cardId = cardIdStartsWith;
    final List<CardState> _cardStates = [];

    for (final cNo in cards) {
      final state = _getCardStateFromCardNo(
        null,
        cNo,
        cardId: cardId,
        boardState: boardState,
      );
      _cardStates.add(state);
      cardId++;

      notifyListeners();

      await _delay();

      // flip
      state.flip = true;
      await _delayFA();
    }

    return _cardStates;
  }

  /// cards -> 5, 6 | 7, 8 (as 1, 2, 3 are common) & (4 is reserved for RIT after Turn case)
  Future<void> _runItTwiceAfterFlop(
    List<int> board1Cards,
    List<int> board2Cards,
  ) async {
    assert(
      board1Cards.length == 2,
      'Invalid: ${board1Cards.length} cards. Board 1 must have 2 cards for Run It Twice After Flop case',
    );
    assert(
      board2Cards.length == 2,
      'Invalid: ${board2Cards.length} cards. Board 2 must have 2 cards for Run It Twice After Flop case',
    );

    /// As we are STILL single board - show cards 4 & 5
    final cardStates = await _displayTwoConsecutiveCards(
      cards: board1Cards,
      cardIdStartsWith: 4,
    );

    int cardId = 4;

    for (int i = 0; i < 2; i++) {
      ritBoardFlop1[i].startPos = cardStates[i].startPos;
      ritBoardFlop1[i].position = cardStates[i].position;
      ritBoardFlop1[i].cardNo = board1Cards[i];
      ritBoardFlop1[i].hide = true;
      ritBoardFlop1[i].notify();
    }

    for (int i = 0; i < cardStates.length; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i + 4);
      ritBoardFlop1[i].position = cardDimen.position;

      ritBoardFlop1[i].size = cardDimen.size;

      ritBoardFlop1[i].slide = false;
      ritBoardFlop1[i].hide = false;
      ritBoardFlop1[i].useStartPos = true;
      ritBoardFlop1[i].flip = true;

      // ritBoardFlop1[i] = state;
      ritBoardFlop1[i].notify();

      cardId++;
    }

    await _delay();

    /// As we are STILL single board - show cards 4 & 5
    var cardStates2 = await _displayTwoConsecutiveCards(
      cards: board1Cards,
      cardIdStartsWith: 4,
    );

    for (int i = 0; i < 2; i++) {
      ritBoardFlop1[i].startPos = cardStates2[i].startPos;
      ritBoardFlop1[i].position = cardStates2[i].position;
      ritBoardFlop1[i].cardNo = board1Cards[i];
      ritBoardFlop1[i].hide = true;
      ritBoardFlop1[i].notify();
    }

    for (int i = 0; i < cardStates2.length; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i + 6);
      ritBoardFlop1[i].position = cardDimen.position;

      ritBoardFlop1[i].size = cardDimen.size;

      ritBoardFlop1[i].slide = false;
      ritBoardFlop1[i].hide = false;
      ritBoardFlop1[i].useStartPos = true;
      ritBoardFlop1[i].flip = false;

      // ritBoardFlop1[i] = state;
      ritBoardFlop1[i].notify();

      cardId++;
    }

    await _delay();

    /// As we are STILL single board - show cards 4 & 5
    var cardStates3 = await _displayTwoConsecutiveCards(
      cards: board2Cards,
      cardIdStartsWith: 6,
      boardState: CommunityCardBoardState.RIT,
    );

    for (int i = 0; i < 2; i++) {
      ritBoardFlop2[i].startPos = cardStates3[i].startPos;
      ritBoardFlop2[i].position = cardStates3[i].position;
      ritBoardFlop2[i].cardNo = board2Cards[i];
      ritBoardFlop2[i].hide = true;
      ritBoardFlop2[i].notify();
    }

    for (int i = 0; i < cardStates3.length; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i + 8);
      ritBoardFlop2[i].position = cardDimen.position;

      ritBoardFlop2[i].size = cardDimen.size;

      ritBoardFlop2[i].slide = false;
      ritBoardFlop2[i].hide = false;
      ritBoardFlop2[i].useStartPos = true;
      ritBoardFlop2[i].flip = true;

      ritBoardFlop2[i].notify();

      cardId++;
    }
  }

  /// call this function only if we were running Single Board game up till now, then shifted to Run It Twice
  Future<void> addRunItTwiceCards({
    @required final List<int> board1,
    @required final List<int> board2,
  }) async {
    assert(
      board2 != null,
      'Second board cannot be null in case of Run It Twice',
    );

    assert(
      board1.length == board2.length && board1.length == 5,
      'Both the boards must contain 5 cards',
    );

    if (_isTurnDone) {
      // need to add last set of cards
      final board1LastCard = board1.last;
      final board2LastCard = board2.last;

      await _delayFA();
      await _runItTwiceAfterTurn(board1LastCard, board2LastCard);
    } else if (_isFlopDone) {
      await _runItTwiceAfterFlop(board1.sublist(3), board2.sublist(3));
    } else {
      final board1Cards = board1.sublist(0, 3);
      final board2Cards = board2.sublist(0, 3);

      _doubleBoard = true;
      _addFlopCards(
        board1Cards,
        startWith: 1,
        boardState: CommunityCardBoardState.DOUBLE,
      );

      await _delayFA();

      await _addTurnCard(board1[3],
          startWith: 4, boardState: CommunityCardBoardState.DOUBLE);

      await _delayFA();

      await _addRiverCard(board1[4],
          startWith: 5, boardState: CommunityCardBoardState.DOUBLE);

      await _delayFA();

      await _addFlopCards(
        board2Cards,
        startWith: 6,
        boardState: CommunityCardBoardState.DOUBLE,
      );

      await _delayFA();

      await _addTurnCard(board2[3],
          startWith: 9, boardState: CommunityCardBoardState.DOUBLE);
      await _delayFA();

      await _addRiverCard(board2[4],
          startWith: 10, boardState: CommunityCardBoardState.DOUBLE);
    }
  }

  /// add cards in between game - via query current hand
  void addBoardCardsWithoutAnimating({
    @required final List<int> board1,
    final List<int> board2,
  }) async {
    log('CommunityCardState: addBoardCardsWithoutAnimating');
    bool isDoubleBoard = false;
    final int n = board1.length;
    bool isFlopRunItTwice = false;
    bool isTurnRunItTwice = false;
    if (board2 != null && board2.length > 0) {
      isDoubleBoard = true;
      isFlopRunItTwice = (n >= 3 && board2[2] == board1[2]);
      isTurnRunItTwice = (n >= 4 && board2[3] == board1[3]);
    }

    _isFlopDone = false;
    _isTurnDone = false;
    _isRiverDone = false;

    log('CommunityCardState: addBoardCardsWithoutAnimating ${board1} board2: ${board2}');
    // FLOP
    if (n >= 3) {
      _isFlopDone = true;
      if (isDoubleBoard) {
        if (isFlopRunItTwice) {
          // run it twice (after flop)
        } else {
          // double board
          _addFlopCards(board1.sublist(0, 3),
              startWith: 1,
              boardState: CommunityCardBoardState.DOUBLE,
              animate: false);
          _addFlopCards(board2.sublist(0, 3),
              startWith: 6,
              boardState: CommunityCardBoardState.DOUBLE,
              animate: false);
        }
      } else {
        // show flop (1, 2, 3)
        log('Single board show flop');
        _addFlopCards(board1.sublist(0, 3), animate: false);
      }
    }

    // // TURN
    if (n >= 4) {
      _isTurnDone = true;
      if (isDoubleBoard) {
        if (isTurnRunItTwice) {
          // Turn card is same for both board
          final cardNo = board1[3];
        } else if (isFlopRunItTwice) {
          final card1No = board1[3];
          final card2No = board2[3];
        } else {
          // double board
          final card1No = board1[3];
          final card2No = board2[3];
          _addTurnCard(card1No,
              startWith: 4,
              boardState: CommunityCardBoardState.DOUBLE,
              animate: false);
          _addTurnCard(card2No,
              startWith: 9,
              boardState: CommunityCardBoardState.DOUBLE,
              animate: false);
        }
      } else {
        final cardNo = board1[3];
        // single board (4)
        _addTurnCard(cardNo, animate: false);
      }
    }

    // RIVER
    if (n == 5) {
      if (isDoubleBoard) {
        if (isFlopRunItTwice) {
          final card1No = board1[4];
          final card2No = board2[4];
          // run it twice after turn
        } else {
          final card1No = board1[4];
          final card2No = board2[4];
          // double board
          _addRiverCard(card1No,
              startWith: 5,
              boardState: CommunityCardBoardState.DOUBLE,
              animate: false);
          _addRiverCard(card2No,
              startWith: 10,
              boardState: CommunityCardBoardState.DOUBLE,
              animate: false);
        }
      } else {
        final cardNo = board1[4];
        // single board
        _addRiverCard(cardNo, animate: false);
      }
    }

    // for (final cardState in cardStates) {
    //   cardState.isFaced = true;
    // }

    // notifyListeners();
  }

  /// add cards in between game - via query current hand
  void addBoardCardsWithoutAnimatingOld({
    @required final List<int> board1,
    final List<int> board2,
  }) async {
    bool isDoubleBoard = false;
    final int n = board1.length;
    bool isFlopRunItTwice = false;
    bool isTurnRunItTwice = false;
    if (board2 != null && board2.length > 0) {
      isDoubleBoard = true;
      isFlopRunItTwice = (n >= 3 && board2[2] == board1[2]);
      isTurnRunItTwice = (n >= 4 && board2[3] == board1[3]);
    }

    final List<CardState> cardStates = [];
    _isFlopDone = false;
    _isTurnDone = false;
    _isRiverDone = false;

    log('CommunityCardState: addBoardCardsWithoutAnimating ${board1} board2: ${board2}');
    // FLOP
    if (n >= 3) {
      _isFlopDone = true;
      if (isDoubleBoard) {
        if (isFlopRunItTwice) {
          // first 3 cards are same
          int cardId = 1;
          final states = board1
              .sublist(0, 3)
              .map((cNo) => _getCardStateFromCardNo(
                    null,
                    cNo,
                    boardState: CommunityCardBoardState.RIT,
                    cardId: cardId++,
                  ))
              .toList();

          cardStates.addAll(states);
        } else {
          int cardId1 = 1;
          int cardId2 = 6;

          final states1 = board1
              .sublist(0, 3)
              .map((cNo) => _getCardStateFromCardNo(
                    null,
                    cNo,
                    boardState: CommunityCardBoardState.DOUBLE,
                    cardId: cardId1++,
                  ))
              .toList();

          final states2 = board2
              .sublist(0, 3)
              .map((cNo) => _getCardStateFromCardNo(
                    null,
                    cNo,
                    boardState: CommunityCardBoardState.DOUBLE,
                    cardId: cardId2++,
                  ))
              .toList();

          cardStates.addAll(states1);
          cardStates.addAll(states2);
        }
      } else {
        int cardId = 1;
        final states = board1
            .sublist(0, 3)
            .map((cNo) => _getCardStateFromCardNo(null, cNo, cardId: cardId++))
            .toList();
        cardStates.addAll(states);
      }
    }

    // TURN
    if (n >= 4) {
      _isTurnDone = true;
      if (isDoubleBoard) {
        if (isTurnRunItTwice) {
          // Turn card is same for both board
          final cardNo = board1[3];
          cardStates.add(_getCardStateFromCardNo(
            null,
            cardNo,
            boardState: CommunityCardBoardState.RIT,
            cardId: 4,
          ));
        } else if (isFlopRunItTwice) {
          final card1No = board1[3];
          final card2No = board2[3];

          cardStates.add(_getCardStateFromCardNo(
            null,
            card1No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 5,
          ));

          cardStates.add(_getCardStateFromCardNo(
            null,
            card2No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 7,
          ));
        } else {
          final card1No = board1[3];
          final card2No = board2[3];

          cardStates.add(_getCardStateFromCardNo(
            null,
            card1No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 4,
          ));

          cardStates.add(_getCardStateFromCardNo(
            null,
            card2No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 9,
          ));
        }
      } else {
        final cardNo = board1[3];
        cardStates.add(_getCardStateFromCardNo(null, cardNo, cardId: 4));
      }
    }

    // RIVER
    if (n == 5) {
      if (isDoubleBoard) {
        if (isFlopRunItTwice) {
          final card1No = board1[4];
          final card2No = board2[4];

          cardStates.add(_getCardStateFromCardNo(
            null,
            card1No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 6,
          ));

          cardStates.add(_getCardStateFromCardNo(
            null,
            card2No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 8,
          ));
        } else {
          final card1No = board1[4];
          final card2No = board2[4];

          cardStates.add(_getCardStateFromCardNo(
            null,
            card1No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 5,
          ));

          cardStates.add(_getCardStateFromCardNo(
            null,
            card2No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 10,
          ));
        }
      } else {
        final cardNo = board1[4];
        cardStates.add(_getCardStateFromCardNo(null, cardNo, cardId: 5));
      }
    }

    for (final cardState in cardStates) {
      cardState.isFaced = true;
    }

    // _cardStates.clear();
    // _cardStates.addAll(cardStates);
    //log('CommunityCardState: addBoardCardsWithoutAnimating end ${board1} board2: ${board2} cardStates: ${_cardStates}');
    notifyListeners();
  }

  /// reset the community card board
  void reset() {
    log('CommunityCardState: CommunityCardState::reset');
    _isFlopDone = false;
    _isTurnDone = false;
    _highlightedCards.clear();
    //_cardStates.clear();
    board1Cards = [];
    board2Cards = [];
    for (final state in singleBoard) {
      state.fade = true;
      state.reset();
      state.notify();
    }
    for (final state in doubleBoard) {
      state.reset();
      state.notify();
    }

    for (final state in ritBoardFlop) {
      state.reset();
    }

    for (final state in ritBoardFlop1) {
      state.reset();
    }

    for (final state in ritBoardFlop2) {
      state.reset();
    }

    for (final state in ritBoardTurn) {
      state.reset();
    }

    for (final state in ritBoardTurn1) {
      state.reset();
    }

    for (final state in ritBoardTurn2) {
      state.reset();
    }
    //notifyListeners();
  }

  /// internal methods to calculate sizes and positions of every possible card configurations

  Map<int, Rect> _singleBoardCardDimens = Map();
  Rect getSingleBoardCardDimens(int no) => _singleBoardCardDimens[no];

  Map<int, Rect> _doubleBoardCardDimens = Map();
  Rect getDoubleBoardCardDimens(int no) => _doubleBoardCardDimens[no];

  Map<int, Rect> _ritCardDimens = Map();
  Rect getRitBoardCardDimens(int no) => _ritCardDimens[no];

  void _initDimenForRitBoard(Size size) {
    /// common cards -> 1, 2, 3, 4, 5
    for (int i = 1; i <= 5; i++) {
      _ritCardDimens[i] = _singleBoardCardDimens[i];
    }

    /// uncommon cards -> 6, 7, 8, 9
    final singleBoard4 = _singleBoardCardDimens[4];
    final singleBoard5 = _singleBoardCardDimens[5];

    final newHeight = (size.height * kSpecialBoardHeightFactor);
    final topOffset = (size.height / 2) - newHeight - kGap;
    final bottomOffset = size.height / 2;

    /// 5, 6 -> top two
    _ritCardDimens[6] = Rect.fromLTWH(
      singleBoard4.left,
      topOffset,
      singleBoard4.width,
      newHeight,
    );
    _ritCardDimens[7] = Rect.fromLTWH(
      singleBoard5.left,
      topOffset,
      singleBoard5.width,
      newHeight,
    );

    /// 7, 8 -> bottom two
    _ritCardDimens[8] = Rect.fromLTWH(
      singleBoard4.left,
      bottomOffset,
      singleBoard4.width,
      newHeight,
    );
    _ritCardDimens[9] = Rect.fromLTWH(
      singleBoard5.left,
      bottomOffset,
      singleBoard5.width,
      newHeight,
    );
  }

  void _initDimenForDoubleBoard(Size size) {
    if (gameState.boardAttributes.isOrientationHorizontal) {
      const int n = kTotalCards;
      const int gap = n + 1;
      const double gapWidth = kGap;
      const totalGapWidth = gap * gapWidth;
      final extraGap = size.width * kDoubleBoardWidthFactor;
      final cardsAvailableWidth = size.width - totalGapWidth - extraGap;
      final eachCardWidth = cardsAvailableWidth / n;
      final eachCardHeight = (size.height - kGap) / 2;

      /// top cards -> 1, 2, 3, 4, 5
      double xOffset = gapWidth + extraGap / 2;
      for (int i = 1; i <= n; i++) {
        _doubleBoardCardDimens[i] =
            Rect.fromLTWH(xOffset, 0, eachCardWidth, eachCardHeight);
        xOffset += gapWidth + eachCardWidth;
      }

      /// bottom cards -> 6, 7, 8, 9, 10
      xOffset = gapWidth + extraGap / 2;
      for (int i = n + 1; i <= n * 2; i++) {
        _doubleBoardCardDimens[i] = Rect.fromLTWH(
            xOffset, eachCardHeight + kGap, eachCardWidth, eachCardHeight);
        xOffset += gapWidth + eachCardWidth;
      }
    } else {
      const int n = kTotalCards;
      const int gap = n + 1;
      const double gapWidth = kGap;
      const totalGapWidth = gap * gapWidth;
      // final extraGap = size.width * kDoubleBoardWidthFactor;
      final extraGap = 0;
      final cardsAvailableWidth = size.width - totalGapWidth - extraGap;
      final eachCardWidth = cardsAvailableWidth / n;
      final eachCardHeight = eachCardWidth * 3 / 2;

      /// top cards -> 1, 2, 3, 4, 5
      double xOffset = gapWidth + extraGap / 2;
      for (int i = 1; i <= n; i++) {
        _doubleBoardCardDimens[i] =
            Rect.fromLTWH(xOffset, 0, eachCardWidth, eachCardHeight);
        xOffset += gapWidth + eachCardWidth;
      }

      /// bottom cards -> 6, 7, 8, 9, 10
      // xOffset = gapWidth + extraGap / 2;
      xOffset = gapWidth + extraGap / 2;
      for (int i = n + 1; i <= n * 2; i++) {
        _doubleBoardCardDimens[i] = Rect.fromLTWH(
            xOffset, eachCardHeight + kGap, eachCardWidth, eachCardHeight);
        xOffset += gapWidth + eachCardWidth;
      }
    }
  }

  void _initDimenForSingleBoard(Size size) {
    const int n = kTotalCards;
    const int gap = n + 1;
    const double gapWidth = kGap;
    const totalGapWidth = gap * gapWidth;
    final cardsAvailableWidth = size.width - totalGapWidth;
    final eachCardWidth = cardsAvailableWidth / n;
    final eachCardHeight = eachCardWidth * 3 / 2;
    // final eachCardHeight = size.height * kSingleBoardHeightFactor;
    final heightOffset = size.height * (1 - kSingleBoardHeightFactor) / 2;

    double xOffset = gapWidth;
    for (int i = 1; i <= n; i++) {
      _singleBoardCardDimens[i] = Rect.fromLTWH(
        xOffset,
        heightOffset,
        eachCardWidth,
        eachCardHeight,
      );
      xOffset += gapWidth + eachCardWidth;
    }
  }

  void initializeCards(Size size) {
    if (_initialized) return;
    // single board size calculations
    _initDimenForSingleBoard(size);

    // double board size calculations
    _initDimenForDoubleBoard(size);

    // special board - combination of double & single board
    _initDimenForRitBoard(size);

    // initialize card states
    // 1, 2, 3, 4, 5  -> board1
    for (int i = 1; i <= 5; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.SINGLE, i);
      Offset offset = null;
      if (i > 1) {
        offset = singleBoard[0].position;
      }
      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
        // flipKey: GlobalKey<AppFlipCardState>(),
      );
      singleBoard.add(cardState);
    }

    // 1, 2, 3, 4, 5  -> board1
    // 6, 7, 8, 9, 10 -> board2
    for (int i = 1; i <= 10; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.DOUBLE, i);
      Offset offset = null;
      if (i > 1 && i < 6) {
        offset = doubleBoard[0].position;
      }

      if (i > 6) {
        offset = doubleBoard[5].position;
      }

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      doubleBoard.add(cardState);
    }

    // ritBoardFlop 1, 2, 3
    for (int i = 1; i < 4; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i);
      Offset offset = null;

      if (i > 1) {
        offset = singleBoard[0].position;
      }

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      ritBoardFlop.add(cardState);
    }

    // ritBoardFlop1 4, 5
    for (int i = 4; i < 6; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i);
      Offset offset = null;

      offset = ritBoardFlop[2].position;

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      ritBoardFlop1.add(cardState);
    }

    // ritBoardFlop2 6, 7
    for (int i = 6; i < 8; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i);
      Offset offset = null;

      offset = ritBoardFlop1[0].position;

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      ritBoardFlop2.add(cardState);
    }

    // ritBoardTurn 1, 2, 3, 4
    for (int i = 1; i < 5; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i);
      Offset offset = null;

      if (i > 1) {
        offset = singleBoard[0].position;
      }

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      ritBoardTurn.add(cardState);
    }

    // ritBoardTurn1 5
    for (int i = 5; i < 6; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i);
      Offset offset = null;

      offset = ritBoardFlop[2].position;

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      ritBoardTurn1.add(cardState);
    }

    // ritBoardTurn2 6
    for (int i = 6; i < 7; i++) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, i);
      Offset offset = null;

      offset = ritBoardFlop[2].position;

      final cardState = CardState(
        startPos: offset,
        position: cardDimen.position,
        cardId: i,
        size: cardDimen.size,
        cardNo: 0,
      );
      ritBoardTurn2.add(cardState);
    }

    // RIT twice
    _initialized = true;
  }
}
