import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_screen/user_object.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view.dart';

// user are seated as per array index starting from the bottom center as 0 and moving in clockwise direction

const horizontalPaddingWidth = 25.0;
const innerWidth = 5.0;
const outerWidth = 15.0;

const widthMultiplier = 0.80;
const heightMultiplier = 1.7;

class BoardView extends StatelessWidget {
  final List<UserObject> _users = [
    UserObject(
      name: 'Bob',
      chips: 102,
      avatarUrl: 'assets/images/2.png',
    ),
    UserObject(
      name: 'John',
      chips: 1235,
      avatarUrl: 'assets/images/1.png',
    ),
    UserObject(
      name: 'Arjun',
      chips: 250,
      avatarUrl: 'assets/images/3.png',
    ),
    UserObject(
      name: 'Ajay',
      chips: 450,
      avatarUrl: 'assets/images/1.png',
    ),
    UserObject(
      name: 'Keith',
      chips: 500,
      avatarUrl: 'assets/images/3.png',
    ),
    UserObject(
      name: 'Baker',
      chips: 675,
      avatarUrl: 'assets/images/2.png',
    ),
    UserObject(
      name: 'Luck',
      chips: 800,
      avatarUrl: 'assets/images/2.png',
    ),
    UserObject(
      name: 'Ramando',
      chips: 735,
      avatarUrl: 'assets/images/1.png',
    ),
    UserObject(
      name: 'Aditya',
      chips: 900,
      avatarUrl: 'assets/images/1.png',
    ),
  ];

  /* the following helper function builds the game board */
  Widget _buildGameBoard({double boardHeight, double boardWidth}) => Container(
        width: boardWidth,
        height: boardHeight,
        padding: EdgeInsets.all(innerWidth),
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
              spreadRadius: 1.0,
            )
          ],
          color: const Color(0xff646464),
          borderRadius: _borderRadius,
          border: Border.all(
            color: const Color(0xff6b451f),
            width: outerWidth,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: const RadialGradient(
              radius: 0.80,
              colors: const [
                const Color(0xff0d47a1),
                const Color(0xff08142b),
              ],
            ),
            borderRadius: _borderRadius,
          ),
        ),
      );

  Widget _positionUser(
      UserObject user, int index, double heightOfBoard, double widthOfBoard) {
    double shiftDownConstant = heightOfBoard / 15;

    switch (index) {
      case 0:
        return Align(
          alignment: Alignment.bottomCenter,
          child: UserView(
            userObject: user,
            cardsAlignment: Alignment.centerLeft,
          ),
        );

      case 1:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, heightOfBoard / 4 + shiftDownConstant),
            child: UserView(
              userObject: user,
            ),
          ),
        );

      case 2:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, 0.0 + shiftDownConstant),
            child: UserView(
              userObject: user,
            ),
          ),
        );

      case 3:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, -heightOfBoard / 4 + shiftDownConstant),
            child: UserView(
              userObject: user,
            ),
          ),
        );

      case 4:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(-widthOfBoard / 3, shiftDownConstant / 2),
            child: UserView(
              userObject: user,
            ),
          ),
        );

      case 5:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(widthOfBoard / 3, shiftDownConstant / 2),
            child: UserView(
              userObject: user,
              cardsAlignment: Alignment.centerLeft,
            ),
          ),
        );

      case 6:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, -heightOfBoard / 4 + shiftDownConstant),
            child: UserView(
              userObject: user,
              cardsAlignment: Alignment.centerLeft,
            ),
          ),
        );

      case 7:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, 0.0 + shiftDownConstant),
            child: UserView(
              userObject: user,
              cardsAlignment: Alignment.centerLeft,
            ),
          ),
        );

      case 8:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, heightOfBoard / 4 + shiftDownConstant),
            child: UserView(
              userObject: user,
              cardsAlignment: Alignment.centerLeft,
            ),
          ),
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double heightOfBoard = width * widthMultiplier * heightMultiplier;
    double widthOfBoard = width * widthMultiplier;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // game board
          _buildGameBoard(boardHeight: heightOfBoard, boardWidth: widthOfBoard),

          ..._users
              .asMap()
              .entries
              .map(
                (u) => _positionUser(
                  u.value,
                  u.key,
                  heightOfBoard,
                  widthOfBoard,
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

const _borderRadius = const BorderRadius.all(
  const Radius.circular(
    1000.0,
  ),
);
