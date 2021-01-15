/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';

class HighhandWinnersView extends StatelessWidget {
  final separator = SizedBox(
    height: 5.0,
  );

  GameHistoryDetailModel data;
  HighhandWinnersView(this.data);

  @override
  Widget build(BuildContext context) {
    List<Widget> hhWinners = new List<Widget>();

    for (HighHandWinner winner in data.hhWinners) {
      hhWinners.add(HighhandWidget(winner));
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
}
