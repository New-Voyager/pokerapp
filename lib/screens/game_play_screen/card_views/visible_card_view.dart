import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/widgets/card_view.dart';
import 'package:provider/provider.dart';

class VisibleCardView extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  CardView cardView;
  VisibleCardView({
    @required card,
    grayOut = false,
    widthRatio = 1.5,
  }) {
    cardView = CardView(card: card, grayOut: grayOut, widthRatio: widthRatio);
  }

  flipCard() => cardKey?.currentState?.toggleCard();

  @override
  Widget build(BuildContext context) {
    bool isNotCommunityCard =
        cardView.card != null ? cardView.card.smaller : false;
    Widget cardWidget = cardView.buildCardWidget(context);
    /* for visible cards, the smaller card size is shown to the left of user,
    * and the bigger size is shown as the community card */
    return Transform.scale(
      scale: isNotCommunityCard ? 0.85 : 1.05,
      child: Container(
        height: cardView.height,
        width: cardView.width,
        child: cardView.card.isShownAtTable
            ? ClipRRect(
                borderRadius: BorderRadius.circular(
                  3.0,
                ),
                child: FlipCard(
                  key: cardKey,
                  front: Consumer<ValueNotifier<String>>(
                    builder: (_, valueNotifier, __) => Image.asset(
                      valueNotifier.value,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  back: cardWidget,
                ),
              )
            : cardWidget,
      ),
    );
  }
}
