import 'package:flutter/material.dart';

const kTotalCards = 5;
const kGap = 4.0;
const kDoubleBoardWidthFactor = 0.35;
const kSingleBoardHeightFactor = 0.65;
const kSpecialBoardHeightFactor = 0.55;

enum CommunityCardBoardState { SINGLE, DOUBLE, RIT }
enum CardState {
  UNSET,

  ANIMATING_FLOP,
  FLOP,
  ANIMATING_TURN,
  TURN,
  ANIMATING_RIVER,
  RIVER,

  // RIT cases
  ANIMATING_BD1_TURN, // animate turn card (same sa ANIMATING_TURN)
  BD1_TURN,
  ANIMATING_BD1_RIVER,
  BD1_RIVER,
  ANIMATING_MOVE_BD1_TURN_RIVER, // move bd1 turn and river to top board
  ANIMATING_BD2_TURN,
  BD2_TURN,
  ANIMATING_BD2_RIVER,
  BD2_RIVER,

  // RIT starts in the river card
  ANIMATING_MOVE_BD1_RIVER, // move bd1 river to top board
}

/// this class holds the card sizes & positions for different community card configurations
class CommunityCardState extends ChangeNotifier {
  bool _initialized = false;

  // this state controls the card animation
  // CardState _cardState = CardState.UNSET;
  // CardState get cardState => _cardState;

  // CommunityCardBoardState _boardState = CommunityCardBoardState.RIT;
  // CommunityCardBoardState get boardState => _boardState;

  bool _isFlopDone = false;
  bool _isRiverDone = false;

  void addFlopCards({
    @required final List<int> board1,
    final List<int> board2,
  }) {
    _isFlopDone = true;
  }

  void addRiverCards({
    @required final List<int> board1,
    final List<int> board2,
  }) {
    _isRiverDone = true;
  }

  void addTurnCards({
    @required final List<int> board1,
    final List<int> board2,
  }) {}

  /// call this function only if we were running Single Board game up till now, then shifted to Run It Twice
  void addRunItTwiceCards({
    @required final List<int> board1,
    @required final List<int> board2,
  }) {}

  void reset() {
    _isFlopDone = false;
    _isRiverDone = false;
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
    if (_initialized) return; // todo: uncomment this line, after finalized
    // single board size calculations
    _initDimenForSingleBoard(size);

    // double board size calculations
    _initDimenForDoubleBoard(size);

    // special board - combination of double & single board
    _initDimenForRitBoard(size);
    _initialized = true;
  }
}
