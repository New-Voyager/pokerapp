/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_mappings.dart';
import 'package:tuple/tuple.dart';

enum BoardOrientation {
  horizontal,
  vertical,
}

class BoardAttributesObject extends ChangeNotifier {
  BoardOrientation _boardOrientation;

  BoardAttributesObject({
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) {
    this._boardOrientation = orientation;
  }

  set orientation(BoardOrientation o) {
    if (_boardOrientation == o) return;

    _boardOrientation = o;
    notifyListeners();
  }

  BoardOrientation get orientation => _boardOrientation;

  bool get isOrientationHorizontal =>
      orientation == BoardOrientation.horizontal;

  Map<int, Offset> get seatChangeStackOffsetMapping {
    if (_boardOrientation == BoardOrientation.horizontal)
      return kSeatChangeStackHorizontalOffsetMapping;
    return kSeatChangeStackVerticalOffsetMapping;
  }

  Map<int, Offset> get cardDistributionAnimationOffsetMapping {
    if (_boardOrientation == BoardOrientation.horizontal)
      return kCardDistributionAnimationOffsetHorizontalMapping;
    return kCardDistributionAnimationOffsetVerticalMapping;
  }

  Map<int, Offset> get foldCardAnimationOffsetMapping {
    if (_boardOrientation == BoardOrientation.horizontal)
      return kFoldCardAnimationOffsetHorizontalMapping;
    return kFoldCardAnimationOffsetVerticalMapping;
  }

  Map<int, Offset> get chipAmountAnimationOffsetMapping {
    if (_boardOrientation == BoardOrientation.horizontal)
      return kChipAmountAnimationOffsetHorizontalMapping;
    return kChipAmountAnimationOffsetVerticalMapping;
  }

  Map<int, Offset> get chipAmountWidgetOffsetMapping {
    if (_boardOrientation == BoardOrientation.horizontal)
      return kChipAmountWidgetOffsetHorizontalMapping;
    return kChipAmountWidgetOffsetVerticalMapping;
  }

  Map<int, Offset> get buttonPos {
    if (_boardOrientation == BoardOrientation.horizontal)
      return kDealerButtonHorizontalOffsetMapping;
    return kDealerButtonVerticalOffsetMapping;
  }

  Tuple2<Color, Color> buttonColor(GameType gameType) {
    if (kDealerButtonColor.containsKey(gameType)) {
      return kDealerButtonColor[gameType];
    }
    return kDealerButtonColor[GameType.UNKNOWN];
  }
}
