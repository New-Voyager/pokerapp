/*
*
* RIVER / TURN CARD ANIMATIONS & DISPLAY
*
* */
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/custom_flip_card.dart';
import 'package:provider/provider.dart';

class TurnOrRiverCommunityCards extends StatefulWidget {
  final List<Widget> riverOrTurnCards;
  final bool twoBoards;
  TurnOrRiverCommunityCards({
    Key key,
    @required this.riverOrTurnCards,
    this.twoBoards,
  }) : super(key: key);

  @override
  _TurnOrRiverCommunityCardsState createState() =>
      _TurnOrRiverCommunityCardsState();
}

class _TurnOrRiverCommunityCardsState extends State<TurnOrRiverCommunityCards> {
  GlobalKey<FlipCardState> _globalFlipKey = GlobalKey<FlipCardState>();

  BoardAttributesObject _boa;

  void onFlipDone(bool _) {
    setState(() => _isFlipDone = true);
  }

  bool _isFlipDone;

  double getDifferenceBetween(int idx1, idx2) {
    return (CommunityCardAttribute.getOffsetPosition(idx1).dx -
            CommunityCardAttribute.getOffsetPosition(idx2).dx) *
        (widget.twoBoards ? _boa.doubleBoardScale : 1.0);
  }

  Widget _buildFlipCardWidget() {
    final gameState = GameState.getState(context);
    final cardBackBytes = gameState.assets.getHoleCardBack();

    return CustomFlipCard(
      onFlipDone: onFlipDone,
      globalKey: _globalFlipKey,
      cardWidget: widget.riverOrTurnCards.last,
      cardBackBytes: cardBackBytes,
      twoBoards: widget.twoBoards,
      doubleBoardScale: _boa.doubleBoardScale,
    );
  }

  @override
  void initState() {
    super.initState();

    _boa = Provider.of<BoardAttributesObject>(context, listen: false);

    _isFlipDone = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
