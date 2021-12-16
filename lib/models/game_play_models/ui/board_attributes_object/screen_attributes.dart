import 'dart:convert';
import 'dart:ui';

import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/screen_attribute_object.dart';

class ScreenAttributes {
  static List<ScreenAttributeObject> allAttribs = [];

  static void buildList() {
    String j = '''
      [
        {
          "name": "iPhone 8",
          "model": "iPhone 8",
          "screenSize": "375.0, 667.0",
          "size": 5.1,
          "board": {
            "playersTableOffset": "0.0, -25.0",
            "namePlate": {
              "width": 70,
              "height": 55
            },
            "buttonPos": {
              "topCenter": "50, 0",
              "bottomCenter": "50, 0",
              "middleLeft": "50, 0",
              "middleRight": "-50, 0",
              "topRight": "-50, 0",
              "topLeft": "50, 0", 
              "bottomLeft": "50, 0",
              "bottomRight": "-50, 0",
              "topCenter1": "50, 0",
              "topCenter2": "-50, 0"
            },
            "foldStopPos": {
              "topCenter": "20, 20",
              "middleLeft": "100, -50",
              "middleRight": "-70, -50",
              "topRight": "-70, 20",
              "topLeft": "100, 20",
              "bottomCenter": "20, -180",
              "bottomLeft": "100, -70",
              "bottomRight": "-70, -90",
              "topCenter1": "30, 20",
              "topCenter2": "-10, 20"
            },
            "boardSize": {
              "width": 0.78,
              "height": 2.0
            },
            "tableSizeInc": {
              "dx": 50,
              "dy": -70
            },
            "centerSizeInc": {
              "dx": -30,
              "dy": -70
            },
            "lottieScale": 1.0,
            "betImageScale": 2.0,
            "betSliderScale": 2.0,
            "betAmountFac": {
              "bottomCenter": "0, -1.0",
              "topCenter": "0.20, 0.70",
              "middleLeft": "0.30, 0.75",
              "middleRight": "-0.30, 0.75",
              "topRight": "-0.30, 0.70",
              "topLeft": "0.30, 0.65",
              "bottomLeft": "0.70, -0.80",
              "bottomRight": "-0.60, -0.80",
              "topCenter1": "-0.10, 0.80",
              "topCenter2": "-0.10, 0.80"
            },
            "cardShufflePos": "0, -30",
            "centerButtonsPos": "0, -40",
            "centerViewPos": "0, -30",
            "centerPotScale": 0.80,
            "centerPotUpdatesScale": 0.70,
            "centerRankScale": 0.85,
            "centerViewScale": 0.85,
            "doubleBoardScale": 0.90,
            "boardScale": 1.0,
            "centerDoubleBoardScale": 0.90,
            "centerBoardScale": 1.4,
            "centerGap": 0.0,
            "potViewGap": 0,
            "centerOffset": "15, 110",
            "tableBottomPos": 35,
            "tableScale": 1.2,
            "headerTopPos": -30,
            "boardHeightAdjust": -40,
            "bottomHeightAdjust": -130,
            "headerTopPos": -10,
            "backDropOffset": "0, -50",
            "seatMap": {
              "bottomCenter": "0, 30",
              "bottomLeft": "15, 15",
              "bottomRight": "-15, 15",
              "middleLeft": "0, 35",
              "middleRight": "0, 35",
              "topLeft": "2, 70",
              "topRight": "2, 70",
              "topCenter": "0, 45",
              "topCenter1": "-45, 45",
              "topCenter2": "48, 45"
            }
          },
          "holeCardDisplacement": {
            "2": 35,
            "4": 35,
            "5": 35,
            "default": 20
          },
          "holeCardDisplacementVisible": {
            "2": 30,
            "4": 25,
            "5": 25,
            "default": 20
          },        
          "footerHeightAdjust": 0,
          "footerViewHeightScale": 0.50,
          "footerRankTextSize": 20.0,
          "otherBetOptionButtonsSpreadRadius": 70.0,
          "holeCardScale": {
            "2": 0.90,
            "4": 0.80,
            "5": 0.80,
            "default": 1
          },
          "betWidgetGap": 10,
          "betWidgetOffset": "0, -40",
          "betButtonsOffset": "0, 50",
          "holeCardOffset": "0, 15",
          "holeCardViewOffset": "0, 15",
          "holeCardViewScale": 1.28,
          "footerActionScale": 1.05,
          "footerScale": 0.50,
          "timerGap": 20,
          "seat": {
            "scale": 0.80,
            "holeCardOffset": "0, 0",
            "holeCardScale": 1.0
          }
        },
        {
          "base": "iPhone 13",
          "name": "iPhone 13 Pro",
          "models": [
            "iPhone 13 Pro"
          ],
          "model": "iPhone 13 Pro",
          "screenSize": "390.0, 844.0",
          "size": 6.2
        },
        {
          "base": "iPhone 12",
          "name": "iPhone 13",
          "model": "iPhone 13",
          "screenSize": "390.0, 844.0",
          "size": 6.2
        },
        {
          "name": "iPhone 12",
          "model": "iPhone 12",
          "screenSize": "375.0, 812.0",
          "size": 6.1,
          "board": {
            "centerViewScale": 0.90,
            "tableScale": 1.15,
            "seatMap": {
              "bottomCenter": "0, 20",
              "bottomLeft": "15, 10",
              "bottomRight": "-15, 10",
              "middleLeft": "0, 35",
              "middleRight": "0, 35",
              "topLeft": "2, 80",
              "topRight": "2, 80",
              "topCenter": "0, 60",
              "topCenter1": "-50, 60",
              "topCenter2": "55, 60"
            },
            "betAmountFac": {
              "bottomCenter": "0, -1.0",
              "topCenter": "0.20, 0.70",
              "middleLeft": "0.10, 0.65",
              "middleRight": "0.10, 0.65",
              "topRight": "-0.10, 0.70",
              "topLeft": "0.30, 0.65",
              "bottomLeft": "0.70, -0.8",
              "bottomRight": "-0.60, -0.8",
              "topCenter1": "0.20, 0.65",
              "topCenter2": "-0.20, 0.65"
            },
            "tableBottomPos": 10,
            "boardHeightAdjust": -20,
            "bottomHeightAdjust": -150,
            "centerPotScale": 0.85,
            "centerPotUpdatesScale": 0.7,
            "centerViewPos": "0, 0.0",
            "betImageScale": 3.0,
            "centerDoubleBoardScale": 1.0
          },
          "holeCardDisplacement": {
            "2": 35,
            "4": 30,
            "5": 25,
            "default": 25
          },
          "holeCardDisplacementVisible": {
            "2": 30,
            "4": 15,
            "5": 15,
            "default": 25
          },        
          "holeCardScale": {
            "2": 1.10,
            "4": 1.05,
            "5": 0.97,
            "default": 1
          },
          "footerViewHeightScale": 0.58,
          "holeCardViewOffset": "0, 30",
          "otherBetOptionButtonsSpreadRadius": 90.0,
          "betButtonsOffset": "0, 80"
        }
      ]
    ''';

    List<dynamic> decodedJson = jsonDecode(j);
    decodedJson.forEach((element) {
      allAttribs.add(ScreenAttributeObject(element));
    });
  }

