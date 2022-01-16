import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
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
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:provider/provider.dart';

const double _lottieAnimationContainerSize = 120.0;
const double _animatingAssetContainerSize = 40.0;

// const Duration _durationWaitBeforeExplosion = const Duration(milliseconds: 10);
const Duration _lottieAnimationDuration = const Duration(milliseconds: 5000);
const Duration _animatingWidgetDuration = const Duration(milliseconds: 1000);

class PlayersOnTableViewNew extends StatefulWidget {
  final Size tableSize;
  final Function(Seat seat) onUserTap;
  final GameComService gameComService;
  final GameState gameState;
  final int maxPlayers;
  final bool isLargerScreen;

  PlayersOnTableViewNew({
    @required this.tableSize,
    @required this.onUserTap,
    @required this.gameComService,
    @required this.gameState,
    @required this.maxPlayers,
    this.isLargerScreen = false,
  });

  @override
  State<PlayersOnTableViewNew> createState() => _PlayersOnTableViewNewState();
}

class _PlayersOnTableViewNewState extends State<PlayersOnTableViewNew>
    with TickerProviderStateMixin {
  BoardAttributesObject _boardAttributes;

  // fun animation transition & lottie animation
  Animation<Offset> _lottieTransitionAnimation;
  AnimationController _lottieTransitionAnimationController;
  AnimationController _lottieController;
  Offset _lottieAnimationPosition;

  //seat change animation controller
  Animation<Offset> _seatChangeAnimation;
  AnimationController _seatChangeAnimationController;

  // find positions of parent widget
  GlobalKey _parentKey = GlobalKey();

  // value notifiers
  ValueNotifier<bool> _isLottieAnimatingVn = ValueNotifier(false);
  ValueNotifier<bool> _isSeatChangingVn = ValueNotifier(false);
  ValueNotifier<bool> _isAnimatingVn = ValueNotifier(false);

  Offset seatChangeFrom, seatChangeTo;
  SeatChangeNotifier hostSeatChange;
  int seatChangerPlayer;
  int seatChangeToo;

  String _animationAssetID;
  List<PlayerChatBubble> chatBubbles = [];

  // getters
  GameState get _gameState => widget.gameState;

  PlayerModel _findPlayerAtSeat(int seatNo) {
    for (final player in _gameState.playersInGame)
      if (player.seatNo == seatNo) return player;

    return null;
  }

  List<Widget> _getPlayers(BuildContext context) {
    final boa = context.read<BoardAttributesObject>();
    final gco = context.read<GameContextObject>();

    final List<Widget> players = [];

    for (int seatNo = 1; seatNo <= widget.maxPlayers; seatNo++) {
      final seat = _gameState.seatPlayer(seatNo, _findPlayerAtSeat(seatNo));
      seat.serverSeatPos = seatNo;

      final playerView = Transform.scale(
        scale: widget.isLargerScreen ? 1.3 : 1.0,
        child: ListenableProvider<Seat>(
          create: (_) => seat,
          builder: (_, __) => Consumer<Seat>(builder: (_, __, ___) {
            return PlayerView(
              seat: seat,
              onUserTap: widget.onUserTap,
              gameComService: widget.gameComService,
              boardAttributes: boa,
              gameContextObject: gco,
              gameState: _gameState,
            );
          }),
        ),
      );

      players.add(LayoutId(id: seat.seatPos, child: playerView));
    }

    return players;
  }

  Size getPlayerOnTableSize() {
    // If larger screen, then allow the multichild layout to spread a little
    // If smaller screen devices, then squeeze the multichild layout
    // Otherwise, do not change the factor of the tableSize

    // in case of larger screens - let the multichild layout be placed extra 1.10 factor
    if (widget.isLargerScreen)
      return Size(
        widget.tableSize.width * 1.10,
        widget.tableSize.height * 1.25,
      );

    // TODO: DO WE NEED A CASE FOR SMALLER SCREEN DEVICES?

    // normal case
    return Size(widget.tableSize.width, widget.tableSize.height * 1.70);
  }

  void _animationHandlers() {
    _lottieController = AnimationController(
      vsync: this,
      duration: _lottieAnimationDuration,
    );

    _lottieTransitionAnimationController = AnimationController(
      vsync: this,
      duration: _animatingWidgetDuration,
    );

    _lottieController.addListener(() {
      /* after the lottie animation is completed reset everything */
      if (_lottieController.isCompleted) {
        _isLottieAnimatingVn.value = false;
        _lottieController.reset();
      }
    });

    _lottieTransitionAnimationController.addListener(() async {
      if (_lottieTransitionAnimationController.isCompleted) {
        /* wait before the explosion */
        // await Future.delayed(_durationWaitBeforeExplosion);

        _isAnimatingVn.value = false;
        _lottieTransitionAnimationController.reset();

        /* finally drive the lottie animation */
        // play the audio
        AudioService.playAnimationSound(_animationAssetID);

        _isLottieAnimatingVn.value = true;
        _lottieController.forward();
      }
    });
  }

  void _onAnimation(ChatMessage message) async {
    Offset from;
    Offset to;

    if (message.fromSeat == null || message.toSeat == null) {
      return;
    }

    if (!_gameState.playerLocalConfig.animations) {
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

    _lottieTransitionAnimation = Tween<Offset>(
      begin: from,
      end: toMod,
    ).animate(
      CurvedAnimation(
        parent: _lottieTransitionAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // set the lottie animation position
    _lottieAnimationPosition = Offset(
      to.dx + (playerWidgetSize.width / 2) - _lottieAnimationContainerSize / 2,
      to.dy + (playerWidgetSize.height / 2) - _lottieAnimationContainerSize / 2,
    );

    _animationAssetID = message.animationID;
    _isAnimatingVn.value = true;

    _lottieTransitionAnimationController.forward();
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

  void _gameChatBubbleNotifier() {
    log('ChatBubble: working on chat notification');
    List<ChatMessage> messages =
        _gameState.gameChatBubbleNotifyState.getMessages();
    for (final message in messages) {
      final seat = _gameState.getSeatByPlayer(message.fromPlayer);
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
  }

  void _init() {
    _boardAttributes = context.read<BoardAttributesObject>();

    widget.gameComService?.gameMessaging?.listen(
      onAnimation: _onAnimation,
    );
    _animationHandlers();
    _seatChangeAnimationHandler();
    _gameState.gameChatBubbleNotifyState.addListener(_gameChatBubbleNotifier);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    _lottieTransitionAnimationController?.dispose();
    _seatChangeAnimationController?.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimating() {
    return Transform.translate(
      offset: _lottieAnimationPosition,
      child: Container(
        height: _lottieAnimationContainerSize,
        width: _lottieAnimationContainerSize,
        child: Transform.scale(
          scale: _boardAttributes.lottieScale,
          child: Lottie.asset(
            'assets/animations/$_animationAssetID.json',
            controller: _lottieController,
          ),
        ),
      ),
    );
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

  Widget _buildLottieTransitionAnimating() {
    return AnimatedBuilder(
      child: Container(
        height: _animatingAssetContainerSize,
        width: _animatingAssetContainerSize,
        child: SvgPicture.asset(
          'assets/animations/$_animationAssetID.svg',
        ),
      ),
      animation: _lottieTransitionAnimation,
      builder: (_, child) => Transform.translate(
        offset: _lottieTransitionAnimation.value,
        child: Transform.scale(
          scale: _boardAttributes.lottieScale,
          child: child,
        ),
      ),
    );
  }

  List<Widget> _getChatBubbles() {
    final gameComService = _gameState.gameComService;
    final maxPlayers = _gameState.gameInfo.maxPlayers;
    for (int localSeat = 1; localSeat <= maxPlayers; localSeat++) {
      final seat = widget.gameState.getSeat(localSeat);
      chatBubbles.add(PlayerChatBubble(gameComService, seat));
    }

    return chatBubbles;
  }

  @override
  Widget build(BuildContext context) {
    final ts = getPlayerOnTableSize();
    Provider.of<SeatsOnTableState>(context, listen: true);
    return Stack(
      key: _parentKey,
      children: [
        // positioning players
        Container(
          // color for debugging
          // color: Colors.red.withOpacity(0.20),
          width: ts.width,
          height: ts.height,
          child: CustomMultiChildLayout(
            delegate: PlayerPlacementDelegate(),
            children: _getPlayers(context),
          ),
        ),

        // lottie transition animation
        ValueListenableBuilder(
          valueListenable: _isAnimatingVn,
          builder: (_, isAnimating, ___) {
            return isAnimating
                ? _buildLottieTransitionAnimating()
                : const SizedBox.shrink();
          },
        ),

        // lottie final animation
        ValueListenableBuilder(
          valueListenable: _isLottieAnimatingVn,
          builder: (_, isLottieAnimating, __) {
            return isLottieAnimating
                ? _buildLottieAnimating()
                : const SizedBox.shrink();
          },
        ),

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
        ..._getChatBubbles(),
      ],
    );
  }
}

class PlayerPlacementDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
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

    // top center 1
    // 3/8 th from the left
    if (hasChild(SeatPos.topCenter1)) {
      final cs = layoutChild(
        SeatPos.topCenter1,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter1,
        Offset((3 * size.width / 8) - cs.width / 2, 0.0),
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
        Offset((5 * size.width / 8) - cs.width / 2, 0.0),
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
        Offset((size.width / 2) - cs.width / 2, 0),
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
          size.height - cs.height * 1.05,
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
        Offset((size.width / 2) - cs.width / 2, size.height - cs.height * 1.10),
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
          size.height - cs.height * 1.05,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
