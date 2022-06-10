import 'package:flutter/material.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/app_flip_card.dart';

import '../../../resources/app_constants.dart';

const kTotalCards = 5;
const kGap = 4.0;
const kDoubleBoardWidthFactor = 0.35;
const kSingleBoardHeightFactor = 0.80;
const kSpecialBoardHeightFactor = 0.50;

extension RectHelper on Rect {
  Offset get position => Offset(left, top);
}

enum CommunityCardBoardState { SINGLE, DOUBLE, RIT }

class CardState {
  Offset position;
  Size size;

  final int cardNo;
  final GlobalKey<AppFlipCardState> flipKey;
  bool isFaced;

  CardState({
    @required this.position,
    @required this.size,
    @required this.cardNo,
    @required this.flipKey,
    this.isFaced = false,
  });
}

/// this class holds the card sizes & positions for different community card configurations
class CommunityCardState extends ChangeNotifier {
  bool _initialized = false;

  final List<CardState> _cardStates = [];
  List<CardState> get cardStates => _cardStates;

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

  CardState _getCardStateFromCardNo(
    int cNo, {
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
    int cardId = 1,
  }) {
    final cardDimen = _getCardDimen(boardState, cardId);
    return CardState(
      position: cardDimen.position,
      size: cardDimen.size,
      cardNo: cNo,
      flipKey: GlobalKey<AppFlipCardState>(),
    );
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
    List<CardState> localCardStates = [];
    localCardStates.addAll(
      board.map(
        (cNo) => _getCardStateFromCardNo(
          cNo,
          boardState: boardState,
          cardId: startWith,
        ),
      ),
    );
    _cardStates.addAll(localCardStates);

    notifyListeners();

    await _delay();

    // flip the first card
    localCardStates.forEach((cs) {
      cs.flipKey.currentState.toggleCard();
    });

    await _delayFA();

    // move the cards
    for (int i = 0; i < 3; i++) {
      final cardId = startWith + i;
      final cardDimen = _getCardDimen(boardState, cardId);
      localCardStates[i].position = cardDimen.position;
    }
    notifyListeners();
  }

  Future<void> addFlopCards({
    @required final List<int> board1,
    final List<int> board2,
  }) async {
    assert(board1.length == 3, 'Board 1: Only 3 cards to be added in Flop');

    final bool isDoubleBoard = board2 != null;
    if (isDoubleBoard) {
      assert(board2.length == 3, 'Board 2: Only 3 cards to be added in Flop');
    }

    if (isDoubleBoard) {
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
    final cardState = _getCardStateFromCardNo(
      cardNo,
      cardId: startWith,
      boardState: boardState,
    );
    _cardStates.add(cardState);
    notifyListeners();

    await _delay();

    // flip
    cardState.flipKey.currentState.toggleCard();
  }

  /// single board -> 4
  /// double board -> 4, 9
  void addTurnCard({
    @required int board1Card,
    final int board2Card,
  }) async {
    final bool isDoubleBoard = board2Card != null;

    if (isDoubleBoard) {
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
      await _addTurnCard(board1Card);
    }

    _isTurnDone = true;
  }

  Future<void> _addRiverCard(
    int cardNo, {
    int startWith = 5,
    CommunityCardBoardState boardState = CommunityCardBoardState.SINGLE,
  }) async {
    final cardState = _getCardStateFromCardNo(
      cardNo,
      cardId: startWith,
      boardState: boardState,
    );
    _cardStates.add(cardState);
    notifyListeners();

    await _delay();

    // flip
    cardState.flipKey.currentState?.toggleCard();
  }

  /// single board -> 5
  /// double board -> 5, 10
  void addRiverCard({
    @required int board1Card,
    final int board2Card,
  }) async {
    final bool isDoubleBoard = board2Card != null;

    if (isDoubleBoard) {
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
      await _addRiverCard(board1Card);
    }
  }

  /// cards -> 6, 8 (as 1, 2, 3, 4 are common) & (5, 7 are reserved for Turn case)
  Future<void> _runItTwiceAfterTurn(int c1, int c2) async {
    final card1State = _getCardStateFromCardNo(
      c1,
      cardId: 5,
    ); // 5 -> before RIT dimen
    _cardStates.add(card1State);
    notifyListeners();
    await _delay();

    // flip
    card1State.flipKey.currentState.toggleCard();
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
      c2,
      cardId: 8,
      boardState: CommunityCardBoardState.RIT,
    ); // 8 -> second card RIT dimen
    _cardStates.add(card2State);
    notifyListeners();
    await _delay();

    // flip
    card2State.flipKey.currentState.toggleCard();
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
        cNo,
        cardId: cardId,
        boardState: boardState,
      );
      cardStates.add(state);
      cardId++;

