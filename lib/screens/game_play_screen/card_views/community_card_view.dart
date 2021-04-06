import 'dart:developer';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';
import 'package:pokerapp/widgets/card_view.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/resources/card_back_assets.dart';

const double pullUpOffset = -15.0;

class CommunityCardsView extends StatelessWidget {
  final List<CardObject> cards;
  final bool horizontal;

  CommunityCardsView({
    @required this.cards,
    this.horizontal = true,
  });

  List<Widget> getCommunityCards() {
    final reversedList = this.cards.reversed.toList();
    List<Widget> widgets = [];
    for (var card in reversedList) {
      var c = Transform.translate(
        offset: Offset(
          0.0,
          card.highlight ? pullUpOffset : 0.0,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          child: CommunityCardView(card: card),
        ),
      );
      widgets.add(c);
      widgets.add(new SizedBox(
        width: 2.0,
      ));
    }
    return widgets.toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (cards == null) return const SizedBox.shrink();

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: 
            cards.isEmpty ? 
                [SizedBox.shrink()] : 
                getCommunityCards());
  }
}

class CommunityCardView extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  // TODO: REFACTOR THIS VIEW
  CardView cardView;
  CommunityCardView({
    @required card,
    grayOut = false,
    widthRatio = 1.5,
  }) {
    cardView = CardView(card: card, grayOut: grayOut, widthRatio: widthRatio);
  }

  flipCard() => cardKey?.currentState?.toggleCard();

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = cardView.buildCardWidget(context);
    /* for visible cards, the smaller card size is shown to the left of user,
    * and the bigger size is shown as the community card */

    String cardBackAsset = CardBackAssets.asset1_1;

    try {
      cardBackAsset =
          Provider.of<ValueNotifier<String>>(context, listen: false).value;
    } catch (_) {}

    return Transform.scale(
      scale: 1.2,
      child: Container(
        height: cardView.height,
        width: cardView.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0)),
        child: FlipCard(
          flipOnTouch: false,
          key: cardKey,
          back: SizedBox(
            height: AppDimensions.cardHeight * 1.3,
            width: AppDimensions.cardWidth * 1.3,
            child: Image.asset(
              cardBackAsset,
              fit: BoxFit.fitHeight,
            ),
          ),
          front: cardWidget,
        ),
      ),
    );
  }
}
