import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:tuple/tuple.dart';

/* seat changing stack offset mappings */
const Map<int, Offset> kSeatChangeStackHorizontalOffsetMapping = {
  1: Offset(0, 80),
  2: Offset(-130, 50),
  3: Offset(-120, -0),
  4: Offset(-110, -80),
  5: Offset(-40, -90),
  6: Offset(60, -90),
  7: Offset(110, -80),
  8: Offset(110, -0),
  9: Offset(130, 50),
};

// fixme: these are not correct values
const Map<int, Offset> kSeatChangeStackVerticalOffsetMapping = {
  1: Offset(20, -140),
  2: Offset(80, -80),
  3: Offset(80, -50),
  4: Offset(80, -30),
  5: Offset(50, 50),
  6: Offset(-50, 50),
  7: Offset(-80, -30),
  8: Offset(-80, -50),
  9: Offset(-80, -80),
};

/* card distribution animation offset mapping */
const kCardDistributionAnimationOffsetVerticalMapping = {
  1: Offset(0, 200.0),
  2: Offset(-130, 180),
  3: Offset(-150, 70),
  4: Offset(-150, -50),
  5: Offset(-50, -170),
  6: Offset(50, -170),
  7: Offset(150, -50),
  8: Offset(150, 70),
  9: Offset(130, 180),
};

// fixme: fix these
const kCardDistributionAnimationOffsetHorizontalMapping = {
  1: Offset(0, 200.0),
  2: Offset(-130, 180),
  3: Offset(-150, 70),
  4: Offset(-150, -50),
  5: Offset(-50, -170),
  6: Offset(50, -170),
  7: Offset(150, -50),
  8: Offset(150, 70),
  9: Offset(130, 180),
};

/* player stack widget position mapping */
const Map<int, Offset> kChipAmountWidgetOffsetVerticalMapping = {
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

const Map<int, Offset> kChipAmountWidgetOffsetHorizontalMapping = {
  1: Offset(0, 0),
  2: Offset(0, 0),
  3: Offset(0, 0),
  4: Offset(0, 0),
  5: Offset(0, 0),
  6: Offset(0, 0),
  7: Offset(0, 0),
  8: Offset(0, 0),
  9: Offset(0, 0),
};

/* chip amount animation mapping */
const Map<int, Offset> kChipAmountAnimationOffsetVerticalMapping = {
  1: Offset(0, -90),
  2: Offset(30, -40),
  3: Offset(40, 10),
  4: Offset(50, 100),
  5: Offset(50, 100),
  6: Offset(-50, 100),
  7: Offset(-20, 80),
  8: Offset(-20, 10),
  9: Offset(-50, -50),
};

// fixme: may not be the correct values
const Map<int, Offset> kChipAmountAnimationOffsetHorizontalMapping = {
  1: Offset(0, -90),
  2: Offset(30, -40),
  3: Offset(40, 10),
  4: Offset(50, 100),
  5: Offset(50, 100),
  6: Offset(-50, 100),
  7: Offset(-20, 80),
  8: Offset(-20, 10),
  9: Offset(-50, -50),
};

/* fold card animation mapping */
const Map<int, Offset> kFoldCardAnimationOffsetVerticalMapping = {
  1: Offset(20, -140),
  2: Offset(80, -80),
  3: Offset(80, -50),
  4: Offset(80, -30),
  5: Offset(50, 50),
  6: Offset(-50, 50),
  7: Offset(-80, -30),
  8: Offset(-80, -50),
  9: Offset(-80, -80),
};

const Map<int, Offset> kDealerButtonVerticalOffsetMapping = {
  1: Offset(0, -15),
  2: Offset(0, -15),
  3: Offset(0, -15),
  4: Offset(0, -15),
  5: Offset(0, -15),
  6: Offset(0, -15),
  7: Offset(0, -15),
  8: Offset(0, -15),
  9: Offset(0, -15),
};

Map<GameType, Tuple2<Color, Color>> kDealerButtonColor = {
  GameType.HOLDEM: Tuple2(Colors.white, Colors.black),
  GameType.PLO: Tuple2(Colors.white, Colors.black),
  GameType.PLO_HILO: Tuple2(Colors.white, Colors.black),
  GameType.FIVE_CARD_PLO: Tuple2(Colors.white, Colors.black),
  GameType.FIVE_CARD_PLO_HILO: Tuple2(Colors.white, Colors.black),
  GameType.UNKNOWN: Tuple2(Colors.white, Colors.black),
};
