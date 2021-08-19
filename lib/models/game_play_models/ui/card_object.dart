import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/widgets/cards/card_view.dart';

enum CardFace {
  FRONT,
  BACK,
}

enum CardType {
  CommunityCard,
  HoleCard,
  PlayerCard,
  HandLogOrHandHistoryCard,
}

class CardObject {
  // card information
  int cardNum;
  String suit;
  String label;
  Color color;
  bool empty;

  /* this is needed in showdown and
  while highlighting a winner */
  bool highlight;
  bool dim;
  bool dimBoard;
  bool otherHighlightColor;

  CardType cardType;
  CardFace cardFace;

  CardObject({
    @required this.cardNum,
    @required this.suit,
    @required this.label,
    @required this.color,
    this.highlight = false,
    this.dim = false,
    this.cardType = CardType.HoleCard,
    this.cardFace = CardFace.FRONT,
    this.dimBoard = false,
    this.empty = false,
  });

  factory CardObject.emptyCard() {
    CardObject card =
        new CardObject(cardNum: 0, suit: null, label: null, color: null);
    card.empty = true;
    card.cardFace = CardFace.BACK;
    card.cardType = CardType.HandLogOrHandHistoryCard;
    return card;
  }

  bool isEmpty() => this.empty;

  Widget get widget => CardView(
        card: this,
        cardBackBytes: null,
      );

  String get cardHash => '$cardNum';

  @override
  String toString() => jsonEncode({
        // 'suit': suit,
        // 'label': label,
        'num': cardNum,
        'highlight': highlight,
        'empty': empty,
      });
}
