import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view.dart';
import 'package:provider/provider.dart';

import '../board_positions.dart';

// user are seated as per array index starting from the bottom center as 0 and moving in clockwise direction

const horizontalPaddingWidth = 25.0;

const widthMultiplier = 0.78;
const heightMultiplier = 1.40;

class BoardView extends StatelessWidget {
  BoardView({
    @required this.onUserTap,
    @required this.onStartGame,
  });

  final Function(int index) onUserTap;
  final Function() onStartGame;

  Widget _positionUser({
    BoardObject board,
    UserObject user,
    double heightOfBoard,
    double widthOfBoard,
    int seatPos,
    bool isPresent,
  }) {
    seatPos++;

    double shiftDownConstant = heightOfBoard / 20;
    double shiftHorizontalConstant = widthOfBoard / 15;
    Alignment cardsAlignment = Alignment.centerRight;

    if (board.horizontal) {
      shiftDownConstant += 20;
    }

    // left for 6, 7, 8, 9
    if (seatPos == 6 || seatPos == 7 || seatPos == 8 || seatPos == 9)
      cardsAlignment = Alignment.centerLeft;

    UserView userView = UserView(
      board: board,
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
                board.horizontal
                    ? -50.0 + shiftDownConstant
                    : -30.0 + shiftDownConstant),
            child: userView,
          ),
        );

      case 4:
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(
            offset: Offset(
                0.0,
                board.horizontal
                    ? -heightOfBoard / 2
                    : -heightOfBoard / 2.8 + shiftDownConstant),
            child: userView,
          ),
        );

      case 5:
        return Align(
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(
              board.horizontal
                  ? -widthOfBoard / 3.8 + shiftHorizontalConstant + 30
                  : -widthOfBoard / 3.8 + shiftHorizontalConstant,
              board.horizontal ? -50 : -shiftDownConstant / 1.5,
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
              board.horizontal ? -50 : -shiftDownConstant / 1.5,
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
                board.horizontal
                    ? -heightOfBoard / 2
                    : -heightOfBoard / 2.8 + shiftDownConstant),
            child: userView,
          ),
        );

      case 8:
        return Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(
                0.0,
                board.horizontal
                    ? -50.0 + shiftDownConstant
                    : -30.0 + shiftDownConstant),
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
      case AppConstants.WAITING_TO_BE_STARTED:
        return 'Tap to start the game';
      case AppConstants.GAME_ENDED:
        return 'Game Ended';
      case AppConstants.NEW_HAND:
        return tableStatus;
    }

    return null;
  }

  Widget _buildCenterView({
    BoardObject board,
    List<CardObject> cards,
    List<int> potChips,
    int potChipsUpdates,
    String tableStatus,
    bool showDown = false,
  }) {
    String _text = showDown ? null : _getText(tableStatus);

    /* in case of new hand, show the deck shuffling animation */
    if (_text == AppConstants.NEW_HAND)
      return Transform.scale(
        scale: 1.5,
        child: AnimatingShuffleCardView(),
      );

    Widget tableStatusWidget = Align(
      key: ValueKey('tableStatusWidget'),
      alignment: Alignment.center,
      child: GestureDetector(
          onTap: () {
            if (tableStatus == AppConstants.WAITING_TO_BE_STARTED) {
              onStartGame();
            }
          },
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
          )),
    );

    /* if reached here, means, the game is RUNNING */
    /* The following view, shows the community cards
    * and the pot chips, if they are nulls, put the default values */

    if (potChips == null) potChips = [0];
    if (cards == null) cards = const [];

    EdgeInsets communityMargin = EdgeInsets.zero;
    EdgeInsets potMargin = EdgeInsets.only(top: 140);
    if (board.horizontal) {
      communityMargin = EdgeInsets.only(bottom: 90.0);
      potMargin = EdgeInsets.only(top: 80);
    }

    Widget tablePotAndCardWidget = Align(
        key: ValueKey('tablePotAndCardWidget'),
        alignment: Alignment.topCenter,
        child: Container(
          margin: potMargin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* rankStr --> needs to be shown only when footer result is not null */
              Consumer<FooterResult>(
                builder: (_, FooterResult footerResult, __) => AnimatedSwitcher(
                  duration: AppConstants.animationDuration,
                  reverseDuration: AppConstants.animationDuration,
                  child: footerResult.isEmpty
                      ? const SizedBox.shrink()
                      : Transform.translate(
                          offset: Offset(
                            0.0,
                            -AppDimensions.cardHeight / 2,
                          ),
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
                              footerResult.potWinners.first.rankStr,
                              style: AppStyles.footerResultTextStyle4,
                            ),
                          ),
                        ),
                ),
              ),

              // pot value
              Opacity(
                opacity: showDown ? 0 : 1,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
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
              ),

              // card stacks
              Container(
                margin: communityMargin,
                child: StackCardView(
                  cards: cards,
                  center: true,
                  isCommunity: true,
                ),
              ),

              const SizedBox(height: AppDimensions.cardHeight / 2),

              const SizedBox(height: AppDimensions.cardHeight / 3),

              /* potUpdates view */
              Opacity(
                opacity: showDown || (potChipsUpdates == null) ? 0 : 1,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.black26,
                    ),
                    child: Visibility(
                      visible: potChipsUpdates != null && potChipsUpdates != 0,
                      child: Text(
                        'Current: $potChipsUpdates',
                        style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ));

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
    final boardState = Provider.of<BoardObject>(context);

    dynamic layoutCoords = LAYOUT_COORDS[BoardLayout.VERTICAL];
    if (boardState.horizontal) {
      widthOfBoard = MediaQuery.of(context).size.width;
      heightOfBoard = MediaQuery.of(context).size.height / 4;
      layoutCoords = LAYOUT_COORDS[BoardLayout.HORIZONTAL];
    }

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
          padding: EdgeInsets.symmetric(
              horizontal: layoutCoords[SIDE_PADDING],
              vertical: boardState.horizontal ? 120 : 30),
          child: Stack(
            alignment:
                boardState.horizontal ? Alignment.topCenter : Alignment.center,
            children: [
              // game board
              TableView(heightOfBoard, widthOfBoard),

              // position the users
              ...getUserObjects(players.players)
                  .asMap()
                  .entries
                  .map(
                    (var u) => _positionUser(
                      board: boardState,
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
              Consumer2<TableState, ValueNotifier<FooterStatus>>(
                builder: (_,
                        TableState tableState,
                        ValueNotifier<FooterStatus> valueNotifierFooterStatus,
                        __) =>
                    _buildCenterView(
                  board: boardState,
                  cards: tableState.cards,
                  potChips: tableState.potChips,
                  potChipsUpdates: tableState.potChipsUpdates,
                  tableStatus: tableState.tableStatus,
                  showDown:
                      valueNotifierFooterStatus.value == FooterStatus.Result,
                ),
              ),

              /* distributing card animation widgets */
              CardDistributionAnimatingWidget(),
            ],
          ),
        );
      },
    );
  }
}
