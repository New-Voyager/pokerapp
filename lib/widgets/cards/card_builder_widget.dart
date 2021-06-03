import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/cards/pulsating_card_container.dart';
import 'package:provider/provider.dart';

// todo: turn off the pulsating highlight if you don't like it ;-)
bool keepPulsatingHighlight = true;

class CardBuilderWidget extends StatelessWidget {
  final CardObject card;
  final bool isCardVisible;
  final Function cardBuilder;
  final bool dim;
  final bool highlight;
  final bool shadow;
  final double roundRadius;
  final CardFace cardFace;

  CardBuilderWidget({
    @required this.card,
    @required this.dim,
    @required this.highlight,
    @required this.isCardVisible,
    @required Widget this.cardBuilder(TextStyle _, TextStyle __),
    this.shadow = false,
    this.roundRadius = 5.0,
    this.cardFace,
  }) : assert(card != null &&
            dim != null &&
            isCardVisible != null &&
            cardBuilder != null);

  /* this method returns the correct RATIO for a particular CARD TYPE */
  static double getCardRatioFromCardType(
    CardType cardType,
    BuildContext context,
  ) {
    switch (cardType) {
      case CardType.CommunityCard:
        /* if we have a card type of community cards, then we must be on the 
          game screen, thus we can safely call BoardAttributesObject */
        final bao = context.read<BoardAttributesObject>();
        return 1.2 * bao.communityCardSizeScales;

      case CardType.HoleCard:
        return 2.9;

      case CardType.PlayerCard:
        return 0.90;

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

    cardTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
      fontSize: 12,
    );

    suitTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
      fontSize: 8,
    );

    bool highlight = card.highlight ?? false;

    Color highlightColor = (card.otherHighlightColor ?? false)
        ? Colors.blue.shade100
        : Colors.green.shade100;

    cardTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );

    suitTextStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );

    double _ratio = getCardRatioFromCardType(
      card.cardType,
      context,
    );

    // IMP: we ignore "dim" value if "highlight" is true
    bool toDim = dim;
    if (highlight) toDim = false;

    final double height = AppDimensions.cardHeight * _ratio;
    final double width = AppDimensions.cardWidth * _ratio;

    Widget cardWidget = Container(
      height: height,
      width: width,
      foregroundDecoration: toDim
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
        color: Colors.white,
      ),
      child: cardFace == CardFace.FRONT
          ? isCardVisible
              ? cardBuilder(cardTextStyle, suitTextStyle)
              : Container()
          : ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(roundRadius),
              ),
              child: Image.asset(
                AppAssets.cardBackImage,
              ),
            ),
    );

    if (highlight && keepPulsatingHighlight)
      return PulsatingCardContainer(
        child: cardWidget,
        height: height,
        width: width,
        color: Colors.green.withOpacity(0.80),
        animationUpToWidth: 4.0,
      );

    return cardWidget;
  }
}
