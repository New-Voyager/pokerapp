import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/widgets/cards/card_view.dart';

enum CardFace {
  FRONT,
  BACK,
}

enum CardType {
  Large,
  Medium,
  Small,
  Smallest,
}

class CardObject {
  // card information
  String suit;
  String label;
  Color color;
  bool empty;

  /* this is needed in showdown and
  while highlighting a winner */
  bool highlight;
  bool dim;

  bool otherHighlightColor;

  CardType cardType;
  CardFace cardFace;

  CardObject({
    @required this.suit,
    @required this.label,
    @required this.color,
    this.highlight = false,
    this.dim = false,
    this.cardType = CardType.Medium,
    this.cardFace = CardFace.FRONT,
    this.empty = false,
  });

  factory CardObject.emptyCard() {
    CardObject card = new CardObject(suit: null, label: null, color: null);
    card.empty = true;
    return card;
  }

  bool isEmpty() => this.empty;

  Widget get widget => CardView(card: this);

  String get cardHash => '$suit:$label';

  @override
  String toString() => jsonEncode({
        'suit': suit,
        'label': label,
        'highlight': highlight,
        'empty': empty,
      });
}
