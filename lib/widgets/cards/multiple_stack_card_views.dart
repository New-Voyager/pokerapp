import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';

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
      if (deactivated) card.dim = true;

      _children.add(card.widget);
      _children.add(const SizedBox(width: 2.0));
    });

    return _children;
  }

  @override
  Widget build(BuildContext context) {
    if (cards == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: cards.isEmpty ? [SizedBox.shrink()] : _buildChildren(),
    );
  }
}

class CardsView extends StatelessWidget {
  final List<int> cards;
  final bool show;
  final bool needToShowEmptyCards;

  CardsView({
    this.cards,
    this.show,
    this.needToShowEmptyCards,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = [];
    if (show ?? true) {
      for (int c in cards) {
        CardObject card = CardHelper.getCard(c);
        card.cardType = CardType.HandLogOrHandHistoryCard;
        cardViews.add(card.widget);
        cardViews.add(
          SizedBox(
            width: 2.0,
          ),
        );
      }
      if ((needToShowEmptyCards ?? false) && cards.length < 5) {
        for (int i = 0; i < 5 - cards.length; i++) {
          // pass 0 for getting card backside
          CardObject card = CardHelper.getCard(0);
          card.cardType = CardType.HandLogOrHandHistoryCard;
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
      for (int _ in cards) {
        CardObject card = CardHelper.getCard(0);
        cardViews.add(card.widget);
        cardViews.add(
          SizedBox(
            width: 2.0,
          ),
        );
      }
    }
    return Container(
      color: Colors.yellow,
      child: Row(children: cardViews),
    );
  }
}

class HighlightedCardsView extends StatelessWidget {
  final List<int> totalCards;
  final List<int> cardsToHighlight;

  final bool show;
  final bool needToShowEmptyCards;

  HighlightedCardsView({
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
    return Container(
      color: Colors.green,
      child: Row(children: cardViews),
    );
  }
}

class NonGameScreenCommunityCardWidget extends StatelessWidget {
  final List<int> cards;
  final bool show;

  NonGameScreenCommunityCardWidget({
    this.cards,
    this.show,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = [];
    print('cards: ${cards.length}');

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
    return Container(
      color: Colors.red,
      child: Row(children: cardViews),
    );
  }
}
