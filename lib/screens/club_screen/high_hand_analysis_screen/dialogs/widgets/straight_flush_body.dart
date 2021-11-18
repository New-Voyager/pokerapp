import 'package:flutter/material.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/widgets/cart_selector.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/rank_cards_utils.dart';

class StraightFlushBody extends StatelessWidget {
  final ValueNotifier<List<int>> cards;

  StraightFlushBody({
    @required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Select one card'),
        const SizedBox(height: 15.0),
        CardSelector(
          cards: RankCardsUtils.getCardsForStraightFlush(),
          onCardSelect: (int c) {
            RankCardsUtils.onStraightFlushCardsSelection(c, cards);
          },
        ),
      ],
    );
  }
}
