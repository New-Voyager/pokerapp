import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

final cardBackImage = new Image(
  image: AssetImage('assets/images/card_back/set2/Asset 6.png'),
);

class CardView extends StatelessWidget {
  final CardObject card;

  CardView({
    @required this.card,
  });

  Widget getCard(TextStyle cardTextStyle, TextStyle suitTextStyle) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: FittedBox(
              child: Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 4,
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
      );

  Widget emptyCard() {
    return ClipRRect(child: cardBackImage);
  }

  @override
  Widget build(BuildContext context) {
    return buildCardWidget(context);
  }

  Widget buildCardWidget(BuildContext context) {
    // double cardWidth = AppDimensions.cardWidth * 1.1;
    // double cardHeight = AppDimensions.cardHeight * 1.5;
    TextStyle cardTextStyle = AppStyles.cardTextStyle.copyWith(
      fontSize: 16,
    );
    TextStyle suitTextStyle = AppStyles.cardTextStyle.copyWith(
      fontSize: 16,
    );
    // bool highlight = false;
    // Color highlightColor = Colors.blue.shade100;
    // if (card != null) {
    //   cardTextStyle = AppStyles.cardTextStyle.copyWith(
    //     color: card.color,
    //     fontSize: 12,
    //   );
    //   suitTextStyle = AppStyles.cardTextStyle.copyWith(
    //     color: card.color,
    //     fontSize: 12,
    //   );
    //   highlight = card.highlight ?? false;
    //   highlightColor = (card.otherHighlightColor ?? false)
    //       ? Colors.blue.shade100
    //       : Colors.green.shade100;
    //   cardTextStyle = AppStyles.cardTextStyle.copyWith(
    //     color: card.color,
    //   );
    //   suitTextStyle = AppStyles.cardTextStyle.copyWith(
    //     color: card.color,
    //   );
    // }
    // if (card.smaller) {
    //   cardWidth = AppDimensions.cardWidth * 1.2;
    // } else {
    //   cardWidth = 22;
    //   cardHeight = 35;
    //
    //   // TODO: We need to revisit how to get width and height working with ratio
    //   width = cardWidth + 10;
    //   height = cardHeight + 10;
    // }

    return Container(
      padding: const EdgeInsets.only(
        bottom: 2.0,
      ),
      height: AppDimensions.cardHeight,
      width: AppDimensions.cardWidth,
      foregroundDecoration: card.dim
          ? BoxDecoration(
              color: Colors.black54,
              backgroundBlendMode: BlendMode.darken,
            )
          : null,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 20.0,
            spreadRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: this.card.isEmpty()
          ? emptyCard()
          : getCard(
              cardTextStyle,
              suitTextStyle,
            ),
    );
  }
}
