import 'package:flutter/material.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';

class CardObject {
  // card information
  String suit;
  String label;
  Color color;
  bool empty; // card is not shown in the UI

  // ui params
  bool smaller;

  bool isShownAtTable;

  /* this is needed in showdown and
  while highlighting a winner */
  bool highlight;
  bool otherHighlightColor;

  VisibleCardView visibleCard;

  CardObject({
    @required this.suit,
    @required this.label,
    @required this.color,
    this.smaller = false,
    this.highlight = false,
    this.isShownAtTable = false, // this is true for the community cards
  }) {
    this.visibleCard = VisibleCardView(
      card: this,
    );
    this.empty = false;
  }

  bool isEmpty() => this.empty;

  void flipCard() => this.visibleCard.flipCard();

  Widget get widget => this.visibleCard;

  Widget get grayedWidget => VisibleCardView(
        card: this,
        grayOut: true,
      );

  @override
  String toString() =>
      'suit: $suit, label: $label, highlight: $highlight empty: $empty';

  static CardObject emptyCard() {
    CardObject card = new CardObject(suit: null, label: null, color: null);
    card.empty = true;
    return card;
  }
}
