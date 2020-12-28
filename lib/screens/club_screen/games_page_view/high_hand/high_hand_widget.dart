import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';

class HighHandWidget extends StatelessWidget {
  final seprator = SizedBox(
    height: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
      child: Container(
        height: 270.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xff313235),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 5,
                    child: RichText(
                      text: TextSpan(
                          text: "Robert ",
                          style: TextStyle(color: Colors.orange),
                          children: [
                            TextSpan(
                                text: "hits a high hand",
                                style: TextStyle(color: Colors.white))
                          ]),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: getCards(),
                  ),
                ],
              ),
              seprator,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Community",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              seprator,
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: getCards(),
                  ),
                  Flexible(
                    child: Container(),
                    flex: 5,
                  ),
                ],
              ),
              seprator,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Robert",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              seprator,
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: getCards(),
                  ),
                  Flexible(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "#212",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          seprator,
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "12/12/2020 11:30PM",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
