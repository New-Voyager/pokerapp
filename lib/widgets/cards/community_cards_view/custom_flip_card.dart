import 'dart:typed_data';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class CustomFlipCard extends StatelessWidget {
  final Function onFlipDone;
  final GlobalKey<FlipCardState> globalKey;
  final Widget cardWidget;
  final Uint8List cardBackBytes;
  final bool twoBoards;

  CustomFlipCard({
    @required this.onFlipDone,
    @required this.globalKey,
    @required this.cardWidget,
    @required this.cardBackBytes,
    this.twoBoards,
  });

  @override
  Widget build(BuildContext context) => FlipCard(
        onFlipDone: onFlipDone,
        key: globalKey,
        speed: AppConstants.communityCardFlipAnimationDuration.inMilliseconds,
        flipOnTouch: false,
        back: cardWidget,
        front: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.memory(
            cardBackBytes,
            height: AppDimensions.cardHeight,
            width: AppDimensions.cardWidth,
          ),
        ),
      );
}
