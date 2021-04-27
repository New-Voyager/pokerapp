/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

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

/**
 * This UI attribute is used for positioning the seat within PlayerOnTableView.
 */
class SeatPosAttribs {
  final Alignment alignment;
  final Offset topLeft;
  final Alignment holeCardPos;

  SeatPosAttribs(this.alignment, this.topLeft, this.holeCardPos);
}

Map<SeatPos, SeatPosAttribs> getSeatMap(int deviceSize) {
  if (deviceSize == 7) {
    return {
      SeatPos.bottomCenter: SeatPosAttribs(
          Alignment.bottomCenter, Offset(0, -10), Alignment.centerRight),
      SeatPos.bottomLeft: SeatPosAttribs(
          Alignment.bottomLeft, Offset(30, -20), Alignment.centerRight),
      SeatPos.middleLeft: SeatPosAttribs(
          Alignment.centerLeft, Offset(30, 0), Alignment.centerRight),
      SeatPos.topLeft: SeatPosAttribs(
          Alignment.topLeft, Offset(40, 30), Alignment.centerRight),
      SeatPos.topCenter1: SeatPosAttribs(
          Alignment.topLeft, Offset(200, 20), Alignment.centerRight),
      SeatPos.topCenter2: SeatPosAttribs(
          Alignment.topLeft, Offset(320, 20), Alignment.centerLeft),
      SeatPos.topRight: SeatPosAttribs(
          Alignment.topRight, Offset(-30, 30), Alignment.centerLeft),
      SeatPos.middleRight: SeatPosAttribs(
          Alignment.centerRight, Offset(-20, 0), Alignment.centerLeft),
      SeatPos.bottomRight: SeatPosAttribs(
          Alignment.bottomRight, Offset(-30, -20), Alignment.centerLeft),
    };
  }

  if (deviceSize == 10) {
    return {
      SeatPos.bottomCenter: SeatPosAttribs(
          Alignment.bottomCenter, Offset(0, -20), Alignment.centerRight),
      SeatPos.bottomLeft: SeatPosAttribs(
          Alignment.bottomLeft, Offset(60, -40), Alignment.centerRight),
      SeatPos.middleLeft: SeatPosAttribs(
          Alignment.centerLeft, Offset(0, 0), Alignment.centerRight),
      SeatPos.topLeft: SeatPosAttribs(
          Alignment.topLeft, Offset(60, 40), Alignment.centerRight),
      SeatPos.topCenter1: SeatPosAttribs(
          Alignment.topLeft, Offset(280, 0), Alignment.centerRight),
      SeatPos.topCenter2: SeatPosAttribs(
          Alignment.topLeft, Offset(460, 0), Alignment.centerLeft),
      SeatPos.topRight: SeatPosAttribs(
          Alignment.topRight, Offset(-80, 40), Alignment.centerLeft),
      SeatPos.middleRight: SeatPosAttribs(
          Alignment.centerRight, Offset(0, 0), Alignment.centerLeft),
      SeatPos.bottomRight: SeatPosAttribs(
          Alignment.bottomRight, Offset(-40, -40), Alignment.centerLeft),
    };
  }

  return {
    SeatPos.bottomCenter: SeatPosAttribs(
        Alignment.bottomCenter, Offset(0, -10), Alignment.centerRight),
    SeatPos.bottomLeft: SeatPosAttribs(
        Alignment.bottomLeft, Offset(30, -20), Alignment.centerRight),
    SeatPos.middleLeft: SeatPosAttribs(
        Alignment.centerLeft, Offset(10, 0), Alignment.centerRight),
    SeatPos.topLeft: SeatPosAttribs(
        Alignment.topLeft, Offset(20, 20), Alignment.centerRight),
    SeatPos.topCenter1: SeatPosAttribs(
        Alignment.topLeft, Offset(130, 20), Alignment.centerRight),
    SeatPos.topCenter2: SeatPosAttribs(
        Alignment.topLeft, Offset(220, 20), Alignment.centerLeft),
    SeatPos.topRight: SeatPosAttribs(
        Alignment.topRight, Offset(-10, 20), Alignment.centerLeft),
    SeatPos.middleRight: SeatPosAttribs(
        Alignment.centerRight, Offset(0, 0), Alignment.centerLeft),
    SeatPos.bottomRight: SeatPosAttribs(
        Alignment.bottomRight, Offset(-20, -20), Alignment.centerLeft),
  };
}

class BoardAttributesObject extends ChangeNotifier {
  BoardOrientation _boardOrientation;
  Size _boardSize;
  Size _tableSize;

  // center attributes
  Offset _centerOffset;
  Size _centerSize;

  Size _namePlateSize;

  GlobalKey _centerKey;
  GlobalKey _emptyCenterKey;
  GlobalKey _centerPotBetKey;
  GlobalKey _dummyViewKey;
  List<PotAttribute> _pots;

  // player view attributes
  Offset _playersOnTableOffset;

  // footer view dimensions
  Size _footerSize;
  Offset _footerOffset;
  double _screenSize;

  // seat attrib map
  Map<SeatPos, SeatPosAttribs> _seatPosAttribs;

  BoardAttributesObject({
    @required double screenSize,
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) {
    this._screenSize = screenSize;
    this._boardOrientation = orientation;
    this._namePlateSize = Size(70, 55);
    this._pots = [];

    _playersOnTableOffset = Offset(0.0, -25.0);

    int screenSizeInt = screenSize.toInt();
    this._seatPosAttribs = getSeatMap(screenSizeInt);
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
    this._centerOffset = Offset(10, 50);
    this._centerSize = Size(widthOfBoard - 30, this._tableSize.height - 70);

    return this._boardSize;
  }

  get tableSize => this._tableSize;
  get centerOffset => this._centerOffset;
  get centerSize => this._centerSize;
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

  GlobalKey get centerPotBetKey => this._centerPotBetKey;
  set centerPotBetKey(GlobalKey key) => this._centerPotBetKey = key;

  Offset get playerOnTableOffset => this._playersOnTableOffset;
  set playerOnTableOffset(Offset offset) => this._playersOnTableOffset = offset;

  void setFooterDimensions(Offset offset, Size size) {
    this._footerOffset = offset;
    this._footerSize = size;
  }

  Size get footerSize => this._footerSize;
  Screen getScreen(BuildContext c) {
    return Screen(c);
  }

  SeatPosAttribs getSeatPosAttrib(SeatPos pos) {
    return this._seatPosAttribs[pos];
  }
}
