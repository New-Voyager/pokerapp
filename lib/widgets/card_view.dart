import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/utils/card_helper.dart';

final cardBackImage =
    new Image(image: AssetImage('assets/images/card_back/set2/Asset 6.png'));

class CardView extends StatelessWidget {
  final CardObject card;
  final bool grayOut;
  double widthRatio;
  double width;
  final bool back;
  double height;
  CardView({
    @required this.card,
    this.grayOut = false,
    this.widthRatio = 1.5,
    this.back = false,
  });

  Widget getCard(TextStyle cardTextStyle, TextStyle suitTextStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: FittedBox(
            child: Text(
              card.label == 'T' ? '10' : card.label,
              style: cardTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: FittedBox(
            child: RichText(
              text: TextSpan(
                text: card.suit ?? AppConstants.redHeart,
                style: suitTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget emptyCard() {
    return ClipRRect(child: cardBackImage);
  }

  @override
  Widget build(BuildContext context) {
    return buildCardWidget(context);
  }

  Widget buildCardWidget(BuildContext context) {
    double cardWidth = AppDimensions.cardWidth * 1.1;
    double cardHeight = AppDimensions.cardHeight * 1.5;
    TextStyle cardTextStyle = AppStyles.cardTextStyle.copyWith(
      fontSize: 12,
    );
    TextStyle suitTextStyle = AppStyles.cardTextStyle.copyWith(
      fontSize: 12,
    );
    bool highlight = false;
    Color highlightColor = Colors.blue.shade100;
    if (card != null) {
      cardTextStyle = AppStyles.cardTextStyle.copyWith(
        color: card.color,
        fontSize: 12,
      );
      suitTextStyle = AppStyles.cardTextStyle.copyWith(
        color: card.color,
        fontSize: 12,
      );
      highlight = card.highlight ?? false;
      highlightColor = (card.otherHighlightColor ?? false)
          ? Colors.blue.shade100
          : Colors.green.shade100;
      cardTextStyle = AppStyles.cardTextStyle.copyWith(
        color: card.color,
      );
      suitTextStyle = AppStyles.cardTextStyle.copyWith(
        color: card.color,
      );
    }
    if (card.smaller) {
      cardWidth = AppDimensions.cardWidth * 1.2;
    } else {
      cardWidth = 22;
      cardHeight = 32;

      // TODO: We need to revisit how to get width and height working with ratio
      width = cardWidth+10;
      height = cardHeight+10;
    }

    Widget cardWidget = Container(
      height: cardHeight,
      width: cardWidth,
      foregroundDecoration: grayOut
          ? BoxDecoration(
              color: Colors.black54,
              backgroundBlendMode: BlendMode.darken,
            )
          : null,
      decoration: BoxDecoration(
        color: highlight ? highlightColor : Colors.white,
      ),
      child: this.card.isEmpty()
          ? emptyCard()
          : getCard(cardTextStyle, suitTextStyle),
    );

    return cardWidget;
  }
}

class CardsView extends StatelessWidget {
  List<int> cards;
  List<CardObject> cardObjects;
  bool show;
  CardsView(List<int> cards, bool show) {
    this.cards = cards;
    this.show = show;
    if (this.show == null) {
      this.show = false;
    }
    this.cardObjects = cards.map((e) => CardHelper.getCard(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = new List<Widget>();
    if (show) {
      for (int c in cards) {
        CardObject card = CardHelper.getCard(c);
        cardViews.add(CardView(card: card));
        cardViews.add(SizedBox(
          width: 2.0,
        ));
      }
    }
    return Row(children: cardViews);
  }
}

class CommunityCardWidget extends StatelessWidget {
  final List<int> cards;
  List<CardObject> cardObjects;
  final bool show;

  CommunityCardWidget(this.cards, this.show) {
    this.cardObjects = cards.map((e) => CardHelper.getCard(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardViews = new List<Widget>();

    if (cards != null) {
      for (int c in this.cards) {
        CardObject card = CardHelper.getCard(c);
        cardViews.add(CardView(card: card));
        cardViews.add(SizedBox(
          width: 2.0,
        ));
      }
    }
    // hide cards
    if (this.cards.length < 5) {
      // show back of the cards here
      for (int i = 0; i < 5 - this.cards.length; i++) {
        CardObject card = CardHelper.getCard(0);
        cardViews.add(CardView(card: card));
        cardViews.add(SizedBox(
          width: 2.0,
        ));
      }
    }
    return Row(children: cardViews);
  }
}
