import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class CardBuilderWidget extends StatelessWidget {
  final CardObject card;
  final bool isCardVisible;
  final Function cardBuilder;
  final bool dim;
  final bool shadow;
  final double roundRadius;

  CardBuilderWidget({
    @required this.card,
    @required this.dim,
    @required this.isCardVisible,
    @required Widget this.cardBuilder(TextStyle _, TextStyle __),
    this.shadow = false,
    this.roundRadius = 5.0,
  }) : assert(card != null &&
            dim != null &&
            isCardVisible != null &&
            cardBuilder != null);

  /* this method returns the correct RATIO for a particular CARD TYPE */
  double _getCardRatioFromCardType() {
    switch (card.cardType) {
      case CardType.CommunityCard:
        return 1.0;

      case CardType.HoleCard:
        return 2.9;

      case CardType.PlayerCard:
        return 1.2;

      case CardType.HandLogOrHandHistoryCard:
        return 0.80;

      default:
        return 1.0;
    }
  }

  // TODO: WE NEED TO CHANGE THE WAY WE HIGHLIGHT CARDS

  @override
  Widget build(BuildContext context) {
    TextStyle cardTextStyle = AppStyles.cardTextStyle.copyWith(fontSize: 12);
    TextStyle suitTextStyle = AppStyles.cardTextStyle.copyWith(fontSize: 12);

    bool highlight = false;
    Color highlightColor = Colors.blue.shade100;

    cardTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
      fontSize: 12,
    );

    suitTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
      fontSize: 8,
    );

    highlight = card.highlight ?? false;

    highlightColor = (card.otherHighlightColor ?? false)
        ? Colors.blue.shade100
        : Colors.green.shade100;

    cardTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );

    suitTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );

    double _ratio = _getCardRatioFromCardType();

    Widget cardWidget = Container(
      height: AppDimensions.cardHeight * _ratio,
      width: AppDimensions.cardWidth * _ratio,
      foregroundDecoration: dim
          ? BoxDecoration(
              color: Colors.black54,
              backgroundBlendMode: BlendMode.darken,
            )
          : null,
      decoration: BoxDecoration(
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 20.0,
                  spreadRadius: 10.0,
                ),
              ]
            : [],
        borderRadius: BorderRadius.all(
          Radius.circular(roundRadius),
        ),
        color: highlight ? highlightColor : Colors.white,
      ),
      child: isCardVisible
          ? cardBuilder(cardTextStyle, suitTextStyle)
          : ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(roundRadius),
              ),
              child: Image.asset(
                AppAssets.cardBackImage,
              ),
            ),
    );

    return cardWidget;
  }
}
