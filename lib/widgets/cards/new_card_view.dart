import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class CardViewNew extends StatelessWidget {
  final CardObject card;

  CardViewNew({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(card.cardNum.toString() + " " + card.label);
    String cardFace = "assets/images/card_face_new/${card.cardNum}.png";
    bool hasCardFace = false;
    if (card.cardNum > 144 && card.cardNum < 185) {
      hasCardFace = true;
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // log(constraints.maxHeight.toString() + "loll");

      double cardWidth = constraints.maxWidth;
      String label = card.label;
      if (card.label == 'T') {
        label = '10';
      }
      ;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: (cardWidth < 69) ? 4.0 : 8.0,
                  left: (cardWidth < 69) ? 4.0 : 8.0,
                  bottom: (cardWidth < 69) ? 0 : 2.0,
                  right: (cardWidth < 69) ? 1 : 2.0,
                ),
                child: hasCardFace
                    ? Image.asset(cardFace)
                    : Text(
                        card.suit,
                        style: TextStyle(
                          color: card.color,
                          fontSize: cardWidth < 69 ? 24.0 : 45.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: '',
                        ),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: (cardWidth < 69) ? 2.0 : 15.0,
                  top: (cardWidth < 69) ? 4.0 : 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // color: Colors.red,
                      height: cardWidth < 69 ? 14 : 40,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: card.color,
                          height: 0.9,
                          fontSize: cardWidth < 69 ? 18.0 : 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kurale',
                        ),
                      ),
                    ),
                    cardWidth < 69
                        ? SizedBox.shrink()
                        : SizedBox(
                            height: 2,
                          ),
                    Text(
                      card.suit,
                      style: TextStyle(
                        color: card.color,
                        fontSize: cardWidth < 69 ? 12.0 : 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: '',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
