import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';

class CardSelector extends StatelessWidget {
  final List<int> cards;
  final Function(int card) onCardSelect;
  final ValueNotifier<int> selectedCard = ValueNotifier<int>(-1);
  final int withoutCard;

  CardSelector({
    @required this.cards,
    @required this.onCardSelect,
    this.withoutCard,
  });

  Widget _buildBody(int card) {
    CardObject c = CardHelper.getCard(card);
    c.cardType = CardType.HandLogOrHandHistoryCard;

    final isNotSelectable = withoutCard == card;

    return InkWell(
      onTap: isNotSelectable
          ? null
          : () {
              selectedCard.value = card;
              onCardSelect(card);
            },
      child: Opacity(
        opacity: isNotSelectable ? 0.50 : 1,
        child: Container(
          color: selectedCard.value == card ? Colors.blueAccent : null,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: c.widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedCard,
        builder: (_, __, ___) => Row(
          children: cards.map((e) => _buildBody(e)).toList(),
        ),
      ),
    );
  }
}
