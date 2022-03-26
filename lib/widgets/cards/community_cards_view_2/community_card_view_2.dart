import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:provider/provider.dart';

class _CardWidget extends StatelessWidget {
  final int no;
  final CommunityCardBoardState state;

  const _CardWidget({
    Key key,
    @required this.no,
    this.state = CommunityCardBoardState.SINGLE,
  }) : super(key: key);

  Rect getCardDimen(BuildContext context) {
    final communityCardState = context.read<GameState>().communityCardState;

    switch (state) {
      case CommunityCardBoardState.SINGLE:
        return communityCardState.getSingleBoardCardDimens(no);

      case CommunityCardBoardState.DOUBLE:
        return communityCardState.getDoubleBoardCardDimens(no);

      case CommunityCardBoardState.RIT:
        return communityCardState.getRitBoardCardDimens(no);
    }

    return communityCardState.getSingleBoardCardDimens(no);
  }

  @override
  Widget build(BuildContext context) {
    final cardDimen = getCardDimen(context);

    assert(cardDimen != null,
        'Invalid card :$no, or the dimensions are not calculated yet');

    return Positioned(
      left: cardDimen.left,
      top: cardDimen.top,
      child: SizedBox.fromSize(
        size: Size(cardDimen.width, cardDimen.height),
        child: CardHelper.getCard(17).widget,
      ),
    );
  }
}

class CommunityCardView2 extends StatelessWidget {
  const CommunityCardView2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final gameState = GameState.getState(context);
      gameState.communityCardState.initializeCards(size);
      return ListenableProvider<CommunityCardState>(
        create: (_) => gameState.communityCardState,
        child:
            Consumer<CommunityCardState>(builder: (_, communityCardState, __) {
          return Stack(
            children: <Widget>[
              _CardWidget(
                no: 1,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 2,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 3,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 4,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 5,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 6,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 7,
                state: communityCardState.boardState,
              ),
              _CardWidget(
                no: 8,
                state: communityCardState.boardState,
              ),
            ],
          );
        }),
      );
    });
  }
}
