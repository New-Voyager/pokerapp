/*
*
* FLOP CARD VIEW (ANIMATION & FLOP CARDS DISPLAY)
*
* */

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:provider/provider.dart';

class FlopCommunityCards extends StatefulWidget {
  final List<Widget> flopCards;

  FlopCommunityCards({
    @required this.flopCards,
  });

  @override
  _FlopCommunityCardsState createState() => _FlopCommunityCardsState();
}

class _FlopCommunityCardsState extends State<FlopCommunityCards> {
  GlobalKey<FlipCardState> _globalFlipKey = GlobalKey<FlipCardState>();

  bool _isFlipDone;
  bool _isAnimationCompleted;

  Future<void> _delay() => Future.delayed(
        const Duration(milliseconds: 500),
      );

  @override
  void initState() {
    super.initState();

    print(CommunityCardAttribute.cardOffsets);

    _isFlipDone = false;
    _isAnimationCompleted = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // wait
      await _delay();

      /* do the flip animation */
      _globalFlipKey.currentState.toggleCard();
    });
  }

  void onFlipDone(bool _) {
    setState(() => _isFlipDone = true);
  }

  double getDifferenceBetween(int idx1, idx2) {
    return CommunityCardAttribute.getOffsetPosition(idx1).dx -
        CommunityCardAttribute.getOffsetPosition(idx2).dx;
  }

  Widget _buildFlipCardWidget() {
    String cardBackAsset = CardBackAssets.asset1_1;

    try {
      cardBackAsset =
          Provider.of<ValueNotifier<String>>(context, listen: false).value;
    } catch (_) {}

    return Transform.translate(
      offset: Offset(
        CommunityCardAttribute.getOffsetPosition(2).dx -
            CommunityCardAttribute.getOffsetPosition(0).dx,
        0.0,
      ),
      child: FlipCard(
        onFlipDone: onFlipDone,
        key: _globalFlipKey,
        flipOnTouch: false,
        back: widget.flopCards.last,
        front: SizedBox(
          height: AppDimensions.cardHeight * 1.3,
          width: AppDimensions.cardWidth * 1.3,
          child: Image.asset(
            cardBackAsset,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  void onEnd(int idx) {
    /* when the last card animation is done */
    if (idx == 0)
      setState(() {
        print('animation ended');
        _isAnimationCompleted = true;
      });
  }

  Widget _buildAnimation(int idx) {
    return TweenAnimationBuilder<Offset>(
      onEnd: () => onEnd(idx),
      tween: Tween<Offset>(
        begin: Offset(
          /* final position - different between two * index */
          getDifferenceBetween(4 - idx, 2) - idx * getDifferenceBetween(0, 1),
          0.0,
        ),
        end: Offset(
          /* final position offset */
          getDifferenceBetween(4 - idx, 2),
          0.0,
        ),
      ),
      duration: const Duration(milliseconds: 500),
      child: widget.flopCards[idx],
      builder: (_, offset, child) => Transform.translate(
        offset: offset,
        child: child,
      ),
    );
  }

  /* use tween offsets to animate the movement of community cards */
  Widget _buildMoveAnimation() => Stack(
        children: [
          _buildAnimation(0),
          _buildAnimation(1),
          _buildAnimation(2),
        ],
      );

  @override
  Widget build(BuildContext context) => _isFlipDone
      ? _isAnimationCompleted
          ? Transform.translate(
              offset: Offset(
                getDifferenceBetween(3, 2),
                0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.flopCards,
              ),
            )
          : _buildMoveAnimation()
      : _buildFlipCardWidget();
}
