import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';

class HighhandWidget extends StatelessWidget {
  final separator = SizedBox(
    height: 5.0,
  );
  final colSeparator = SizedBox(
    width: 20.0,
  );

  final HighHandWinner winner;
  HighhandWidget(this.winner);

  Widget cardsView(List<int> cards) {
    List<Widget> cardViews = new List<Widget>();
    for (int cardValue in cards) {
      CardObject card = CardHelper.getCard(cardValue);
      card.smaller = true;
      cardViews.add(card.widget);
    }
    return Row(children: cardViews);
  }

  @override
  Widget build(BuildContext context) {
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
                  (winner.gameCode != null ? '${winner.gameCode}/' : '') +
                      'Hand #${winner.handNum.toString()}',
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
}
