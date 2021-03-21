import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/name_plate_view.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/player_view.dart';
import 'package:pokerapp/services/game_play/game_chat_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';

// PlayersOnTableView encapsulates the players sitting on the table.
// This view uses Stack layout to place the UserView on top of the table.
class PlayersOnTableView extends StatefulWidget {
  final Function(int index) onUserTap;
  final Players players;
  final isBoardHorizontal;
  final double heightOfBoard;
  final double widthOfBoard;
  final GameComService gameComService;
  final int maxPlayers;

  PlayersOnTableView({
    @required this.gameComService,
    @required this.players,
    @required this.isBoardHorizontal,
    @required this.widthOfBoard,
    @required this.heightOfBoard,
    @required this.onUserTap,
    @required this.maxPlayers,
  });

  @override
  _PlayersOnTableViewState createState() => _PlayersOnTableViewState();
}

class _PlayersOnTableViewState extends State<PlayersOnTableView>
    with TickerProviderStateMixin {
  // for animation
  Animation<Offset> animation;
  AnimationController animationController;

  //seat change animation controller
  Animation<Offset> seatChangeAnimation;
  AnimationController seatChangeAnimationController;

  // find postion of parent widget
  GlobalKey key = GlobalKey();

  // hold position of user tile
  List<GlobalKey> keys = [];

  // some offset
  double offset = 30;

  // sender to receiver
  bool isAnimatating = false;
  bool isSeatChanging = false;
  AnimationController _lottieController;
  bool isLottieAnimationAnimating = false;
  Offset lottieAnimationPostion;
  int index;

  Offset SeatChangefrom, SeactChangeto;
  HostSeatChange hostSeatChange;
  bool isSeatReverseChanged = false;
  int seatChangerPlayer;
  int seatChangeTo;
  @override
  void initState() {
    keys = List.generate(9, (index) => GlobalKey());
    widget.gameComService.chat.listen(onAnimation: this.onAnimation);
    animationHandlers();
    seatChangeAnimationHandler();
    super.initState();
  }

  seatChangeAnimationHandler() {
    Provider.of<HostSeatChange>(
      context,
      listen: false,
    ).addListener(() {
      hostSeatChange = Provider.of<HostSeatChange>(
        context,
        listen: false,
      );
      print(
          "provider data is changed and get notified ${hostSeatChange.fromSeatNo} ${hostSeatChange.toSeatNo}");
      if (hostSeatChange.fromSeatNo != null &&
          hostSeatChange.toSeatNo != null &&
          hostSeatChange.toSeatNo != hostSeatChange.fromSeatNo) {
        final positions = findPostionOfFromAndTouser(
            fromSeat: hostSeatChange.fromSeatNo,
            toSeat: hostSeatChange.toSeatNo);
        seatChangerPlayer = hostSeatChange.fromSeatNo;
        seatChangeTo = hostSeatChange.toSeatNo;
        SeatChangefrom = positions[0];
        SeactChangeto = positions[1];
        seatChangeAnimation = Tween<Offset>(
          begin: SeatChangefrom,
          end: SeactChangeto,
        ).animate(seatChangeAnimationController);
        isSeatChanging = true;
        isSeatReverseChanged = false;
        seatChangeAnimationController.forward();
      }
    });
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

    seatChangeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _lottieController.addListener(() {
      if (_lottieController.isCompleted) {
        isLottieAnimationAnimating = false;
        _lottieController.reset();
      }
      setState(() {});
    });

    seatChangeAnimationController.addListener(() {
      if (seatChangeAnimationController.isCompleted) {
        if (!isSeatReverseChanged) {
          seatChangerPlayer = seatChangeTo;
          isSeatReverseChanged = true;
          Future.delayed(Duration(seconds: 1), () {
            seatChangeAnimationController.reset();
            seatChangeAnimation = Tween<Offset>(
              begin: SeactChangeto,
              end: SeatChangefrom,
            ).animate(seatChangeAnimationController);
            isSeatChanging = false;
            seatChangeAnimationController.forward();
          });
        } else {
          seatChangeAnimationController.reset();
          setState(() {
            isSeatReverseChanged = false;
          });
        }
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
    final positions = findPostionOfFromAndTouser(
        fromSeat: message.fromSeat, toSeat: message.toSeat);
    from = positions[0];
    to = positions[1];
    animation = Tween<Offset>(
      begin: from,
      end: to,
    ).animate(animationController);
    isAnimatating = true;
    animationController.forward();
  }

  List<Offset> findPostionOfFromAndTouser({int fromSeat, int toSeat}) {
    Offset from, to;
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final paretWidgetPositionRed = renderBoxRed.localToGlobal(Offset.zero);
    widget.players.players.forEach((element) {
      final RenderBox renderBoxRed =
          keys[element.seatNo - 1].currentContext.findRenderObject();
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
      if (element.seatNo == fromSeat) {
        from =
            Offset(positionRed.dx, positionRed.dy - paretWidgetPositionRed.dy);
      } else if (element.seatNo == toSeat) {
        to = Offset(positionRed.dx, positionRed.dy - paretWidgetPositionRed.dy);
        lottieAnimationPostion =
            Offset(positionRed.dx, positionRed.dy - paretWidgetPositionRed.dy);
      }
    });
    return [from, to];
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

          isSeatReverseChanged || isSeatChanging
              ? Positioned(
                  left: seatChangeAnimation.value.dx,
                  top: seatChangeAnimation.value.dy + 32,
                  child: NamePlateWidget(
                      getSeats(
                          widget.players.players)[seatChangerPlayer - 1],
                      0,
                      false),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  List<Widget> getPlayers() {
    PlayerModel me = this.widget.players.me;
    index = -1;
    final seats = this.getSeats(widget.players.players).asMap().entries.map(
      (var u) {
        index++;
        return this._positionedForUsers(
          key: keys[index],
          isBoardHorizontal: widget.isBoardHorizontal,
          seat: u.value,
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
    return seats;
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

  List<Seat> getSeats(List<PlayerModel> users) {
    /* build an empty user object list
    *  This is done, because all the empty seats are
    *  also UserObject objects, and we need all
    * the 9 objects in an array to build the entire table + users
    * */

    final List<Seat> seats = [];
    for(int i = 0; i < widget.maxPlayers; i++) {
      seats.add(Seat(i, i+1, null));
    }
    for (PlayerModel model in users) {
      int idx = model.seatNo - 1;

      seats[idx] = Seat(idx, model.seatNo, model);
      // userObjects[idx].serverSeatPos = model.seatNo;
      // userObjects[idx].isMe = model.isMe;
      // userObjects[idx].stack = model.stack;
      // userObjects[idx].status = model.status;
      // userObjects[idx].buyIn = (model.showBuyIn ?? false) ? model.buyIn : null;
      // userObjects[idx].highlight = model.highlight;
      // userObjects[idx].playerType = model.playerType;
      // userObjects[idx].avatarUrl = model.avatarUrl;
      // userObjects[idx].playerFolded = model.playerFolded;
      // userObjects[idx].cards = model.cards;
      // userObjects[idx].highlightCards = model.highlightCards;
      // userObjects[idx].winner = model.winner;
      // userObjects[idx].coinAmount = model.coinAmount;
      // userObjects[idx].animatingCoinMovement = model.animatingCoinMovement;
      // userObjects[idx].noOfCardsVisible = model.noOfCardsVisible ?? 0;
      // userObjects[idx].animatingFold = model.animatingFold;
      // userObjects[idx].animatingCoinMovementReverse =
      //     model.animatingCoinMovementReverse;
      // userObjects[idx].showFirework = model.showFirework ?? false;
    }

    return seats;
  }

  Widget _positionedForUsers(
      {@required bool isBoardHorizontal,
      Seat seat,
      double heightOfBoard,
      double widthOfBoard,
      int seatPos,
      bool isPresent,
      Function onUserTap,
      GlobalKey key}) {
    if (widget.maxPlayers == 2) {
      return positionUser_2(
          isBoardHorizontal: isBoardHorizontal,
          seat: seat,
          heightOfBoard: heightOfBoard,
          widthOfBoard: widthOfBoard,
          seatPos: seatPos,
          isPresent: isPresent,
          onUserTap: onUserTap,
          key: key);
    } else if (widget.maxPlayers == 4) {
      return positionUser_4(
          isBoardHorizontal: isBoardHorizontal,
          seat: seat,
          heightOfBoard: heightOfBoard,
          widthOfBoard: widthOfBoard,
          seatPos: seatPos,
          isPresent: isPresent,
          onUserTap: onUserTap,
          key: key);
    } else if (widget.maxPlayers == 6) {
      return positionUser_6(
          isBoardHorizontal: isBoardHorizontal,
          seat: seat,
          heightOfBoard: heightOfBoard,
          widthOfBoard: widthOfBoard,
          seatPos: seatPos,
          isPresent: isPresent,
          onUserTap: onUserTap,
          key: key);
    } else if (widget.maxPlayers == 8) {
      return positionUser_8(
          isBoardHorizontal: isBoardHorizontal,
          seat: seat,
          heightOfBoard: heightOfBoard,
          widthOfBoard: widthOfBoard,
          seatPos: seatPos,
          isPresent: isPresent,
          onUserTap: onUserTap,
          key: key);
    }

    return positionUser(
        isBoardHorizontal: isBoardHorizontal,
        seat: seat,
        heightOfBoard: heightOfBoard,
        widthOfBoard: widthOfBoard,
        seatPos: seatPos,
        isPresent: isPresent,
        onUserTap: onUserTap,
        key: key);
  }

  Widget positionUser(
      {@required bool isBoardHorizontal,
      Seat seat,
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
      seat: seat,
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

  Widget positionUser_2(
      {@required bool isBoardHorizontal,
      Seat seat,
      double heightOfBoard,
      double widthOfBoard,
      int seatPos,
      bool isPresent,
      Function onUserTap,
      GlobalKey key}) {
    seatPos++;

    Alignment cardsAlignment = Alignment.centerRight;

    PlayerView userView = PlayerView(
      isPresent: isPresent,
      seatPos: seatPos,
      key: ValueKey(seatPos),
      seat: seat,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
      globalKey: key,
      gameComService: widget.gameComService,
    );

    switch (seatPos) {
      case 1:
        return Align(
          alignment: Alignment.bottomCenter,
          child: userView,
        );

      case 2:
        return Align(
          alignment: Alignment.topCenter,
          child: userView,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget positionUser_4(
      {@required bool isBoardHorizontal,
      Seat seat,
      double heightOfBoard,
      double widthOfBoard,
      int seatPos,
      bool isPresent,
      Function onUserTap,
      GlobalKey key}) {
    seatPos++;

    Alignment cardsAlignment = Alignment.centerRight;

    if (seatPos == 2) cardsAlignment = Alignment.centerLeft;

    PlayerView userView = PlayerView(
      isPresent: isPresent,
      seatPos: seatPos,
      key: ValueKey(seatPos),
      seat: seat,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
      globalKey: key,
      gameComService: widget.gameComService,
    );

    switch (seatPos) {
      case 1:
        return Align(
          alignment: Alignment.bottomCenter,
          child: userView,
        );

      case 2:
        return Align(
          alignment: Alignment.centerLeft,
          child: userView,
        );

      case 3:
        return Align(
          alignment: Alignment.topCenter,
          child: userView,
        );

      case 4:
        return Align(
          alignment: Alignment.centerRight,
          child: userView,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget positionUser_6(
      {@required bool isBoardHorizontal,
      Seat seat,
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
      isPresent: isPresent,
      seatPos: seatPos,
      key: ValueKey(seatPos),
      seat: seat,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
      globalKey: key,
      gameComService: widget.gameComService,
    );

    switch (seatPos) {
      case 1:
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
        return Positioned(
          top: 20,
          left: 10,
          child: userView,
        );

      case 4:
        return Align(
          alignment: Alignment.topCenter,
          child: userView,
        );

      case 5:
        return Positioned(
          top: 20,
          right: 10,
          child: userView,
        );

      case 6:
        return Positioned(
          bottom: 20,
          right: 10,
          child: userView,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget positionUser_8(
      {@required bool isBoardHorizontal,
      Seat seat,
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
      isPresent: isPresent,
      seatPos: seatPos,
      key: ValueKey(seatPos),
      seat: seat,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
      globalKey: key,
      gameComService: widget.gameComService,
    );

    switch (seatPos) {
      case 1:
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
        return Align(
          alignment: Alignment.topCenter,
          child: userView,
        );

      case 6:
        return Positioned(
          top: 20,
          right: 10,
          child: userView,
        );

      case 7:
        return Align(
          alignment: Alignment.centerRight,
          child: userView,
        );

      case 8:
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
