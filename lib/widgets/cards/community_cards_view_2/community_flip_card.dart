import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/app_flip_card.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:developer' as developer;

class CommunityFlipCard extends StatelessWidget {
  final CardState cardState;

  CommunityFlipCard({@required this.cardState});

  @override
  Widget build(BuildContext context) {
    Provider.of<TableState>(context);
    final gameState = context.read<GameState>();
    final colorCards = gameState.colorCards;
    final size = cardState.size;

    final back = SizedBox.fromSize(
      size: size,
      child: AnimatedBuilder(
        animation: gameState.communityCardState,
        builder: (_, __) {
          final co = CardHelper.getCard(
            cardState.cardNo,
            colorCards: colorCards,
          );
          if (gameState.communityCardState.highlightCards.isNotEmpty) {
            if (gameState.communityCardState.highlightCards.contains(
              cardState.cardNo,
            )) {
              co.highlight = true;
            } else {
              co.dim = true;
            }
          }

          if (!gameState.boardAttributes.isOrientationHorizontal)
            return co.newWidget;
          return co.widget;
        },
      ),
    );

    final front = ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.memory(
        context.read<GameState>().assets.holeCardBackBytes,
        height: size.height,
        width: size.width,
      ),
    );

    // return AppFlipCard(
    //   // key: cardState.flipKey,
    //   cardState: cardState,
    //   speed: AppConstants.communityCardFlipAnimationDuration.inMilliseconds,
    //   flipOnTouch: false,
    //   back: cardState.isFaced ? front : back,
    //   front: cardState.isFaced ? back : front,
    // );
    return FlipCard(
      // key: cardState.flipKey,
      key: UniqueKey(),
      cardState: cardState,
      back: cardState.isFaced ? front : back,
      front: cardState.isFaced ? back : front,
    );
  }
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final CardState cardState;

  const FlipCard({Key key, this.front, this.back, this.cardState})
      : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _showFrontSide;
  bool _flipXAxis;
  @override
  void initState() {
    super.initState();
    _showFrontSide = false;
    _flipXAxis = true;
    if (widget.cardState.flip) {
      //flip = false;
      developer.log(
          'CommunityCard: [${widget.cardState.cardId}] FLIPPING CARD _showFrontSide: $_showFrontSide flip: ${!widget.cardState.flip}');

      _showFrontSide = true;
      Future.delayed(Duration(milliseconds: 10), () {
        _showFrontSide = false;
        widget.cardState.flip = true;
        setState(() {});
        // _changeRotationAxis();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cardState.hide) {
      return Container(
        constraints: BoxConstraints.tight(widget.cardState.size),
        color: Colors.transparent,
      );
    }

    if (!widget.cardState.flip) {
      return _buildRear();
    }
    return Container(
      constraints: BoxConstraints.tight(widget.cardState.size),
      child: _buildFlipAnimation(),
    );
  }

  Widget _buildFlipAnimation() {
    developer.log(
        'CommunityCard: [${widget.cardState.cardId}] flip _showFrontSide: $_showFrontSide flip: ${!widget.cardState.flip}');
    if (!widget.cardState.flip) {
      return _buildRear();
    }
    return AnimatedSwitcher(
      duration: AppConstants.communityCardWaitDuration,
      transitionBuilder: __transitionBuilder,
      layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
      child: _showFrontSide ? _buildFront() : _buildRear(),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut.flipped,
    );
  }

  Widget __transitionBuilder(Widget child, Animation<double> animation) {
    if (animation.isCompleted || animation.isDismissed) {
      widget.cardState.flip = false;
    }
    developer.log(
        'CommunityCard: [${widget.cardState.cardId}] __transitionBuilder flip _showFrontSide: $_showFrontSide flip: ${!widget.cardState.flip} animation: ${animation.status} value: ${animation.value}');

    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: child,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: "Front",
      child: widget.front,
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: "Rear",
      child: widget.back,
    );
  }

  Widget __buildLayout(
      {Key key, Widget child, String faceName, Color backgroundColor}) {
    return child;
  }
}
