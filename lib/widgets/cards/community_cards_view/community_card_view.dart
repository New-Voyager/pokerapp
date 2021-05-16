/*
*
* community card view (SINGLE CARD)
*
* */
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class CommunityCardView extends StatelessWidget {
  final CardObject card;

  CommunityCardView({
    Key key,
    @required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    card.cardType = CardType.CommunityCard;
    return card.widget;
  }
}
