import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view.dart';
import 'package:provider/provider.dart';

// user are seated as per array index starting from the bottom center as 0 and moving in clockwise direction

const horizontalPaddingWidth = 25.0;
const innerWidth = 5.0;
const outerWidth = 15.0;

const widthMultiplier = 0.80;
const heightMultiplier = 1.55;

class BoardView extends StatelessWidget {
  BoardView({
    @required this.onUserTap,
  });

  final Function(int index) onUserTap;

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

  Widget _positionUser({
    UserObject user,
    double heightOfBoard,
    double widthOfBoard,
    int seatPos,
    bool isPresent,
  }) {
    seatPos++;

    double shiftDownConstant = heightOfBoard / 12;
    double shiftHorizontalConstant = widthOfBoard / 15;
    Alignment cardsAlignment = Alignment.centerRight;

    // left for 6, 7, 8, 9
    if (seatPos == 6 || seatPos == 7 || seatPos == 8 || seatPos == 9)
      cardsAlignment = Alignment.centerLeft;

    UserView userView = UserView(
      isPresent: isPresent,
      seatPos: isPresent ? -1 : seatPos,
      key: ValueKey(seatPos),
      userObject: user,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    switch (seatPos) {
      case 1:
        return Transform.translate(
          offset: Offset(0.0, 0.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: userView,
          ),
        );

      case 2:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(
              shiftHorizontalConstant,
              heightOfBoard / 4 + shiftDownConstant,
            ),
            child: userView,
          ),
        );

      case 3:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, 0.0 + shiftDownConstant),
            child: userView,
          ),
        );

      case 4:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(0.0, -heightOfBoard / 4 + shiftDownConstant),
            child: userView,
          ),
        );

      case 5:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(
              -widthOfBoard / 3 + shiftHorizontalConstant,
              shiftDownConstant / 2,
            ),
            child: userView,
          ),
        );

      case 6:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(
              widthOfBoard / 3 - shiftHorizontalConstant,
              shiftDownConstant / 2,
            ),
            child: userView,
          ),
        );

      case 7:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, -heightOfBoard / 4 + shiftDownConstant),
            child: userView,
          ),
        );

      case 8:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(0.0, 0.0 + shiftDownConstant),
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

  String _getText(String tableStatus) {
    switch (tableStatus) {
      case AppConstants.TABLE_STATUS_NOT_ENOUGH_PLAYERS:
        return 'Waiting for more players';
      case AppConstants.TABLE_STATUS_WAITING_TO_BE_STARTED:
        return 'Waiting to be started';
    }

    return null;
  }

  Widget _buildCenterView({
    List<CardObject> cards,
    List<int> potChips,
    int potChipsUpdates,
    String tableStatus,
  }) {
    String _text = _getText(tableStatus);

    Widget tableStatusWidget = Align(
      key: ValueKey('tableStatusWidget'),
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
          _text ?? '',
          style: AppStyles.itemInfoTextStyleHeavy.copyWith(
            fontSize: 13,
          ),
        ),
      ),
    );

    /* if reached here, means, the game is RUNNING */
    /* The following view, shows the community cards
    * and the pot chips, if they are nulls, put the default values */

    if (potChips == null) potChips = [0];
    if (potChipsUpdates == null) potChipsUpdates = 0;
    if (cards == null) cards = const [];

    Widget tablePotAndCardWidget = Align(
      key: ValueKey('tablePotAndCardWidget'),
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
                    'Pot: ${potChips[0]}', // todo: at later point might need to show multiple pots - need to design UI
                    style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.cardHeight / 3),

          /* potUpdates view */
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.black26,
            ),
            child: Text(
              'Updated Pot: $potChipsUpdates',
              style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );

    return AnimatedSwitcher(
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      duration: AppConstants.animationDuration,
      reverseDuration: AppConstants.animationDuration,
      child: _text != null ? tableStatusWidget : tablePotAndCardWidget,
    );
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
    }

    return userObjects;
  }

  int _getAdjustedSeatPosition(int pos, bool isPresent, int currentUserSeatNo) {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heightOfBoard = width * widthMultiplier * heightMultiplier;
    double widthOfBoard = width * widthMultiplier;

    /* finally the view */
    return Consumer<Players>(
      builder: (_, Players players, __) {
        // dealing with players
        PlayerModel tmp = players.players.firstWhere(
          (u) => u.isMe,
          orElse: () => null,
        );
        bool isPresent = tmp != null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // game board
              _buildGameBoard(
                boardHeight: heightOfBoard,
                boardWidth: widthOfBoard,
              ),

              // position the users
              ...getUserObjects(players.players)
                  .asMap()
                  .entries
                  .map(
                    (var u) => _positionUser(
                      user: u.value,
                      heightOfBoard: heightOfBoard,
                      widthOfBoard: widthOfBoard,
                      seatPos: _getAdjustedSeatPosition(
                        u.key,
                        isPresent,
                        tmp?.seatNo,
                      ),
                      isPresent: isPresent,
                    ),
                  )
                  .toList(),

              // center view
              Consumer<TableState>(
                builder: (_, TableState tableState, __) => _buildCenterView(
                  cards: tableState.cards,
                  potChips: tableState.potChips,
                  potChipsUpdates: tableState.potChipsUpdates,
                  tableStatus: tableState.tableStatus,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

const _borderRadius = const BorderRadius.all(
  const Radius.circular(
    1000.0,
  ),
);
