String androidAttribs = """
[
  {
    "name": "default",
    "models": [],
    "screenSize": "0, 0",
    "default": true,
    "size": 6,
    "appliesTo": "6",
    "board": {
      "backDropOffset": "0, -50",
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
        "topCenter2": "50, 0"
      },
      "foldStopPos": {
        "bottomCenter": "20, -130",
        "bottomLeft": "100, -120",
        "bottomRight": "-70, -120",
        "topCenter": "20, 20",
        "middleLeft": "100, -50",
        "middleRight": "-70, -50",
        "topRight": "-70, 20",
        "topLeft": "100, 20",
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
        "middleLeft": "0.60, 0.70",
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
      "centerViewPos": "0, 0",
      "centerPotScale": 1.0,
      "centerPotUpdatesScale": 0.85,
      "centerRankScale": 0.85,
      "centerViewScale": 0.85,
      "centerDoubleBoardScale": 1.1,
      "centerBoardScale": 1.3,
      "boardScale": 1.0,
      "tableScale": 1.0,
      "tableBottomPos": 30,
      "centerGap": 0.0,
      "potViewGap": 0,
      "centerOffset": "15, 130",
      "boardHeightAdjust": -60,
      "bottomHeightAdjust": -60,
      "seatMap": {
        "bottomCenter": "0, 10",
        "bottomLeft": "15, 0",
        "bottomRight": "-15, 0",
        "middleLeft": "2, 45",
        "middleRight": "2, 45",
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
    "footerViewHeightScale": 0.50,
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
    "betWidgetGap": 20,
    "betWidgetOffset": "0, 0",
    "betButtonsOffset": "0, 80",
    "otherBetOptionButtonsSpreadRadius": 90,
    "seat": {
      "scale": 1.0,
      "holeCardOffset": "0, 0",
      "holeCardScale": 1.0
    }
  },
  {
    "base": "default",
    "name": "pixel-xl",
    "models": ["pixel-xl"],
    "screenSize": "411.4, 683.4",
    "size": 5.5,
    "board": {
      "centerViewScale": 0.85,
      "centerOffset": "15, 100",
      "centerPotScale": 0.90,
      "centerPotUpdatesScale": 0.90,
      "centerRankScale": 0.80,
      "boardScale": 0.90,
      "tableScale": 1.0,
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
        "bottomLeft": "0.90, -0.75",
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
      "default": 35
    },
    "holeCardDisplacementVisible": {
      "2": 30,
      "4": 25,
      "5": 25,
      "default": 25
    },        

    "seat": {
      "scale": 0.90,
      "holeCardOffset": "0, 0",
      "holeCardScale": 1.0
    }
  },
  {
    "base": "default",
    "name": "Samsung Galaxy S7 Edge",
    "models": ["SM-G935K"],
    "screenSize": "414.4, 736.7",
    "size": 5.5,
    "board": {
      "centerViewScale": 0.75,
      "centerOffset": "15, 145",
      "centerPotScale": 0.90,
      "centerPotUpdatesScale": 0.90,
      "centerRankScale": 0.80,
      "boardScale": 0.9,
      "tableScale": 1.1,
      "seatMap": {
        "bottomCenter": "0, 20",
        "bottomLeft": "15, 10",
        "bottomRight": "-15, 10",
        "middleLeft": "0, 55",
        "middleRight": "0, 55",
        "topLeft": "0, 120",
        "topRight": "0, 120",
        "topCenter": "0, 97",
        "topCenter1": "-50, 97",
        "topCenter2": "50, 97"
      },
      "betAmountFac": {
        "bottomCenter": "0, -1",
        "topCenter": "0.20, 0.70",
        "middleLeft": "0.20, 0.75",
        "middleRight": "0.0, 0.75",
        "topRight": "-0.10, 0.70",
        "topLeft": "0.30, 0.65",
        "bottomLeft": "0.90, -0.85",
        "bottomRight": "-0.60, -0.85",
        "topCenter1": "0.20, 0.80",
        "topCenter2": "-0.20, 0.80"
      }          
    },
    "betImageScale": 2.5,
    "footerActionScale": 0.90,
    "footerViewHeightScale": 0.40,
    "holeCardViewScale": 0.80,
    "holeCardViewOffset": "0, 30",
    "holeCardScale": {
      "2": 1.45,
      "4": 1.35,
      "5": 1.30,
      "default": 1
    },
    "holeCardDisplacement": {
      "2": 35,
      "4": 35,
      "5": 35,
      "default": 35
    },
    "holeCardDisplacementVisible": {
      "2": 30,
      "4": 25,
      "5": 25,
      "default": 25
    },
    "seat": {
      "scale": 0.90,
      "holeCardOffset": "0, 0",
      "holeCardScale": 1.0
    }
  }
]
""";
