import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class CustomFlipCard extends StatelessWidget {
  final Function onFlipDone;
  final GlobalKey<FlipCardState> globalKey;
  final Widget cardWidget;
  final String cardBackAsset;

  CustomFlipCard({
    @required this.onFlipDone,
    @required this.globalKey,
    @required this.cardWidget,
    @required this.cardBackAsset,
  });

  @override
  Widget build(BuildContext context) => FlipCard(
        onFlipDone: onFlipDone,
        key: globalKey,
        flipOnTouch: false,
        back: cardWidget,
        front: Transform.translate(
          offset: Offset(
            0.0,
            -4.00,
          ),
          child: SizedBox(
            height: AppDimensions.cardHeight * 1.4,
            width: AppDimensions.cardWidth * 1.4,
            child: Image.asset(
              cardBackAsset,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
}
