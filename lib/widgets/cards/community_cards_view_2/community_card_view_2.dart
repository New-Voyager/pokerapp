import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/community_flip_card.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';

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
            developer.log(
                'CommunityCardState: Rebuilding ${communityCardState.cardStates.length}');
            return AnimatedSwitcher(
              switchInCurve: Curves.easeInOutExpo,
              switchOutCurve: Curves.easeInOut,
              duration: Duration.zero,
              reverseDuration: AppConstants.cardThrowAnimationDuration,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: AnimatedBuilder(
                  animation: animation,
                  child: child,
                  builder: (context, child) {
                    return Transform.scale(
                      alignment: Alignment.topCenter,
                      scale: max(animation.value, 0.60),
                      child: child,
                    );
                  },
                ),
              ),
              child: communityCardState.cardStates.isEmpty
                  ? const SizedBox.shrink()
                  : Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: communityCardState.cardStates
                          .map((cardState) => DebugBorderWidget(
                              child: _CardWidget(cardState: cardState)))
                          .toList(),
                    ),
            );
          },
        );
      },
    );
  }
}
