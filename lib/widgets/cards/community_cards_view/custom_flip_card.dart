import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';

class CustomFlipCard extends StatelessWidget {
  final Function onFlipDone;
  final GlobalKey<FlipCardState> globalKey;
  final Widget cardWidget;
  final String cardBackAsset;
  final int speed;

  CustomFlipCard({
    @required this.onFlipDone,
    @required this.globalKey,
    @required this.cardWidget,
    @required this.cardBackAsset,
    this.speed = 200,
  });

  @override
  Widget build(BuildContext context) => FlipCard(
        onFlipDone: onFlipDone,
        key: globalKey,
        speed: this.speed,
        flipOnTouch: false,
        back: cardWidget,
        front: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.asset(
            cardBackAsset,
            height: AppDimensions.cardHeight *
                CardBuilderWidget.getCardRatioFromCardType(
                  CardType.CommunityCard,
                ),
            width: AppDimensions.cardWidth *
                CardBuilderWidget.getCardRatioFromCardType(
                  CardType.CommunityCard,
                ),
          ),
        ),
      );
}
