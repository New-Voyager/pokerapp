import 'package:flutter/material.dart';

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
  1: Offset(0, -40),
  2: Offset(45, 10),
  3: Offset(35, 50),
  4: Offset(45, 45),
  5: Offset(-10, 70),
  6: Offset(-10, 70),
  7: Offset(-40, 30),
  8: Offset(-40, 45),
  9: Offset(-40, 10),
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

// fixme: these are not correct values
const Map<int, Offset> kFoldCardAnimationOffsetHorizontalMapping = {
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
