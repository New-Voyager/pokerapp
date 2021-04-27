import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';

class GameCardWidget extends StatelessWidget {
  final CardObject card;
  final bool grayOut;
  final double widthRatio;
  // double width;
  // double height;
  final bool back;
  final bool isCardVisible;
  final bool marked;
  final Function onMarkTapCallback;

  GameCardWidget({
    @required this.card,
    this.onMarkTapCallback,
    this.marked = false,
    this.grayOut = false,
    this.widthRatio = 1.5,
    this.back = false,
    this.isCardVisible = false,
  });

  Widget getCard(TextStyle cardTextStyle, TextStyle suitTextStyle) {
    return Stack(
      children: [
        /* center suit */
        Align(
          child: Container(
            height: 220 / 3,
            width: 170 / 3,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: card.suit ?? AppConstants.redHeart,
                  style: suitTextStyle,
                ),
              ),
            ),
          ),
        ),

        /* top left suit */
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
              ),
              Text(
                card.suit ?? AppConstants.redHeart,
                style: suitTextStyle.copyWith(fontSize: 11),
              ),
            ],
          ),
          top: 5,
          left: 5,
        ),

        /* bottom right suit */
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
              ),
              Text(
                card.suit ?? AppConstants.redHeart,
                style: suitTextStyle.copyWith(fontSize: 11),
              ),
            ],
          ),
          bottom: 5,
          right: 5,
        ),

        /* visible marker */
        Positioned(
          bottom: 5,
          left: 5,
          child: marked
              ? Icon(
                  Icons.visibility,
                  color: Colors.green,
                )
              : const SizedBox.shrink(),
        ),
        Positioned(
            top: 0,
            left: 0,
            width: 20,
            height: 120,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                log('card is tapped for viewing');
                onMarkTapCallback();
              },
              child: Container(
                color: Colors.black26,
              ),
            ))
      ],
    );

    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Expanded(
    //       flex: 7,
    //       child: FittedBox(
    //         child: Text(
    //           card.label == 'T' ? '10' : card.label,
    //           style: cardTextStyle,
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       flex: 4,
    //       child: FittedBox(
    //         child: RichText(
    //           text: TextSpan(
    //             text: card.suit ?? AppConstants.redHeart,
    //             style: suitTextStyle,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget emptyCard() {
    return ClipRRect(child: Image.asset(AppAssets.cardBackImage));
  }

  @override
  Widget build(BuildContext context) {
    return buildCardWidget(context);
  }

  Widget buildCardWidget(BuildContext context) {
    // double cardWidth = 85;
    // double cardHeight = 110;
    TextStyle cardTextStyle = AppStyles.cardTextStyle.copyWith(
      fontSize: 12,
    );
    TextStyle suitTextStyle = AppStyles.cardTextStyle.copyWith(
      fontSize: 12,
    );
    bool highlight = false;
    Color highlightColor = Colors.blue.shade100;
    if (card != null) {
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
    }
    // if (card.smaller) {
    //   cardWidth = AppDimensions.cardWidth * 1.2;
    // } else {
    //   cardWidth = 22;
    //   cardHeight = 35;
    //
    //   // // TODO: We need to revisit how to get width and height working with ratio
    //   // width = cardWidth + 10;
    //   // height = cardHeight + 10;
    // }

    Widget cardWidget = Container(
      height: 110,
      width: 85,
      foregroundDecoration: grayOut
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
        color: highlight ? highlightColor : Colors.white,
      ),
      child: getCardUi(cardTextStyle, suitTextStyle),
    );

    return cardWidget;
  }

  Widget getCardUi(TextStyle cardTextStyle, TextStyle suitTextStyle) {
    if (this.card.empty) {
      return emptyCard();
    } else if (this.isCardVisible) {
      return getCard(cardTextStyle, suitTextStyle);
    } else {
      return Image.asset(AppAssets.cardBackImage);
    }
  }
}
