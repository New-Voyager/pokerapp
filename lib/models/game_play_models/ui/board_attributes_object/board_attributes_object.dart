/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_mappings.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:tuple/tuple.dart';

enum BoardOrientation {
  horizontal,
  vertical,
}

/* TODO; PUT THIS IN A DIFFERENT FILE */
class CommunityCardAttribute {
  static Map<int, Offset> cardOffsets = Map();

  static bool hasEntry(int idx) => cardOffsets.containsKey(idx);

  static addEntry(
    int idx,
    GlobalKey key,
  ) {
    // print('trying to add entry for $idx index');

    if (key.currentContext == null) return;

    final RenderBox renderBox = key.currentContext.findRenderObject();
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    cardOffsets[idx] = offset;

    // print('card at index $idx is at offset $offset');
  }

  static getOffsetPosition(int idx) => cardOffsets[idx];
}

class PotAttribute {
  GlobalKey _key;
  Offset _globalPos;
  Map<int, Offset> _seatDistance;

  PotAttribute() {
    _key = null;
    _seatDistance = Map<int, Offset>();
  }

  void setSeatDistance(int seatNo, Offset distance) {
    _seatDistance[seatNo] = distance;
  }

  Offset getSeatDistance(int seatNo) {
    return _seatDistance[seatNo];
  }

  get key => this._key;
  set key(GlobalKey key) => this._key = key;

  get globalPos => this._globalPos;
  set globalPos(Offset pos) => this._globalPos = pos;
}

enum SeatPos {
  bottomCenter,
  bottomLeft,
  middleLeft,
  topLeft,
  topCenter,
  topCenter1,
  topCenter2,
  topRight,
  middleRight,
  bottomRight,
}

/*
 * This UI attribute is used for positioning the seat within PlayerOnTableView.
 */
class SeatPosAttribs {
  final Alignment alignment;
  final Offset topLeft;
  final Alignment holeCardPos;

  const SeatPosAttribs(
    this.alignment,
    this.topLeft,
    this.holeCardPos,
  );
}

/* we just need to care about 3 settings
* 1. equals to 7 inch
* 2. less than 7 inch
* 3. greater than 7 inch */

