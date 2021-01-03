/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart'; //for date locale

class HighhandWinnersView extends StatelessWidget {
  final separator = SizedBox(
    height: 5.0,
  );
  final colSeparator = SizedBox(
    width: 20.0,
  );

  GameHistoryDetailModel data;
  HighhandWinnersView(this.data);

  Widget cardsView(List<int> cards) {
    List<Widget> cardViews = new List<Widget>();
    for (int cardValue in cards) {
      CardObject card = CardHelper.getCard(cardValue);
      card.smaller = true;
      cardViews.add(VisibleCardView(card: card));
    }
    return Row(children: cardViews);
  }

  Widget hhWidget(HighHandWinner winner) {
    var newFormat = new DateFormat.yMd().add_jm();
    final date = newFormat.format(winner.handTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // player, community
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  winner.player,
                  style: TextStyle(color: Colors.yellow),
                ),
                separator,
                cardsView(winner.playerCards),
              ],
            ),
            colSeparator,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community',
                  style: TextStyle(color: Colors.teal),
                ),
                separator,
                cardsView(winner.boardCards),
              ],
            )
          ],
        ),
        Row(
          // highhand
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'High hand',
                  style: TextStyle(color: Colors.green),
                ),
                separator,
                cardsView(winner.hhCards),
              ],
            ),
            colSeparator,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  winner.gameCode + '/#' + winner.handNum.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(date, style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> hhWinners = new List<Widget>();

    for (HighHandWinner winner in data.hhWinners) {
      hhWinners.add(hhWidget(winner));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      separator,
      Text(
        "High Hand Winners",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      separator,
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: hhWinners,
          ),
        ],
      )
    ]);
  }

  @override
  Widget build2(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        separator,
        Text(
          "High Hand Winners ABCDE",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        separator,
        Text(
          "Reward: 100",
          style: TextStyle(color: Color(0xff848484)),
        ),
        separator,
        Text(
          "Aditya C",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        separator,
        Row(
          children: [
            Flexible(
              flex: 6,
              child: getCards(),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Game Code: ABCDEF",
                      style:
                          TextStyle(color: Color(0xff848484), fontSize: 12.0),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      "#Hand:212",
                      style:
                          TextStyle(color: Color(0xff848484), fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        separator,
        Text(
          "Paul",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        separator,
        Row(
          children: [
            Flexible(
              flex: 6,
              child: getCards(),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Game Code: XXYYZY",
                      style:
                          TextStyle(color: Color(0xff848484), fontSize: 12.0),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      "#Hand:214",
                      style:
                          TextStyle(color: Color(0xff848484), fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        separator,
      ],
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
