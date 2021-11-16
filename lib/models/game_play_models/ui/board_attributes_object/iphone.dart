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
          "centerGap": 0.0,
          "potViewGap": 0,
          "centerOffset": "15, 115",
          "seatMap": {
            "bottomCenter": "0, 100",
            "bottomLeft": "15, 70",
            "bottomRight": "-15, 70",
            "middleLeft": "2, 75",
            "middleRight": "2, 75",
            "topLeft": "2, 80",
            "topRight": "2, 80",
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
        "footerViewHeightScale": 0.40,
        "holeCardScale": {
          "2": 1.10,
          "4": 1.35,
          "5": 1.15,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 30",
        "holeCardViewScale": 1.28,
        "footerActionScale": 1.05,
        "footerScale": 0.45,
        "seat": {
          "scale": 0.90,
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

  static Map<String, dynamic> getIPhoneXS() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 10S",
        "screenSize": "375.0, 812.0",
        "size": 6.0,
        "board": {
          "centerViewScale": 0.90
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 13",
        "screenSize": "375.0, 812.0",
        "size": 6.1,
        "board": {
          "centerViewScale": 0.90,
          "tableScale": 1.15,
          "seatMap": {
            "bottomCenter": "0, 60",
            "bottomLeft": "15, 50",
            "bottomRight": "-15, 50",
            "middleLeft": "2, 75",
            "middleRight": "2, 75",
            "topLeft": "2, 110",
            "topRight": "2, 110",
            "topCenter": "0, 60",
            "topCenter1": "-50, 80",
            "topCenter2": "55, 80"
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
          "centerPotScale": 0.85,
          "centerPotUpdatesScale": 0.7
        },
        "holeCardDisplacement": {
          "2": 35,
          "4": 30,
          "5": 25,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 30,
          "4": 30,
          "5": 25,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.05,
          "4": 1.10,
          "5": 1.10,
          "default": 1
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13Pro() {
    final defaultValue = getIPhone13();
    String override = '''
      {
        "base": "iPhone 13",
        "model": "iPhone 13 Pro",
        "screenSize": "390.0, 844.0",
        "size": 6.2
      }''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13Mini() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 13 mini",
        "screenSize": "375.0, 812.0",
        "size": 5.4,
        "board": {
          "centerViewScale": 0.85,
          "tableScale": 1.3,
          "seatMap": {
            "bottomCenter": "0, 70",
            "bottomLeft": "15, 60",
            "bottomRight": "-15, 60",
            "middleLeft": "2, 75",
            "middleRight": "2, 75",
            "topLeft": "2, 105",
            "topRight": "2, 105",
            "topCenter": "0, 60",
            "topCenter1": "-50, 50",
            "topCenter2": "55, 50"
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
          "2": 30,
          "4": 30,
          "5": 25,
          "default": 25
        },
        "holeCardDisplacementVisible": {
          "2": 22,
          "4": 25,
          "5": 25,
          "default": 25
        },        
        "holeCardScale": {
          "2": 1.10,
          "4": 1.05,
          "5": 1.00,
          "default": 1
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPhone13ProMax() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone 13 Pro Max",
        "screenSize": "375.0, 812.0",
        "size": 5.4,
        "board": {
          "centerViewScale": 1.1,
          "tableScale": 1.2,
          "seatMap": {
            "bottomCenter": "0, 60",
            "bottomLeft": "15, 50",
            "bottomRight": "-15, 50",
            "middleLeft": "2, 75",
            "middleRight": "2, 75",
            "topLeft": "2, 105",
            "topRight": "2, 105",
            "topCenter": "0, 60",
            "topCenter1": "-50, 70",
            "topCenter2": "55, 70"
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
          "centerPotScale": 0.8,
          "centerPotUpdatesScale": 0.7
        },
        "holeCardDisplacement": {
          "2": 35,
          "4": 20,
          "5": 15,
          "default": 20
        },
        "holeCardDisplacementVisible": {
          "2": 30,
          "4": 13,
          "5": 13,
          "default": 20
        },        
        "holeCardScale": {
          "2": 1.3,
          "4": 1.3,
          "5": 1.2,
          "default": 1
        }
      }
    ''';
    Map<String, dynamic> overrideMap = jsonDecode(override);
    updateMap(defaultValue, overrideMap);
    return defaultValue;
  }

  static Map<String, dynamic> getIPad97() {
    final defaultValue = getDefault();
    String override = '''
      {
        "model": "iPhone Pro (9.7inch)",
        "screenSize": "768.0, 1024.0",
        "size": 8.5,
        "board": {
          "centerViewScale": 1.20,
          "centerOffset": "15, 250",
          "boardScale": 1.10,
          "tableScale": 1.05,
          "tableBottomPos": -140,
          "seatMap": {
            "bottomCenter": "0, 140",
            "bottomLeft": "100, 140",
            "bottomRight": "-100, 140",
            "middleLeft": "50, 170",
            "middleRight": "-50, 170",
            "topLeft": "80, 220",
            "topRight": "-80, 220",
            "topCenter": "0, 160",
            "topCenter1": "-80, 160",
            "topCenter2": "80, 160"
          },
          "betAmountFac": {
            "bottomCenter": "-0.25, -0.70",
            "topCenter": "0.20, 0.70",
            "middleLeft": "1.05, 0",
            "middleRight": "-1.05, 0",
            "topRight": "-0.65, 0.65",
            "topLeft": "0.75, 0.50",
            "bottomLeft": "0.70, -0.80",
            "bottomRight": "-0.60, -0.80",
            "topCenter1": "0.20, 0.80",
            "topCenter2": "-0.20, 0.80"
          },
          "betImageScale": 3.0
        },
        "otherBetOptionButtonsSpreadRadius": 90.0,
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
          "betImageScale": 2.0,
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
          "centerGap": 0.0,
          "potViewGap": 0,
          "centerOffset": "15, 115",
          "tableBottomPos": -40,
          "tableScale": 1.0,
          "seatMap": {
            "bottomCenter": "0, 100",
            "bottomLeft": "15, 90",
            "bottomRight": "-15, 90",
            "middleLeft": "0, 85",
            "middleRight": "0, 85",
            "topLeft": "2, 80",
            "topRight": "2, 80",
            "topCenter": "0, 55",
            "topCenter1": "-45, 50",
            "topCenter2": "48, 50"
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
        "footerViewHeightScale": 0.40,
        "footerRankTextSize": 20.0,
        "otherBetOptionButtonsSpreadRadius": 70.0,
        "holeCardScale": {
          "2": 0.90,
          "4": 0.80,
          "5": 0.80,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 30",
        "holeCardViewScale": 1.28,
        "footerActionScale": 1.05,
        "footerScale": 0.45,
        "seat": {
          "scale": 0.90,
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
          "centerViewScale": 1.30,
          "centerViewPos": "0, 50.0"
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
        "footerViewHeightScale": 0.42,
        "holeCardScale": {
          "2": 1.30,
          "4": 1.35,
          "5": 1.15,
          "default": 1
        },
        "holeCardOffset": "0, 0",
        "holeCardViewOffset": "0, 70",
        "otherBetOptionButtonsSpreadRadius": 80.0,
        "footerRankTextSize": 25.0,
        "holeCardViewScale": 1.4,
        "footerActionScale": 1.30,
        "footerScale": 0.50,
        "seat": {
          "scale": 1.30,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
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
        "centerViewScale": 1.60,
        "centerViewPos": "0, 100.0"
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
          "centerViewPos": "0, 60.0"
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
        "footerViewHeightScale": 0.43,
        "holeCardScale": {
          "2": 1.40,
          "4": 1.40,
          "5": 1.20,
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
          "centerViewPos": "0, 40.0"
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
        "footerViewHeightScale": 0.41,
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
          "centerViewPos": "0, 50.0"
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
        "footerViewHeightScale": 0.40,
        "holeCardScale": {
          "2": 1.10,
          "4": 1.15,
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
      if (name == 'ipad pro (9.7-inch)') return getIPad97();

      if (name == 'ipad (9th generation)') return getIPadNormal();

      if (name.contains('air')) return getIPadAir();

      if (name.contains('pro')) {
        if (name.contains('12')) return getIPadPro12();

        return getIPadPro11();
      }

      if (name.contains('mini')) return getIPadMini();

      return getDefault();
    } else {
      // iphone's sections
      if (name.contains('iphone 13 pro')) {
        return getIPhone13Pro();
      } else if (name.contains('iphone 13 mini')) {
        return getIPhone13Mini();
      } else if (name.contains('iphone 13 pro max')) {
        return getIPhone13ProMax();
      }
      return getIPhone8();
    }
  }
}