Map<SeatPos, SeatPosAttribs> getSeatMap(int deviceSize) {
  /* device configurations equal to the 7 inch configuration */
  if (deviceSize == 7) {
    return {
      /* bottom center */
      SeatPos.bottomCenter: SeatPosAttribs(
        Alignment.bottomCenter,
        Offset(0, -10),
        Alignment.centerRight,
      ),

      /* bottom left and bottom right */
      SeatPos.bottomLeft: SeatPosAttribs(
        Alignment.bottomLeft,
        Offset(30, -25),
        Alignment.centerRight,
      ),
      SeatPos.bottomRight: SeatPosAttribs(
        Alignment.bottomRight,
        Offset(-30, -25),
        Alignment.centerLeft,
      ),

      /* middle left and middle right */
      SeatPos.middleLeft: SeatPosAttribs(
        Alignment.centerLeft,
        Offset(20, -10),
        Alignment.centerRight,
      ),
      SeatPos.middleRight: SeatPosAttribs(
        Alignment.centerRight,
        Offset(-20, -10),
        Alignment.centerLeft,
      ),

      /* top left and top right */
      SeatPos.topLeft: SeatPosAttribs(
        Alignment.topLeft,
        Offset(40, 35),
        Alignment.centerRight,
      ),
      SeatPos.topRight: SeatPosAttribs(
        Alignment.topRight,
        Offset(-40, 35),
        Alignment.centerLeft,
      ),

      /* center, center left and center right */
      SeatPos.topCenter: SeatPosAttribs(
        Alignment.topCenter,
        Offset(0, 20),
        Alignment.centerLeft,
      ),
      SeatPos.topCenter1: SeatPosAttribs(
        Alignment.topCenter,
        Offset(-65, 15),
        Alignment.centerRight,
      ),
      SeatPos.topCenter2: SeatPosAttribs(
        Alignment.topCenter,
        Offset(65, 15),
        Alignment.centerLeft,
      ),
    };
  }

  /* device configurations larger than 7 inch configurations */
  if (deviceSize > 7) {
    return {
      /* bottom center */
      SeatPos.bottomCenter: SeatPosAttribs(
        Alignment.bottomCenter,
        Offset(0, -20),
        Alignment.centerRight,
      ),

      /* bottom left and bottom right */
      SeatPos.bottomLeft: SeatPosAttribs(
        Alignment.bottomLeft,
        Offset(60, -40),
        Alignment.centerRight,
      ),
      SeatPos.bottomRight: SeatPosAttribs(
        Alignment.bottomRight,
        Offset(-60, -40),
        Alignment.centerLeft,
      ),

      /* middle left and middle right */
      SeatPos.middleLeft: SeatPosAttribs(
        Alignment.centerLeft,
        Offset(20, -15),
        Alignment.centerRight,
      ),
      SeatPos.middleRight: SeatPosAttribs(
        Alignment.centerRight,
        Offset(-20, -15),
        Alignment.centerLeft,
      ),

      /* top left and top right */
      SeatPos.topLeft: SeatPosAttribs(
        Alignment.topLeft,
        Offset(70, 40),
        Alignment.centerRight,
      ),
      SeatPos.topRight: SeatPosAttribs(
        Alignment.topRight,
        Offset(-70, 40),
        Alignment.centerLeft,
      ),

      /* top center, center left and center right */
      SeatPos.topCenter: SeatPosAttribs(
        Alignment.topCenter,
        Offset(0, 0),
        Alignment.centerRight,
      ),
      SeatPos.topCenter1: SeatPosAttribs(
        Alignment.topCenter,
        Offset(-85, 0),
        Alignment.centerRight,
      ),
      SeatPos.topCenter2: SeatPosAttribs(
        Alignment.topCenter,
        Offset(85, 0),
        Alignment.centerLeft,
      ),
    };
  }

  /* device configurations smaller than 7 inch configurations */
  return {
    /* bottom center */
    SeatPos.bottomCenter: SeatPosAttribs(
      Alignment.bottomCenter,
      Offset(0, -10),
      Alignment.centerRight,
    ),

    /* bottom left and bottom right  */
    SeatPos.bottomLeft: SeatPosAttribs(
      Alignment.bottomLeft,
      Offset(20, -20),
      Alignment.centerRight,
    ),
    SeatPos.bottomRight: SeatPosAttribs(
      Alignment.bottomRight,
      Offset(-20, -20),
      Alignment.centerLeft,
    ),

    /* middle left and middle right */
    SeatPos.middleLeft: SeatPosAttribs(
      Alignment.centerLeft,
      Offset(10, 0),
      Alignment.centerRight,
    ),
    SeatPos.middleRight: SeatPosAttribs(
      Alignment.centerRight,
      Offset(-10, 0),
      Alignment.centerLeft,
    ),

    /* top left and top right  */
    SeatPos.topLeft: SeatPosAttribs(
      Alignment.topLeft,
      Offset(20, 40),
      Alignment.centerRight,
    ),
    SeatPos.topRight: SeatPosAttribs(
      Alignment.topRight,
      Offset(-20, 40),
      Alignment.centerLeft,
    ),

    /* center, center right & center left */
    SeatPos.topCenter: SeatPosAttribs(
      Alignment.topCenter,
      Offset(0, 20),
      Alignment.centerRight,
    ),
    SeatPos.topCenter1: SeatPosAttribs(
      Alignment.topCenter,
      Offset(-45, 20),
      Alignment.centerRight,
    ),
    SeatPos.topCenter2: SeatPosAttribs(
      Alignment.topCenter,
      Offset(45, 20),
      Alignment.centerLeft,
    ),
  };
}

