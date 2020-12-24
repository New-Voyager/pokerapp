import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class VisibleCardView extends StatelessWidget {
  final CardObject card;
  final bool grayOut;

  VisibleCardView({
    @required this.card,
    this.grayOut = false,
  });

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

    /* for visible cards, the smaller card size is shown to the left of user,
    * and the bigger size is shown as the community card */
    return Transform.scale(
      scale: card.smaller ? 0.90 : 1.05,
      child: Container(
        padding: const EdgeInsets.all(5.0),
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
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: card.smaller
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 10,
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
      ),
    );
  }
}