  static Map<String, dynamic> getScreenAttribs(
      String modelName, double diagnoalSize, Size screenSize) {
    ScreenAttributeObject screenAttributeObject = allAttribs.firstWhere(
        (element) => element.modelMatches(modelName),
        orElse: () => allAttribs.firstWhere(
            (element) => element.screenSizeMatches(screenSize),
            orElse: () => allAttribs.firstWhere(
                (element) => element.diagonalSizeMatches(diagnoalSize),
                orElse: () => allAttribs.firstWhere(
                    (element) => element.defaultAttribs,
                    orElse: null))));

    if (screenAttributeObject != null) {
      Map<String, dynamic> attribs = screenAttributeObject.getAttribs();
      Map<String, dynamic> baseAtttribs = Map<String, dynamic>();
      if (screenAttributeObject.base != null &&
          screenAttributeObject.base.isNotEmpty) {
        baseAtttribs = _getBaseAttribs(screenAttributeObject.base);

        attribs = {
          ...baseAtttribs,
          ...attribs,
        };
      }
      return attribs;
    } else {
      return null;
    }
  }

  static Map<String, dynamic> _getBaseAttribs(String name) {
    ScreenAttributeObject attribsObject =
        allAttribs.firstWhere((element) => element.name == name);

    Map<String, dynamic> attribs = attribsObject.getAttribs();
    Map<String, dynamic> baseAtttribs = Map<String, dynamic>();
    if (attribsObject.base != null && attribsObject.base.isNotEmpty) {
      baseAtttribs = _getBaseAttribs(attribsObject.base);
      attribs = {
        ...attribs,
        ...baseAtttribs,
      };
    }
    return attribs;
  }
}
