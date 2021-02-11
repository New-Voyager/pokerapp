import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/player_view.dart';

import 'board_view_util_methods.dart';

// PlayersOnTableView encapsulates the players sitting on the table.
// This view uses Stack layout to place the UserView on top of the table.
class PlayersOnTableView extends StatelessWidget {
  final Function(int index) onUserTap;
  final Players players;
  final isBoardHorizontal;
  final double heightOfBoard;
  final double widthOfBoard;

  PlayersOnTableView({
    @required this.players,
    @required this.isBoardHorizontal,
    @required this.widthOfBoard,
    @required this.heightOfBoard,
    @required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    // am I on this table?
    PlayerModel me = this.players.me;

    return Transform(
      transform: BoardViewUtilMethods.getTransformationMatrix(
        isBoardHorizontal: isBoardHorizontal,
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: isBoardHorizontal ? Alignment.topLeft : Alignment.center,
        children: [
          // position the users
          ...this
              .getUserObjects(players.players)
              .asMap()
              .entries
              .map(
                (var u) => this.positionUser(
                  isBoardHorizontal: isBoardHorizontal,
                  user: u.value,
                  heightOfBoard: heightOfBoard,
                  widthOfBoard: widthOfBoard,
                  seatPos: getAdjustedSeatPosition(
                    u.key,
                    me != null,
                    me?.seatNo,
                  ),
                  isPresent: me != null,
                  onUserTap: onUserTap,
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  /* this method adjusts the server and local seat positions so that the
  current playing user is shown always at seat 1 */
  int getAdjustedSeatPosition(int pos, bool isPresent, int currentUserSeatNo) {
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

  /* this function is the link between the player model and the actual user shown in the table */
  List<UserObject> getUserObjects(List<PlayerModel> users) {
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

  /* this method helps to position the user in the table */
  Widget positionUser({
    @required bool isBoardHorizontal,
    UserObject user,
    double heightOfBoard,
    double widthOfBoard,
    int seatPos,
    bool isPresent,
    Function onUserTap,
  }) {
    seatPos++;

    Alignment cardsAlignment = Alignment.centerRight;

    // left for 6, 7, 8, 9
    if (seatPos == 6 || seatPos == 7 || seatPos == 8 || seatPos == 9)
      cardsAlignment = Alignment.centerLeft;

    PlayerView userView = PlayerView(
      isPresent: isPresent,
      seatPos: seatPos,
      key: ValueKey(seatPos),
      userObject: user,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    switch (seatPos) {
      case 1:
        return Positioned(
          bottom: 20,
          right: widthOfBoard / 2.2,
          child: userView,
        );
      case 2:
        return Positioned(
          bottom: 30,
          left: 10,
          child: userView,
        );
      case 3:
        return Positioned(
          bottom: 150,
          left: 0,
          child: userView,
        );
      case 4:
        return Positioned(
          top: -40,
          left: 0,
          child: userView,
        );

      case 5:
        return Positioned(
          top: -60,
          left: widthOfBoard / 3,
          child: userView,
        );

      case 6:
        return Positioned(
          top: -60,
          left: 1.8 * (widthOfBoard / 3),
          child: userView,
        );

      case 7:
        return Positioned(
          top: -30,
          right: 0,
          child: userView,
        );

      case 8:
        return Positioned(
          right: 0,
          bottom: 150,
          child: userView,
        );

      case 9:
        return Positioned(
          right: 30,
          bottom: 30,
          child: userView,
        );

      default:
        return Container();
    }
  }
}

/* this method helps to position the user in the table */
Widget positionUserOld({
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

  PlayerView userView = PlayerView(
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
            -heightOfBoard / 2.5,
          ),
          child: userView,
        ),
      );
    case 2:
      return Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(
            shiftHorizontalConstant - 10,
            heightOfBoard / 3,
          ),
          child: userView,
        ),
      );

    case 3:
      return Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(
            -20.0,
            isBoardHorizontal
                ? heightOfBoard / 2.5 - 100
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
            -25.0,
            isBoardHorizontal
                ? -heightOfBoard / 2 - 20
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
                ? -widthOfBoard / 3.8 + shiftHorizontalConstant + 20
                : -widthOfBoard / 3.8 + shiftHorizontalConstant,
            isBoardHorizontal ? -heightOfBoard / 10 : -shiftDownConstant / 1.5,
          ),
          child: userView,
        ),
      );

    case 6:
      return Align(
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: Offset(
            widthOfBoard / 5 - shiftHorizontalConstant,
            isBoardHorizontal ? -heightOfBoard / 10 : -shiftDownConstant / 1.5,
          ),
          child: userView,
        ),
      );

    case 7:
      return Align(
        alignment: Alignment.centerRight,
        child: Transform.translate(
          offset: Offset(
            15.0,
            isBoardHorizontal
                ? -heightOfBoard + 80
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
            15.0,
            isBoardHorizontal
                ? -heightOfBoard / 2 + 80
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
            heightOfBoard / 3,
          ),
          child: userView,
        ),
      );

    default:
      return Container();
  }
}
