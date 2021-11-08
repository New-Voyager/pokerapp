/* This class holds board attributes data, like orientation,
* mappings and everything that is variable */

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'board_attributes_object.dart';

class IosBoardAttributesObject extends BoardAttributesObject {
  IosBoardAttributesObject({
    /*
    * This screen size is diagonal inches*/
    @required double screenSize,
    BoardOrientation orientation = BoardOrientation.horizontal,
  }) : super(screenSize: screenSize, orientation: orientation) {
    
  }

  SeatPosAttribs getSeatPosAttrib(SeatPos pos) {
    return getSeatMap(this.screenDiagnolSize)[pos];
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

  /* device configurations smaller than 7 inch configurations */
  return {
    /* bottom center */
    SeatPos.bottomCenter: SeatPosAttribs(
      Alignment.bottomCenter,
      Offset(0, 30),
      Alignment.centerRight,
    ),
    /* bottom left and bottom right  */
    SeatPos.bottomLeft: SeatPosAttribs(
      Alignment.bottomLeft,
      Offset(15, 20),
      Alignment.centerRight,
    ),
    SeatPos.bottomRight: SeatPosAttribs(
      Alignment.bottomRight,
      Offset(-15, 20),
      Alignment.centerLeft,
    ),
    /* middle left and middle right */
    SeatPos.middleLeft: SeatPosAttribs(
      Alignment.centerLeft,
      Offset(0, 40),
      Alignment.centerRight,
    ),
    SeatPos.middleRight: SeatPosAttribs(
      Alignment.centerRight,
      Offset(0, 40),
      Alignment.centerLeft,
    ),

    /* top left and top right  */
    SeatPos.topLeft: SeatPosAttribs(
      Alignment.topLeft,
      Offset(0, 75),
      Alignment.centerRight,
    ),
    SeatPos.topRight: SeatPosAttribs(
      Alignment.topRight,
      Offset(0, 75),
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
      Offset(-70, 0),
      Alignment.centerRight,
    ),
    SeatPos.topCenter2: SeatPosAttribs(
      Alignment.topCenter,
      Offset(70, 0),
      Alignment.centerLeft,
    ),
  };
}


}
