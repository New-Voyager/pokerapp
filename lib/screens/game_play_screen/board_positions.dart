import 'dart:ui';

import 'package:pokerapp/models/game_play_models/ui/board_object.dart';

const Map<int, Offset> verticalCoinAmountWidgetOffsets = {
  1: Offset(0, -70),
  2: Offset(55, 10),
  3: Offset(55, 50),
  4: Offset(50, 50),
  5: Offset(0, 60),
  6: Offset(0, 60),
  7: Offset(-50, 30),
  8: Offset(-50, 20),
  9: Offset(-50, 0),
};

const Map<int, Offset> horizontalCoinAmountWidgetOffsets = {
  1: Offset(0, -40),
  2: Offset(45, 10),
  3: Offset(35, 50),
  4: Offset(45, 45),
  5: Offset(10, 70),
  6: Offset(-10, 70),
  7: Offset(-40, 30),
  8: Offset(-40, 45),
  9: Offset(-40, 10),
};

const SIDE_PADDING = 1;
const COIN_WIDGET_OFFSETS = 2;

Map<BoardLayout, Map<int, dynamic>> LAYOUT_COORDS = {
  BoardLayout.HORIZONTAL: {
    SIDE_PADDING: 5.0,
    COIN_WIDGET_OFFSETS: horizontalCoinAmountWidgetOffsets,
  },
  BoardLayout.VERTICAL: {
    SIDE_PADDING: 25.0,
    COIN_WIDGET_OFFSETS: verticalCoinAmountWidgetOffsets,
  }
};
