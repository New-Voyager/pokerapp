import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';

const double _lottieAnimationContainerSize = 120.0;
const double _animatingAssetContainerSize = 40.0;

const Duration _lottieAnimationDuration = const Duration(milliseconds: 5000);
const Duration _animatingWidgetDuration = const Duration(milliseconds: 500);

class LottieAnimation extends StatefulWidget {
  final ChatMessage message;
  final GameState gameState;
  final GlobalKey parentKey;
  final Function onComplete;
  LottieAnimation(
      {Key key, this.parentKey, this.gameState, this.message, this.onComplete})
      : super(key: key);

  @override
  State<LottieAnimation> createState() => _LottieAnimationState();
}

class _LottieAnimationState extends State<LottieAnimation>
    with TickerProviderStateMixin {
  bool isAnimating = false;
  bool isLottieAnimationAnimating = false;

  Offset lottieAnimationPosition;

  String animationAssetID;

  Animation<Offset> animation;
  AnimationController animationController;

  AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    init();
    animate();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void init() {
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

        widget.onComplete(0);
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

  animate() {
    Offset from;
    Offset to;

    if (widget.message.fromSeat == null || widget.message.toSeat == null) {
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
      fromSeat: widget.message.fromSeat,
      toSeat: widget.message.toSeat,
    );

    final Size playerWidgetSize = getPlayerWidgetSize(widget.message.toSeat);

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
      animationAssetID = widget.message.animationID;
      isAnimating = true;
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final boardAttributes =
        GameState.getState(context).getBoardAttributes(context);

    return Stack(
      children: [
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
      ],
    );
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
        widget.parentKey.currentContext.findRenderObject();
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
}
