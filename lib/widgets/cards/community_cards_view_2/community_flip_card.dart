import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/community_card_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/community_cards_view_2/app_flip_card.dart';
import 'package:provider/provider.dart';

class CommunityFlipCard extends StatelessWidget {
  final CardState cardState;

  CommunityFlipCard({@required this.cardState});

  @override
  Widget build(BuildContext context) {
    final size = cardState.size;
    return AppFlipCard(
      key: cardState.flipKey,
      speed: AppConstants.communityCardFlipAnimationDuration.inMilliseconds,
      flipOnTouch: false,
      back: SizedBox.fromSize(
        size: size,
        // Consumer<WinningCards> (
        // if my card is winning, highlight this
        // )
        child: CardHelper.getCard(cardState.cardNo).widget,
      ),
      front: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.memory(
          context.read<GameState>().assets.holeCardBackBytes,
          height: size.height,
          width: size.width,
        ),
      ),
    );
  }
}
