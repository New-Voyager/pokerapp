/*
*
* community card view (SINGLE CARD)
*
* */
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/card_view.dart';

class CommunityCardView extends StatelessWidget {
  final CardObject card;

  CommunityCardView({
    Key key,
    @required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CardView cardView = CardView(
      card: card,
      grayOut: false,
      widthRatio: 1.5,
    );

    final Widget cardWidget = cardView.buildCardWidget(context);

    return Transform.scale(
      scale: 1.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          3.0,
        ),
        child: Container(
          height: cardView.height,
          width: cardView.width,
          child: cardWidget,
        ),
      ),
    );
  }
}
