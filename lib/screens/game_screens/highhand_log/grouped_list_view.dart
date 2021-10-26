import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';

class GroupedHandLogListView extends StatelessWidget {
  GroupedHandLogListView({
    @required this.winners,
    @required this.clubCode,
  });

  final List<HighHandWinner> winners;
  final String clubCode;

  String _belongsToGroup(HighHandWinner winner) {
    final playedAtHour = winner.handTime.hour;
    final nextHour = playedAtHour == 23 ? 0 : playedAtHour + 1;

    return "${playedAtHour.toString().padLeft(2, "0")} - ${nextHour.toString().padLeft(2, "0")}";
  }

  Map<String, List<HighHandWinner>> _process() {
    // sort the input winners array
    winners.sort((a, b) => b.handTime.compareTo(a.handTime));

    final Map<String, List<HighHandWinner>> groupedWinners = {};

    /* group winners as per _belongsToGroup function value */
    for (final winner in winners) {
      String belongsToGroup = _belongsToGroup(winner);

      if (groupedWinners.containsKey(belongsToGroup))
        groupedWinners[belongsToGroup].add(winner);
      else
        groupedWinners[belongsToGroup] = <HighHandWinner>[winner];
    }

    return groupedWinners;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<HighHandWinner>> groupedWinners = _process();

    return ListView(
      physics: BouncingScrollPhysics(),
      children: groupedWinners.entries.map((entries) {
        String groupName = entries.key;
        List<HighHandWinner> groupWinners = entries.value;

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // group header
              Text(groupName),

              // group body
              Column(
                mainAxisSize: MainAxisSize.min,
                children: groupWinners
                    .map((HighHandWinner w) =>
                        HighhandWidget(w, clubCode: clubCode))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
