/*
*
* FLOP CARD VIEW (ANIMATION & FLOP CARDS DISPLAY)
*
* */

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/custom_flip_card.dart';
import 'package:provider/provider.dart';

class FlopCommunityCards extends StatefulWidget {
  final List<Widget> flopCards;
  final int speed;
  FlopCommunityCards({
    @required this.flopCards,
    @required this.speed,
  });

  @override
  _FlopCommunityCardsState createState() => _FlopCommunityCardsState();
}

class _FlopCommunityCardsState extends State<FlopCommunityCards> {
  GlobalKey<FlipCardState> _globalFlipKey = GlobalKey<FlipCardState>();

  bool _isFlipDone;
  bool _isAnimationCompleted;

  Future<void> _delay() => Future.delayed(
        AppConstants.communityCardAnimationDuration,
      );

  @override
  void initState() {
    super.initState();

    _isFlipDone = false;
    _isAnimationCompleted = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // wait
      await _delay();

      /* do the flip animation */
      if (_globalFlipKey.currentState != null) {
        _globalFlipKey.currentState.toggleCard();
      }
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
      child: CustomFlipCard(
        cardBackAsset: cardBackAsset,
        speed: widget.speed,
        onFlipDone: onFlipDone,
        globalKey: _globalFlipKey,
        cardWidget: widget.flopCards.last,
      ),
    );
  }

  void onEnd(int idx) {
    // print('onEnd last index value will be: $idx');

    /* when the last card animation is done */
    if (idx == 2)
      setState(() {
        // print('animation ended');
        _isAnimationCompleted = true;
      });
  }

  Widget _buildAnimation(int idx) {
    return TweenAnimationBuilder<Offset>(
      duration: AppConstants.communityCardAnimationDuration,
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
                getDifferenceBetween(1, 0),
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
