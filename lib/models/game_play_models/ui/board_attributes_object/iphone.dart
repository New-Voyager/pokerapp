import 'dart:convert';

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
        "seat": {
          "scale": 1.3,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        },
        "holeCardScale": {
          "2": 1.70,
          "4": 1.35,
          "5": 1.15,
          "default": 1
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
}
