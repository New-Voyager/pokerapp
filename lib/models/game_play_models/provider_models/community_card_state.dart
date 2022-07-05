import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/app_flip_card.dart';

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
  // final List<CardState> _cardStates = [];
  // List<CardState> get cardStates => _cardStates;
  List<CardState> singleBoard = []; // 1, 2, 3, 4, 5
  List<CardState> doubleBoard = []; // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  List<CardState> ritBoard1 = []; // 1, 2, 3, 4, 51, 52
  List<CardState> ritBoard2 = []; // 1, 2, 3, 41, 42, 51, 52

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
    // if (cardStateCache[cardId] != null) {
    //   var cardState = cardStateCache[cardId];
    //   cardState.cardNo = cNo;
    //   return cardState;
    // }
    final cardDimen = _getCardDimen(boardState, cardId);
    final cardState = CardState(
      startPos: startPos,
      position: cardDimen.position,
      cardId: cardId,
      size: cardDimen.size,
      cardNo: cNo,
      // flipKey: GlobalKey<AppFlipCardState>(),
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
      _board[i].hide = true;
      _board[i].notify();
    }
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

    //   singleBoard[i].hide = false;
    //   singleBoard[i].flip = true;
    //   singleBoard[i].notify();
    // }
  }

  // Future<void> _addFlopCards2(
  //   List<int> board, {
  //   int startWith = 1,
  //   CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
  // }) async {
  //   // first add last card and flip it
  //   List<CardState> localCardStates = [];
  //   //board = [board[0]];
  //   localCardStates.add(_getCardStateFromCardNo(
  //     Offset(0, 0),
  //     board[2],
  //     boardState: boardState,
  //     cardId: startWith,
  //   ));
  //   localCardStates[0].flip = true;

  //   //_cardStates.addAll(localCardStates);
  //   // notifyListeners();
  //   // then add other cards
  //   await _delay();

  //   localCardStates = [];
  //   //board = [board[0]];
  //   localCardStates.addAll(
  //     board.map(
  //       (cNo) => _getCardStateFromCardNo(
  //         cNo,
  //         boardState: boardState,
  //         cardId: startWith,
  //       ),
  //     ),
  //   );

  //   // _cardStates.addAll(localCardStates);

  //   notifyListeners();

  //   //await _delay();
  //   //log('1 CommunityCardState: _addFlopCards: _cardStates: $_cardStates');
  //   // flip the first card
  //   bool addWithoutAnimating = false;
  //   //localCardStates[2].flip = true;
  //   localCardStates.forEach((cs) {
  //     cs.notify();
  //   });
  //   // log('2 CommunityCardState: _addFlopCards: _cardStates: $_cardStates');

  //   await _delayFA();
  //   if (PlatformUtils.isWeb && addWithoutAnimating) {
  //     addBoardCardsWithoutAnimating(board1: board1Cards, board2: board2Cards);
  //     return;
  //   }

  //   // move the cards
  //   for (int i = 0; i < 3; i++) {
  //     final cardId = startWith + i;
  //     final cardDimen = _getCardDimen(boardState, cardId);
  //     localCardStates[i].position = cardDimen.position;
  //   }
  //   notifyListeners();
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
    _board[cardIndex].flip = true;
    _board[cardIndex].notify();

    await _delay();

    // final cardState = _getCardStateFromCardNo(
    //   null,
    //   cardNo,
    //   cardId: startWith,
    //   boardState: boardState,
    // );
    // //_cardStates.add(cardState);

    // notifyListeners();

    // await _delay();

    // // flip
    // // if (PlatformUtils.isWeb) {
    // //   if (cardState.flipKey != null && cardState.flipKey.currentState == null) {
    // //     addBoardCardsWithoutAnimating(board1: board1Cards, board2: board2Cards);
    // //     return;
    // //   }
    // // }
    // // cardState.flipKey.currentState?.toggleCard();
    // cardState.flip = true;
    // cardState.notify();
    // _delay().then((value) {
    //   cardState.flip = false;
    // }).onError((error, stackTrace) {});

    // if (PlatformUtils.isWeb) {}
  }

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

  Future<void> _addRiverCard(
    int cardNo, {
    int startWith = 5,
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
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
    _board[cardIndex].flip = true;
    _board[cardIndex].notify();

    await _delay();

    // final cardState = _getCardStateFromCardNo(
    //   null,
    //   cardNo,
    //   cardId: startWith,
    //   boardState: boardState,
    // );
    // // _cardStates.add(cardState);
    // // if (PlatformUtils.isWeb) {
    // //   bool addWithoutAnimating = false;
    // //   if (cardState.flipKey != null && cardState.flipKey.currentState == null) {
    // //     addWithoutAnimating = true;
    // //   }
    // //   if (addWithoutAnimating) {
    // //     addBoardCardsWithoutAnimating(board1: board1Cards, board2: board2Cards);
    // //     return;
    // //   }
    // // }

    // notifyListeners();

    // await _delay();

    // // flip
    // cardState.flip = true;
    // cardState.notify();

    // if (PlatformUtils.isWeb) {
    //   if (cardState.flipKey != null && cardState.flipKey.currentState == null) {
    //     addBoardCardsWithoutAnimating(board1: board1Cards, board2: board2Cards);
    //     return;
    //   }
    // }
    // cardState.flipKey.currentState?.toggleCard();
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

//      await _addRiverCard(board1Card);
    }
    log('CommunityCardState: CommunityCardState::addRiverCard ${board1Cards} board2: ${board2Cards}');
  }

  /// cards -> 6, 8 (as 1, 2, 3, 4 are common) & (5, 7 are reserved for Turn case)
  Future<void> _runItTwiceAfterTurn(int c1, int c2) async {
    final card1State = _getCardStateFromCardNo(
      null,
      c1,
      cardId: 5,
    ); // 5 -> before RIT dimen
    //_cardStates.add(card1State);
    notifyListeners();
    await _delay();

    // flip
    card1State.flip = true;
    card1State.notify();
    //card1State.flipKey.currentState.toggleCard();
    await _delayFA();

    // push up and change size
    final cardDimen = getRitBoardCardDimens(6); // 6 -> RIT dimen
    card1State.size = cardDimen.size;
    card1State.position = cardDimen.position;
    notifyListeners();

    // wait for the push
    await _delay();

    /// DO IT FOR THE OTHER CARD
    final card2State = _getCardStateFromCardNo(
      null,
      c2,
      cardId: 8,
      boardState: CommunityCardBoardState.RIT,
    ); // 8 -> second card RIT dimen
//    _cardStates.add(card2State);
    notifyListeners();
    await _delay();

    // flip
    card2State.flip = true;
    card2State.notify();
    await _delayFA();
  }

  Future<List<CardState>> _displayTwoConsecutiveCards({
    @required List<int> cards,
    @required int cardIdStartsWith,
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
  }) async {
    int cardId = cardIdStartsWith;
    final List<CardState> cardStates = [];

    for (final cNo in cards) {
      final state = _getCardStateFromCardNo(
        null,
        cNo,
        cardId: cardId,
        boardState: boardState,
      );
      cardStates.add(state);
      cardId++;

      //_cardStates.add(state);
      notifyListeners();

      await _delay();

      // flip
      state.flip = true;
      state.notify();
      // state.flipKey.currentState.toggleCard();

      await _delayFA();
    }

    return cardStates;
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

    // push the cards | 4, 5 of SINGLE changes to 5, 6 of RIT
    int cardId = 5;
    cardStates.forEach((cardState) {
      final cardDimen = _getCardDimen(CommunityCardBoardState.RIT, cardId);
      cardState.position = cardDimen.position;
      cardState.size = cardDimen.size;
      cardId++;
    });
    notifyListeners();

    // add the other two cards
    await _displayTwoConsecutiveCards(
      cards: board2Cards,
      cardIdStartsWith: 7,
      boardState: CommunityCardBoardState.RIT,
    );
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

      await _runItTwiceAfterTurn(board1LastCard, board2LastCard);
    } else if (_isFlopDone) {
      // need to add two cards for each board
      final board1Cards = board1.sublist(3);
      final board2Cards = board2.sublist(3);

      await _runItTwiceAfterFlop(board1Cards, board2Cards);
    } else {
      throw AssertionError(
        'Invalid State: If you want to add double board cards, use the addFlopCards method',
      );
    }
  }

  /// add cards in between game - via query current hand
  void addBoardCardsWithoutAnimating({
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

    // for (final state in ritBoard) {
    //   state.reset();
    // }
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
    /// common cards -> 1, 2, 3, 4
    for (int i = 1; i <= 4; i++) {
      _ritCardDimens[i] = _singleBoardCardDimens[i];
    }

    /// uncommon cards -> 5, 6, 7, 8
    final singleBoard4 = _singleBoardCardDimens[4];
    final singleBoard5 = _singleBoardCardDimens[5];

    final newHeight = (size.height * kSpecialBoardHeightFactor);
    final topOffset = (size.height / 2) - newHeight - kGap;
    final bottomOffset = size.height / 2;

    /// 5, 6 -> top two
    _ritCardDimens[5] = Rect.fromLTWH(
      singleBoard4.left,
      topOffset,
      singleBoard4.width,
      newHeight,
    );
    _ritCardDimens[6] = Rect.fromLTWH(
      singleBoard5.left,
      topOffset,
      singleBoard5.width,
      newHeight,
    );

    /// 7, 8 -> bottom two
    _ritCardDimens[7] = Rect.fromLTWH(
      singleBoard4.left,
      bottomOffset,
      singleBoard4.width,
      newHeight,
    );
    _ritCardDimens[8] = Rect.fromLTWH(
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

    // RIT twice
    _initialized = true;
  }
}
