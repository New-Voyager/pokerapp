/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';

class HighhandWinnersView extends StatelessWidget {
  final separator = SizedBox(
    height: 5.0,
  );

  final GameHistoryDetailModel data;
  HighhandWinnersView(this.data);

  @override
  Widget build(BuildContext context) {
    List<Widget> hhWinners = [];

    for (HighHandWinner winner in data.hhWinners) {
      hhWinners.add(HighhandWidget(winner));
    }
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "High Hand Winners",
          ),
          separator,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: hhWinners,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
