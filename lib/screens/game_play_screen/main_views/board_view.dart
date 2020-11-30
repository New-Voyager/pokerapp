import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_in_seat_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
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
  BoardView({
    @required this.users,
    @required this.onUserTap,
    @required this.tableStatus,
  }) : assert(users != null);

  final Function(int index) onUserTap;
  final List<PlayerInSeatModel> users;
  final String tableStatus;

  final List<UserObject> userObjects = List.generate(
    9,
    (index) => UserObject(
      seatPosition: null,
      name: null,
      stack: null,
    ),
  );

  final List<CardObject> _cards = [
//    CardObject(
//      suit: AppConstants.blackClub,
//      label: 'Q',
//      color: Colors.black,
//    ),
//    CardObject(
//      suit: AppConstants.redHeart,
//      label: 'J',
//      color: Colors.red,
//    ),
//    CardObject(
//      suit: AppConstants.redDiamond,
//      label: 'K',
//      color: Colors.red,
//    ),
//    CardObject(
//      suit: AppConstants.redHeart,
//      label: '6',
//      color: Colors.red,
//    ),
//    CardObject(
//      suit: AppConstants.blackSpade,
//      label: '5',
//      color: Colors.black,
//    ),
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
    int index,
  ) {
    double shiftDownConstant = heightOfBoard / 15;

    Alignment cardsAlignment = Alignment.centerRight;

    // left for 5, 6, 7, 8
    if (index == 5 || index == 6 || index == 7 || index == 8)
      cardsAlignment = Alignment.centerLeft;

    UserView userView = UserView(
      index: index,
      key: ValueKey(index),
      userObject: user,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    switch (index) {
      case 0:
        return Align(
          alignment: Alignment.bottomCenter,
          child: userView,
        );

      case 1:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, heightOfBoard / 4 + shiftDownConstant),
            child: userView,
          ),
        );

      case 2:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, 0.0 + shiftDownConstant),
            child: userView,
          ),
        );

      case 3:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, -heightOfBoard / 4 + shiftDownConstant),
            child: userView,
          ),
        );

      case 4:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(-widthOfBoard / 3, shiftDownConstant / 2),
            child: userView,
          ),
        );

      case 5:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(widthOfBoard / 3, shiftDownConstant / 2),
            child: userView,
          ),
        );

      case 6:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, -heightOfBoard / 4 + shiftDownConstant),
            child: userView,
          ),
        );

      case 7:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, 0.0 + shiftDownConstant),
            child: userView,
          ),
        );

      case 8:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, heightOfBoard / 4 + shiftDownConstant),
            child: userView,
          ),
        );

      default:
        return Container();
    }
  }

  String _getText() {
    switch (tableStatus) {
      case AppConstants.TABLE_STATUS_NOT_ENOUGH_PLAYERS:
        return 'Waiting for more players';
      case AppConstants.TABLE_STATUS_WAITING_TO_BE_STARTED:
        return 'Waiting to be started';
    }

    return '';
  }

  Widget _buildCenterView({
    List<CardObject> cards = const [],
    int potChips = 0,
  }) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.black26,
        ),
        child: Text(
          _getText(),
          style: AppStyles.itemInfoTextStyleHeavy.copyWith(
            fontSize: 15,
          ),
        ),
      ),
    );

    /*
    // showing the POT value along with the chips
    return Align(
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
    );*/
  }

  void seatPlayers() {
    for (PlayerInSeatModel model in users) {
      int idx = model.seatNo - 1;
      userObjects[idx].name = model.name;
      userObjects[idx].seatPosition = model.seatNo - 1;
      userObjects[idx].isMe = model.isMe;
      userObjects[idx].stack = model.stack;
    }
  }

  @override
  Widget build(BuildContext context) {
    // this method runs in every frame
    seatPlayers();

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
          ...userObjects
              .asMap()
              .entries
              .map(
                (var u) => _positionUser(
                  u.value,
                  heightOfBoard,
                  widthOfBoard,
                  u.key,
                ),
              )
              .toList(),

          // center view
          _buildCenterView(
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
