import 'package:flutter/material.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_cards_view/community_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_cards_view/community_cards_view.dart';
import 'package:pokerapp/widgets/card_view.dart';

enum CardFace {
  FRONT,
  BACK,
}

class CardObject {
  // card information
  String suit;
  String label;
  Color color;
  bool empty; // card is not shown in the UI

  // ui params
  bool smaller;
  bool highHandLog;

  bool isShownAtTable;
  bool isCommunity;

  /* this is needed in showdown and
  while highlighting a winner */
  bool highlight;
  bool otherHighlightColor;

  CardView cardView;
  CommunityCardView communityCardView;

  CardFace cardFace;

  CardObject({
    @required this.suit,
    @required this.label,
    @required this.color,
    this.isCommunity = false,
    this.smaller = false,
    this.highlight = false,
    this.isShownAtTable = false,
    this.highHandLog = false, // this is true for the community cards
    this.cardFace = CardFace.FRONT,
  }) {
    if (this.isCommunity) {
      this.communityCardView = CommunityCardView(
        card: this,
      );
    } else {
      this.cardView = CardView(
        card: this,
      );
    }

    this.empty = false;
  }

  bool isEmpty() => this.empty;

  // void cardShowFront() {
  //   if (cardFace == CardFace.FRONT) return;
  //   flipCard();
  // }

  // void cardShowBack() {
  //   if (cardFace == CardFace.BACK) return;
  //   flipCard();
  // }

  // void flipCard() {
  //   if (cardFace == CardFace.BACK)
  //     cardFace = CardFace.FRONT;
  //   else
  //     cardFace = CardFace.BACK;
  //   if (this.isCommunity) {
  //     this.communityCardView.flipCard();
  //   }
  // }

  Widget get widget {
    if (this.isCommunity) {
      return this.communityCardView;
    } else {
      return this.cardView;
    }
  }

  String get cardHash => '$suit:$label';

  @override
  String toString() =>
      'suit: $suit, label: $label, highlight: $highlight empty: $empty';

  static CardObject emptyCard() {
    CardObject card = new CardObject(suit: null, label: null, color: null);
    card.empty = true;
    return card;
  }
}
