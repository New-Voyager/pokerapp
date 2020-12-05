import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class VisibleCardView extends StatelessWidget {
  final CardObject card;

  VisibleCardView({
    @required this.card,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = AppStyles.cardTextStyle.copyWith(
      color: card.color,
    );

    return Transform.scale(
      scale: card.smaller ? 0.8 : 1.1,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        height: AppDimensions.cardHeight * 1.5,
        width: AppDimensions.cardWidth * 1.5,
        decoration: BoxDecoration(
            color: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                child: Text(
                  card.label ?? 'L',
                  style: textStyle,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                child: RichText(
                  text: TextSpan(
                    text: card.suit ?? AppConstants.redHeart,
                    style: textStyle,
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
