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
      double cardWidth = constraints.maxWidth;
      double cardHeight = constraints.maxHeight;
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
                child: hasCardFace
                    ? SizedBox(
                        width: cardWidth / 1.3,
                        child: FittedBox(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              cardFace,
                              alignment: Alignment.bottomRight,
                              fit: BoxFit.contain,
                            )),
                      )
                    : SizedBox(
                        width: cardWidth / 2,
                        child: FittedBox(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            card.suit,
                            style: TextStyle(
                              color: card.color,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: '',
                            ),
                          ),
                        ),
                      )),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cardWidth / 10,
                    top: cardWidth / 7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: cardWidth / 2.7,
                        height: cardWidth / 2.7,
                        child: FittedBox(
                          alignment: Alignment.topLeft,
                          child: Text(
                            label,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: 0.9,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kurale',
                              color: card.color,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: cardHeight / 18,
                      ),
                      SizedBox(
                        width: cardWidth / 3.7,
                        height: cardWidth / 3.7,
                        child: FittedBox(
                          alignment: Alignment.topLeft,
                          child: Text(
                            card.suit,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: 0.9,
                              fontWeight: FontWeight.bold,
                              fontFamily: '',
                              fontStyle: FontStyle.normal,
                              color: card.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