/* bet positions configurations for different screen sizes */
Map<SeatPos, Offset> getBetAmountPositionMap({
  @required Size namePlateSize,
  @required int deviceSize,
}) {
  /* for screen sizes less than 7 inch */
  if (deviceSize < 7)
    return {
      /* bottom, bottom left and bottom right */
      SeatPos.bottomCenter: Offset(
        0,
        -namePlateSize.height * 0.80,
      ),
      SeatPos.bottomLeft: Offset(
        namePlateSize.width * 0.60,
        -namePlateSize.height * 0.80,
      ),
      SeatPos.bottomRight: Offset(
        -namePlateSize.width * 0.60,
        -namePlateSize.height * 0.80,
      ),

      /* middle left and middle right */
      SeatPos.middleLeft: Offset(
        namePlateSize.width * 0.10,
        namePlateSize.height * 0.60,
      ),
      SeatPos.middleRight: Offset(
        0,
        namePlateSize.height * 0.60,
      ),

      /* top left and top right */
      SeatPos.topLeft: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),
      SeatPos.topRight: Offset(
        -namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),

      /* center, center left and center right */
      SeatPos.topCenter: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),
      SeatPos.topCenter1: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),
      SeatPos.topCenter2: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),
    };

  /* for screen sizes greater than 7 inch */
  if (deviceSize > 7)
    return {
      /* bottom, bottom left and bottom right */
      SeatPos.bottomCenter: Offset(
        0,
        -namePlateSize.height * 0.80,
      ),
      SeatPos.bottomLeft: Offset(
        namePlateSize.width * 0.60,
        -namePlateSize.height * 0.80,
      ),
      SeatPos.bottomRight: Offset(
        -namePlateSize.width * 0.60,
        -namePlateSize.height * 0.80,
      ),

      /* middle left and middle right */
      SeatPos.middleLeft: Offset(
        namePlateSize.width * 0.30,
        namePlateSize.height * 0.60,
      ),
      SeatPos.middleRight: Offset(
        -namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),

      /* top left and top right */
      SeatPos.topLeft: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),
      SeatPos.topRight: Offset(
        -namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),

      /* center, center left and center right */
      SeatPos.topCenter: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),
      SeatPos.topCenter1: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),
      SeatPos.topCenter2: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.60,
      ),
    };

  /* for screen sizes equals to 7 */
  return {
    /* bottom, bottom left and bottom right */
    SeatPos.bottomCenter: Offset(
      0,
      -namePlateSize.height * 0.80,
    ),
    SeatPos.bottomLeft: Offset(
      namePlateSize.width * 0.60,
      -namePlateSize.height * 0.80,
    ),
    SeatPos.bottomRight: Offset(
      -namePlateSize.width * 0.60,
      -namePlateSize.height * 0.80,
    ),

    /* middle left and middle right */
    SeatPos.middleLeft: Offset(
      namePlateSize.width * 0.20,
      namePlateSize.height * 0.60,
    ),
    SeatPos.middleRight: Offset(
      -namePlateSize.width * 0.10,
      namePlateSize.height * 0.60,
    ),

    /* top left and top right */
    SeatPos.topLeft: Offset(
      namePlateSize.width * 0.30,
      namePlateSize.height * 0.70,
    ),
    SeatPos.topRight: Offset(
      -namePlateSize.width * 0.30,
      namePlateSize.height * 0.70,
    ),

    /* center, center left and center right */
    SeatPos.topCenter: Offset(
      namePlateSize.width * 0.20,
      namePlateSize.height * 0.60,
    ),
    SeatPos.topCenter1: Offset(
      namePlateSize.width * 0.20,
      namePlateSize.height * 0.60,
    ),
    SeatPos.topCenter2: Offset(
      namePlateSize.width * 0.20,
      namePlateSize.height * 0.60,
    ),
  };
}

class BoardAttributesObject extends ChangeNotifier {
  BoardOrientation _boardOrientation;
  Size _boardSize;
  Size _tableSize;

  // center attributes
  // TODO HOW IS THIS CENTER SIZE RELEVANT
  Size _centerSize;

  Size _namePlateSize;

  GlobalKey _centerKey;
  GlobalKey _emptyCenterKey;
  // GlobalKey _centerPotBetKey;
  GlobalKey _dummyViewKey;
  List<PotAttribute> _pots;

  // player view attributes
  Offset _playersOnTableOffset;

  // footer view dimensions
  Size _footerSize;
  Offset _footerOffset;
  int _screenSize;

  // seat attrib map
  Map<SeatPos, SeatPosAttribs> _seatPosAttribs;

  // bet image
  Uint8List _betImage;

