import 'dart:convert';

import 'package:pokerapp/utils/utils.dart';

void updateMap(Map<String, dynamic> defaultMap, Map<String, dynamic> updates) {
  for (final key in defaultMap.keys) {
    final val = defaultMap[key];
    if (updates.containsKey(key)) {
      if (val is Map) {
        updateMap(val, updates[key]);
      } else {
        defaultMap[key] = updates[key];
      }
    }
  }
}

class IPhoneAttribs {
  static Map<String, dynamic> getIPhone8Plus() {
    String attribs = '''
      {
        "model": "iPhone 8 Plus", 
        "size": 5.6,
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
          "tableScale": 1.2,
          "centerSizeInc": {
            "dx": -30,
            "dy": -70
          },
          "lottieScale": 1.0,
          "betImageScale": 3.0,
          "betSliderScale": 3.0,
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.00, 0.75",
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
          "centerViewPos": "0, 5.0",
          "centerPotScale": 0.80,
          "centerPotUpdatesScale": 0.70,
          "centerRankScale": 0.85,
          "centerViewScale": 0.93,
          "doubleBoardScale": 0.90,
          "boardScale": 1.0,
          "centerGap": 0.0,
          "potViewGap": 0,
          "centerDoubleBoardScale": 0.90,
          "centerBoardScale": 1.4,
          "centerOffset": "15, 90",
          "boardHeightAdjust": -40,
          "bottomHeightAdjust": -54,
          "tableBottomPos": 40,
          "seatMap": {
            "bottomCenter": "0, 20",
            "bottomLeft": "15, 0",
            "bottomRight": "-15, 0",
            "middleLeft": "2, 30",
            "middleRight": "2, 30",
            "topLeft": "2, 60",
            "topRight": "2, 60",
            "topCenter": "0, 40",
            "topCenter1": "-50, 40",
            "topCenter2": "55, 40"
          }
        },
        "holeCardDisplacement": {
          "2": 45,
          "4": 35,
          "5": 27,
          "default": 20
        },
        "holeCardDisplacementVisible": {
          "2": 35,
          "4": 20,
          "5": 13,
          "default": 20
        },        
        "footerViewHeightScale": 0.50,
        "holeCardScale": {
          "2": 1.00,
          "4": 1.10,
          "5": 1.10,
          "default": 1
        },
        "betButtonsOffset": "0, 80",
        "betWidgetOffset": "0, -40",
        "otherBetOptionButtonsSpreadRadius": 90,
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 35",
        "holeCardViewScale": 1.28,
        "footerActionScale": 1.05,
        "footerScale": 0.58,
        "seat": {
          "scale": 0.95,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }
      }
    ''';
    return jsonDecode(attribs);
  }

  static Map<String, dynamic> getIPhone8() {
    return getDefault();
  }

