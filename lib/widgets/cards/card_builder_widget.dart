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

    double _ratio = 1.0;

    switch (card.cardType) {
      case CardType.CommunityCard:
        _ratio = 1.0;
        break;
      case CardType.HoleCard:
        _ratio = 2.9;
        break;
      case CardType.PlayerCard:
        _ratio = 1.2;
        break;
      case CardType.HandLogOrHandHistoryCard:
        _ratio = 0.80;
        break;
    }

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
          : Image.asset(
              AppAssets.cardBackImage,
            ),
    );

    return cardWidget;
  }
}
