import 'package:flutter/material.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/dialogs/widgets/cart_selector.dart';
import 'package:pokerapp/screens/club_screen/high_hand_analysis_screen/rank_cards_utils.dart';

class FullHouseBody extends StatelessWidget {
  final ValueNotifier<List<int>> cards;
  final ValueNotifier<int> firstCard = ValueNotifier<int>(-1);

  FullHouseBody({
    @required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // select first card
        Text('Select first card'),
        const SizedBox(height: 5.0),
        CardSelector(
          cards: RankCardsUtils.getAllCardsFromSpade(),
          onCardSelect: (int c) {},
        ),

        // second card selection widget
        ValueListenableBuilder(
          valueListenable: firstCard,
          builder: (_, fc, __) => fc == -1
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const SizedBox(height: 20.0),

                    // select second card
                    Text('Select second card'),
                    const SizedBox(height: 5.0),
                    CardSelector(
                      cards: RankCardsUtils.getAllCardsFromSpade(),
                      onCardSelect: (int c) {},
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
