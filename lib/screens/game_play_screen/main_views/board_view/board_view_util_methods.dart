import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'dart:math' as math;

/* collection of all methods used by the board_view widget */
class BoardViewUtilMethods {
  BoardViewUtilMethods._();

  static const _angleOfSlant = -30.0;

  static String getText(String tableStatus) {
    switch (tableStatus) {
      case AppConstants.SeatChangeInProgress:
        return 'Seat Change In Progress';
      case AppConstants.TABLE_STATUS_NOT_ENOUGH_PLAYERS:
        return 'Waiting for more players';
      case AppConstants.WAITING_TO_BE_STARTED:
        return 'Tap to start the game';
      case AppConstants.GAME_ENDED:
        return 'Game Ended';
      case AppConstants.NEW_HAND:
        return tableStatus;
    }

    return null;
  }

  /* this methods returns a matrix which is used for perception of slant */
  static Matrix4 getTransformationMatrix({
    @required isBoardHorizontal,
  }) {
    final Matrix4 horizontalBoardMatrix = Matrix4(
      1.0, 0.0, 0.0, 0.0, //
      0.0, 1.0, 0.0, 0.0, //
      0.0, 0.0, 1.0, 0.001, //
      0.0, 0.0, 0.0, 1.0, //
    ).scaled(1.0, 1.0, 1.0)
      ..rotateX(_angleOfSlant * math.pi / 180)
      ..rotateY(0.0)
      ..rotateZ(0.0);

    final Matrix4 verticalBoardMatrix = Matrix4(
      1.0, 0.0, 0.0, 0.0, //
      0.0, 1.0, 0.0, 0.0, //
      0.0, 0.0, 1.0, 0.001, //
      0.0, 0.0, 0.0, 1.0, //
    ).scaled(1.0, 1.0, 1.0)
      ..rotateX(_angleOfSlant * math.pi / 180)
      ..rotateY(0.0)
      ..rotateZ(0.0);

    return isBoardHorizontal ? horizontalBoardMatrix : verticalBoardMatrix;
  }
}