  BoardAttributesObject({
    /*
    * This screen size is diagonal inches*/
    @required double screenSize,
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) {
    this._screenSize = screenSize.round();
    log('original screen size: $screenSize, rounded screen size: $_screenSize');
    this._boardOrientation = orientation;
    this._namePlateSize = Size(70, 55);
    this._pots = [];

    _playersOnTableOffset = Offset(0.0, -25.0);

    this._seatPosAttribs = getSeatMap(this._screenSize);
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
    if (_boardOrientation == BoardOrientation.horizontal) {
      return {
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
    }
    return kSeatChangeStackVerticalOffsetMapping;
  }

  Map<int, Offset> buttonPos(int maxPlayers) {
    if (_boardOrientation == BoardOrientation.horizontal) {
      if (maxPlayers == 2) return kDealerButtonHorizontalOffsetMapping2;
      if (maxPlayers == 4) return kDealerButtonHorizontalOffsetMapping4;
      if (maxPlayers == 6) return kDealerButtonHorizontalOffsetMapping6;
      if (maxPlayers == 8) return kDealerButtonHorizontalOffsetMapping8;
      if (maxPlayers == 9) return kDealerButtonHorizontalOffsetMapping9;
    }

    return kDealerButtonVerticalOffsetMapping;
  }

  Map<int, Offset> foldCardPos(int maxPlayers) {
    if (_boardOrientation == BoardOrientation.horizontal) {
      if (maxPlayers == 2) return kFoldCardAnimationOffsetHorizontalMapping2;
      if (maxPlayers == 4) return kFoldCardAnimationOffsetHorizontalMapping4;
      if (maxPlayers == 6) return kFoldCardAnimationOffsetHorizontalMapping6;
      if (maxPlayers == 8) return kFoldCardAnimationOffsetHorizontalMapping8;
      if (maxPlayers == 9) return kFoldCardAnimationOffsetHorizontalMapping9;
    }

    return kDealerButtonVerticalOffsetMapping;
  }

  Tuple2<Color, Color> buttonColor(GameType gameType) {
    if (kDealerButtonColor.containsKey(gameType)) {
      return kDealerButtonColor[gameType];
    }
    return kDealerButtonColor[GameType.UNKNOWN];
  }

  Size dimensions(BuildContext context) {
    var _widthMultiplier = 0.78;
    var _heightMultiplier = 2.0;
    double width = MediaQuery.of(context).size.width;
    double heightOfBoard = width * _widthMultiplier * _heightMultiplier;
    double widthOfBoard = width * _widthMultiplier;

    if (this.orientation == BoardOrientation.horizontal) {
      widthOfBoard = MediaQuery.of(context).size.width;
      heightOfBoard = MediaQuery.of(context).size.height / 2.5;
    }
    this._boardSize = Size(widthOfBoard, heightOfBoard);
    // NOTE: Hard coded
    /* NOTE: THE IMAGE IS SET TO STRETCH TO THE ENTIRE HEIGHT OF THIS AVAILABLE CONTAINER,
    THIS HEIGHT - 40 VARIABLE CAN BE CHANGED TO STRETCH IT FURTHER OR SQUEEZE IT*/
    this._tableSize = Size(widthOfBoard + 50, heightOfBoard - 70);
    this._centerSize = Size(widthOfBoard - 30, this._tableSize.height - 70);

    return this._boardSize;
  }

  get tableSize => this._tableSize;
  get centerKey => this._centerKey;
  get emptyCenterKey => this._emptyCenterKey;

  set centerKey(Key key) => this._centerKey = key;
  set emptyCenterKey(Key key) => this._emptyCenterKey = key;

  get dummyKey => this._dummyViewKey;
  set dummyKey(Key key) => this._dummyViewKey = key;

  GlobalKey getPotsKey(int i) {
    if (this._pots.length == 0 || i >= _pots.length) {
      return null;
    }
    return this._pots[i].key;
  }

  void setPotsKey(int i, GlobalKey key) {
    if (i <= _pots.length - 1) {
      _pots[i].key = key;
      return;
    }
    if (i == _pots.length) {
      PotAttribute attr = PotAttribute();
      attr.key = key;
      _pots.add(attr);
    } else {
      throw Exception('Invalid index');
    }
  }

  Size get namePlateSize => this._namePlateSize;

  // GlobalKey get centerPotBetKey => this._centerPotBetKey;
  // set centerPotBetKey(GlobalKey key) => this._centerPotBetKey = key;

  Offset get playerOnTableOffset => this._playersOnTableOffset;
  set playerOnTableOffset(Offset offset) => this._playersOnTableOffset = offset;

  void setFooterDimensions(Offset offset, Size size) {
    this._footerOffset = offset;
    this._footerSize = size;
  }

  Size get footerSize => this._footerSize;

  SeatPosAttribs getSeatPosAttrib(SeatPos pos) {
    return getSeatMap(this._screenSize)[pos];
  }

  Map<SeatPos, Offset> get betAmountPosition => getBetAmountPositionMap(
        namePlateSize: this._namePlateSize,
        deviceSize: this._screenSize,
      );

  dynamic _decide({
    @required dynamic lessThan6Inches,
    @required dynamic equalTo6Inches,
    @required dynamic equalTo7Inches,
    @required dynamic greaterThan7Inches,
  }) {
    if (this._screenSize < 6) {
      log('Device less than 6 inches');
      return lessThan6Inches;
    }

    if (this._screenSize == 6) {
      //log('Device is 6 inches');
      return equalTo6Inches;
    }

    if (this._screenSize == 7) {
      log('Device is equal to 7 inches ${this._screenSize}');
      return equalTo7Inches;
      // TODO: WHY IS THIS COMMENTED?
      //return equalTo7Inches;
    }

    if (this._screenSize > 7) {
      log('Device greater than 7 inches');
      return greaterThan7Inches;
    }
  }

  static const holeCardViewDisplacementConstant = 60.0;

  static const holeCardViewAngleConstant = 0.05;

  /* center view scales for different widgets */

  Offset get centerViewButtonVerticalTranslate => _decide(
        lessThan6Inches: Offset.zero,
        equalTo6Inches: Offset(0.0, -20.0),
        equalTo7Inches: Offset.zero,
        greaterThan7Inches: Offset.zero,
      ) as Offset;

  Offset get centerViewVerticalTranslate => _decide(
        lessThan6Inches: Offset(0.0, 15.0),
        equalTo6Inches: Offset(0.0, 10.0),
        equalTo7Inches: Offset.zero,
        greaterThan7Inches: Offset.zero,
      ) as Offset;

  double get centerPotScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.20,
        greaterThan7Inches: 2.0,
      ) as double;

  double get centerPotUpdatesScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.0,
        greaterThan7Inches: 2.0,
      ) as double;

