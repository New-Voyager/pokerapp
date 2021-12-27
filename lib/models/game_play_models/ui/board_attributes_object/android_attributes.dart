String androidAttribs() {
  return """
[
  {
    "name": "base-model",
    "models": [],
    "screenSize": "0, 0",
    "diagonalMinSize": 6.0,
    "diagonalMaxSize": 6.1,
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
    "base": "base-model",
    "name": "pixel2",
    "models": ["pixel-xl", "pixel 2"],
    "screenSize": "411, 683",
    "diagonalMinSize": 5.3,
    "diagonalMaxSize": 5.55,
    "board": {
      "centerViewScale": 0.85,
      "centerOffset": "15, 80",
      "centerPotScale": 0.90,
      "centerPotUpdatesScale": 0.90,
      "centerRankScale": 0.80,
      "centerDoubleBoardScale": 0.90,
      "boardScale": 0.90,
      "tableScale": 1.2,
      "seatMap": {
        "bottomCenter": "0, 35",
        "bottomLeft": "15, 25",
        "bottomRight": "-15, 25",
        "middleLeft": "15, 35",
        "middleRight": "-15, 35",
        "topLeft": "15, 50",
        "topRight": "-15, 50",
        "topCenter": "0, 30",
        "topCenter1": "-45, 30",
        "topCenter2": "45, 30"
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
    "betWidgetOffset": "0, -30",
    "betImageScale": 2.5,
    "footerActionScale": 0.90,
    "footerViewHeightScale": 0.50,
    "holeCardViewScale": 0.80,
    "holeCardViewOffset": "0, 20",
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
    "holeCardOffset": "0, 15",
    "seat": {
      "scale": 0.90,
      "holeCardOffset": "0, 0",
      "holeCardScale": 1.0
    }
  },
  {
    "base": "base-model",
    "name": "Samsung Galaxy S7 Edge",
    "models": ["SM-G935K"],
    "screenSize": "414, 736",
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
  },
  {
    "name": "nexus5",
    "base": "pixel2",
    "models": ["Nexus 5"],
    "screenSize": "360.0, 592.0",
    "size": 4.6,
    "board": {
      "centerViewScale": 0.70,
      "centerViewPos": "15, 20",
      "centerOffset": "15, 40",
      "centerPotScale": 0.70,
      "centerPotUpdatesScale": 0.70,
      "centerRankScale": 0.70,
      "tableScale": 1.2,
      "seatMap": {
        "bottomCenter": "0, 30",
        "bottomLeft": "45, 30",
        "bottomRight": "-45, 30",
        "middleLeft": "0, 30",
        "middleRight": "0, 30",
        "topLeft": "10, 35",
        "topRight": "-10, 35",
        "topCenter": "0, 10",
        "topCenter1": "-45, 10",
        "topCenter2": "45, 10"
      },
      "betAmountFac": {
        "bottomCenter": "0, -0.80",
        "topCenter": "0.20, 0.70",
        "middleLeft": "0.60, 0.60",
        "middleRight": "-0.30, 0.60",
        "topRight": "-0.10, 0.70",
        "topLeft": "0.30, 0.65",
        "bottomLeft": "0.60, -0.75",
        "bottomRight": "-0.30, -0.85",
        "topCenter1": "0.20, 0.80",
        "topCenter2": "0.0, 0.80"
      },          
      "betImageScale": 2.0,
      "betWidgetOffset": "0, -50",
      "bottomHeightAdjust": -70
    },
    "footerViewHeightScale": 0.50,
    "holeCardViewOffset": "0, 30",
    "betWidgetGap": 0,
    "betWidgetOffset": "0, -50",
    "betButtonsOffset": "0, 60",
    "otherBetOptionButtonsSpreadRadius": 70,
    "holeCardScale": {
      "2": 1.2,
      "4": 1.0,
      "5": 0.90,
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
        "scale": 0.70,
        "holeCardOffset": "0, 0",
        "holeCardScale": 1.0
      }               
  },
  {
    "name": "nexus7",
    "base": "nexus5",
    "models": ["Nexus 7"],
    "screenSize": "600.0, 912.0",
    "diagonalMinSize": 7.0,
    "diagonalMaxSize": 7.6,
    "board": {

      "centerViewScale": 1.0,
      "centerViewPos": "15, 80",
      "centerOffset": "15, 50",
      "centerPotScale": 0.90,
      "centerPotUpdatesScale": 0.90,
      "centerDoubleBoardScale": 1.2,
      "centerBoardScale": 1.5,

      "tableBottomPos": 20,
      "tableScale": 1.2,
      "seatMap": {
        "bottomCenter": "0, 10",
        "bottomLeft": "45, 0",
        "bottomRight": "-45, 0",
        "middleLeft": "5, 30",
        "middleRight": "5, 30",
        "topLeft": "10, 70",
        "topRight": "-10, 70",
        "topCenter": "0, 45",
        "topCenter1": "-80, 45",
        "topCenter2": "80, 45"
      },
      "betAmountFac": {
        "bottomCenter": "-0.5, -0.80",
        "topCenter": "0.20, 0.70",
        "middleLeft": "1.2, 0.0",
        "middleRight": "-1.2, 0.0",
        "topRight": "-1.0, 0.60",
        "topLeft": "1.0, 0.60",
        "bottomLeft": "0.60, -0.75",
        "bottomRight": "-0.30, -0.85",
        "topCenter1": "0.0, 0.80",
        "topCenter2": "0.20, 0.80"
      },          
      "betImageScale": 4.0
    },
    "betWidgetGap": 30,
    "betWidgetOffset": "0, 0",
    "betButtonsOffset": "0, 90",
    "otherBetOptionButtonsSpreadRadius": 110,

    "holeCardViewOffset": "0, 30",
    "holeCardScale": {
      "2": 3.0,
      "4": 2.5,
      "5": 2.5,
      "default": 1
    },
    "holeCardDisplacement": {
      "2": 55,
      "4": 55,
      "5": 55,
      "default": 55
    },
    "holeCardDisplacementVisible": {
      "2": 50,
      "4": 45,
      "5": 45,
      "default": 45
    },        

    "seat": {
        "scale": 1.1,
        "holeCardOffset": "0, 0",
        "holeCardScale": 1.0
      }          
  },
    {
    "base": "pixel2",
    "name": "pixel3",
    "models": ["pixel 3"],
    "screenSize": "392, 735",
    "diagonalMinSize": 5.6,
    "diagonalMaxSize": 5.9,
    "board": {
      "centerOffset": "15, 95",
      "seatMap": {
        "bottomCenter": "0, 25",
        "bottomLeft": "15, 15",
        "bottomRight": "-15, 15",
        "middleLeft": "0, 35",
        "middleRight": "0, 35",
        "topLeft": "5, 60",
        "topRight": "-5, 60",
        "topCenter": "0, 40",
        "topCenter1": "-45, 40",
        "topCenter2": "45, 40"
      }
    },
    "holeCardScale": {
      "2": 1.6,
      "4": 1.45,
      "5": 1.40,
      "default": 1
    },
    "holeCardViewScale": 0.95
  },
{
    "base": "pixel3",
    "name": "pixel3xl",
    "models": ["pixel 3 xl"],
    "screenSize": "411, 797",
    "diagonalMinSize": 6.0,
    "diagonalMaxSize": 6.1,
    "board": {
      "centerDoubleBoardScale": 1.2,
      "centerBoardScale": 1.5,
      "bottomHeightAdjust": -64
    }
  },
{
    "base": "pixel3",
    "name": "pixel3a",
    "models": ["pixel 3a"],
    "screenSize": "392, 759",
    "diagonalMinSize": 5.7,
    "diagonalMaxSize": 5.7,
    "board": {
      "centerOffset": "15, 90",
      "centerDoubleBoardScale": 1.1,
      "centerBoardScale": 1.5
    }
  },
{
    "base": "pixel3",
    "name": "pixel3axl",
    "models": ["pixel 3a xl", "pixel 4 xl"],
    "screenSize": "432, 816",
    "diagonalMinSize": 6.1,
    "diagonalMaxSize": 6.2,
    "board": {
      "centerDoubleBoardScale": 1.2,
      "centerBoardScale": 1.5,
       "seatMap": {
        "bottomCenter": "0, 5",
        "bottomLeft": "15, 0",
        "bottomRight": "-15, 0",
        "middleLeft": "0, 35",
        "middleRight": "0, 35",
        "topLeft": "5, 60",
        "topRight": "-5, 60",
        "topCenter": "0, 40",
        "topCenter1": "-45, 40",
        "topCenter2": "45, 40"
      }
   }
  },
{
    "base": "pixel3",
    "name": "pixel4",
    "models": ["pixel 4"],
    "screenSize": "392, 813",
    "diagonalMinSize": 5.7,
    "diagonalMaxSize": 5.7,
    "board": {
      "centerDoubleBoardScale": 1.1,
      "bottomHeightAdjust": -77,
      "seatMap": {
        "bottomCenter": "0, 15",
        "bottomLeft": "15, 5",
        "bottomRight": "-15, 5",
        "middleLeft": "0, 35",
        "middleRight": "0, 35",
        "topLeft": "5, 60",
        "topRight": "-5, 60",
        "topCenter": "0, 40",
        "topCenter1": "-45, 40",
        "topCenter2": "45, 40"
      }      
    }
  },
  {
    "base": "base-model",
    "name": "motog",
    "models": ["moto g play (2021)"],
    "screenSize": "411, 890",
    "diagonalMinSize": 6.5,
    "diagonalMaxSize": 6.6,
    "default": true,
    "board": {
      "centerViewScale": 1.0,
      "centerOffset": "15, 130",
      "centerPotScale": 0.90,
      "centerPotUpdatesScale": 0.80,
      "centerRankScale": 0.80,
      "boardScale": 0.90,
      "tableScale": 1.30
    }        
  },
      {
        "name":"lenova10",
        "base":"motog",
        "models": ["lenova tb-x606f"],
        "screenSize": "800.0, 1264.0",
    "diagonalMinSize": 9.0,
    "diagonalMaxSize": 13.0,
        "board": {
          "centerViewScale": 1.30,
          "centerPotScale": 0.85,
          "centerPotUpdatesScale": 0.70,
          "centerRankScale": 0.85,
          "centerOffset": "15, 220",
          "centerViewPos": "15, 40",
          "boardScale": 1.10,
          "tableScale": 0.90,
          "tableBottomPos": 40,
          "seatMap": {
            "bottomCenter": "0, -50",
            "bottomLeft": "100, -70",
            "bottomRight": "-100, -70",
            "middleLeft": "50, 50",
            "middleRight": "-50, 50",
            "topLeft": "80, 170",
            "topRight": "-80, 170",
            "topCenter": "0, 130",
            "topCenter1": "-80, 130",
            "topCenter2": "80, 130"
          },
          "betAmountFac": {
            "bottomCenter": "-0.25, -0.80",
            "topCenter": "0.20, 1.0",
            "middleLeft": "1.10, 0.0",
            "middleRight": "-1.10, 0.0",
            "topRight": "-0.55, 0.70",
            "topLeft": "0.75, 0.70",
            "bottomLeft": "0.70, -0.80",
            "bottomRight": "-0.60, -0.80",
            "topCenter1": "0.10, 1.0",
            "topCenter2": "0.10, 1.0"
          },
          "betImageScale": 3.0,
          "betSliderScale": 3.0
        },

        "betWidgetGap": 90,
        "betButtonsOffset": "0, 90",
        "betWidgetOffset": "0, 0",
        "seat": {
          "scale": 1.4,
          "holeCardOffset": "0, 0",
          "holeCardScale": 1.0
        },
        "holeCardScale": {
          "2": 2.0,
          "4": 2.0,
          "5": 2.0,
          "default": 1
        },
        "holeCardDisplacement": {
          "2": 60,
          "4": 60,
          "5": 60,
          "default": 60
        },
        "holeCardDisplacementVisible": {
          "2": 60,
          "4": 60,
          "5": 60,
          "default": 20
        },
        "footerActionScale": 1.4
      }  
]
""";
}
