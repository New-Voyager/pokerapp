/*
*
* community card view (SINGLE CARD)
*
* */
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/cards/card_view_old.dart';

class CommunityCardView extends StatelessWidget {
  final CardObject card;

  CommunityCardView({
    Key key,
    @required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    card.cardType = CardType.CommunityCard;

    return Transform.scale(
      scale: 1.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          3.0,
        ),
        child: card.widget,
      ),
    );
  }
}
