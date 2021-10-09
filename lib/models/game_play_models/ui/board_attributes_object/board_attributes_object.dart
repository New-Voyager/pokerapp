/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_mappings.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:tuple/tuple.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

enum BoardOrientation {
  horizontal,
  vertical,
}

enum ScreenSize {
  lessThan7Inches,
  equalTo7Inches,
  greaterThan7Inches,
}

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
  GlobalKey _key;
  Offset _potViewPos;
  Offset _betWidgetPos;
  GlobalKey _betWidgetUiKey;
  Size _size;

  // this offset is used for fun animation and seat change animation
  // this offset is postion of the seat on the PlayerOnTableView widget
  Offset _parentRelativePos;

  SeatPosAttribs(
    this.alignment,
    this.topLeft,
    this.holeCardPos,
  );

  GlobalKey get key {
    if (_key == null) {
      _key = GlobalKey();
    }
    return _key;
  }

  void resetKey() {
    _key = null;
  }

  Offset get parentRelativePos => _parentRelativePos;
  set parentRelativePos(Offset pos) => _parentRelativePos = pos;

  Offset get potPos => _potViewPos;
  set potPos(Offset pos) => _potViewPos = pos;

  Offset get betWidgetPos => _betWidgetPos;
  set betWidgetPos(Offset pos) => _betWidgetPos = pos;

  GlobalKey get betWidgetUiKey => _betWidgetUiKey;
  set betWidgetUiKey(GlobalKey key) => _betWidgetUiKey = key;

  Size get size => _size;
  set size(Size size) => _size = size;
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
      Offset(0, 10),
      Alignment.centerRight,
    ),

    /* bottom left and bottom right  */
    SeatPos.bottomLeft: SeatPosAttribs(
      Alignment.bottomLeft,
      Offset(10, 0),
      Alignment.centerRight,
    ),
    SeatPos.bottomRight: SeatPosAttribs(
      Alignment.bottomRight,
      Offset(-10, 0),
      Alignment.centerLeft,
    ),

    /* middle left and middle right */
    SeatPos.middleLeft: SeatPosAttribs(
      Alignment.centerLeft,
      Offset(3, 25),
      Alignment.centerRight,
    ),
    SeatPos.middleRight: SeatPosAttribs(
      Alignment.centerRight,
      Offset(-3, 40),
      Alignment.centerLeft,
    ),

    /* top left and top right  */
    SeatPos.topLeft: SeatPosAttribs(
      Alignment.topLeft,
      Offset(3, 65),
      Alignment.centerRight,
    ),
    SeatPos.topRight: SeatPosAttribs(
      Alignment.topRight,
      Offset(-3, 75),
      Alignment.centerLeft,
    ),

    /* center, center right & center left */
    SeatPos.topCenter: SeatPosAttribs(
      Alignment.topCenter,
      Offset(0, 0),
      Alignment.centerRight,
    ),
    SeatPos.topCenter1: SeatPosAttribs(
      Alignment.topCenter,
      Offset(-35, 0),
      Alignment.centerRight,
    ),
    SeatPos.topCenter2: SeatPosAttribs(
      Alignment.topCenter,
      Offset(80, 0),
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
        -20,
        -namePlateSize.height * 0.90,
      ),
      SeatPos.bottomLeft: Offset(
        namePlateSize.width * 0.60,
        -namePlateSize.height * 0.80,
      ),
      SeatPos.bottomRight: Offset(
        -namePlateSize.width * 0.90,
        -namePlateSize.height * 0.80,
      ),

      /* middle left and middle right */
      SeatPos.middleLeft: Offset(
        namePlateSize.width * 0.10,
        namePlateSize.height * 0.70,
      ),
      SeatPos.middleRight: Offset(
        -namePlateSize.width,
        -namePlateSize.height * 0.20,
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
        namePlateSize.height * 0.70,
      ),
      SeatPos.topCenter1: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),
      SeatPos.topCenter2: Offset(
        namePlateSize.width * -0.30,
        namePlateSize.height * 0.70,
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

  int _noOfCards = 2; // default no of cards be 2
  set noOfCards(int n) => _noOfCards = n;

  // center attributes
  // TODO HOW IS THIS CENTER SIZE RELEVANT
  Size _centerSize;

  Size _namePlateSize;

  // player view attributes
  Offset _playersOnTableOffset;

  // footer view dimensions
  Size _footerSize;
  Offset _footerOffset;
  int _screenDiagnolSize;
  ScreenSize _screenSize;

  // seat attrib map
  Map<SeatPos, SeatPosAttribs> _seatPosAttribs;

  // bet image
  Uint8List _betImage;

  // center pot view key
  GlobalKey _potKey;
  Offset potGlobalPos;

  BoardAttributesObject({
    /*
    * This screen size is diagonal inches*/
    @required double screenSize,
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) {
    //this._screenSize = screenSize.round();
    this._screenDiagnolSize = Screen.screenSize;
    log('original screen size: $screenSize, rounded screen size: $_screenDiagnolSize');
    this._boardOrientation = orientation;
    this._namePlateSize = Size(70, 55);

    _playersOnTableOffset = Offset(0.0, -25.0);

    this._seatPosAttribs = getSeatMap(this._screenDiagnolSize);
    if (this._screenDiagnolSize <= 7) {
      this._screenSize = ScreenSize.lessThan7Inches;
    } else if (this._screenSize == 7) {
      this._screenSize = ScreenSize.equalTo7Inches;
    } else {
      this._screenSize = ScreenSize.greaterThan7Inches;
    }
  }

  GlobalKey get potKey => _potKey;
  set potKey(GlobalKey key) => _potKey = key;

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

  Map<SeatPos, Offset> buttonPos() {
    if (_boardOrientation == BoardOrientation.horizontal) {
      return {
        SeatPos.topCenter: Offset(25, 40),
        SeatPos.bottomCenter: Offset(30, -40),
        SeatPos.middleLeft: Offset(50, 0),
        SeatPos.middleRight: Offset(-50, 0),
        SeatPos.topRight: Offset(-40, 30),
        SeatPos.topLeft: Offset(40, 30),
        SeatPos.bottomLeft: Offset(25, -40),
        SeatPos.bottomRight: Offset(-20, -40),
        SeatPos.topCenter1: Offset(0, 40),
        SeatPos.topCenter2: Offset(0, 40),
      };
    }

    return throw UnimplementedError();
  }

  Map<SeatPos, Offset> foldCardPos() {
    if (_boardOrientation == BoardOrientation.horizontal) {
      return {
        SeatPos.bottomCenter: Offset(20, -140),
        SeatPos.topCenter: Offset(20, 20),
        SeatPos.middleLeft: Offset(100, -50),
        SeatPos.middleRight: Offset(-70, -50),
        SeatPos.topRight: Offset(-70, 0),
        SeatPos.topLeft: Offset(100, 0),
        SeatPos.bottomLeft: Offset(100, -120),
        SeatPos.bottomRight: Offset(-70, -120),
        SeatPos.topCenter1: Offset(30, 20),
        SeatPos.topCenter2: Offset(-10, 20),
      };
    }

    return throw UnimplementedError();
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

  double get lottieScale {
    if (this._screenSize == ScreenSize.lessThan7Inches) {
      return 1.0;
    } else if (this._screenSize == ScreenSize.equalTo7Inches) {
      return 1.3;
    } else {
      return 2.0;
    }
  }

  double get betImageScale {
    if (this._screenSize == ScreenSize.lessThan7Inches) {
      return 1.5;
    } else if (this._screenSize == ScreenSize.equalTo7Inches) {
      return 2.0;
    } else {
      return 2.2;
    }
  }

  double get betSliderScale {
    if (this._screenSize == ScreenSize.lessThan7Inches) {
      return 1.5;
    } else if (this._screenSize == ScreenSize.equalTo7Inches) {
      return 2.0;
    } else {
      return 2.5;
    }
  }

  double get betWidgetBottomGap {
    if (this._screenSize == ScreenSize.lessThan7Inches) {
      return 1.ph;
    } else if (this._screenSize == ScreenSize.equalTo7Inches) {
      return 20.ph;
    } else {
      return 60.ph;
    }
  }

  double get betWidgetBetChipBottomGap {
    if (this._screenSize == ScreenSize.lessThan7Inches) {
      return 10.ph;
    } else if (this._screenSize == ScreenSize.equalTo7Inches) {
      return 10.ph;
    } else {
      return 20.ph;
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
    return getSeatMap(this._screenDiagnolSize)[pos];
  }

  Map<SeatPos, Offset> get betAmountPosition => getBetAmountPositionMap(
        namePlateSize: this._namePlateSize,
        deviceSize: this._screenDiagnolSize,
      );

  dynamic _decide({
    @required dynamic lessThan6Inches,
    @required dynamic equalTo6Inches,
    @required dynamic equalTo7Inches,
    @required dynamic greaterThan7Inches,
  }) {
    if (this._screenDiagnolSize < 6) {
      //log('Device less than 6 inches');
      return lessThan6Inches;
    }

    if (this._screenDiagnolSize == 6) {
      //log('Device is 6 inches');
      return equalTo6Inches;
    }

    if (this._screenDiagnolSize == 7) {
      ///log('Device is equal to 7 inches ${this._screenSize}');
      return equalTo7Inches;
    }

    if (this._screenDiagnolSize > 7) {
      //log('Device greater than 7 inches');
      return greaterThan7Inches;
    }
  }

  double get holeCardDisplacement {
    return 20.pw;
  }

  /* center view scales for different widgets */

  Offset get centerViewCardShufflePosition => _decide(
        lessThan6Inches: Offset.zero,
        equalTo6Inches: Offset(0.0, -20.0),
        equalTo7Inches: Offset(0.0, -50.0),
        greaterThan7Inches: Offset(0.0, -40.0),
      ) as Offset;

  Offset get centerViewButtonVerticalTranslate => _decide(
        lessThan6Inches: Offset.zero,
        equalTo6Inches: Offset(0.0, -20.0),
        equalTo7Inches: Offset(0.0, -20.0),
        greaterThan7Inches: Offset(0.0, -20.0),
      ) as Offset;

  Offset get centerViewVerticalTranslate => _decide(
        lessThan6Inches: Offset(0.0, 15.0),
        equalTo6Inches: Offset(0.0, 10.0),
        equalTo7Inches: Offset.zero,
        greaterThan7Inches: Offset(0.0, 60.ph),
      ) as Offset;

  double get centerPotScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.20,
        greaterThan7Inches: 1.5,
      ) as double;

  double get centerPotUpdatesScale => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.0,
        greaterThan7Inches: 1.0,
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

  /// Different No of cards, will create different sized hole card
  double get _getScaleBasedOnNoOfCards {
    switch (_noOfCards) {
      case 2:
        return 1.4;

      case 4:
        return 1.2;

      case 5:
        return 1;

      default:
        return 1;
    }
  }

  double get holeCardSizeRatio => _decide(
        lessThan6Inches: _getScaleBasedOnNoOfCards * 4.0,
        equalTo6Inches: _getScaleBasedOnNoOfCards * 4.0,
        equalTo7Inches: _getScaleBasedOnNoOfCards * 4.0,
        greaterThan7Inches: _getScaleBasedOnNoOfCards * 4.0,
      ) as double;

  double get communityCardDoubleBoardScaleFactor => _decide(
        lessThan6Inches: 0.90,
        equalTo6Inches: 0.90,
        equalTo7Inches: 0.90,
        greaterThan7Inches: 0.90,
      ) as double;

  double get communityCardSizeScales => _decide(
        lessThan6Inches: 0.85,
        equalTo6Inches: 1.0,
        equalTo7Inches: 1.05,
        greaterThan7Inches: 1.50,
      ) as double;

  double get centerGap => _decide(
        lessThan6Inches: 0.0,
        equalTo6Inches: 0.0,
        equalTo7Inches: 10.0,
        greaterThan7Inches: 2.ph,
      ) as double;

  double get potsViewGap => _decide(
        lessThan6Inches: 0.0,
        equalTo6Inches: 0.0,
        equalTo7Inches: 10.0,
        greaterThan7Inches: 2.ph,
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
        greaterThan7Inches: 1.8,
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
        greaterThan7Inches: 1.7,
      ) as double;

  /* player hole card configurations */
  Offset get playerHoleCardOffset {
    return _decide(
      lessThan6Inches: Offset.zero,
      equalTo6Inches: Offset.zero,
      equalTo7Inches: Offset(5.pw, -10.ph),
      greaterThan7Inches: Offset(0, -5.ph),
    ) as Offset;
  }

  double get playerHoleCardScale {
    return _decide(
      lessThan6Inches: 1.0,
      equalTo6Inches: 1.0,
      equalTo7Inches: 1.5,
      greaterThan7Inches: 1.0,
    ) as double;
  }

  double get tableDividerHeightScale => _decide(
        lessThan6Inches: 0.40,
        equalTo6Inches: 0.40,
        equalTo7Inches: 0.70,
        greaterThan7Inches: 0.60,
      ) as double;

  int get screenDiagnolSize => this._screenDiagnolSize;
  ScreenSize get screenSize => this._screenSize;

  Uint8List get betImage => this._betImage;
  set betImage(Uint8List betImage) => this._betImage = betImage;

  double get holeCardOffset {
    double holeCardOffset = 5.ph;
    if (_screenSize == ScreenSize.greaterThan7Inches) {
      holeCardOffset = 25.ph;
    }
    return holeCardOffset;
  }
}

Map<int, SeatPos> getSeatLocations(int maxSeats) {
  assert(maxSeats != 1);
  assert(maxSeats != 3);
  assert(maxSeats != 5);
  assert(maxSeats != 7);

  switch (maxSeats) {
    case 9:
      return {
        1: SeatPos.bottomCenter,
        2: SeatPos.bottomLeft,
        3: SeatPos.middleLeft,
        4: SeatPos.topLeft,
        5: SeatPos.topCenter1,
        6: SeatPos.topCenter2,
        7: SeatPos.topRight,
        8: SeatPos.middleRight,
        9: SeatPos.bottomRight
      };
    case 8:
      return {
        1: SeatPos.bottomCenter,
        2: SeatPos.bottomLeft,
        3: SeatPos.middleLeft,
        4: SeatPos.topLeft,
        5: SeatPos.topCenter,
        6: SeatPos.topRight,
        7: SeatPos.middleRight,
        8: SeatPos.bottomRight
      };
    case 6:
      return {
        1: SeatPos.bottomCenter,
        2: SeatPos.middleLeft,
        3: SeatPos.topLeft,
        4: SeatPos.topCenter,
        5: SeatPos.topRight,
        6: SeatPos.middleRight,
      };

    case 4:
      return {
        1: SeatPos.bottomCenter,
        2: SeatPos.middleLeft,
        3: SeatPos.topCenter,
        4: SeatPos.middleRight,
      };

    case 2:
      return {
        1: SeatPos.bottomCenter,
        2: SeatPos.topCenter,
      };

    default:
      return {};
  }
}
