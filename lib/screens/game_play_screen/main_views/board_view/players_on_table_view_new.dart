import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/lottie_animation.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/chat_bubble_holder.class.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/player_chat_bubble.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/name_plate_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/player_view.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/utils/name_plate_widget_parent.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';

// const Duration _durationWaitBeforeExplosion = const Duration(milliseconds: 10);

class PlayersOnTableViewNew extends StatefulWidget {
  final Size tableSize;
  final Function(Seat seat) onUserTap;
  final GameComService gameComService;
  final GameState gameState;
  final int maxPlayers;
  final bool isLargerScreen;

  PlayersOnTableViewNew({
    Key key,
    @required this.tableSize,
    @required this.onUserTap,
    @required this.gameComService,
    @required this.gameState,
    @required this.maxPlayers,
    this.isLargerScreen = false,
  }) : super(key: key);

  @override
  State<PlayersOnTableViewNew> createState() => _PlayersOnTableViewNewState();
}

class _PlayersOnTableViewNewState extends State<PlayersOnTableViewNew>
    with TickerProviderStateMixin {
  BoardAttributesObject _boardAttributes;

  final LottieAnimationChangeNotifier animations =
      LottieAnimationChangeNotifier();

  //seat change animation controller
  Animation<Offset> _seatChangeAnimation;
  AnimationController _seatChangeAnimationController;

  // find positions of parent widget
  GlobalKey _parentKey = GlobalKey();

  // value notifiers
  ValueNotifier<bool> _isSeatChangingVn = ValueNotifier(false);

  Offset seatChangeFrom, seatChangeTo;
  SeatChangeNotifier hostSeatChange;
  int seatChangerPlayer;
  int seatChangeToo;

  final List<ChatBubbleHolder> chatBubbleHolders = [];

  // getters
  GameState get _gameState => widget.gameState;
  int get _maxPlayers => widget.maxPlayers;

  PlayerModel _findPlayerAtSeat(int seatNo) {
    for (final player in _gameState.playersInGame)
      if (player.seatNo == seatNo) return player;

    return null;
  }

  List<Widget> _getPlayers(BuildContext context) {
    final boa = context.read<BoardAttributesObject>();
    final gco = context.read<GameContextObject>();
    final mySeat = _gameState.me?.seatNo ?? -1;
    log('mySeat: $mySeat');

    final List<Widget> players = [];

    int serverSeatNo = 1;

    if (_gameState.hostSeatChangeInProgress == false && _gameState.me != null) {
      serverSeatNo = _gameState.me.seatNo;
    }

    for (int localSeatNo = 1; localSeatNo <= _maxPlayers; localSeatNo++) {
      final seat = _gameState.seatPlayer(
        localSeatNo,
        _findPlayerAtSeat(serverSeatNo),
      );
      seat.serverSeatPos = serverSeatNo;

      // scale: widget.isLargerScreen ? 1.3 : 1.0,
      final playerView = ListenableProvider<Seat>(
        create: (_) => seat,
        builder: (_, __) => Consumer<Seat>(builder: (_, __, ___) {
          return DebugBorderWidget(
            color: Colors.blue,
            child: PlayerView(
              seat: seat,
              onUserTap: widget.onUserTap,
              gameComService: widget.gameComService,
              boardAttributes: boa,
              gameContextObject: gco,
              gameState: _gameState,
            ),
          );
        }),
      );

      players.add(LayoutId(id: seat.seatPos, child: playerView));

      serverSeatNo++;
      if (serverSeatNo > _maxPlayers) serverSeatNo = 1;
    }

    return players;
  }

  void _onAnimation(ChatMessage message) async {
    int id = DateTime.now().millisecondsSinceEpoch;

    final LottieAnimation lottieAnimation = LottieAnimation(
      key: ValueKey(id),
      parentKey: _parentKey,
      gameState: widget.gameState,
      animationId: id,
      message: message,
      animationNotifier: animations,
    );

    animations.addAnimation(id, lottieAnimation);
  }

  Offset getPositionOffsetFromKey(GlobalKey key) {
    if (key?.currentContext == null) return null;

    final RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero);
  }

  Size getPlayerWidgetSize(int seatNo) {
    final seat = _gameState.getSeat(seatNo);
    final RenderBox renderBox = seat.key.currentContext.findRenderObject();

    return renderBox.size;
  }

  /**
   * Returns screen position of a nameplate within the parent
   */
  Offset findPositionOfUser({@required int seatNo}) {
    /* if available in cache, get from there */
    final seat = _gameState.getSeat(seatNo);
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

  void _seatChangeAnimationHandler() {
    final SeatChangeNotifier hostSeatChange = Provider.of<SeatChangeNotifier>(
      context,
      listen: false,
    );

    /* initialize the animation controller */
    _seatChangeAnimationController = AnimationController(
      vsync: this,
      duration: AppConstants.seatChangeAnimationDuration,
    );

    /* refresh, when the animation plays */
    _seatChangeAnimationController.addListener(() {
      if (_seatChangeAnimationController.isCompleted)
        _isSeatChangingVn.value = false;
    });

    /* listen for changes in the host seat change model, to trigger seat change animation */
    hostSeatChange.addListener(() {
      final int fromSeatNo = hostSeatChange.fromSeatNo;
      final int toSeatNo = hostSeatChange.toSeatNo;

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
      if (seatChangeFrom == null || seatChangeTo == null) {
        return;
      }

      _seatChangeAnimationController.reset();

      _seatChangeAnimation = Tween<Offset>(
        begin: seatChangeFrom,
        end: seatChangeTo,
      ).animate(_seatChangeAnimationController);

      _seatChangeAnimationController.forward();

      _isSeatChangingVn.value = true;
    });
  }

  void _gameChatBubbleNotifier() async {
    List<ChatMessage> messages =
        _gameState.gameChatBubbleNotifyState.getMessages();
    final latestMessage = messages.first;
    final seat = _gameState.getSeatByPlayer(latestMessage.fromPlayer);

    for (final chatHolder in chatBubbleHolders) {
      if (chatHolder.seatPos == seat.seatPos) {
        chatHolder.timer?.cancel();

        // set message
        chatHolder.chatMessageHolder.value = latestMessage;

        final overlayState = Overlay.of(context);
        overlayState.insert(chatHolder.overlayEntry);

        chatHolder.timer = Timer(const Duration(seconds: 4), () {
          chatHolder.chatMessageHolder.value = null;
          chatHolder.overlayEntry.remove();
        });

        break;
      }
    }

    // final o = _gameState.gameUIState.seatPosToOffsetMap[SeatPos.bottomCenter];
    // final parentOffset = _gameState.gameUIState.playerOnTableRect.topLeft;
    //
    // final offset = Offset(
    //   o.dx + parentOffset.dx + NamePlateWidgetParent.namePlateSize.width / 2,
    //   o.dy + parentOffset.dy + NamePlateWidgetParent.namePlateSize.height / 2,
    // );
    // final overlayState = Overlay.of(context);
    // final overlayEntry = OverlayEntry(
    //   builder: (_) => Positioned(
    //     left: offset.dx,
    //     top: offset.dy,
    //     child: Container(
    //       color: Colors.green,
    //       width: 100,
    //       height: 100,
    //     ),
    //   ),
    // );
    // overlayState.insert(overlayEntry);
    //
    // await Future.delayed(const Duration(seconds: 5));
    //
    // overlayEntry.remove();
    //
    // return;
    // log('ChatBubble: working on chat notification');
    // List<ChatMessage> messages =
    //     _gameState.gameChatBubbleNotifyState.getMessages();
    // for (final message in messages) {
    //   final seat = _gameState.getSeatByPlayer(message.fromPlayer);
    //   if (seat != null) {
    //     log('ChatBubble: seat ${message.fromPlayer} seat: ${seat.serverSeatPos} sent ${message.text}');
    //
    //     for (final chatBubble in chatBubbles) {
    //       if (chatBubble.seatPos == seat.seatPos) {
    //         // chatBubble.show(false);
    //         final offset =
    //             _gameState.gameUIState.seatPosToOffsetMap[seat.seatPos];
    //         if (offset != null) {
    //           final namePlateSize = NamePlateWidgetParent.namePlateSize;
    //           final messageLoc = Offset(
    //             offset.dx + namePlateSize.width / 2,
    //             offset.dy + namePlateSize.height / 2,
    //           );
    //           // final overlay = Overlay.of(context);
    //           // overlay.insert(
    //           //   OverlayEntry(
    //           //     builder: (_) => chatBubble,
    //           //   ),
    //           // );
    //           // chatBubble.show(true, offset: messageLoc, message: message);
    //         }
    //       }
    //     }
    //   } else {
    //     log('ChatBubble: seat ${message.fromPlayer} sent ${message.text}');
    //   }
    // }
  }

  void _init() {
    _boardAttributes = context.read<BoardAttributesObject>();

    widget.gameComService?.gameMessaging?.listen(
      onAnimation: this._onAnimation,
    );
    _seatChangeAnimationHandler();
    _gameState.gameChatBubbleNotifyState.addListener(_gameChatBubbleNotifier);
  }

  void _initChatBubbleHolders() {
    final gameComService = _gameState.gameComService;

    for (int s = 1; s <= _maxPlayers; s++) {
      final seat = widget.gameState.seats[s];

      final chatMessageHolder = ValueNotifier<ChatMessage>(null);

      final seatOffset =
          _gameState.gameUIState.seatPosToOffsetMap[seat.seatPos];
      final parentOffset = _gameState.gameUIState.playerOnTableRect.topLeft;

      final overlayOffset = Offset(
        seatOffset.dx +
            parentOffset.dx +
            NamePlateWidgetParent.namePlateSize.width / 2,
        seatOffset.dy +
            parentOffset.dy +
            NamePlateWidgetParent.namePlateSize.height / 2,
      );

      final playerChatBubble = PlayerChatBubble(
        gameComService: gameComService,
        seat: seat,
        chatMessageHolder: chatMessageHolder,
      );

      final overlayEntry = OverlayEntry(
        builder: (_) => Positioned(
          left: overlayOffset.dx,
          top: overlayOffset.dy,
          child: playerChatBubble,
        ),
      );

      final chatBubbleHolder = ChatBubbleHolder(
        chatMessageHolder: chatMessageHolder,
        overlayEntry: overlayEntry,
        seatPos: seat.seatPos,
      );

      chatBubbleHolders.add(chatBubbleHolder);
    }
  }

  Timer _chatBubbleInitTimer;

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _chatBubbleInitTimer = Timer(const Duration(seconds: 1), () {
        _initChatBubbleHolders();
      });
    });
  }

  void _disposeChatHolders() {
    for (final chatHolder in chatBubbleHolders) {
      chatHolder.timer?.cancel();
    }
  }

  @override
  void dispose() {
    _seatChangeAnimationController?.dispose();
    _chatBubbleInitTimer?.cancel();
    _disposeChatHolders();
    super.dispose();
  }

  Widget _buildSeatChangeAnimating() {
    return AnimatedBuilder(
      animation: _seatChangeAnimation,
      builder: (_, child) {
        final position = _seatChangeAnimation.value;
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: NamePlateWidget(
            _gameState.getSeat(seatChangerPlayer),
            globalKey: null,
            boardAttributes: _boardAttributes,
          ),
        );
      },
    );
  }

  // List<Widget> _getChatBubbles() {
  //   final gameComService = _gameState.gameComService;
  //   for (int localSeat = 1; localSeat <= _maxPlayers; localSeat++) {
  //     final seat = widget.gameState.seats[localSeat];
  //     chatBubbles.add(PlayerChatBubble(
  //       gameComService,
  //       seat,
  //     ));
  //   }
  //
  //   return chatBubbles;
  // }

  @override
  Widget build(BuildContext context) {
    Rect rect = widget.gameState.gameUIState.getPlayersOnTableRect();
    log('PlayersOnTableViewNew Rect: ${rect}');
    Provider.of<SeatsOnTableState>(context, listen: true);
    // this calculates the table size after drawing the table image
    widget.gameState.gameUIState.calculateTableSizePostFrame();

    return AnimatedBuilder(
        animation: animations,
        builder: (_, __) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            key: _parentKey,
            children: [
              // positioning players
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  key: widget.gameState.gameUIState.playerOnTableKey,
                  width: rect.width,
                  height: rect.height,
                  child: ValueListenableBuilder(
                    valueListenable:
                        widget.gameState.gameUIState.playerOnTablePositionVn,
                    builder: (_, size, __) {
                      if (size == null) {
                        return Container();
                      }
                      return DebugBorderWidget(
                        color: Colors.transparent,
                        child: CustomMultiChildLayout(
                          delegate: PlayerPlacementDelegate(
                            isLarger: widget.isLargerScreen,
                            gameState: widget.gameState,
                          ),
                          children: _getPlayers(context),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // lottie animations
              ...animations.animations,

              // seat change animation
              ValueListenableBuilder(
                valueListenable: _isSeatChangingVn,
                builder: (_, isSeatChanging, __) {
                  return isSeatChanging
                      ? _buildSeatChangeAnimating()
                      : const SizedBox.shrink();
                },
              ),

              // chat bubbles - for every players
              // ..._getChatBubbles(),
            ],
          );
        });
  }
}

class PlayerPlacementDelegate extends MultiChildLayoutDelegate {
  final bool isLarger;
  final GameState gameState;

  PlayerPlacementDelegate({@required this.isLarger, @required this.gameState});

  @override
  void performLayout(Size size) {
    if (Screen.isLargeScreen) {
      performLayoutLargeScreen(size);
      return;
    }
    performLayoutLargeScreen(size);
    return;

    // top left
    if (hasChild(SeatPos.topLeft)) {
      final cs = layoutChild(
        SeatPos.topLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topLeft,
        Offset(0.0, 0.0),
      );
    }

    // top right
    if (hasChild(SeatPos.topRight)) {
      final cs = layoutChild(
        SeatPos.topRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topRight,
        Offset(size.width - cs.width, 0.0),
      );
    }

    // top center 1
    // 3/8 th from the left
    if (hasChild(SeatPos.topCenter1)) {
      final cs = layoutChild(
        SeatPos.topCenter1,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter1,
        Offset(
          (3 * size.width / 8) - cs.width / 2,
          -NamePlateWidgetParent.topWidgetOffset,
        ),
      );
    }

    // top center 2
    // 5/8 th from the left
    if (hasChild(SeatPos.topCenter2)) {
      final cs = layoutChild(
        SeatPos.topCenter2,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter2,
        Offset(
          (5 * size.width / 8) - cs.width / 2,
          -NamePlateWidgetParent.topWidgetOffset,
        ),
      );
    }

    // top center
    if (hasChild(SeatPos.topCenter)) {
      final cs = layoutChild(
        SeatPos.topCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter,
        Offset((size.width / 2) - cs.width / 2, -cs.height * 0.20),
      );
    }

    // bottom left
    // 3/16 th from left -> 0   1/8   3/16   1/4    1/2 ...................... 1
    if (hasChild(SeatPos.bottomLeft)) {
      final cs = layoutChild(
        SeatPos.bottomLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomLeft,
        Offset(
          (3 * size.width / 16) - (cs.width / 2),
          size.height - cs.height,
        ),
      );
    }

    // bottom center
    if (hasChild(SeatPos.bottomCenter)) {
      final cs = layoutChild(
        SeatPos.bottomCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomCenter,
        Offset((size.width / 2) - cs.width / 2, size.height - cs.height),
      );
    }

    // bottom right
    // 13/16 th from left
    if (hasChild(SeatPos.bottomRight)) {
      final cs = layoutChild(
        SeatPos.bottomRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomRight,
        Offset(
          (13 * size.width / 16) - (cs.width / 2),
          size.height - cs.height,
        ),
      );
    }

    // middle left
    if (hasChild(SeatPos.middleLeft)) {
      final cs = layoutChild(
        SeatPos.middleLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.middleLeft,
        Offset(0.0, size.height / 2 - cs.height / 1.5),
      );
    }
    // middle right
    if (hasChild(SeatPos.middleRight)) {
      final cs = layoutChild(
        SeatPos.middleRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.middleRight,
        Offset(size.width - cs.width, size.height / 2 - cs.height / 1.5),
      );
    }
  }

  void performLayoutLargeScreen(Size size) {
    final pot = gameState.gameUIState.seatPosToOffsetMap;

    // top left
    if (hasChild(SeatPos.topLeft)) {
      final cs = layoutChild(
        SeatPos.topLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topLeft,
        pot[SeatPos.topLeft],
      );
    }

    // top right
    if (hasChild(SeatPos.topRight)) {
      final cs = layoutChild(
        SeatPos.topRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topRight,
        pot[SeatPos.topRight],
      );
    }

    // middle left
    if (hasChild(SeatPos.middleLeft)) {
      final cs = layoutChild(
        SeatPos.middleLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.middleLeft,
        pot[SeatPos.middleLeft],
      );
    }

    // top center 1
    // 3/8 th from the left
    if (hasChild(SeatPos.topCenter1)) {
      final cs = layoutChild(
        SeatPos.topCenter1,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter1,
        pot[SeatPos.topCenter1],
      );
    }

    // top center 2
    // 5/8 th from the left
    if (hasChild(SeatPos.topCenter2)) {
      final cs = layoutChild(
        SeatPos.topCenter2,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter2,
        pot[SeatPos.topCenter2],
      );
    }

    // top center
    if (hasChild(SeatPos.topCenter)) {
      final cs = layoutChild(
        SeatPos.topCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter,
        pot[SeatPos.topCenter],
      );
    }

    // middle right
    if (hasChild(SeatPos.middleRight)) {
      final cs = layoutChild(
        SeatPos.middleRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.middleRight,
        pot[SeatPos.middleRight],
      );
    }

    // bottom left
    // 3/16 th from left -> 0   1/8   3/16   1/4    1/2 ...................... 1
    if (hasChild(SeatPos.bottomLeft)) {
      final cs = layoutChild(
        SeatPos.bottomLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomLeft,
        pot[SeatPos.bottomLeft],
      );
    }

    // bottom center
    if (hasChild(SeatPos.bottomCenter)) {
      final cs = layoutChild(
        SeatPos.bottomCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomCenter,
        pot[SeatPos.bottomCenter],
      );
    }

    // bottom right
    // 13/16 th from left
    if (hasChild(SeatPos.bottomRight)) {
      final cs = layoutChild(
        SeatPos.bottomRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomRight,
        pot[SeatPos.bottomRight],
      );
    }
  }

  void performLayoutLargeScreenOld(Size size) {
    final pot = gameState.gameUIState.playerOnTableRect;
    final table = gameState.gameUIState.tableRect;
    final npVertPadding = gameState.gameUIState.tableBaseHeight;

    double widthGap = 0;
    double heightGap = 0;
    double topLeftLeft = 0;
    if (pot != null) {
      widthGap = table.left - pot.left;
      heightGap = table.top - pot.top;
    }
    double left = 0;
    double top = 0;
    double topGap = 0;

    // top left
    if (hasChild(SeatPos.topLeft)) {
      final cs = layoutChild(
        SeatPos.topLeft,
        BoxConstraints.loose(size),
      );

      left = widthGap;
      top = heightGap / 2;
      topLeftLeft = left;
      positionChild(
        SeatPos.topLeft,
        Offset(left, top),
      );
    }

    // top right
    if (hasChild(SeatPos.topRight)) {
      final cs = layoutChild(
        SeatPos.topRight,
        BoxConstraints.loose(size),
      );

      left = topLeftLeft + table.width - cs.width;
      top = heightGap / 2;
      topGap = (left + cs.width) - topLeftLeft;
      positionChild(
        SeatPos.topRight,
        Offset(left, top),
      );
    }

    // middle left
    if (hasChild(SeatPos.middleLeft)) {
      final cs = layoutChild(
        SeatPos.middleLeft,
        BoxConstraints.loose(size),
      );
      left = 0;
      top = heightGap + (table.height - cs.height) / 3;

      positionChild(
        SeatPos.middleLeft,
        Offset(left, top),
      );
    }

    // top center 1
    // 3/8 th from the left
    if (hasChild(SeatPos.topCenter1)) {
      final cs = layoutChild(
        SeatPos.topCenter1,
        BoxConstraints.loose(size),
      );
      double topCenter1Left = (topGap / 2) - cs.width * 3 / 4;
      top = (heightGap - cs.height); // + npVertPadding;

      positionChild(
        SeatPos.topCenter1,
        Offset(
          topCenter1Left,
          top,
        ),
      );
    }

    // top center 2
    // 5/8 th from the left
    if (hasChild(SeatPos.topCenter2)) {
      final cs = layoutChild(
        SeatPos.topCenter2,
        BoxConstraints.loose(size),
      );

      double topCenter1Left = (topGap / 2) + cs.width * 3 / 4;
      top = (heightGap - cs.height); // + npVertPadding;

      positionChild(
        SeatPos.topCenter2,
        Offset(
          topCenter1Left,
          top,
        ),
      );
    }

    // top center
    if (hasChild(SeatPos.topCenter)) {
      final cs = layoutChild(
        SeatPos.topCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter,
        Offset((size.width / 2) - cs.width / 2, -cs.height * 0.20),
      );
    }

    // middle right
    if (hasChild(SeatPos.middleRight)) {
      final cs = layoutChild(
        SeatPos.middleRight,
        BoxConstraints.loose(size),
      );
      left = size.width - cs.width;
      top = heightGap + (table.height - cs.height) / 3;

      positionChild(
        SeatPos.middleRight,
        Offset(left, top),
      );
    }

    // bottom left
    // 3/16 th from left -> 0   1/8   3/16   1/4    1/2 ...................... 1
    if (hasChild(SeatPos.bottomLeft)) {
      final cs = layoutChild(
        SeatPos.bottomLeft,
        BoxConstraints.loose(size),
      );

      left = widthGap;
      top = size.height - cs.height - heightGap / 4;
      positionChild(
        SeatPos.bottomLeft,
        Offset(
          left,
          top,
        ),
      );
    }

    // bottom center
    if (hasChild(SeatPos.bottomCenter)) {
      final cs = layoutChild(
        SeatPos.bottomCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomCenter,
        Offset((size.width / 2) - cs.width / 2, size.height - cs.height),
      );
    }

    // bottom right
    // 13/16 th from left
    if (hasChild(SeatPos.bottomRight)) {
      final cs = layoutChild(
        SeatPos.bottomRight,
        BoxConstraints.loose(size),
      );
      left = topLeftLeft + table.width - cs.width;
      top = size.height - cs.height - heightGap / 4;

      positionChild(
        SeatPos.bottomRight,
        Offset(
          left,
          top,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
