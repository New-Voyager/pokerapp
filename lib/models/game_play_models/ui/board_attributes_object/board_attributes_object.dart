/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_mappings.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:tuple/tuple.dart';

import 'android.dart';
import 'iphone.dart';

enum BoardOrientation {
  horizontal,
  vertical,
}

enum ScreenSize {
  lessThan6Inches,
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
    if (key.currentContext == null) return;

    final RenderBox renderBox = key.currentContext.findRenderObject();
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    cardOffsets[idx] = offset;
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

enum BetTextPos {
  Right,
  Left,
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

class BoardAttributesJson {
  Map<String, dynamic> attribs;
  void init(double screenSize) {
    if (Platform.isAndroid) {
      if (screenSize >= 5.3 && screenSize <= 5.5) {
        attribs = AndroidAttribs.getPixelXl();
      } else {
        attribs = AndroidAttribs.get6Inch();
      }
    } else {
      // iphone
      // attribs = IPhoneAttribs.getIPhoneXS();
      attribs = IPhoneAttribs.getAttribs(DeviceInfo.name, screenSize);
    }
  }

  double get size => attribs["size"];
  Size get namePlateSize {
    if (attribs["board"]["namePlate"] != null) {
      dynamic namePlate = attribs["board"]["namePlate"];
      return Size(
        double.parse(namePlate["width"].toString()),
        double.parse(namePlate["height"].toString()),
      );
    }
    return Size(70, 55);
  }

  Offset parseOffset(dynamic val) {
    List<double> vals = val
        .toString()
        .split(',')
        .map((e) => double.parse(e.toString()))
        .toList();
    return Offset(vals[0], vals[1]);
  }

  Offset get playerTableOffset {
    if (attribs["board"]["playersTableOffset"] != null) {
      dynamic offset = attribs["board"]["playersTableOffset"];
      return parseOffset(offset);
    }
    return Offset(0.0, -25.0);
  }

  SeatPos getSeatPosEnum(String posStr) {
    Map<String, SeatPos> pos = {
      "bottomCenter": SeatPos.bottomCenter,
      "bottomLeft": SeatPos.bottomLeft,
      "bottomRight": SeatPos.bottomRight,
      "middleLeft": SeatPos.middleLeft,
      "middleRight": SeatPos.middleRight,
      "topCenter": SeatPos.topCenter,
      "topCenter1": SeatPos.topCenter1,
      "topCenter2": SeatPos.topCenter2,
      "topLeft": SeatPos.topLeft,
      "topRight": SeatPos.topRight,
    };
    return pos[posStr];
  }

  Map<SeatPos, Offset> buttonPos() {
    Map<SeatPos, Offset> ret = Map<SeatPos, Offset>();
    if (attribs["board"]["buttonPos"] != null) {
      final map = attribs["board"]["buttonPos"] as Map<String, dynamic>;
      for (final pos in map.keys) {
        final val = parseOffset(map[pos]);
        ret[getSeatPosEnum(pos)] = val;
      }
    }
    return ret;
  }

  Map<SeatPos, Offset> betAmountPos() {
    Map<SeatPos, Offset> ret = Map<SeatPos, Offset>();
    Size namePlateSize = this.namePlateSize;
    if (attribs["board"]["betAmountFac"] != null) {
      final map = attribs["board"]["betAmountFac"] as Map<String, dynamic>;
      for (final pos in map.keys) {
        final val = parseOffset(map[pos]);
        ret[getSeatPosEnum(pos)] =
            Offset(val.dx * namePlateSize.width, val.dy * namePlateSize.height);
      }
    }
    return ret;
  }

  Map<SeatPos, Offset> foldCardPos() {
    Map<SeatPos, Offset> ret = Map<SeatPos, Offset>();
    if (attribs["board"]["foldStopPos"] != null) {
      final map = attribs["board"]["foldStopPos"] as Map<String, dynamic>;
      for (final pos in map.keys) {
        final val = parseOffset(map[pos]);
        ret[getSeatPosEnum(pos)] = val;
      }
    }
    return ret;
  }

