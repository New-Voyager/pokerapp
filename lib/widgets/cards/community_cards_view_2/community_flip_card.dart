import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/app_flip_card.dart';
import 'package:provider/provider.dart';

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

    return AppFlipCard(
      key: cardState.flipKey,
      speed: AppConstants.communityCardFlipAnimationDuration.inMilliseconds,
      flipOnTouch: false,
      back: cardState.isFaced ? front : back,
      front: cardState.isFaced ? back : front,
    );
  }
}
