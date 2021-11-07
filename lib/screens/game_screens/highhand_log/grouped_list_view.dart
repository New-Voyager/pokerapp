import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';

class GroupedHandLogListView extends StatelessWidget {
  GroupedHandLogListView({
    @required this.winners,
    @required this.gameCode,
    @required this.clubCode,
    @required this.theme,
  });

  final List<HighHandWinner> winners;
  final String clubCode;
  final String gameCode;
  final AppTheme theme;

  String _belongsToGroup(HighHandWinner winner) {
    final localDateTime = winner.handTime.toLocal();

    final String startTime = DateFormat("hh:00 a").format(localDateTime);
    final String endTime = DateFormat("hh:00 a").format(
      localDateTime.add(const Duration(hours: 1)),
    );

    return "$startTime - ${endTime}";
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
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // group header
              Container(
                decoration: AppDecorators.tileDecoration(theme),
                // color: theme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
                ),
                child: Text(
                  groupName,
                  style: TextStyle(
                    color: theme.accentColor,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // group body
              Column(
                mainAxisSize: MainAxisSize.min,
                children: groupWinners
                    .map((HighHandWinner w) => HighhandWidget(w,
                        gameCode: gameCode, clubCode: clubCode))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