  Map<SeatPos, SeatPosAttribs> getSeatMap() {
    Map<SeatPos, SeatPosAttribs> ret = Map<SeatPos, SeatPosAttribs>();
    if (attribs["board"]["seatMap"] != null) {
      final map = attribs["board"]["seatMap"] as Map<String, dynamic>;
      for (final pos in map.keys) {
        final val = map[pos];
        if (pos == 'bottomCenter') {
          ret[SeatPos.bottomCenter] = SeatPosAttribs(
              Alignment.bottomCenter, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'bottomLeft') {
          ret[SeatPos.bottomLeft] = SeatPosAttribs(
              Alignment.bottomLeft, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'bottomRight') {
          ret[SeatPos.bottomRight] = SeatPosAttribs(
              Alignment.bottomRight, parseOffset(val), Alignment.centerLeft);
        } else if (pos == 'bottomLeft') {
          ret[SeatPos.bottomLeft] = SeatPosAttribs(
              Alignment.bottomLeft, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'middleLeft') {
          ret[SeatPos.middleLeft] = SeatPosAttribs(
              Alignment.centerLeft, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'middleRight') {
          ret[SeatPos.middleRight] = SeatPosAttribs(
              Alignment.centerRight, parseOffset(val), Alignment.centerLeft);
        } else if (pos == 'topLeft') {
          ret[SeatPos.topLeft] = SeatPosAttribs(
              Alignment.topLeft, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'bottomLeft') {
          ret[SeatPos.bottomLeft] = SeatPosAttribs(
              Alignment.bottomLeft, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'topRight') {
          ret[SeatPos.topRight] = SeatPosAttribs(
              Alignment.topRight, parseOffset(val), Alignment.centerLeft);
        } else if (pos == 'topCenter') {
          ret[SeatPos.topCenter] = SeatPosAttribs(
              Alignment.topCenter, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'topCenter1') {
          ret[SeatPos.topCenter1] = SeatPosAttribs(
              Alignment.topCenter, parseOffset(val), Alignment.centerRight);
        } else if (pos == 'topCenter2') {
          ret[SeatPos.topCenter2] = SeatPosAttribs(
              Alignment.topCenter, parseOffset(val), Alignment.centerLeft);
        }
      }
    }
    return ret;
  }

  double get lottieScale {
    if (attribs["board"]["lottieScale"] != null) {
      return double.parse(attribs["board"]["lottieScale"].toString());
    }
    return 2.0;
  }

  double get betImageScale {
    if (attribs["board"]["betImageScale"] != null) {
      return double.parse(attribs["board"]["betImageScale"].toString());
    }
    return 2.2;
  }

  double get betSliderScale {
    if (attribs["board"]["betSliderScale"] != null) {
      return double.parse(attribs["board"]["betSliderScale"].toString());
    }
    return 2.5;
  }

  Map<String, double> getHoleDisplacement() {
    Map<String, double> ret = Map<String, double>();
    if (attribs["holeCardDisplacement"] != null) {
      final map = attribs["holeCardDisplacement"] as Map<String, dynamic>;
      for (final noCardsStr in map.keys) {
        ret[noCardsStr] = double.parse(map[noCardsStr].toString());
      }
    }
    return ret;
  }

  Map<String, double> getHoleCardScale() {
    Map<String, double> ret = Map<String, double>();
    if (attribs["holeCardScale"] != null) {
      final map = attribs["holeCardScale"] as Map<String, dynamic>;
      for (final noCardsStr in map.keys) {
        ret[noCardsStr] = double.parse(map[noCardsStr].toString());
      }
    }
    return ret;
  }

  Map<String, double> getVisibleHoleDisplacement() {
    Map<String, double> ret = Map<String, double>();
    if (attribs["holeCardDisplacementVisible"] != null) {
      final map =
          attribs["holeCardDisplacementVisible"] as Map<String, dynamic>;
      for (final noCardsStr in map.keys) {
        ret[noCardsStr] = double.parse(map[noCardsStr].toString());
      }
    }
    return ret;
  }

  Offset get cardShufflePos {
    if (attribs['board']['cardShufflePos'] != null) {
      return parseOffset(attribs['board']['cardShufflePos']);
    }
    return Offset.zero;
  }

  Offset get centerButtonsPos {
    if (attribs['board']['centerButtonsPos'] != null) {
      return parseOffset(attribs['board']['centerButtonsPos']);
    }
    return Offset.zero;
  }

  Offset get centerViewPos {
    if (attribs['board']['centerViewPos'] != null) {
      return parseOffset(attribs['board']['centerViewPos']);
    }
    return Offset.zero;
  }

  double get footerViewScale {
    if (attribs["footerViewHeightScale"] != null) {
      return double.parse(attribs["footerViewHeightScale"].toString());
    }
    return 0.45;
  }

  double get centerPotScale {
    if (attribs["board"]["centerPotScale"] != null) {
      return double.parse(attribs["board"]["centerPotScale"].toString());
    }
    return 1.0;
  }

  double get centerPotUpdatesScale {
    double ret = 1.0;
    if (attribs["board"]["centerPotUpdatesScale"] != null) {
      ret = double.parse(attribs["board"]["centerPotUpdatesScale"].toString());
    }
    return ret;
  }

  double get centerRankStrScale {
    if (attribs["board"]["centerRankStrScale"] != null) {
      return double.parse(attribs["board"]["centerRankStrScale"].toString());
    }
    return 1.0;
  }

  double get centerViewCenterScale {
    if (attribs["board"]["centerViewScale"] != null) {
      return double.parse(attribs["board"]["centerViewScale"].toString());
    }
    return 0.85;
  }

  double get doubleBoardScale {
    if (attribs["board"]["doubleBoardScale"] != null) {
      return double.parse(attribs["board"]["doubleBoardScale"].toString());
    }
    return 0.90;
  }

  double get boardScale {
    if (attribs["boardScale"] != null) {
      return double.parse(attribs["boardScale"].toString());
    }
    return 1.0;
  }

  double get centerGap {
    if (attribs["board"]["centerGap"] != null) {
      return double.parse(attribs["board"]["centerGap"].toString());
    }
    return 0.0;
  }

  double get potViewGap {
    if (attribs["board"]["potViewGap"] != null) {
      return double.parse(attribs["board"]["potViewGap"].toString());
    }
    return 0.0;
  }

  Offset get centerOffet {
    if (attribs['board']['centerOffset'] != null) {
      return parseOffset(attribs['board']['centerOffset']);
    }
    return Offset.zero;
  }

  double get tableScale {
    if (attribs['board']['tableScale'] != null) {
      return double.parse(attribs['board']['tableScale'].toString());
    }
    return 1.0;
  }

  double get tableBottomPos {
    if (attribs['board']['tableBottomPos'] != null) {
      return double.parse(attribs['board']['tableBottomPos'].toString());
    }
    return -40;
  }

  Offset get holeCardOffset {
    if (attribs['holeCardOffset'] != null) {
      return parseOffset(attribs['holeCardOffset']);
    }
    return Offset.zero;
  }

  Offset get holeCardViewOffset {
    if (attribs['holeCardViewOffset'] != null) {
      return parseOffset(attribs['holeCardViewOffset']);
    }
    return Offset.zero;
  }

  double get holeCardViewScale {
    if (attribs["holeCardViewScale"] != null) {
      return double.parse(attribs["holeCardViewScale"].toString());
    }
    return 1.0;
  }

  double get footerActionScale {
    if (attribs["footerActionScale"] != null) {
      return double.parse(attribs["footerActionScale"].toString());
    }
    return 1.0;
  }

  double get playerViewScale {
    if (attribs["seat"]["scale"] != null) {
      return double.parse(attribs["seat"]["scale"].toString());
    }
    return 1.0;
  }

  Offset get playerHoleCardOffset {
    if (attribs['seat']['holeCardOffset'] != null) {
      return parseOffset(attribs['seat']['holeCardOffset']);
    }
    return Offset.zero;
  }

  double get playerHoleCardScale {
    if (attribs["seat"]["holeCardScale"] != null) {
      return double.parse(attribs["seat"]["holeCardScale"].toString());
    }
    return 1.0;
  }
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
  Map<SeatPos, Offset> _buttonPos;
  Map<SeatPos, Offset> _foldCardPos;
  Map<SeatPos, Offset> _betAmountPos;

  // footer attribs
  Map<String, double> _holeCardDisplacement;
  Map<String, double> _holeCardVisibleDisplacement;
  Map<String, double> _holeCardScale;

  // bet image
  Uint8List _betImage;

  // center pot view key
  GlobalKey _potKey;
  Offset potGlobalPos;
  BoardAttributesJson attribsObj;

  BoardAttributesObject({
    /*
    * This screen size is diagonal inches*/
    @required double screenSize,
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) {
    //this._screenSize = screenSize.round();
    this._screenDiagnolSize = Screen.screenSize;
    log('original screen size: $screenSize, rounded screen size: ${Screen.screenSizeInches}');
    attribsObj = BoardAttributesJson();
    attribsObj.init(Screen.screenSizeInches);

    this._boardOrientation = orientation;
    this._namePlateSize = attribsObj.namePlateSize; //Size(70, 55);

    _playersOnTableOffset = attribsObj.playerTableOffset; // Offset(0.0, -25.0);
    this._seatPosAttribs = attribsObj.getSeatMap();
    this._buttonPos = attribsObj.buttonPos();
    this._foldCardPos = attribsObj.foldCardPos();
    this._betAmountPos = attribsObj.betAmountPos();

    this._holeCardDisplacement = attribsObj.getHoleDisplacement();
    this._holeCardVisibleDisplacement = attribsObj.getVisibleHoleDisplacement();
    this._holeCardScale = attribsObj.getHoleCardScale();

    if (Screen.diagonalInches <= 6) {
      this._screenSize = ScreenSize.lessThan6Inches;
    } else if (this._screenDiagnolSize <= 7) {
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
    return this._buttonPos;
  }

  Map<SeatPos, Offset> foldCardPos() {
    return this._foldCardPos;
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
    return attribsObj.lottieScale;
  }

  double get betImageScale {
    return attribsObj.betImageScale;
  }

  double get betSliderScale {
    return attribsObj.betImageScale;
  }

  Size get namePlateSize {
    return this.attribsObj.namePlateSize;
  }

  Offset get playerOnTableOffset {
    return this.attribsObj.playerTableOffset;
  }

  void setFooterDimensions(Offset offset, Size size) {
    this._footerOffset = offset;
    this._footerSize = size;
  }

  SeatPosAttribs getSeatPosAttrib(SeatPos pos) {
    return this._seatPosAttribs[pos];
  }

  Map<SeatPos, Offset> get betAmountPosition {
    return this._betAmountPos;
  }

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

  // n -> no of cards
  double getHoleCardDisplacement({
    @required int noOfCards,
    @required bool isCardVisible,
  }) {
    double ret = 20.0;
    if (isCardVisible) {
      ret = _holeCardVisibleDisplacement[noOfCards.toString()];
    } else {
      ret = _holeCardDisplacement[noOfCards.toString()];
    }
    return ret;
  }

  /* center view scales for different widgets */
  Offset get centerViewCardShufflePosition {
    return attribsObj.cardShufflePos;
  }

  Offset get centerButtonsPos {
    return attribsObj.centerButtonsPos;
  }

  Offset get centerViewPos {
    return attribsObj.centerViewPos;
  }

  double get footerViewScale {
    return attribsObj.footerViewScale;
  }

  double get centerPotScale {
    return attribsObj.centerPotScale;
  }

  double get centerPotUpdatesScale {
    return attribsObj.centerPotUpdatesScale;
  }

  double get centerRankStrScale {
    return attribsObj.centerRankStrScale;
  }

  double get centerViewCenterScale {
    return attribsObj.centerViewCenterScale;
  }

  double get holeCardSizeRatio {
    return _holeCardScale[_noOfCards.toString()] * 4.0;
  }

  double get doubleBoardScale {
    return attribsObj.doubleBoardScale;
  }

  double get boardScale {
    return attribsObj.boardScale;
  }

  double get centerGap {
    return attribsObj.centerGap;
  }

  double get potViewGap {
    return attribsObj.potViewGap;
  }

  Offset get centerOffset {
    return attribsObj.centerOffet;
  }

  double get tableScale {
    return attribsObj.tableScale;
  }

  double get tableBottomPos {
    return attribsObj.tableBottomPos;
  }

  Size get centerSize {
    return this._centerSize;
  }

  Offset get holeCardOffset {
    return attribsObj.holeCardOffset;
  }

  Offset get holeCardViewOffset {
    return attribsObj.holeCardViewOffset;
  }

  double get holeCardViewScale {
    return attribsObj.holeCardViewScale;
  }

  double get footerActionScale {
    return attribsObj.footerActionScale;
  }

  double get playerViewScale {
    return attribsObj.playerViewScale;
  }

  Offset get playerHoleCardOffset {
    return attribsObj.playerHoleCardOffset;
  }

  double get playerHoleCardScale {
    return attribsObj.playerHoleCardScale;
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
Map<SeatPos, BetTextPos> betTextPos = {
    SeatPos.bottomCenter: BetTextPos.Right,
    SeatPos.bottomLeft: BetTextPos.Right,
    SeatPos.middleLeft: BetTextPos.Left,
    SeatPos.topLeft: BetTextPos.Left,
    SeatPos.topCenter: BetTextPos.Left,
    SeatPos.topCenter1: BetTextPos.Left,
    SeatPos.topCenter2: BetTextPos.Right,
    SeatPos.topRight: BetTextPos.Right,
    SeatPos.middleRight: BetTextPos.Right,
    SeatPos.bottomRight: BetTextPos.Right,
  };

BetTextPos getBetTextPos(SeatPos pos) {
  return betTextPos[pos] ?? BetTextPos.Right;
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
        Offset(-55, 15),
        Alignment.centerRight,
      ),
      SeatPos.topCenter2: SeatPosAttribs(
        Alignment.topCenter,
        Offset(100, 15),
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

  if (deviceSize <= 5) {
    return {
      /* bottom center */
      SeatPos.bottomCenter: SeatPosAttribs(
        Alignment.bottomCenter,
        Offset(0, 80),
        Alignment.centerRight,
      ),
      /* bottom left and bottom right  */
      SeatPos.bottomLeft: SeatPosAttribs(
        Alignment.bottomLeft,
        Offset(15, 60),
        Alignment.centerRight,
      ),
      SeatPos.bottomRight: SeatPosAttribs(
        Alignment.bottomRight,
        Offset(-15, 60),
        Alignment.centerLeft,
      ),
      /* middle left and middle right */
      SeatPos.middleLeft: SeatPosAttribs(
        Alignment.centerLeft,
        Offset(2, 65),
        Alignment.centerRight,
      ),
      SeatPos.middleRight: SeatPosAttribs(
        Alignment.centerRight,
        Offset(2, 65),
        Alignment.centerLeft,
      ),

      /* top left and top right  */
      SeatPos.topLeft: SeatPosAttribs(
        Alignment.topLeft,
        Offset(2, 75),
        Alignment.centerRight,
      ),
      SeatPos.topRight: SeatPosAttribs(
        Alignment.topRight,
        Offset(2, 75),
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
        Offset(-50, 60),
        Alignment.centerRight,
      ),
      SeatPos.topCenter2: SeatPosAttribs(
        Alignment.topCenter,
        Offset(55, 60),
        Alignment.centerLeft,
      ),
    };
  }

  /* device configurations smaller than 7 inch configurations */
  return {
    /* bottom center */
    SeatPos.bottomCenter: SeatPosAttribs(
      Alignment.bottomCenter,
      Offset(0, 60),
      Alignment.centerRight,
    ),
    /* bottom left and bottom right  */
    SeatPos.bottomLeft: SeatPosAttribs(
      Alignment.bottomLeft,
      Offset(15, 50),
      Alignment.centerRight,
    ),
    SeatPos.bottomRight: SeatPosAttribs(
      Alignment.bottomRight,
      Offset(-15, 50),
      Alignment.centerLeft,
    ),
    /* middle left and middle right */
    SeatPos.middleLeft: SeatPosAttribs(
      Alignment.centerLeft,
      Offset(2, 65),
      Alignment.centerRight,
    ),
    SeatPos.middleRight: SeatPosAttribs(
      Alignment.centerRight,
      Offset(2, 65),
      Alignment.centerLeft,
    ),

    /* top left and top right  */
    SeatPos.topLeft: SeatPosAttribs(
      Alignment.topLeft,
      Offset(2, 100),
      Alignment.centerRight,
    ),
    SeatPos.topRight: SeatPosAttribs(
      Alignment.topRight,
      Offset(2, 100),
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
      Offset(-50, 60),
      Alignment.centerRight,
    ),
    SeatPos.topCenter2: SeatPosAttribs(
      Alignment.topCenter,
      Offset(55, 60),
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
        -namePlateSize.height * 1.0,
      ),
      SeatPos.bottomLeft: Offset(
        namePlateSize.width * 0.70,
        -namePlateSize.height * 0.80,
      ),
      SeatPos.bottomRight: Offset(
        -namePlateSize.width * 0.60,
        -namePlateSize.height * 0.80,
      ),

      /* middle left and middle right */
      SeatPos.middleLeft: Offset(
        -namePlateSize.width * 0.10,
        namePlateSize.height * 0.75,
      ),
      SeatPos.middleRight: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.75,
      ),

      /* top left and top right */
      SeatPos.topLeft: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),
      SeatPos.topRight: Offset(
        -namePlateSize.width * 0.20,
        namePlateSize.height * 0.65,
      ),

      /* center, center left and center right */
      SeatPos.topCenter: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.70,
      ),
      SeatPos.topCenter1: Offset(
        namePlateSize.width * 0.20,
        namePlateSize.height * 0.8,
      ),
      SeatPos.topCenter2: Offset(
        namePlateSize.width * -0.20,
        namePlateSize.height * 0.8,
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
