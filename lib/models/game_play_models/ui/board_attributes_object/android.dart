import 'dart:convert';

import 'iphone.dart';

class AndroidAttribs {
  static Map<String, dynamic> getDefault() {
    String attribs = '''
      {
        "size": 6,
        "appliesTo": "6",
        "board": {
          "playersTableOffset": "0.0, -25.0",
          "namePlate": {
            "width": 70,
            "height": 55
          },
          "buttonPos": {
            "topCenter": "25, 40",
            "bottomCenter": "10, -40",
            "middleLeft": "50, 0",
            "middleRight": "-50, 0",
            "topRight": "-40, 30",
            "topLeft": "40, 30", 
            "bottomLeft": "25, -40",
            "bottomRight": "-20, -40",
            "topCenter1": "0, 40",
            "topCenter2": "0, 40"
          },
          "foldStopPos": {
            "bottomCenter": "20, -140",
            "topCenter": "20, 20",
            "middleLeft": "100, -50",
            "middleRight": "-70, -50",
            "topRight": "-70, 20",
            "topLeft": "100, 20",
            "bottomLeft": "100, -120",
            "bottomRight": "-70, -120",
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
          "betImageScale": 3.0,
          "betSliderScale": 2.0,
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.30, 0.75",
            "middleRight": "-0.10, 0.75",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.80",
            "bottomRight": "-0.60, -0.80",
            "topCenter1": "0.20, 0.80",
            "topCenter2": "-0.20, 0.80"
          },
          "cardShufflePos": "0, -30",
          "centerButtonsPos": "0, -40",
          "centerViewPos": "0, 15.0",
          "centerPotScale": 1.0,
          "centerPotUpdatesScale": 0.85,
          "centerRankScale": 0.85,
          "centerViewScale": 0.85,
          "doubleBoardScale": 0.90,
          "boardScale": 1.0,
          "tableScale": 1.0,
          "tableBottomPos": -40,
          "centerGap": 0.0,
          "potViewGap": 0,
          "centerOffset": "15, 130",
          "seatMap": {
            "bottomCenter": "0, 60",
            "bottomLeft": "15, 50",
            "bottomRight": "-15, 50",
            "middleLeft": "2, 65",
            "middleRight": "2, 65",
            "topLeft": "2, 100",
            "topRight": "2, 100",
            "topCenter": "0, 60",
            "topCenter1": "-50, 60",
            "topCenter2": "55, 60"
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
        "footerViewHeightScale": 0.45,
        "holeCardScale": {
          "2": 1.45,
          "4": 1.35,
          "5": 1.15,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 60",
        "holeCardViewScale": 1.28,
        "footerActionScale": 1.05,
        "footerScale": 0.45,
        "seat": {
          "scale": 1.0,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }
      }
    ''';
    return jsonDecode(attribs);
  }

  static Map<String, dynamic> get6Inch() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "motog",
        "screenSize": "411.4, 890.3",
        "size": 6.5
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getPixelXl() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "pixel-xl",
        "screenSize": "411.4, 683.4",
        "size": 5.5,
        "board": {
          "centerViewScale": 0.85,
          "centerOffset": "15, 100",
          "centerPotScale": 0.90,
          "centerPotUpdatesScale": 0.70,
          "centerRankScale": 0.80,
          "boardScale": 0.90,
          "tableScale": 1.10,
          "seatMap": {
            "bottomCenter": "0, 80",
            "bottomLeft": "15, 70",
            "bottomRight": "-15, 70",
            "middleLeft": "15, 70",
            "middleRight": "-15, 70",
            "topLeft": "15, 75",
            "topRight": "-15, 75",
            "topCenter": "0, 60",
            "topCenter1": "-45, 60",
            "topCenter2": "45, 60"
          },
          "betAmountFac": {
            "bottomCenter": "0, -0.80",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.20, 0.75",
            "middleRight": "0.0, 0.75",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.85",
            "bottomRight": "-0.60, -0.85",
            "topCenter1": "0.20, 0.80",
            "topCenter2": "-0.20, 0.80"
          }          
        },
        "betImageScale": 2.5,
        "footerActionScale": 0.90,
        "footerViewHeightScale": 0.40,
        "holeCardViewScale": 0.80,
        "holeCardViewOffset": "0, 0",
        "holeCardScale": {
          "2": 1.45,
          "4": 1.35,
          "5": 1.15,
          "default": 1
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

        "seat": {
          "scale": 0.90,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }
}
