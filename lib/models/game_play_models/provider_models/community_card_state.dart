import 'package:flutter/material.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/app_flip_card.dart';

import '../../../resources/app_constants.dart';

const kTotalCards = 5;
const kGap = 4.0;
const kDoubleBoardWidthFactor = 0.35;
const kSingleBoardHeightFactor = 0.65;
const kSpecialBoardHeightFactor = 0.55;

extension RectHelper on Rect {
  Offset get position => Offset(left, top);
}

enum CommunityCardBoardState { SINGLE, DOUBLE, RIT }
// enum CardState {
//   UNSET,
//
//   ANIMATING_FLOP,
//   FLOP,
//   ANIMATING_TURN,
//   TURN,
//   ANIMATING_RIVER,
//   RIVER,
//
//   // RIT cases
//   ANIMATING_BD1_TURN, // animate turn card (same sa ANIMATING_TURN)
//   BD1_TURN,
//   ANIMATING_BD1_RIVER,
//   BD1_RIVER,
//   ANIMATING_MOVE_BD1_TURN_RIVER, // move bd1 turn and river to top board
//   ANIMATING_BD2_TURN,
//   BD2_TURN,
//   ANIMATING_BD2_RIVER,
//   BD2_RIVER,
//
//   // RIT starts in the river card
//   ANIMATING_MOVE_BD1_RIVER, // move bd1 river to top board
// }

class CardState {
  Offset position;
  Size size;

  final int cardNo;
  final GlobalKey<AppFlipCardState> flipKey;

  CardState({
    @required this.position,
    @required this.size,
    @required this.cardNo,
    @required this.flipKey,
  });
}

/// this class holds the card sizes & positions for different community card configurations
class CommunityCardState extends ChangeNotifier {
  bool _initialized = false;

  final List<CardState> _cardStates = [];
  List<CardState> get cardStates => _cardStates;

  // this state controls the card animation
  // CardState _cardState = CardState.UNSET;
  // CardState get cardState => _cardState;

  // CommunityCardBoardState _boardState = CommunityCardBoardState.RIT;
  // CommunityCardBoardState get boardState => _boardState;

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
    cardState.flipKey.currentState.toggleCard();
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

  /// call this function only if we were running Single Board game up till now, then shifted to Run It Twice
  Future<void> addRunItTwiceCards({
    @required final List<int> board1,
    @required final List<int> board2,
  }) async {
    if (_isTurnDone) {
      // need to add last set of cards
      final board1LastCard = board1.last;
      final board2LastCard = board2.last;

      await _runItTwiceAfterTurn(board1LastCard, board2LastCard);
    } else if (_isFlopDone) {
      // need to add two cards

    }

    throw AssertionError(
        'Invalid State: If you want to add double board cards, use the addFlopCards method');
  }

  void reset() {
    _isFlopDone = false;
    _isTurnDone = false;
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
  }

  void _initDimenForSingleBoard(Size size) {
    const int n = kTotalCards;
    const int gap = n + 1;
    const double gapWidth = kGap;
    const totalGapWidth = gap * gapWidth;
    final cardsAvailableWidth = size.width - totalGapWidth;
    final eachCardWidth = cardsAvailableWidth / n;
    final eachCardHeight = size.height * kSingleBoardHeightFactor;
    final heightOffset = size.height * (1 - kSingleBoardHeightFactor) / 2;

    double xOffset = gapWidth;
    for (int i = 1; i <= n; i++) {
      _singleBoardCardDimens[i] =
          Rect.fromLTWH(xOffset, heightOffset, eachCardWidth, eachCardHeight);
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
