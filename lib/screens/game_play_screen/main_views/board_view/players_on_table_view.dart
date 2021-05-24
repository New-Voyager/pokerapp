import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/name_plate_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/player_view.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';

const double _lottieAnimationContainerSize = 120.0;
const double _animatingAssetContainerSize = 40.0;

// const Duration _durationWaitBeforeExplosion = const Duration(milliseconds: 10);
const Duration _lottieAnimationDuration = const Duration(milliseconds: 5000);
const Duration _animatingWidgetDuration = const Duration(milliseconds: 1000);

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

  // find positions of parent widget
  GlobalKey _parentKey = GlobalKey();

  // hold position of user tile
  //List<GlobalKey> _playerKeys = [];

  // some offset
  double offset = 0;

  // sender to receiver
  bool isAnimating = false;
  bool isSeatChanging = false;
  AnimationController _lottieController;
  bool isLottieAnimationAnimating = false;
  Offset lottieAnimationPosition;
  int index;

  Offset seatChangeFrom, seatChangeTo;
  HostSeatChange hostSeatChange;
  int seatChangerPlayer;
  int seatChangeToo;

  String animationAssetID;

  @override
  void initState() {
    // todo: commented onAnimation
    widget.gameComService?.gameMessaging?.listen(onAnimation: this.onAnimation);
    animationHandlers();
    _seatChangeAnimationHandler();
    // seatChangeAnimationHandler_old();
    super.initState();
  }

  void _seatChangeAnimationHandler() {
    final HostSeatChange hostSeatChange = Provider.of<HostSeatChange>(
      context,
      listen: false,
    );

    /* initialize the animation controller */
    seatChangeAnimationController = AnimationController(
      vsync: this,
      duration: AppConstants.seatChangeAnimationDuration,
    );

    /* TODO: CAN BE MADE EFFICIENT USING ANIMATION BUILDER */
    /* refresh, when the animation plays */
    seatChangeAnimationController.addListener(() => setState(() {
          if (seatChangeAnimationController.isCompleted) isSeatChanging = false;
        }));

    /* listen for changes in the host seat change model, to trigger seat change animation */
    hostSeatChange.addListener(() {
      final int fromSeatNo = hostSeatChange.fromSeatNo;
      final int toSeatNo = hostSeatChange.toSeatNo;

      print('seat change data: $fromSeatNo and $toSeatNo');

      if (fromSeatNo == null || toSeatNo == null) return;
      if (fromSeatNo == 0 || toSeatNo == 0) return;

      final positions = findPositionOfFromAndToUser(
        fromSeat: fromSeatNo,
        toSeat: toSeatNo,
      );
      seatChangerPlayer = hostSeatChange.fromSeatNo;
      seatChangeToo = hostSeatChange.toSeatNo;

      seatChangeFrom = positions[0];
      seatChangeTo = positions[1];

      seatChangeAnimationController.reset();

      seatChangeAnimation = Tween<Offset>(
        begin: seatChangeFrom,
        end: seatChangeTo,
      ).animate(seatChangeAnimationController);

      seatChangeAnimationController.forward();

      isSeatChanging = true;
    });
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    animationController?.dispose();
    seatChangeAnimationController?.dispose();
    super.dispose();
  }

  animationHandlers() {
    _lottieController = AnimationController(
      vsync: this,
      duration: _lottieAnimationDuration,
    );

    animationController = AnimationController(
      vsync: this,
      duration: _animatingWidgetDuration,
    );

    _lottieController.addListener(() {
      /* after the lottie animation is completed reset everything */
      if (_lottieController.isCompleted) {
        setState(() {
          isLottieAnimationAnimating = false;
        });

        _lottieController.reset();
      }
    });

    animationController.addListener(() async {
      if (animationController.isCompleted) {
        /* wait before the explosion */
        // await Future.delayed(_durationWaitBeforeExplosion);

        isAnimating = false;
        animationController.reset();

        /* finally drive the lottie animation */

        setState(() {
          isLottieAnimationAnimating = true;
        });
        _lottieController.forward();
      }
    });
  }

  void onAnimation(ChatMessage message) async {
    Offset from;
    Offset to;
    print(
      'Here ${message.messageId} from player ${message.fromSeat} to ${message.toSeat}. Animation: ${message.animationID}',
    );

    if (message.fromSeat == null || message.toSeat == null) {
      return;
    }

    /*
    * find position of to and from user
    **/
    final positions = findPositionOfFromAndToUser(
      fromSeat: message.fromSeat,
      toSeat: message.toSeat,
    );

    final Size playerWidgetSize = getPlayerWidgetSize(message.toSeat);

    from = positions[0];
    to = positions[1];

    /* get the middle point for the animated to player */
    final Offset toMod = Offset(
      to.dx + (playerWidgetSize.width / 2) - _animatingAssetContainerSize / 2,
      to.dy + (playerWidgetSize.height / 2) - _animatingAssetContainerSize / 2,
    );

    animation = Tween<Offset>(
      begin: from,
      end: toMod,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    // set the lottie animation position
    lottieAnimationPosition = Offset(
      to.dx + (playerWidgetSize.width / 2) - _lottieAnimationContainerSize / 2,
      to.dy + (playerWidgetSize.height / 2) - _lottieAnimationContainerSize / 2,
    );

    setState(() {
      animationAssetID = message.animationID;
      isAnimating = true;
    });

    animationController.forward();
  }

  Offset getPositionOffsetFromKey(GlobalKey key) {
    final RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero);
  }

  Size getPlayerWidgetSize(int seatNo) {
    final gameState = GameState.getState(context);

    final seat = gameState.getSeat(context, seatNo);
    final RenderBox renderBox = seat.key.currentContext.findRenderObject();

    return renderBox.size;
  }

  List<Offset> findPositionOfFromAndToUser({
    int fromSeat,
    int toSeat,
  }) {
    /* get parent position */
    //final parentWidgetPosition = getPositionOffsetFromKey(_parentKey);

    final gameState = GameState.getState(context);
    //final tableState = gameState.getTableState(context);

    final from = gameState.getSeat(context, fromSeat);
    final to = gameState.getSeat(context, toSeat);

    /* get from player position */
    final fromPlayerWidgetPosition = getPositionOffsetFromKey(from.key);

    /* get to player position */
    final toPlayerWidgetPosition = getPositionOffsetFromKey(to.key);

    final RenderBox parentBox =
        this._parentKey.currentContext.findRenderObject();
    Offset fromOffset = parentBox.globalToLocal(fromPlayerWidgetPosition);
    Offset toOffset = parentBox.globalToLocal(toPlayerWidgetPosition);

    return [fromOffset, toOffset];
  }

  @override
  Widget build(BuildContext context) {
    // am I on this table?
    return Transform.translate(
      key: _parentKey,
      offset: Offset(
        0.0,
        -offset,
      ),
      child: Stack(
        alignment:
            widget.isBoardHorizontal ? Alignment.topLeft : Alignment.center,
        children: [
          // position the users

          ...getPlayers(context),

          isAnimating && animation != null
              ? AnimatedBuilder(
                  child: Container(
                    height: _animatingAssetContainerSize,
                    width: _animatingAssetContainerSize,
                    child: SvgPicture.asset(
                      'assets/animations/$animationAssetID.svg',
                    ),
                  ),
                  animation: animation,
                  builder: (_, child) => Transform.translate(
                    offset: animation.value,
                    child: child,
                  ),
                )
              : SizedBox.shrink(),

          isLottieAnimationAnimating
              ? Transform.translate(
                  offset: lottieAnimationPosition,
                  child: Container(
                    height: _lottieAnimationContainerSize,
                    width: _lottieAnimationContainerSize,
                    child: Lottie.asset(
                      'assets/animations/$animationAssetID.json',
                      controller: _lottieController,
                    ),
                  ),
                )
              : SizedBox.shrink(),

          isSeatChanging
              ? Positioned(
                  left: seatChangeAnimation.value.dx,
                  top: seatChangeAnimation.value.dy,
                  child: Consumer<BoardAttributesObject>(
                    builder: (_, boardAttributes, __) => NamePlateWidget(
                      getSeats(context, widget.players.players)[
                          seatChangerPlayer - 1],
                      globalKey: null,
                      boardAttributes: boardAttributes,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  List<Widget> getPlayers(BuildContext context) {
    // todo: THIS MAY INTRODUCE A BUG?
    // PlayerModel me = this.widget.players.me;
    final gameState = GameState.getState(context);

    final currPlayerID = gameState.currentPlayerId;
    PlayerModel me = this
        .widget
        .players
        .players
        .firstWhere((p) => p.playerId == currPlayerID);

    final maxPlayers = gameState.gameInfo.maxPlayers;
    index = -1;
    // update seat states in game state
    final seatsState = this.getSeats(context, widget.players.players);
    final boardAttribs =
        Provider.of<BoardAttributesObject>(context, listen: false);

    final seats = seatsState.asMap().entries.map(
      (var u) {
        index++;
        return this._positionedForUsers(
          boardAttribs: boardAttribs,
          isBoardHorizontal: widget.isBoardHorizontal,
          seat: u.value,
          heightOfBoard: widget.heightOfBoard,
          widthOfBoard: widget.widthOfBoard,
          seatPos: getAdjustedSeatPosition(
            u.key,
            maxPlayers,
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

  int getAdjustedSeatPosition(
      int pos, int maxPlayers, bool isPresent, int currentUserSeatNo) {
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
    if (isPresent) return (pos - currentUserSeatNo + 1) % maxPlayers;

    return pos;
  }

  List<Seat> getSeats(BuildContext context, List<PlayerModel> users) {
    /* build an empty user object list
    *  This is done, because all the empty seats are
    *  also UserObject objects, and we need all
    * the 9 objects in an array to build the entire table + users
    * */
    final gameState = Provider.of<GameState>(context, listen: false);
    for (PlayerModel model in users) {
      gameState.seatPlayer(model.seatNo, model);
    }

    return gameState.seats;
  }

  Widget _positionedForUsers({
    @required BoardAttributesObject boardAttribs,
    @required bool isBoardHorizontal,
    Seat seat,
    double heightOfBoard,
    double widthOfBoard,
    int seatPos,
    bool isPresent,
    Function onUserTap,
  }) {
    return positionUser(
      boardAttribs: boardAttribs,
      isBoardHorizontal: isBoardHorizontal,
      maxPlayers: widget.maxPlayers,
      seat: seat,
      heightOfBoard: heightOfBoard,
      widthOfBoard: widthOfBoard,
      seatPosIndex: seatPos,
      isPresent: isPresent,
      onUserTap: onUserTap,
    );
  }

  Widget createUserView({
    @required bool isBoardHorizontal,
    Seat seat,
    SeatPos seatPos,
    int seatPosIndex,
    Function onUserTap,
    Alignment cardsAlignment,
  }) {
    Widget userView;
    seat.uiSeatPos = seatPos;
    //debugPrint('Creating user view for seat: ${seat.serverSeatPos}');
    userView = ListenableProvider<Seat>(
      create: (_) => seat,
      builder: (context, _) => Consumer2<Seat, BoardAttributesObject>(
        builder: (_, seat, boardAttributes, __) => Transform.scale(
          scale: boardAttributes.playerViewScale,
          child: PlayerView(
            gameComService: widget.gameComService,
            seat: seat,
            cardsAlignment: cardsAlignment,
            onUserTap: onUserTap,
            boardAttributes: boardAttributes,
            seatPos: seatPos,
            seatPosIndex: seatPosIndex,
          ),
        ),
      ),
    );
    return userView;
  }

  Map<int, SeatPos> getSeatLocations(int maxSeats) {
    switch (maxSeats) {
      case 9:
        return {
          1: SeatPos.bottomCenter,
          2: SeatPos.bottomLeft,
          3: SeatPos.middleLeft,
          4: SeatPos.topLeft,
          5: SeatPos.topCenter1,
          6: SeatPos.topCenter2,
          7: SeatPos.topRight,
          8: SeatPos.middleRight,
          9: SeatPos.bottomRight
        };
      case 8:
        return {
          1: SeatPos.bottomCenter,
          2: SeatPos.bottomLeft,
          3: SeatPos.middleLeft,
          4: SeatPos.topLeft,
          5: SeatPos.topCenter,
          6: SeatPos.topRight,
          7: SeatPos.middleRight,
          8: SeatPos.bottomRight
        };
      case 6:
        return {
          1: SeatPos.bottomCenter,
          2: SeatPos.middleLeft,
          3: SeatPos.topLeft,
          4: SeatPos.topCenter,
          5: SeatPos.topRight,
          6: SeatPos.middleRight,
        };

      case 4:
        return {
          1: SeatPos.bottomCenter,
          2: SeatPos.middleLeft,
          3: SeatPos.topCenter,
          4: SeatPos.middleRight,
        };

      case 2:
        return {
          1: SeatPos.bottomCenter,
          2: SeatPos.topCenter,
        };

      default:
        return {};
    }
  }

  Widget positionUser({
    @required BoardAttributesObject boardAttribs,
    @required bool isBoardHorizontal,
    @required int maxPlayers,
    Seat seat,
    double heightOfBoard,
    double widthOfBoard,
    int seatPosIndex,
    bool isPresent,
    Function onUserTap,
  }) {
    seatPosIndex++;

    //log('board width: $widthOfBoard height: $heightOfBoard');
    Map<int, SeatPos> seatPosLoc = getSeatLocations(maxPlayers);
    SeatPos seatPos = seatPosLoc[seatPosIndex];
    SeatPosAttribs seatAttribs = boardAttribs.getSeatPosAttrib(seatPos);
    if (seatAttribs == null) {
      return SizedBox.shrink();
    }
    //log('seat: ${seat.serverSeatPos} seatPosIndex: $seatPosIndex seatPos: ${seatPos.toString()}');
    Alignment cardsAlignment = seatAttribs.holeCardPos;

    Widget userView = createUserView(
      isBoardHorizontal: isBoardHorizontal,
      seatPos: seatPos,
      seatPosIndex: seatPosIndex,
      seat: seat,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    return Transform.translate(
        offset: seatAttribs.topLeft,
        child: Align(alignment: seatAttribs.alignment, child: userView));
  }
}
