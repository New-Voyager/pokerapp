import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/club_screen_icons_icons.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';

class HighHandWidget extends StatelessWidget {
  final seprator = SizedBox(
    height: 10.0,
  );
  final HighHandWinner winner;
  HighHandWidget(this.winner);

  Widget cardsView(List<int> cards) {
    List<Widget> cardViews = new List<Widget>();
    for (int cardValue in cards) {
      CardObject card = CardHelper.getCard(cardValue);
      card.smaller = true;
      card.highHandLog = true;
      cardViews.add(VisibleCardView(card: card));
    }
    return Row(children: cardViews);
  }

  @override
  Widget build(BuildContext context) {
    var newFormat = new DateFormat.yMd().add_jm();
    final date = newFormat.format(winner.handTime);

    Widget widget = Padding(
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
                          text: winner.player,
                          style: TextStyle(color: Colors.orange),
                          children: [
                            TextSpan(
                                text: " hits a high hand",
                                style: TextStyle(color: Colors.white))
                          ]),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: cardsView(winner.hhCards),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 5,
                    child: cardsView(winner.boardCards),
                  ),
                  Flexible(
                    child: Center(
                      child: Visibility(
                        visible: winner.winner != null && winner.winner,
                        child: Container(
                          child: Icon(
                            ClubScreenIcons.reward,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                    flex: 5,
                  ),
                ],
              ),
              seprator,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  winner.player,
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              seprator,
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: cardsView(winner.playerCards),
                  ),
                  Flexible(
                    flex: 5,
                    child: Container(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '#${winner.handNum}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          seprator,
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              date,
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
    return widget;
  }
}
