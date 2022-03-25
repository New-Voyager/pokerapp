import 'package:flutter/material.dart';

const kTotalCards = 5;
const kGap = 4.0;
const kDoubleBoardWidthFactor = 0.35;
const kSingleBoardHeightFactor = 0.65;
const kSpecialBoardHeightFactor = 0.55;

class Pair<A, B> {
  final A a;
  final B b;

  Pair(this.a, this.b);
}

enum CommunityCardBoardState { single, double, special }

/// this class holds the card sizes & positions for different community card configurations
class CommunityCardState {
  bool isCalculated = false;

  Map<int, Pair<Offset, Size>> _singleBoardCardDimens = Map();
  Pair<Offset, Size> getSingleBoardCardDimens(int no) =>
      _singleBoardCardDimens[no];

  Map<int, Pair<Offset, Size>> _doubleBoardCardDimens = Map();
  Pair<Offset, Size> getDoubleBoardCardDimens(int no) =>
      _doubleBoardCardDimens[no];

  Map<int, Pair<Offset, Size>> _specialBoardCardDimens = Map();
  Pair<Offset, Size> getSpecialBoardCardDimens(int no) =>
      _specialBoardCardDimens[no];

  void _initDimenForSpecialBoard(Size size) {
    /// common cards -> 1, 2, 3, 4
    for (int i = 1; i <= 4; i++) {
      _specialBoardCardDimens[i] = _singleBoardCardDimens[i];
    }

    /// uncommon cards -> 5, 6, 7, 8
    final singleBoard4 = _singleBoardCardDimens[4];
    final singleBoard5 = _singleBoardCardDimens[5];

    final newHeight = (size.height * kSpecialBoardHeightFactor);
    final topOffset = (size.height / 2) - newHeight - kGap;
    final bottomOffset = size.height / 2;

    /// 5, 6 -> top two
    _specialBoardCardDimens[5] = Pair(
      Offset(singleBoard4.a.dx, topOffset),
      Size(singleBoard4.b.width, newHeight),
    );
    _specialBoardCardDimens[6] = Pair(
      Offset(singleBoard5.a.dx, topOffset),
      Size(singleBoard5.b.width, newHeight),
    );

    /// 7, 8 -> bottom two
    _specialBoardCardDimens[7] = Pair(
      Offset(singleBoard4.a.dx, bottomOffset),
      Size(singleBoard4.b.width, newHeight),
    );
    _specialBoardCardDimens[8] = Pair(
      Offset(singleBoard5.a.dx, bottomOffset),
      Size(singleBoard5.b.width, newHeight),
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
      _doubleBoardCardDimens[i] = Pair<Offset, Size>(
        Offset(xOffset, 0.0),
        Size(eachCardWidth, eachCardHeight),
      );
      xOffset += gapWidth + eachCardWidth;
    }

    /// bottom cards -> 6, 7, 8, 9, 10
    xOffset = gapWidth + extraGap / 2;
    for (int i = n + 1; i <= n * 2; i++) {
      _doubleBoardCardDimens[i] = Pair<Offset, Size>(
        Offset(xOffset, eachCardHeight + kGap),
        Size(eachCardWidth, eachCardHeight),
      );
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
      _singleBoardCardDimens[i] = Pair<Offset, Size>(
        Offset(xOffset, heightOffset),
        Size(eachCardWidth, eachCardHeight),
      );
      xOffset += gapWidth + eachCardWidth;
    }
  }

  void initializeCards(Size size) {
    // if (isCalculated) return; // todo: uncomment this line, after finalized
    isCalculated = true;

    // single board size calculations
    _initDimenForSingleBoard(size);

    // double board size calculations
    _initDimenForDoubleBoard(size);

    // special board - combination of double & single board
    _initDimenForSpecialBoard(size);
  }
}
