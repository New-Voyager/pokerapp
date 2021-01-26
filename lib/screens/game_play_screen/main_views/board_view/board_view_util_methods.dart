import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view.dart';
import 'dart:math' as math;

/* collection of all methods used by the board_view widget */
class BoardViewUtilMethods {
  BoardViewUtilMethods._();

  static const _angleOfSlant = -30.0;

  static String getText(String tableStatus) {
    switch (tableStatus) {
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

  /* this method adjusts the server and local seat positions so that the
  current playing user is shown always at seat 1 */
  static int getAdjustedSeatPosition(
      int pos, bool isPresent, int currentUserSeatNo) {
    /*
    * if the current user is present, then the localSeatNo would be different from that of server seat number
    * This is done, so that the current user can stay at the bottom center of the table
    */

    /*
    * 1 -> the bottom center seat
    * 9 -> total available seats
    * shifts (rotates) the local seat position by the x amount (x => current user seat NO.)
    * This is done so that current user is at seat 1 always
    * */
    if (isPresent) return (pos - currentUserSeatNo + 1) % 9;

    return pos;
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

  /* this method helps to position the user in the table */
  static Widget positionUser({
    @required bool isBoardHorizontal,
    UserObject user,
    double heightOfBoard,
    double widthOfBoard,
    int seatPos,
    bool isPresent,
    Function onUserTap,
  }) {
    seatPos++;

    double shiftDownConstant = heightOfBoard / 20;
    double shiftHorizontalConstant = widthOfBoard / 15;
    Alignment cardsAlignment = Alignment.centerRight;

    if (isBoardHorizontal) {
      shiftDownConstant += 20;
      if (seatPos == 1) shiftDownConstant -= 30;
    }

    // left for 6, 7, 8, 9
    if (seatPos == 6 || seatPos == 7 || seatPos == 8 || seatPos == 9)
      cardsAlignment = Alignment.centerLeft;

    UserView userView = UserView(
      isPresent: isPresent,
      seatPos: seatPos,
      key: ValueKey(seatPos),
      userObject: user,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    switch (seatPos) {
      case 1:
        return Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(
              0.0,
              shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 2:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(
              shiftHorizontalConstant - 20,
              heightOfBoard / 4 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 3:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(
              -10.0,
              isBoardHorizontal
                  ? -50.0 + shiftDownConstant
                  : -30.0 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 4:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(
              0.0,
              isBoardHorizontal
                  ? -heightOfBoard / 2
                  : -heightOfBoard / 2.8 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 5:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(
              isBoardHorizontal
                  ? -widthOfBoard / 3.8 + shiftHorizontalConstant + 30
                  : -widthOfBoard / 3.8 + shiftHorizontalConstant,
              isBoardHorizontal ? -50 : -shiftDownConstant / 1.5,
            ),
            child: userView,
          ),
        );

      case 6:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(
              widthOfBoard / 3.8 - shiftHorizontalConstant,
              isBoardHorizontal ? -50 : -shiftDownConstant / 1.5,
            ),
            child: userView,
          ),
        );

      case 7:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(
              0.0,
              isBoardHorizontal
                  ? -heightOfBoard / 2
                  : -heightOfBoard / 2.8 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 8:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(
              0.0,
              isBoardHorizontal
                  ? -50.0 + shiftDownConstant
                  : -30.0 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 9:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(
              -shiftHorizontalConstant,
              heightOfBoard / 4 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      default:
        return Container();
    }
  }

  /* this function is the link between the player model and the actual user shown in the table */
  static List<UserObject> getUserObjects(List<PlayerModel> users) {
    /* build an empty user object list
    *  This is done, because all the empty seats are
    *  also UserObject objects, and we need all
    * the 9 objects in an array to build the entire table + users
    * */

    final List<UserObject> userObjects = List.generate(
      9,
      (index) => UserObject(
        serverSeatPos: null,
        name: null,
        stack: null,
      ),
    );

    for (PlayerModel model in users) {
      int idx = model.seatNo - 1;

      // TODO: CLEAN THIS UP

      userObjects[idx].name = model.name;
      userObjects[idx].serverSeatPos = model.seatNo;
      userObjects[idx].isMe = model.isMe;
      userObjects[idx].stack = model.stack;
      userObjects[idx].status = model.status;
      userObjects[idx].buyIn = (model.showBuyIn ?? false) ? model.buyIn : null;
      userObjects[idx].highlight = model.highlight;
      userObjects[idx].playerType = model.playerType;
      userObjects[idx].avatarUrl = model.avatarUrl;
      userObjects[idx].playerFolded = model.playerFolded;
      userObjects[idx].cards = model.cards;
      userObjects[idx].highlightCards = model.highlightCards;
      userObjects[idx].winner = model.winner;
      userObjects[idx].coinAmount = model.coinAmount;
      userObjects[idx].animatingCoinMovement = model.animatingCoinMovement;
      userObjects[idx].noOfCardsVisible = model.noOfCardsVisible ?? 0;
      userObjects[idx].animatingFold = model.animatingFold;
      userObjects[idx].animatingCoinMovementReverse =
          model.animatingCoinMovementReverse;
      userObjects[idx].showFirework = model.showFirework ?? false;
    }

    return userObjects;
  }
}
