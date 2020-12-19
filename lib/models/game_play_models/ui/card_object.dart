import 'package:flutter/material.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';

class CardObject {
  // card information
  String suit;
  String label;
  Color color;

  // ui params
  bool smaller;

  CardObject({
    @required this.suit,
    @required this.label,
    @required this.color,
    this.smaller = false,
  });

  Widget get widget => VisibleCardView(
        card: this,
      );

  Widget get grayedWidget => VisibleCardView(
        card: this,
        grayOut: true,
      );
}