      _cardStates.add(state);
      notifyListeners();

      await _delay();

      // flip
      state.flipKey.currentState.toggleCard();

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
    final bool isDoubleBoard = board2 != null;
    final int n = board1.length;

    final bool isFlopRunItTwice =
        board2 != null && n >= 3 && board2[2] == board1[2];
    final bool isTurnRunItTwice =
        board2 != null && n >= 4 && board2[3] == board1[3];

    final List<CardState> cardStates = [];
    _isFlopDone = false;
    _isTurnDone = false;

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
                    cNo,
                    boardState: CommunityCardBoardState.DOUBLE,
                    cardId: cardId1++,
                  ))
              .toList();

          final states2 = board2
              .sublist(0, 3)
              .map((cNo) => _getCardStateFromCardNo(
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
            .map((cNo) => _getCardStateFromCardNo(cNo, cardId: cardId++))
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
            cardNo,
            boardState: CommunityCardBoardState.RIT,
            cardId: 4,
          ));
        } else if (isFlopRunItTwice) {
          final card1No = board1[3];
          final card2No = board2[3];

          cardStates.add(_getCardStateFromCardNo(
            card1No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 5,
          ));

          cardStates.add(_getCardStateFromCardNo(
            card2No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 7,
          ));
        } else {
          final card1No = board1[3];
          final card2No = board2[3];

          cardStates.add(_getCardStateFromCardNo(
            card1No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 4,
          ));

          cardStates.add(_getCardStateFromCardNo(
            card2No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 9,
          ));
        }
      } else {
        final cardNo = board1[3];
        cardStates.add(_getCardStateFromCardNo(cardNo, cardId: 4));
      }
    }

    // RIVER
    if (n == 5) {
      if (isDoubleBoard) {
        if (isFlopRunItTwice) {
          final card1No = board1[4];
          final card2No = board2[4];

          cardStates.add(_getCardStateFromCardNo(
            card1No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 6,
          ));

          cardStates.add(_getCardStateFromCardNo(
            card2No,
            boardState: CommunityCardBoardState.RIT,
            cardId: 8,
          ));
        } else {
          final card1No = board1[4];
          final card2No = board2[4];

          cardStates.add(_getCardStateFromCardNo(
            card1No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 5,
          ));

          cardStates.add(_getCardStateFromCardNo(
            card2No,
            boardState: CommunityCardBoardState.DOUBLE,
            cardId: 10,
          ));
        }
      } else {
        final cardNo = board1[4];
        cardStates.add(_getCardStateFromCardNo(cardNo, cardId: 5));
      }
    }

    for (final cardState in cardStates) {
      cardState.isFaced = true;
    }

    _cardStates.clear();
    _cardStates.addAll(cardStates);
    notifyListeners();
  }

  /// reset the community card board
  void reset() {
    _isFlopDone = false;
    _isTurnDone = false;
    _highlightedCards.clear();
    _cardStates.clear();
    notifyListeners();
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
    const int n = kTotalCards;
    const int gap = n + 1;
    const double gapWidth = kGap;
    const totalGapWidth = gap * gapWidth;
    final extraGap = size.width * kDoubleBoardWidthFactor;
    final cardsAvailableWidth = size.width - totalGapWidth - extraGap;
    final eachCardHeight = (size.height - kGap) / 2;
    final eachCardWidth = eachCardHeight * 2 / 3;

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
    _initialized = true;
  }
}