  double get centerRankStrScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.10,
        greaterThan7Inches: 1.15,
      ) as double;

  double get centerViewCenterScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.10,
        greaterThan7Inches: 1.30,
      ) as double;

  double get communityCardSizeScales => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.05,
        greaterThan7Inches: 1.75,
      ) as double;

  double get centerGap => _decide(
        lessThan6Inches: 0.0,
        equalTo6Inches: 0.0,
        equalTo7Inches: 10.0,
        greaterThan7Inches: 25.0,
      ) as double;

  /* table center view offsets, scaling and sizes */
  Offset get centerOffset => _decide(
        lessThan6Inches: Offset(10, 40),
        equalTo6Inches: Offset(15, 60),
        equalTo7Inches: Offset(15, 85),
        greaterThan7Inches: Offset(10, 40),
      ) as Offset;

  double get tableScale => _decide(
        lessThan6Inches: 1.0,
        equalTo6Inches: 1.0,
        equalTo7Inches: 0.90,
        greaterThan7Inches: 0.85,
      ) as double;

  Size get centerSize => this._centerSize;

  /* hole card view offsets */
  Offset get holeCardViewOffset => _decide(
        lessThan6Inches: const Offset(0, 50),
        equalTo6Inches: const Offset(0, 60),
        equalTo7Inches: const Offset(0, 90),
        greaterThan7Inches: const Offset(0, 130),
      ) as Offset;

  /* hold card view scales */
  double get holeCardViewScale => _decide(
        lessThan6Inches: 1.4,
        equalTo6Inches: 1.4,
        equalTo7Inches: 1.5,
        greaterThan7Inches: 1.6,
      ) as double;

  double get footerActionViewScale => _decide(
        lessThan6Inches: 1.0,
        equalTo6Inches: 1.05,
        equalTo7Inches: 1.2,
        greaterThan7Inches: 1.3,
      ) as double;

  /* players configurations */
  double get playerViewScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.4,
        greaterThan7Inches: 2.0,
      ) as double;

  /* player hole card configurations */
  Offset get playerHoleCardOffset => _decide(
        lessThan6Inches: Offset.zero,
        equalTo6Inches: Offset.zero,
        equalTo7Inches: Offset(10.0, -10.0),
        greaterThan7Inches: Offset(10.0, -10.0),
      ) as Offset;

  double get playerHoleCardScale => _decide(
        lessThan6Inches: 1.0,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.5,
        greaterThan7Inches: 1.5,
      ) as double;

  double get tableDividerHeightScale => _decide(
        lessThan6Inches: 0.40,
        equalTo6Inches: 0.40,
        equalTo7Inches: 0.70,
        greaterThan7Inches: 0.60,
      ) as double;

  int get screenSize => this._screenSize;
  Uint8List get betImage => this._betImage;
  set betImage(Uint8List betImage) => this._betImage = betImage;
}
