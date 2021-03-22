import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/widgets/card_view.dart';
import 'package:provider/provider.dart';

// TODO: WHY IS THIS BUILD FUNCTION BEING REBUILD EVERYTIME SOMETHING IN THE UI CHANGES?

import 'dart:developer';

class VisibleCardViewDelete extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  // TODO: REFACTOR THIS VIEW
  CardView cardView;
  VisibleCardViewDelete({
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

    String cardBackAsset = CardBackAssets.asset1_1;

    try {
      cardBackAsset =
          Provider.of<ValueNotifier<String>>(context, listen: false).value;
    } catch (_) {}

    return Transform.scale(
      scale: isNotCommunityCard ? 0.85 : 1.4,
      child: Container(
        height: cardView.height,
        width: cardView.width,
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
