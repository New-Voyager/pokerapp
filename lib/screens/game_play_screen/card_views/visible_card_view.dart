import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/card_back_assets.dart';

class VisibleCardView extends StatelessWidget {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final CardObject card;
  final bool grayOut;

  VisibleCardView({
    @required this.card,
    this.grayOut = false,
  });

  flipCard() => cardKey.currentState.toggleCard();

  @override
  Widget build(BuildContext context) {
    TextStyle cardTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );
    TextStyle suitTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );
    bool highlight = card.highlight ?? false;
    Color highlightColor = (card.otherHighlightColor ?? false)
        ? Colors.blue.shade100
        : Colors.green.shade100;

    bool isNotCommunityCard = card.smaller;

    Widget cardWidget = Container(
      padding: const EdgeInsets.only(bottom: 3.0),
      height: AppDimensions.cardHeight * 1.5,
      width: card.smaller
          ? AppDimensions.cardWidth * 1.5
          : AppDimensions.cardWidth * 1.1,
      foregroundDecoration: grayOut
          ? BoxDecoration(
              color: Colors.black54,
              backgroundBlendMode: BlendMode.darken,
            )
          : null,
      decoration: BoxDecoration(
        color: highlight ? highlightColor : Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 5.0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 8,
            child: FittedBox(
              child: Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: FittedBox(
              child: RichText(
                text: TextSpan(
                  text: card.suit ?? AppConstants.redHeart,
                  style: suitTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    /* for visible cards, the smaller card size is shown to the left of user,
    * and the bigger size is shown as the community card */
    return Transform.scale(
      scale: isNotCommunityCard ? 0.85 : 1.05,
      child: Container(
        height: AppDimensions.cardHeight * 1.5,
        width: card.smaller
            ? AppDimensions.cardWidth * 1.5
            : AppDimensions.cardWidth * 1.1,
        child: card.isShownAtTable
            ? ClipRRect(
                borderRadius: BorderRadius.circular(
                  5.0,
                ),
                child: FlipCard(
                  key: cardKey,
                  front: Image.asset(
                    CardBackAssets
                        .asset1_1, // todo: update this to the current card back asset
                    fit: BoxFit.fitHeight,
                  ),
                  back: cardWidget,
                ),
              )
            : cardWidget,
      ),
    );
  }
}
