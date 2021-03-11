import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/player_view.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';

// PlayersOnTableView encapsulates the players sitting on the table.
// This view uses Stack layout to place the UserView on top of the table.
class PlayersOnTableView extends StatefulWidget {
  final Function(int index) onUserTap;
  final Players players;
  final isBoardHorizontal;
  final double heightOfBoard;
  final double widthOfBoard;
  final GameComService gameComService;

  PlayersOnTableView({
    @required this.gameComService,
    @required this.players,
    @required this.isBoardHorizontal,
    @required this.widthOfBoard,
    @required this.heightOfBoard,
    @required this.onUserTap,
  });

  @override
  _PlayersOnTableViewState createState() => _PlayersOnTableViewState();
}

class _PlayersOnTableViewState extends State<PlayersOnTableView>
    with TickerProviderStateMixin {
  // for animation
  Animation<Offset> animation;
  AnimationController animationController;

  // find postion of parent widget
  GlobalKey key = GlobalKey();

  // hold position of user tile
  List<GlobalKey> keys = [];

  // some offset
  double offset = 30;

  // sender to receiver
  bool isAnimatating = false;
  AnimationController _lottieController;
  bool isLottieAnimationAnimating = false;
  Offset lottieAnimationPostion;
  int index;

  @override
  void initState() {
    keys = List.generate(widget.players.players.length, (index) => GlobalKey());
    widget.gameComService.chat.listen(onAnimation: this.onAnimation);
    animationHandlers();
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    animationController.dispose();
    super.dispose();
  }

  animationHandlers() {
    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _lottieController.addListener(() {
      if (_lottieController.isCompleted) {
        isLottieAnimationAnimating = false;
        _lottieController.reset();
      }
      setState(() {});
    });

    animationController.addListener(() {
      if (animationController.isCompleted) {
        Future.delayed(Duration(seconds: 1), () {
          isAnimatating = false;
          animationController.reset();
          isLottieAnimationAnimating = true;
          _lottieController.forward();
        });
      }
      setState(() {});
    });
  }

  void onAnimation(ChatMessage message) async {
    Offset from;
    Offset to;
    print(
        'Here ${message.messageId} from player ${message.fromSeat} to ${message.toSeat}. Animation id: ${message.animationId}');

    if (message.fromSeat == null || message.toSeat == null) {
      return;
    }

    /*
    * find postion of to and from user
    **/

    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final paretWidgetPositionRed = renderBoxRed.localToGlobal(Offset.zero);
    widget.players.players.forEach((element) {
      final RenderBox renderBoxRed =
          keys[element.seatNo - 1].currentContext.findRenderObject();
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
      if (element.seatNo == message.fromSeat) {
        from =
            Offset(positionRed.dx, positionRed.dy - paretWidgetPositionRed.dy);
      } else if (element.seatNo == message.toSeat) {
        to = Offset(positionRed.dx, positionRed.dy - paretWidgetPositionRed.dy);
        lottieAnimationPostion =
            Offset(positionRed.dx, positionRed.dy - paretWidgetPositionRed.dy);
      }
    });
    animation = Tween<Offset>(
      begin: from,
      end: to,
    ).animate(animationController);
    isAnimatating = true;
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // am I on this table?
    return Transform.translate(
      key: key,
      offset: Offset(
        0.0,
        -offset,
      ),
      child: Stack(
        alignment:
            widget.isBoardHorizontal ? Alignment.topLeft : Alignment.center,
        children: [
          // position the users
          ...getPlayers(),

          isAnimatating
              ? Positioned(
                  left: animation.value.dx,
                  top: animation.value.dy,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/animations/poop.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),

          isLottieAnimationAnimating
              ? Positioned(
                  top: lottieAnimationPostion.dy,
                  left: lottieAnimationPostion.dx,
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: Lottie.asset(
                      'assets/animations/poop.json',
                      controller: _lottieController,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  List<Widget> getPlayers() {
    PlayerModel me = this.widget.players.me;
    index = -1;
    return this.getUserObjects(widget.players.players).asMap().entries.map(
      (var u) {
        index++;
        return this.positionUser(
          key: keys[index],
          isBoardHorizontal: widget.isBoardHorizontal,
          user: u.value,
          heightOfBoard: widget.heightOfBoard,
          widthOfBoard: widget.widthOfBoard,
          seatPos: getAdjustedSeatPosition(
            u.key,
            me != null,
            me?.seatNo,
          ),
          isPresent: me != null,
          onUserTap: widget.onUserTap,
        );
      },
    ).toList();
  }

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

  Widget positionUser(
      {@required bool isBoardHorizontal,
      UserObject user,
      double heightOfBoard,
      double widthOfBoard,
      int seatPos,
      bool isPresent,
      Function onUserTap,
      GlobalKey key}) {
    seatPos++;

    Alignment cardsAlignment = Alignment.centerRight;

    // left for 6, 7, 8, 9
    if (seatPos == 6 || seatPos == 7 || seatPos == 8 || seatPos == 9)
      cardsAlignment = Alignment.centerLeft;

    PlayerView userView = PlayerView(
      globalKey: key,
      isPresent: isPresent,
      seatPos: seatPos,
      gameComService: widget.gameComService,
      key: ValueKey(seatPos),
      userObject: user,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    switch (seatPos) {
      case 1:

        // TODO: IF WE NEED TO SHIFT UP THIS PLAYER, USE TRANSLATE,
        // TODO: IT'S RECOMMENDED NOT TO USE POSITIONED, BECAUSE USING POSITIONED, CENTERING IS NOT POSSIBLE, AND WITHOUT THIS PLAYER IN CENTER, IT MAY LOOK BAD
        return Align(
          alignment: Alignment.bottomCenter,
          child: userView,
        );

      case 2:
        return Positioned(
          bottom: 20,
          left: 10,
          child: userView,
        );

      case 3:
        return Align(
          alignment: Alignment.centerLeft,
          child: userView,
        );

      case 4:
        return Positioned(
          top: 20,
          left: 10,
          child: userView,
        );

      case 5:
        return Positioned(
          top: 0,
          left: widthOfBoard / 3.5,
          child: userView,
        );

      case 6:
        return Positioned(
          top: 0,
          right: widthOfBoard / 3.5,
          child: userView,
        );

      case 7:
        return Positioned(
          top: 20,
          right: 10,
          child: userView,
        );

      case 8:
        return Align(
          alignment: Alignment.centerRight,
          child: userView,
        );

      case 9:
        return Positioned(
          bottom: 20,
          right: 10,
          child: userView,
        );

      default:
        return const SizedBox.shrink();
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
