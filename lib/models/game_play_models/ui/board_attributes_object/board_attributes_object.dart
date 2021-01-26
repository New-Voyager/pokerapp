/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_mappings.dart';

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
}
