import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';

class HandHistoryWidget extends StatelessWidget {

  final String number;
  final String name;
  final String ended;
  final String won;
  final bool showCards;

  HandHistoryWidget(
      {this.name = "Paul",
      this.number = "123",
      this.ended = "Showdown",
      this.showCards = true,
      this.won = "24"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xff313235),
        ),
        height: 100.0,
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 3.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "#" + number,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.blue),
                    ),

                    /*RichText(
                      text: TextSpan(
                          text: "Ended At: ",
                          style: TextStyle(
                            color: Color(0xff848484),
                          ),
                          children: [
                            TextSpan(
                                text: ended,
                                style: TextStyle(color: Colors.white)),
                          ]),
                    ),*/
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: showCards ? getCards() : Container(),
            ),

            Flexible(
                flex: 1,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                )),

          ],

        ),
      ),
    );
  }

  getCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.redHeart, label: "B", color: Colors.red)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.redHeart, label: "9", color: Colors.red)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "A",
                color: Colors.black)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "J",
                color: Colors.black)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "J",
                color: Colors.black)),
      ],
    );
  }
}
