/*
*
* RIVER / TURN CARD ANIMATIONS & DISPLAY
*
* */
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/custom_flip_card.dart';
import 'package:provider/provider.dart';

class TurnOrRiverCommunityCards extends StatefulWidget {
  final List<Widget> riverOrTurnCards;
  final int speed;
  TurnOrRiverCommunityCards({
    Key key,
    @required this.riverOrTurnCards,
    @required this.speed,
  }) : super(key: key);

  @override
  _TurnOrRiverCommunityCardsState createState() =>
      _TurnOrRiverCommunityCardsState();
}

class _TurnOrRiverCommunityCardsState extends State<TurnOrRiverCommunityCards> {
  GlobalKey<FlipCardState> _globalFlipKey = GlobalKey<FlipCardState>();

  void onFlipDone(bool _) {
    setState(() => _isFlipDone = true);
  }

  bool _isFlipDone;

  Future<void> _delay() => Future.delayed(
        AppConstants.communityCardAnimationDuration,
      );

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

    return CustomFlipCard(
      onFlipDone: onFlipDone,
      speed: widget.speed,
      globalKey: _globalFlipKey,
      cardWidget: widget.riverOrTurnCards.last,
      cardBackAsset: cardBackAsset,
    );
  }

  @override
  void initState() {
    super.initState();

    _isFlipDone = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // wait
      await _delay();

      /* do the flip animation */
      if (_globalFlipKey.currentState != null) {
        _globalFlipKey.currentState.toggleCard();
      }
    });
  }

  Widget _buildAnimation() => Stack(
        children: [
          /* show all the flop cards */
          Transform.translate(
            offset: Offset(
              getDifferenceBetween(1, 0) /
                  (widget.riverOrTurnCards.length == 4 ? 1 : 2),
              0.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.riverOrTurnCards.length == 4
                  ? widget.riverOrTurnCards.sublist(0, 3)
                  : widget.riverOrTurnCards.sublist(0, 4),
            ),
          ),

          /*
          show the flip
          */

          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(
                getDifferenceBetween(
                  0,
                  widget.riverOrTurnCards.length == 4 ? 1 : 2,
                ),
                0.0,
              ),
              child: _buildFlipCardWidget(),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return _isFlipDone
        ? Transform.translate(
            offset: Offset(
              widget.riverOrTurnCards.length == 4
                  ? getDifferenceBetween(1, 0) / 2
                  : 0.0,
              0.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.riverOrTurnCards,
            ),
          )
        : _buildAnimation();
  }
}
