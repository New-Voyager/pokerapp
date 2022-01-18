import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/card_view.dart';

class StackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool deactivated;
  final bool horizontal;

  StackCardView({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true,
  });

  List<Widget> _buildChildren() {
    List<Widget> _children = [];

    cards.forEach((CardObject card) {
      if (deactivated) {
        card.dim = true;
        // log('Player cards: reveal ${card.cardType}: ${card.dim}');
      }

      _children.add(card.widget);
      _children.add(const SizedBox(width: 2.0));
    });

    return _children;
  }

  @override
  Widget build(BuildContext context) {
    if (cards == null || cards.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildChildren(),
    );
  }
}

class StackCardView00 extends StatelessWidget {
  final List<int> cards;
  final bool show;
  final bool needToShowEmptyCards;
  final int maxCards;
  StackCardView00({
    this.cards,
    this.show,
    this.needToShowEmptyCards,
    this.maxCards = 5,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = [];
    if (show ?? true) {
      for (int c in cards) {
        CardObject card = CardHelper.getCard(c);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(SizedBox(width: 2.0));
      }
      if ((needToShowEmptyCards ?? false) && cards.length < this.maxCards) {
        for (int i = 0; i < this.maxCards - cards.length; i++) {
          // pass 0 for getting card backside
          CardObject card = CardHelper.getCard(0);
          card.cardType = CardType.HandLogOrHandHistoryCard;
          card.dim = true;
          // card.empty = true;
          card.cardFace = CardFace.BACK;
          cardViews.add(card.widget);
          cardViews.add(SizedBox(width: 2.0));
        }
      }
    } else {
      for (int _ in cards) {
        CardObject card = CardHelper.getCard(0);
        cardViews.add(card.widget);
        cardViews.add(
          SizedBox(width: 2.0),
        );
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: cardViews);
  }
}

class StackCardView01 extends StatelessWidget {
  final List<int> totalCards;
  final List<int> cardsToHighlight;

  final bool show;
  final bool needToShowEmptyCards;

  StackCardView01({
    this.totalCards,
    this.show,
    this.needToShowEmptyCards,
    this.cardsToHighlight,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = [];
    if (show ?? true) {
      for (int c in totalCards) {
        CardObject card = CardHelper.getCard(c);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        bool dim = true;
        for (int k in cardsToHighlight) {
          if (k == c) {
            dim = false;
            break;
          }
        }
        card.dim = dim;
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(
          SizedBox(
            width: 2.0,
          ),
        );
      }
      if ((needToShowEmptyCards ?? false) && totalCards.length < 5) {
        for (int i = 0; i < 5 - totalCards.length; i++) {
          // pass 0 for getting card backside
          CardObject card = CardHelper.getCard(0);
          card.dim = true;
          cardViews.add(card.widget);
          cardViews.add(
            SizedBox(
              width: 2.0,
            ),
          );
        }
      }
    } else {
      for (int _ in totalCards) {
        CardObject card = CardHelper.getCard(0);
        cardViews.add(card.widget);
        cardViews.add(
          SizedBox(
            width: 2.0,
          ),
        );
      }
    }
    return Row(children: cardViews);
  }
}

class StackCardView02 extends StatelessWidget {
  final List<int> cards;
  final bool show;

  StackCardView02({
    this.cards,
    this.show,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = [];

    if (cards != null) {
      for (int c in this.cards) {
        CardObject card = CardHelper.getCard(c);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(SizedBox(width: 2.0));
      }
    }
    // hide cards
    if (this.cards.length < 5) {
      // show back of the cards here
      for (int i = 0; i < 5 - this.cards.length; i++) {
        CardObject card = CardHelper.getCard(0);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(
          SizedBox(
            width: 2.0,
          ),
        );
      }
    }
    return Row(
      children: cardViews,
    );
  }
}

class StackCardView03 extends StatelessWidget {
  final List<int> cards;

  StackCardView03({
    @required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = [];

    if (cards != null) {
      for (int c in this.cards) {
        CardObject card = CardHelper.getCard(c);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(SizedBox(width: 2.0));
      }
    }
    // hide cards
    if (this.cards.length < 5) {
      // show back of the cards here
      for (int i = 0; i < 5 - this.cards.length; i++) {
        CardObject card = CardHelper.getCard(0);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(SizedBox(width: 2.0));
      }
    }
    return Row(
      children: cardViews,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class NamePlateStackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final List<int> highlightCards;
  final bool deactivated;
  final bool horizontal;

  NamePlateStackCardView({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true,
    this.highlightCards = const [],
  });

  List<Widget> _buildChildren() {
    double dx = 0;
    double offset = 80 / cards.length;

    List<Widget> _children = [
      SizedBox(
        width:
            namePlateCardViewWidth * cards.length - offset * (cards.length - 1),
      ),
    ];

    for (int index = 0; index < cards.length; index++) {
      CardObject card = cards[index];
      if (deactivated) {
        card.dim = true;
      }

      Widget view = NamePlateCardView(
        card: card,
        cardBackBytes: null,
        doubleBoard: card.doubleBoard,
        index: _children.length,
        highlightCards: highlightCards,
      );

      double dy = 0;
      if (card.highlight) {
        dy = -20;
      }

      view = Transform.translate(offset: Offset(dx, dy), child: view);

      dx += offset;

      _children.add(view);
    }

    return _children;
  }

  @override
  Widget build(BuildContext context) {
    if (cards == null || cards.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: _buildChildren(),
    );
  }
}
