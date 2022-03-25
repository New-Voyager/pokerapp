import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/state/community_card_state.dart';
import 'package:provider/provider.dart';

class _CardWidget extends StatelessWidget {
  final int no;
  final CommunityCardBoardState state;

  const _CardWidget({
    Key key,
    @required this.no,
    this.state = CommunityCardBoardState.single,
  }) : super(key: key);

  Pair<Offset, Size> getCardDimen(BuildContext context) {
    final communityCardState = context.read<GameState>().communityCardState;

    switch (state) {
      case CommunityCardBoardState.single:
        return communityCardState.getSingleBoardCardDimens(no);

      case CommunityCardBoardState.double:
        return communityCardState.getDoubleBoardCardDimens(no);

      case CommunityCardBoardState.special:
        return communityCardState.getSpecialBoardCardDimens(no);
    }

    return communityCardState.getSingleBoardCardDimens(no);
  }

  @override
  Widget build(BuildContext context) {
    final cardDimen = getCardDimen(context);

    assert(cardDimen != null,
        'Invalid card :$no, or the dimensions are not calculated yet');

    return Positioned(
      left: cardDimen.a.dx,
      top: cardDimen.a.dy,
      child: SizedBox.fromSize(
        size: cardDimen.b,
        child: CardHelper.getCard(17).widget,
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
        final communityCardState = context.read<GameState>().communityCardState;
        communityCardState.initializeCards(size);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _CardWidget(
              no: 1,
              state: CommunityCardBoardState.special,
            ),
            _CardWidget(
              no: 2,
              state: CommunityCardBoardState.special,
            ),
            _CardWidget(
              no: 3,
              state: CommunityCardBoardState.special,
            ),
            _CardWidget(
              no: 5,
              state: CommunityCardBoardState.special,
            ),
            _CardWidget(
              no: 6,
              state: CommunityCardBoardState.special,
            ),
            _CardWidget(
              no: 7,
              state: CommunityCardBoardState.special,
            ),
            _CardWidget(
              no: 8,
              state: CommunityCardBoardState.special,
            ),
          ],
        );
      },
    );
  }
}
