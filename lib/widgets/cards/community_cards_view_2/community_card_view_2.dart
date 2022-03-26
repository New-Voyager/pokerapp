import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/community_flip_card.dart';
import 'package:provider/provider.dart';

class _CardWidget extends StatelessWidget {
  final CardState cardState;

  const _CardWidget({Key key, @required this.cardState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = cardState.position;

    return AnimatedPositioned(
      duration: AppConstants.communityCardAnimationDuration,
      left: position.dx,
      top: position.dy,
      child: CommunityFlipCard(cardState: cardState),
    );
  }
}

class CommunityCardView2 extends StatelessWidget {
  const CommunityCardView2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final gameState = GameState.getState(context);
        final communityCardState = gameState.communityCardState;
        communityCardState.initializeCards(
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        return AnimatedBuilder(
          animation: communityCardState,
          builder: (_, __) {
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: communityCardState.cardStates
                  .map((cardState) => _CardWidget(cardState: cardState))
                  .toList(),
            );
          },
        );
      },
    );
  }
}
