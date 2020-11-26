import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/card_object.dart';
import 'package:pokerapp/models/game_play_models/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
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
      seatPosition: 0,
      name: 'Bob',
      chips: 102,
      avatarUrl: 'assets/images/2.png',
    ),
    UserObject(
      seatPosition: 1,
      name: 'John',
      chips: 1235,
      avatarUrl: 'assets/images/1.png',
    ),
    UserObject(
      seatPosition: 2,
      name: 'Arjun',
      chips: 250,
      avatarUrl: 'assets/images/3.png',
    ),
    UserObject(
      seatPosition: 3,
      name: 'Ajay',
      chips: 450,
      avatarUrl: 'assets/images/1.png',
    ),
    UserObject(
      seatPosition: 4,
      name: 'Keith',
      chips: 500,
      avatarUrl: 'assets/images/3.png',
    ),
    UserObject(
      seatPosition: 5,
      name: 'Baker',
      chips: 675,
      avatarUrl: 'assets/images/2.png',
    ),
    UserObject(
      seatPosition: 6,
      name: 'Luck',
      chips: 800,
      avatarUrl: 'assets/images/2.png',
    ),
    UserObject(
      seatPosition: 7,
      name: 'Ramando',
      chips: 735,
      avatarUrl: 'assets/images/1.png',
    ),
    UserObject(
      seatPosition: 8,
      name: 'Aditya',
      chips: 900,
      avatarUrl: 'assets/images/1.png',
    ),
  ];

  final List<CardObject> _cards = [
    CardObject(
      suit: AppConstants.blackClub,
      label: 'Q',
      color: Colors.black,
    ),
    CardObject(
      suit: AppConstants.redHeart,
      label: 'J',
      color: Colors.red,
    ),
    CardObject(
      suit: AppConstants.redDiamond,
      label: 'K',
      color: Colors.red,
    ),
    CardObject(
      suit: AppConstants.redHeart,
      label: '6',
      color: Colors.red,
    ),
    CardObject(
      suit: AppConstants.blackSpade,
      label: '5',
      color: Colors.black,
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
    UserObject user,
    double heightOfBoard,
    double widthOfBoard,
  ) {
    double shiftDownConstant = heightOfBoard / 15;

    switch (user.seatPosition) {
      case 0:
        return Align(
          alignment: Alignment.bottomCenter,
          child: UserView(
            userObject: user,
            isMe: true,
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

  Widget _buildCenterCardView({
    List<CardObject> cards = const [],
    int potChips = 0,
  }) =>
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // card stacks
            StackCardView(
              cards: cards,
              center: true,
            ),

            const SizedBox(height: AppDimensions.cardHeight / 2),

            // pot value
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.black26,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // chip image
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/chips.png',
                      height: 25.0,
                    ),
                  ),

                  // pot amount text
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 15.0,
                      top: 5.0,
                      bottom: 5.0,
                      left: 5.0,
                    ),
                    child: Text(
                      'Pot: $potChips.1 K',
                      style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

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

          // position the users
          ..._users
              .map(
                (UserObject user) => _positionUser(
                  user,
                  heightOfBoard,
                  widthOfBoard,
                ),
              )
              .toList(),

          // center view
          _buildCenterCardView(
            cards: _cards,
            potChips: 15,
          ),
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
