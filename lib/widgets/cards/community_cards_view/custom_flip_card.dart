import 'dart:typed_data';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';

class CustomFlipCard extends StatelessWidget {
  final Function onFlipDone;
  final GlobalKey<FlipCardState> globalKey;
  final Widget cardWidget;
  final Uint8List cardBackBytes;

  CustomFlipCard({
    @required this.onFlipDone,
    @required this.globalKey,
    @required this.cardWidget,
    @required this.cardBackBytes,
  });

  double _getScale(context) => CardBuilderWidget.getCardRatioFromCardType(
        CardType.CommunityCard,
        context,
      );

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
            height: AppDimensions.cardHeight * _getScale(context),
            width: AppDimensions.cardWidth * _getScale(context),
          ),
        ),
      );
}
