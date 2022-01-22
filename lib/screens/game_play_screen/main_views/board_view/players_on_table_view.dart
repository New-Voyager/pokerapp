import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/player_chat_bubble.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/name_plate_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/player_view.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:provider/provider.dart';

const double _lottieAnimationContainerSize = 120.0;
const double _animatingAssetContainerSize = 40.0;

// const Duration _durationWaitBeforeExplosion = const Duration(milliseconds: 10);
const Duration _lottieAnimationDuration = const Duration(milliseconds: 5000);
const Duration _animatingWidgetDuration = const Duration(milliseconds: 500);

// PlayersOnTableView encapsulates the players sitting on the table.
// This view uses Stack layout to place the UserView on top of the table.
class PlayersOnTableView extends StatefulWidget {
  final Function(Seat seat) onUserTap;
  final isBoardHorizontal;
  final double heightOfBoard;
  final double widthOfBoard;
  final GameComService gameComService;
  final GameState gameState;
  final int maxPlayers;

  PlayersOnTableView({
    @required this.gameComService,
    @required this.isBoardHorizontal,
    @required this.widthOfBoard,
    @required this.heightOfBoard,
    @required this.onUserTap,
    @required this.maxPlayers,
    @required this.gameState,
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
  SeatChangeNotifier hostSeatChange;
  int seatChangerPlayer;
  int seatChangeToo;

  String animationAssetID;
  List<PlayerChatBubble> chatBubbles = [];

  @override
  void initState() {
    // todo: commented onAnimation
    widget.gameComService?.gameMessaging?.listen(onAnimation: this.onAnimation);
    animationHandlers();
    _seatChangeAnimationHandler();

    widget.gameState.gameChatBubbleNotifyState.addListener(() {
      log('ChatBubble: working on chat notification');
      List<ChatMessage> messages =
          widget.gameState.gameChatBubbleNotifyState.getMessages();
      for (final message in messages) {
        final seat = widget.gameState.getSeatByPlayer(message.fromPlayer);
        if (seat != null) {
          log('ChatBubble: seat ${message.fromPlayer} seat: ${seat.serverSeatPos} sent ${message.text}');
          for (final chatBubble in chatBubbles) {
            if (chatBubble.seatNo == seat.serverSeatPos) {
              chatBubble.show(false);
              Offset offset = findPositionOfUser(seatNo: seat.serverSeatPos);
              if (offset != null) {
                Offset loc = Offset(offset.dx + 20, offset.dy + 20);
                chatBubble.show(true, offset: loc, message: message);
              }
            }
          }
        } else {
          log('ChatBubble: seat ${message.fromPlayer} sent ${message.text}');
        }
      }
    });
    // cacheSeatPositions();
    super.initState();
  }

  void _seatChangeAnimationHandler() {
    final SeatChangeNotifier hostSeatChange = Provider.of<SeatChangeNotifier>(
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
      final fromSeat = widget.gameState.getSeat(fromSeatNo);
      final toSeat = widget.gameState.getSeat(toSeatNo);

      if (fromSeatNo == null || toSeatNo == null) return;
      if (fromSeatNo == 0 || toSeatNo == 0) return;

      // log('Seat Change data: $fromSeatNo (${fromSeat.player.name}/${fromSeat.player.stack}, ${fromSeat.seatPos.toString()}) and $toSeatNo (${toSeat.player.name}/${toSeat.player.stack} ${toSeat.seatPos.toString()})');

      final positions = findPositionOfFromAndToUser(
        fromSeat: fromSeatNo,
        toSeat: toSeatNo,
      );
      seatChangerPlayer = hostSeatChange.fromSeatNo;
      seatChangeToo = hostSeatChange.toSeatNo;

      seatChangeFrom = positions[0];
      seatChangeTo = positions[1];
      if (seatChangeFrom == null || seatChangeTo == null) {
        return;
      }

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
        // play the audio
        AudioService.playAnimationSound(animationAssetID);

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

    if (message.fromSeat == null || message.toSeat == null) {
      return;
    }

    if (!widget.gameState.playerLocalConfig.animations) {
      // animation is disabled
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
    if (key?.currentContext == null) return null;

    final RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero);
  }

  Size getPlayerWidgetSize(int seatNo) {
    final gameState = GameState.getState(context);

    final seat = gameState.getSeat(seatNo);
    final RenderBox renderBox = seat.key.currentContext.findRenderObject();

    return renderBox.size;
  }

  /**
   * Returns screen position of a nameplate within the parent
   */
  Offset findPositionOfUser({@required int seatNo}) {
    final gameState = GameState.getState(context);
    /* if available in cache, get from there */
    final seat = gameState.getSeat(seatNo);
    if (seat == null) {
      return Offset(0, 0);
    }
    if (seat.parentRelativePos != null) {
      return seat.parentRelativePos;
    }

    final relativeSeatPos = getPositionOffsetFromKey(seat?.key);
    if (relativeSeatPos == null) return null;

    final RenderBox parentBox =
        this._parentKey.currentContext.findRenderObject();
    final Offset seatPos = parentBox.globalToLocal(relativeSeatPos);

    /* we have the seatPos now, put in the cache */
    seat.parentRelativePos = seatPos;
    return seatPos;
  }

  List<Offset> findPositionOfFromAndToUser({
    int fromSeat,
    int toSeat,
  }) {
    return [
      findPositionOfUser(seatNo: fromSeat),
      findPositionOfUser(seatNo: toSeat),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // cacheSeatPositions();
    // log('PlayersOnTableView:  ::build::');
    final boardAttributes =
        GameState.getState(context).getBoardAttributes(context);

    // am I on this table?
    return Consumer<SeatsOnTableState>(builder: (_, __, ___) {
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
                      child: Transform.scale(
                          scale: boardAttributes.lottieScale, child: child),
                    ),
                  )
                : SizedBox.shrink(),

            isLottieAnimationAnimating
                ? Transform.translate(
                    offset: lottieAnimationPosition,
                    child: Container(
                      height: _lottieAnimationContainerSize,
                      width: _lottieAnimationContainerSize,
                      child: Transform.scale(
                          scale: boardAttributes.lottieScale,
                          child: Lottie.asset(
                            'assets/animations/$animationAssetID.json',
                            controller: _lottieController,
                          )),
                    ),
                  )
                : SizedBox.shrink(),

            isSeatChanging
                ? Positioned(
                    left: seatChangeAnimation.value.dx,
                    top: seatChangeAnimation.value.dy,
                    child: Consumer<BoardAttributesObject>(
                        builder: (_, boardAttributes, __) {
                      final seat = widget.gameState.getSeat(seatChangerPlayer);
                      String playerName = seat.player?.name;
                      int playerSeat = seat.player?.seatNo;
                      // log('SeatChange: data: Animation seat: ${seat.serverSeatPos}, ${playerName}/$playerSeat');
                      return NamePlateWidget(
                        seat,
                        globalKey: null,
                        boardAttributes: boardAttributes,
                      );
                    }),
                  )
                : SizedBox.shrink(),

            // chat bubble
            ...getChatBubbles(context),
          ],
        ),
      );
    });
  }

  List<Widget> getChatBubbles(BuildContext context) {
    final gameState = context.read<GameState>();
    final gameComService = gameState.gameComService;

    for (int localSeat = 1;
        localSeat <= gameState.gameInfo.maxPlayers;
        localSeat++) {
      final seat = widget.gameState.getSeat(localSeat);
      chatBubbles.add(PlayerChatBubble(gameComService, seat));
    }

    return chatBubbles;
  }

  List<Widget> getPlayers(BuildContext context) {
    PlayerModel me;
    final gameState = GameState.getState(context);

    final currPlayerID = gameState.currentPlayerId;

    if (TestService.isTesting) {
      me = this.widget.gameState.me;
    } else {
      me = widget.gameState.me;
    }

    final maxPlayers = gameState.gameInfo?.maxPlayers ?? 9;
    index = -1;
    // update seat states in game state
    //final seatsState = this.getSeats(context, widget.gameState.playersInGame);
    final boardAttribs =
        Provider.of<BoardAttributesObject>(context, listen: false);

    // start seating
    // if i am in the table, i will be sitting in bottom center (local seat 1)
    // if i am not in the table, the server seat 1 will be sitting in the bottom center
    int serverSeatNo = 1;
    if (!gameState.hostSeatChangeInProgress) {
      for (final player in gameState.playersInGame) {
        if (player.isMe) {
          serverSeatNo = player.seatNo;
          break;
        }
      }
    }

    List<Widget> seats = [];
    for (int localSeat = 1;
        localSeat <= gameState.gameInfo.maxPlayers;
        localSeat++) {
      PlayerModel playerInSeat;
      // find the player who is in the seat
      for (PlayerModel model in gameState.playersInGame) {
        if (model.seatNo == serverSeatNo && model.playerUuid != 'open') {
          playerInSeat = model;
          break;
        }
      }
      Seat seat;
      if (playerInSeat != null) {
        seat = widget.gameState.seatPlayer(localSeat, playerInSeat);
      } else {
        // open seat
        seat = widget.gameState.seatPlayer(localSeat, null);
      }
      seat.serverSeatPos = serverSeatNo;
      Widget seatWidget = positionUser(
        boardAttribs: boardAttribs,
        isBoardHorizontal: true,
        maxPlayers: gameState.gameInfo.maxPlayers,
        seat: seat,
        heightOfBoard: widget.heightOfBoard,
        widthOfBoard: widget.widthOfBoard,
        seatPosIndex: localSeat - 1,
        isPresent: playerInSeat != null,
        onUserTap: widget.onUserTap,
      );
      seats.add(seatWidget);
      // get local seat
      serverSeatNo++;
      if (serverSeatNo > gameState.gameInfo.maxPlayers) {
        serverSeatNo = 1;
      }
    }
    return seats;
  }

  int getAdjustedSeatPosition(
    int pos,
    int maxPlayers,
    bool isPresent,
    int currentUserSeatNo, {
    bool seatChangeInProgress,
  }) {
    /* if seat change is in progress, we show the actual seat nos */
    if (seatChangeInProgress == true) return pos;
    // else we do the following calculation

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
    for (PlayerModel model in users) {
      widget.gameState.seatPlayer(model.seatNo, model);
    }

    return widget.gameState.seats;
  }

  Widget createUserView({
    @required bool isBoardHorizontal,
    Seat seat,
    Function onUserTap,
    Alignment cardsAlignment,
  }) {
    Widget userView;
    userView = ListenableProvider<Seat>(
      create: (_) => seat,
      builder: (context, _) {
        final gameState = GameState.getState(context);
        final gameContextObject = context.read<GameContextObject>();

        return Consumer2<Seat, BoardAttributesObject>(
          builder: (_, seat, boardAttributes, __) {
            bool seatActive = gameState.customizationMode;
            if (!gameState.customizationMode && seat != null) {
              if (seat.isOpen) {
                seatActive = true;
              } else if (seat.player != null) {
                if (!gameState.isGameRunning) {
                  seatActive = true;
                } else {
                  seatActive = seat.player.isActive;
                }
              }
            }
            double scale = boardAttributes.playerViewScale;
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: seatActive ? 1.0 : 0.50,
                child: PlayerView(
                  gameContextObject: gameContextObject,
                  gameState: widget.gameState,
                  gameComService: widget.gameComService,
                  seat: seat,
                  cardsAlignment: cardsAlignment,
                  onUserTap: onUserTap,
                  boardAttributes: boardAttributes,
                ),
              ),
            );
          },
        );
      },
    );
    return userView;
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
      seat: seat,
      cardsAlignment: cardsAlignment,
      onUserTap: onUserTap,
    );

    Offset offset = seatAttribs.topLeft;
    if (seat.seatPos == SeatPos.bottomCenter ||
        seat.seatPos == SeatPos.bottomLeft ||
        seat.seatPos == SeatPos.bottomRight) {
      if (seat.isOpen) {
        offset = Offset(offset.dx, offset.dy - 30);
      }
    }

    return Transform.translate(
        offset: offset,
        child: Align(alignment: seatAttribs.alignment, child: userView));
  }
}
