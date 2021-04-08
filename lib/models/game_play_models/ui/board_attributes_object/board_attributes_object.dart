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

/* TODO; PUT THIS IN A DIFFERENT FILE */
class CommunityCardAttribute {
  static Map<int, Offset> cardOffsets = Map();

  static bool hasEntry(int idx) => cardOffsets.containsKey(idx);

  static addEntry(
    int idx,
    GlobalKey key,
  ) {
    if (key.currentContext == null) return;

    final RenderBox renderBox = key.currentContext.findRenderObject();
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    cardOffsets[idx] = offset;
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

class BoardAttributesObject extends ChangeNotifier {
  BoardOrientation _boardOrientation;
  Size _boardSize;
  Size _tableSize;

  // center attributes
  Offset _centerOffset;
  Size _centerSize;

  Size _namePlateSize;

  GlobalKey _centerKey;
  GlobalKey _centerPotBetKey;
  GlobalKey _dummyViewKey;
  List<PotAttribute> _pots;

  // player view attributes
  Offset _playersOnTableOffset;

  BoardAttributesObject({
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) {
    this._boardOrientation = orientation;
    this._namePlateSize = Size(70, 55);
    this._pots = [];

    _playersOnTableOffset = Offset(0.0, -25.0);
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
  set centerKey(Key key) => this._centerKey = key;

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
}
