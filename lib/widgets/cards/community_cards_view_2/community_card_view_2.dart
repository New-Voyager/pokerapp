import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class _CardWidget extends StatelessWidget {
  final int cardNo;
  final int idx;
  final CommunityCardBoardState state;

  const _CardWidget({
    Key key,
    @required this.cardNo,
    @required this.idx,
    this.state = CommunityCardBoardState.SINGLE,
  }) : super(key: key);

  Rect getCardDimen(BuildContext context) {
    final communityCardState = context.read<GameState>().communityCardState;

    switch (state) {
      case CommunityCardBoardState.SINGLE:
        return communityCardState.getSingleBoardCardDimens(idx);

      case CommunityCardBoardState.DOUBLE:
        return communityCardState.getDoubleBoardCardDimens(idx);

      case CommunityCardBoardState.RIT:
        return communityCardState.getRitBoardCardDimens(idx);
    }

    return communityCardState.getSingleBoardCardDimens(idx);
  }

  @override
  Widget build(BuildContext context) {
    final cardDimen = getCardDimen(context);

    assert(cardDimen != null,
        'Invalid card :$idx, or the dimensions are not calculated yet');

    return Positioned(
      left: cardDimen.left,
      top: cardDimen.top,
      child: SizedBox.fromSize(
        size: Size(cardDimen.width, cardDimen.height),
        child: CardHelper.getCard(cardNo).widget,
      ),
    );
  }
}

class CommunityCardView2 extends StatelessWidget {
  const CommunityCardView2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final gameState = GameState.getState(context);
        gameState.communityCardState.initializeCards(size);
        return AnimatedBuilder(
          animation: gameState.communityCardState,
          builder: (_, __) {
            final communityCardState = gameState.communityCardState;
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: <Widget>[],
            );
          },
        );
      },
    );
  }
}