  static Map<String, dynamic> getIPhoneX() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 10",
        "screenSize": "375.0, 812.0",
        "size": 5.8,
        "board": {
          "centerViewScale": 0.85,
          "tableScale": 1.1,
          "seatMap": {
            "bottomCenter": "0, 30",
            "bottomLeft": "15, 20",
            "bottomRight": "-15, 20",
            "middleLeft": "-4, 60",
            "middleRight": "4, 60",
            "topLeft": "-4, 110",
            "topRight": "4, 110",
            "topCenter": "0, 90",
            "topCenter1": "-48, 90",
            "topCenter2": "48, 90"
          },
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.5, 0.65",
            "middleRight": "-0.5, 0.65",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.8",
            "bottomRight": "-0.60, -0.8",
            "topCenter1": "0.20, 0.65",
            "topCenter2": "-0.20, 0.65"
          },
          "centerPotScale": 0.80,
          "centerPotUpdatesScale": 0.80,
          "centerViewPos": "0, 5.0",
          "tableBottomPos": 0,
          "backDropOffset": "0, 0",
          "betImageScale": 2.5
        },
        "holeCardDisplacement": {
          "2": 30,
          "4": 27,
          "5": 25,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 27,
          "4": 15,
          "5": 13,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.05,
          "4": 1.0,
          "5": 0.95,
          "default": 1
        },
        "betButtonsOffset": "0, 80",
        "otherBetOptionButtonsSpreadRadius": 80,
        "footerViewHeightScale": 0.55,
        "holeCardViewOffset": "0, 30"
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }


  static Map<String, dynamic> getIPhone11() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 11",
        "screenSize": "414.0, 896.0",
        "size": 6.6,
        "board": {
          "centerViewScale": 0.85,
          "tableScale": 1.2,
          "seatMap": {
            "bottomCenter": "0, 30",
            "bottomLeft": "15, 20",
            "bottomRight": "-15, 20",
            "middleLeft": "-4, 50",
            "middleRight": "4, 50",
            "topLeft": "-4, 100",
            "topRight": "4, 100",
            "topCenter": "0, 90",
            "topCenter1": "-48, 90",
            "topCenter2": "48, 90"
          },
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.5, 0.65",
            "middleRight": "-0.5, 0.65",
            "topRight": "-0.60, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.8",
            "bottomRight": "-0.60, -0.8",
            "topCenter1": "0.20, 0.65",
            "topCenter2": "-0.20, 0.65"
          },
          "centerPotScale": 0.80,
          "centerPotUpdatesScale": 0.80,
          "centerViewPos": "0, 35.0",
          "tableBottomPos": -10,
          "boardHeightAdjust": 0,
          "bottomHeightAdjust": -130,
          "backDropOffset": "0, 0",
          "betImageScale": 3.0
        },
        "holeCardDisplacement": {
          "2": 30,
          "4": 27,
          "5": 25,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 27,
          "4": 27,
          "5": 25,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.20,
          "4": 1.20,
          "5": 1.20,
          "default": 1
        },
        "seat": {
          "scale": 0.90
        },
        "betButtonsOffset": "0, 90",
        "footerViewHeightScale": 0.60,
        "holeCardViewOffset": "0, 30",
        "otherBetOptionButtonsSpreadRadius": 90
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone11Pro() {
    final defaultValue = getIPhone11();
    String override = '''
      {
        "model": "iPhone 10S",
        "screenSize": "375.0, 812.0",
        "size": 5.8,

        "board": {
          "backDropOffset": "0, -50",
          "centerViewPos": "0, 0",
          "tableBottomPos": 10,
           "seatMap": {
            "bottomCenter": "0, 30",
            "bottomLeft": "15, 20",
            "bottomRight": "-15, 20",
            "middleLeft": "-4, 50",
            "middleRight": "4, 50",
            "topLeft": "-4, 80",
            "topRight": "4, 80",
            "topCenter": "0, 60",
            "topCenter1": "-48, 60",
            "topCenter2": "48, 60"
          }
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }


  static Map<String, dynamic> getIPhone11ProMax() {
    final defaultValue = getIPhone11Pro();
    String override = '''
      {
        "model": "iPhone 11 Pro Max",
        "screenSize": "375.0, 812.0",
        "size": 5.8,

        "board": {
          "backDropOffset": "0, -50",
          "centerViewPos": "0, 0",
          "tableBottomPos": 10,
           "seatMap": {
            "bottomCenter": "0, 10",
            "bottomLeft": "15, 0",
            "bottomRight": "-15, 0",
            "middleLeft": "-4, 40",
            "middleRight": "4, 40",
            "topLeft": "-4, 80",
            "topRight": "4, 80",
            "topCenter": "0, 70",
            "topCenter1": "-48, 70",
            "topCenter2": "48, 70"
          }
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }
  static Map<String, dynamic> getIPhoneXS() {
    final defaultValue = getIPhoneX();
    String override = '''
      {
        "model": "iPhone 10S",
        "screenSize": "375.0, 812.0",
        "size": 5.8,
        "board": {
 
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhoneXSMax() {
    final defaultValue = getDefault();
    String override = '''
      {
        "base": "iPhone 10S",
        "model": "iPhone 10S Max",
        "screenSize": "375.0, 812.0",
        "size": 6.5,
        "board": {
          "centerViewScale": 1.05,
          "tableScale": 1.2,
          "seatMap": {
            "bottomCenter": "0, 63",
            "bottomLeft": "15, 53",
            "bottomRight": "-15, 53",
            "middleLeft": "-4, 80",
            "middleRight": "4, 80",
            "topLeft": "-4, 110",
            "topRight": "4, 110",
            "topCenter": "0, 60",
            "topCenter1": "-55, 70",
            "topCenter2": "55, 70"
          },
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "-0.2, 0.65",
            "middleRight": "0.10, 0.65",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.8",
            "bottomRight": "-0.60, -0.8",
            "topCenter1": "0.20, 0.65",
            "topCenter2": "-0.20, 0.65"
          },
          "centerPotScale": 0.80,
          "centerPotUpdatesScale": 0.80,
          "centerViewPos": "0, 20.0"
        },
        "holeCardDisplacement": {
          "2": 33,
          "4": 30,
          "5": 27,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 27,
          "4": 15,
          "5": 13,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.25,
          "4": 1.15,
          "5": 1.10,
          "default": 1
        },
        "holeCardViewOffset": "0, 60"
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhoneXR() {
    final defaultValue = getDefault();
    String override = '''
      {
        "base": "iPhone 10S",
        "model": "iPhone 10R",
        "screenSize": "375.0, 812.0",
        "size": 6.1,
        "board": {
          "centerViewScale": 1.05,
          "tableScale": 1.2,
          "seatMap": {
            "bottomCenter": "0, 65",
            "bottomLeft": "15, 55",
            "bottomRight": "-15, 55",
            "middleLeft": "-4, 80",
            "middleRight": "4, 80",
            "topLeft": "-4, 110",
            "topRight": "4, 110",
            "topCenter": "0, 60",
            "topCenter1": "-55, 63",
            "topCenter2": "55, 63"
          },
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "-0.2, 0.65",
            "middleRight": "0.10, 0.65",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.8",
            "bottomRight": "-0.60, -0.8",
            "topCenter1": "0.20, 0.65",
            "topCenter2": "-0.20, 0.65"
          },
          "centerPotScale": 0.80,
          "centerPotUpdatesScale": 0.80,
          "centerViewPos": "0, 20.0"
        },
         "holeCardDisplacement": {
          "2": 35,
          "4": 32,
          "5": 27,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 30,
          "4": 15,
          "5": 13,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.25,
          "4": 1.20,
          "5": 1.13,
          "default": 1
        },
        "holeCardViewOffset": "0, 60"
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone12() {
    final defaultValue = getDefault();
    String override = '''
      {
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
          "betImageScale": 3.0
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
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone12Pro() {
    final defaultValue = getIPhone12();
    String override = '''
      {
        "base": "iPhone 12",
        "model": "iPhone 12 Pro",
        "screenSize": "390.0, 844.0",
        "size": 6.2
      }''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone12Mini() {
    final defaultValue = getIPhone12();
    String override = '''
      {
        "model": "iPhone 12 mini",
        "screenSize": "375.0, 812.0",
        "size": 5.4,
        "board": {
          "centerViewScale": 0.85,
          "tableScale": 1.3,
          "seatMap": {
            "bottomCenter": "0, 30",
            "bottomLeft": "15, 10",
            "bottomRight": "-15, 10",
            "middleLeft": "-5, 45",
            "middleRight": "5, 45",
            "topLeft": "2, 70",
            "topRight": "2, 70",
            "topCenter": "0, 60",
            "topCenter1": "-40, 50",
            "topCenter2": "45, 50"
          },
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.30, 0.65",
            "middleRight": "-0.10, 0.65",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.8",
            "bottomRight": "-0.60, -0.8",
            "topCenter1": "0.20, 1.05",
            "topCenter2": "-0.20, 1.05"
          },
          "centerPotScale": 0.85,
          "centerPotUpdatesScale": 0.7
        },
        "holeCardDisplacement": {
          "2": 33,
          "4": 30,
          "5": 23,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 22,
          "4": 15,
          "5": 13,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.10,
          "4": 1.00,
          "5": 0.95,
          "default": 1
        },
        "footerHeightViewScale": 0.55,
        "holeCardViewOffset": "0, 25"
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone12ProMax() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 12 Pro Max",
        "screenSize": "375.0, 812.0",
        "size": 6.8,
        "board": {
          "centerViewScale": 0.90,
          "tableScale": 1.2,
          "seatMap": {
            "bottomCenter": "0, 20",
            "bottomLeft": "15,10",
            "bottomRight": "-15, 10",
            "middleLeft": "2, 35",
            "middleRight": "2, 35",
            "topLeft": "2, 75",
            "topRight": "2, 75",
            "topCenter": "0, 50",
            "topCenter1": "-50, 50",
            "topCenter2": "55, 50"
          },
          "betAmountFac": {
            "bottomCenter": "0, -1.0",
            "topCenter": "0.20, 0.70",
            "middleLeft": "0.10, 0.65",
            "middleRight": "0.00, 0.65",
            "topRight": "-0.10, 0.70",
            "topLeft": "0.30, 0.65",
            "bottomLeft": "0.70, -0.8",
            "bottomRight": "-0.60, -0.8",
            "topCenter1": "0.20, 0.7",
            "topCenter2": "-0.20, 0.7"
          },
          "tableBottomPos": 0,
          "boardHeightAdjust": -75,
          "centerPotScale": 0.75,
          "centerPotUpdatesScale": 0.70,
          "centerGap": 2,
          "centerViewPos": "0, -10.0",
          "betImageScale": 3.0

        },
        "otherBetOptionButtonsSpreadRadius": 90.0,
        "betButtonsOffset": "0, 80",

        "holeCardDisplacement": {
          "2": 37,
          "4": 33,
          "5": 28,
          "default": 20
        },
        "holeCardDisplacementVisible": {
          "2": 30,
          "4": 20,
          "5": 20,
          "default": 20
        },        
        "holeCardScale": {
          "2": 1.40,
          "4": 1.20,
          "5": 1.15,
          "default": 1
        },
        "seat": {
          "scale": 1.0,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        },

        "footerViewHeightScale": 0.55,
        "holeCardViewOffset": "0, 40"
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13Mini() {
    final defaultValue = getIPhone12Mini();
    String override = '''
      {
        "base": "iPhone 13",
        "model": "iPhone 13 mini",
        "screenSize": "390.0, 844.0",
        "size": 5.4
      }''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13() {
    final defaultValue = getIPhone12();
    String override = '''
      {
        "model": "iPhone 13",
        "screenSize": "390.0, 844.0",
        "size": 6.2
      }''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13Pro() {
    final defaultValue = getIPhone12Pro();
    String override = '''
      {
        "base": "iPhone 13",
        "model": "iPhone 13 Pro",
        "screenSize": "390.0, 844.0",
        "size": 6.8
      }''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13ProMax() {
    final defaultValue = getIPhone12ProMax();
    String override = '''
      {
        "base": "iPhone 13",
        "model": "iPhone 13 Pro Max",
        "screenSize": "390.0, 844.0",
        "size": 6.8,
        "board": {
          
        }
      }''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPad97() {
    final defaultValue = getDefault();
    String override = '''
      {
        "base": "default",
        "name": "iPad97",
        "model": "iPhone Pro (9.7inch)",
        "screenSize": "768.0, 1024.0",
        "size": 8.5,
        "board": {
          "centerViewScale": 1.20,
          "centerOffset": "15, 250",
          "centerViewPos": "0, -10",
          "boardScale": 1.2,
          "tableScale": 1.1,
          "tableBottomPos": 30,
          "boardHeightAdjust": 30,
          "bottomHeightAdjust": -140,
          "headerTopPos": -10,
          "backDropOffset": "0, -50",
          "seatMap": {
            "bottomCenter": "0, 10",
            "bottomLeft": "140, 0",
            "bottomRight": "-140, 0",
            "middleLeft": "50, 90",
            "middleRight": "-50, 90",
            "topLeft": "80, 170",
            "topRight": "-80, 170",
            "topCenter": "0, 120",
            "topCenter1": "-80, 120",
            "topCenter2": "80, 120"
          },
          "betAmountFac": {
            "bottomCenter": "-0.25, -0.70",
            "topCenter": "0.20, 0.70",
            "middleLeft": "1.05, 0",
            "middleRight": "-1.05, 0",
            "topRight": "-0.65, 0.65",
            "topLeft": "0.75, 0.65",
            "bottomLeft": "0.70, -0.80",
            "bottomRight": "-0.60, -0.80",
            "topCenter1": "0.20, 0.80",
            "topCenter2": "-0.20, 0.80"
          },
          "betImageScale": 4.0
        },
        "betWidgetGap": 90,
        "betButtonsOffset": "0, 90",
        "betWidgetOffset": "0, -30",
        "footerViewHeightScale": 0.55,
        "footerHeightAdjust": -200,
        "otherBetOptionButtonsSpreadRadius": 120.0,
        "seat": {
          "scale": 1.2,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        },
        "holeCardViewOffset": "0, 50",
        "holeCardScale": {
          "2": 1.60,
          "4": 1.35,
          "5": 1.50,
          "default": 1
        },
        "holeCardDisplacement": {
          "2": 35,
          "4": 50,
          "5": 50,
          "default": 20
        },
        "holeCardDisplacementVisible": {
          "2": 50,
          "4": 50,
          "5": 50,
          "default": 20
        }       
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getDefault() {
    String attribs = '''
      {
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
      }
    ''';
    return jsonDecode(attribs);
  }

  static Map<String, dynamic> getIPadMini() {
    final defaultMap = getIPad97();

    String override = '''
      {
       "model": "iPad mini (6th generation)",
       "screenSize": "744.0, 1133.0",
       "size": 9.0,
        "board": {
          "seatMap": {
            "bottomCenter": "0, 10",
            "bottomLeft": "140, 0",
            "bottomRight": "-140, 0",
            "middleLeft": "50, 90",
            "middleRight": "-50, 90",
            "topLeft": "80, 170",
            "topRight": "-80, 170",
            "topCenter": "0, 120",
            "topCenter1": "-80, 120",
            "topCenter2": "80, 120"
          }          
        }
     }
    ''';

    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultMap, overrideMap);

    return defaultMap;
  }

  static Map<String, dynamic> getIPadPro12() {
    final defaultMap = getIPadPro11();
    String override = '''
    {
     "model": "iPad Pro 12 inch",
     "size": 12.9,
     "board": {
       "tableScale": 0.90,
        "centerViewScale": 1.60,
        "centerViewPos": "0, 100.0",
          "seatMap": {
            "bottomCenter": "0, -30",
            "bottomLeft": "140, -40",
            "bottomRight": "-140, -40",
            "middleLeft": "50, 90",
            "middleRight": "-50, 90",
            "topLeft": "110, 200",
            "topRight": "-110, 200",
            "topCenter": "0, 160",
            "topCenter1": "-100, 160",
            "topCenter2": "100, 160"
          }        
      },
        "timerGap": 20,
        "seat": {
          "scale": 1.30,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }
    }
    ''';

    updateMap(defaultMap, jsonDecode(override));
    return defaultMap;
  }

  static Map<String, dynamic> getIPadPro11() {
    final defaultMap = getIPadMini();

    String override = '''
      {
       "model": "iPad Pro 11 inch",
       "screenSize": "1024.0, 1366.0",
       "size": 11.0,
        "board": {
          "centerViewScale": 1.40,
          "centerViewPos": "0, 30.0"
        },
        "holeCardDisplacement": {
          "2": 50,
          "4": 50,
          "5": 40,
          "default": 50
        },
        "holeCardDisplacementVisible": {
          "2": 50,
          "4": 50,
          "5": 40,
          "default": 50
        },        
        "footerViewHeightScale": 0.55,
        "holeCardScale": {
          "2": 1.20,
          "4": 1.10,
          "5": 1.00,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 90",
        "otherBetOptionButtonsSpreadRadius": 90.0,
        "footerRankTextSize": 28.0,
        "holeCardViewScale": 1.6,
        "footerActionScale": 1.50,
        "footerScale": 0.70,
        "seat": {
          "scale": 1.50,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }

      }
    ''';

    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultMap, overrideMap);

    return defaultMap;
  }

  static Map<String, dynamic> getIPadNormal() {
    final defaultMap = getIPad97();
    String override = '''
      {
        "model": "iPad (9th generation)",
        "screenSize": "810.0, 1080.0",
        "size": 9.0,
        "board": {
          "centerViewScale": 1.30,
          "centerDoubleBoardScale": 0.90,
          "centerBoardScale": 1.4,
          "betImageScale": 3.0
        },
        "holeCardDisplacement": {
          "2": 50,
          "4": 50,
          "5": 40,
          "default": 50
        },
        "holeCardDisplacementVisible": {
          "2": 50,
          "4": 50,
          "5": 40,
          "default": 50
        },
        "holeCardScale": {
          "2": 1.10,
          "4": 1.15,
          "5": 1.15,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 80",
        "holeCardViewScale": 1.60,
        "footerActionScale": 1.30,
        "otherBetOptionButtonsSpreadRadius": 90.0,
        "footerScale": 0.45,
        "seat": {
          "scale": 1.2,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }

      }
    ''';

    updateMap(defaultMap, jsonDecode(override));
    return defaultMap;
  }

  static Map<String, dynamic> getIPadAir() {
    final defaultValue = getIPad97();
    String override = '''
      {
        "model": "iPad Air (4th generation)",
        "screenSize": "820.0, 1180.0",
        "size": 9.5,
        "board": {
          "centerViewScale": 1.30,
          "centerViewPos": "0, 20.0",
          "seatMap": {
            "bottomCenter": "0, -20",
            "bottomLeft": "140, -20",
            "bottomRight": "-140, -20",
            "middleLeft": "50, 70",
            "middleRight": "-50, 70",
            "topLeft": "80, 170",
            "topRight": "-80, 170",
            "topCenter": "0, 120",
            "topCenter1": "-80, 120",
            "topCenter2": "80, 120"
          }          
        },
        "holeCardDisplacement": {
          "2": 50,
          "4": 50,
          "5": 40,
          "default": 50
        },
        "holeCardDisplacementVisible": {
          "2": 50,
          "4": 50,
          "5": 40,
          "default": 50
        },        
        "holeCardScale": {
          "2": 1.30,
          "4": 1.25,
          "5": 1.15,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 60",
        "holeCardViewScale": 1.60,
        "footerActionScale": 1.30,
        "otherBetOptionButtonsSpreadRadius": 90.0,
        "footerScale": 0.45,
        "seat": {
          "scale": 1.30,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        }

      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  /*
  * iPad Pro (9.7-inch)
  * iPad (9th generation)
  * iPad Air (4th generation)
  * iPad Pro (11-inch) (3rd generation)
  * iPad Pro (12.9-inch) (5th generation)
  * iPad mini (6th generation)
  * */
  static Map<String, dynamic> getAttribs(String deviceName, double screenSize) {
    String name = deviceName.toLowerCase();

    // ipad's section
    if (name.contains('ipad')) {
      if (name == 'ipad pro (9.7-inch)') {
        return getIPad97();
      }

      if (name == 'ipad (9th generation)') {
        return getIPadNormal();
      }

      if (name.contains('air')) {
        return getIPadAir();
      }

      if (name.contains('pro')) {
        if (name.contains('12')) {
          return getIPadPro12();
        }
        return getIPadPro11();
      }

      if (name.contains('mini')) {
        return getIPadMini();
      }

      return getDefault();
    } else {
      print("name is $name");
      if (name.contains('iphone 11 pro max')) {
        return getIPhone11ProMax();
      } else if (name.contains('iphone 11 pro')) {
        return getIPhone11Pro();
      } else if (name.contains('iphone 11')) {
        return getIPhone11();
      } else if (name.contains('iphone 12 mini')) {
        return getIPhone12Mini();
      } else if (name.contains('iphone 12 pro max')) {
        return getIPhone12ProMax();
      } else if (name.contains('iphone 12 pro')) {
        return getIPhone12Pro();
      } else if (name.contains('iphone 12')) {
        return getIPhone12();
      } else if (name.contains('iphone 13 pro max')) {
        return getIPhone13ProMax();
      } else if (name.contains('iphone 13 pro')) {
        return getIPhone13Pro();
      } else if (name.contains('iphone 13 mini')) {
        return getIPhone13Mini();
      } else if (name.contains('iphone 13')) {
        return getIPhone13();
      } else if (name.contains('iphone xs max')) {
        return getIPhoneXSMax();
      } else if (name.contains('iphone xʀ')) {
        return getIPhoneXR();
      } else if (name.contains('iphone xs') ||
        name.contains('iphone10s')) {
        return getIPhoneXS();
      } else if (name.contains('iphone x')) {
        return getIPhoneX();
      } else if (name.contains('iphone 8 plus')) {
        return getIPhone8Plus();
      }
      return getIPhone8();
    }
  }
}
