import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/highhand_widget.dart';

class GroupedHandLogListView extends StatelessWidget {
  GroupedHandLogListView({
    @required this.winners,
    @required this.clubCode,
    @required this.theme,
  });

  final List<HighHandWinner> winners;
  final String clubCode;
  final AppTheme theme;


  @override
  Widget build(BuildContext context) {
    final group = GroupedWinnersProcess(theme, winners, clubCode, HHGroupType.HOURLY);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: group.list(),
    );
  }
}

enum HHGroupType {
  HOURLY,
  EVERY_30MIN,
  DAILY,
}

class GroupedWinnersProcess {
  final List<HighHandWinner> winners;
  final String clubCode;
  final AppTheme theme;
  final HHGroupType groupType;
  Map<String, String> groupTitle = Map<String, String>();
  Map<String, String> groupDate = Map<String, String>();
  GroupedWinnersProcess(this.theme, this.winners, this.clubCode, this.groupType);


  String _belongsToGroup(HighHandWinner winner) {
    final localDateTime = winner.handTime.toLocal();

    final String startTime = DateFormat("MM/dd/yyyy hh:00 a").format(localDateTime);
    final String endTime = DateFormat("MM/dd/yyyy hh:00 a").format(
      localDateTime.add(const Duration(hours: 1)),
    );
    final String titleStartTime = DateFormat("hh:00 a").format(localDateTime);
    final String titleEndTime = DateFormat("hh:00 a").format(
      localDateTime.add(const Duration(hours: 1)),
    );
    String date = DateFormat("dd MMM").format(localDateTime);
    String groupString = "$startTime - ${endTime}";
    String title = '$titleStartTime  - $titleEndTime';
    groupDate[groupString] = date;
    groupTitle[groupString] = title;
    return groupString;
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
  List<Widget> list() {
    final Map<String, List<HighHandWinner>> groupedWinners = _process();

    return groupedWinners.entries.map((entries) {
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
                  groupDate[groupName] + ' ' + groupTitle[groupName],
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
                        gameCode: w.gameCode, clubCode: clubCode))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList();
  }
}


/*
Window {
    DateTime start
    DateTime end
    String title
    int count
}

Map<String, List<Winner>> windowedWinners;

List<Window> generateWindows(DateTime start, DateTime end, Duration division) {

}

String getBucket(winner) {
    if (groupByDay) {
        return winner.date.ddmmYY;
    } else if (groupByHour) {
        return winner.date.ddmmYYHH;
    } else if (groupByMin) {
      if (mins >= 30 && secs >= 1) {
        return winner.date.ddmmYYHHMM30;
      } else {
        return winner.date.ddmmYYHHMM00;
      }
    }
}
void processItem(Winner winner) {
    String itemBucket = getBucket(winner);
}
*/

class GroupWindow {
  DateTime start;
  DateTime end;
  String title;
  int count;
}
class GroupHighHands {
  List<GroupWindow> windows = [];
  Map<String, List<HighHandWinner>> windowedWinners = Map<String, List<HighHandWinner>>();
  HHGroupType type;
  DateFormat dayFormat = DateFormat("MM/dd/yyyy");
  DateFormat hourFormat = DateFormat("MM/dd/yyyy hh:00");
  DateFormat zeroHourFormat = DateFormat("MM/dd/yyyy hh:00");
  DateFormat zeroHourEndFormat = DateFormat("MM/dd/yyyy hh:00");
  DateFormat halfHourFormat = DateFormat("MM/dd/yyyy hh:30");
  DateFormat halfHourEndFormat = DateFormat("MM/dd/yyyy hh:00");
  
  final List<HighHandWinner> winners;
  final String clubCode;
  final AppTheme theme;
  final HHGroupType groupType;
  final DateTime start;
  final DateTime end;

  GroupHighHands({
        this.start, this.end,
        this.winners, this.clubCode, 
        this.theme, this.groupType});

  String getBucket(DateTime date) {
      if (type == HHGroupType.DAILY) {
          return dayFormat.format(date);
      } else if (type == HHGroupType.HOURLY) {
          String start = hourFormat.format(date);
          String end = hourFormat.format(date.add(Duration(hours: 1)));
          return '$start - $end';
      } else if (type == HHGroupType.EVERY_30MIN) {
        if (date.minute >= 30 && date.second >= 1) {
          String start = zeroHourFormat.format(date);
          String end = zeroHourEndFormat.format(date);
          return '$start - $end';
        } else {
          String start = halfHourFormat.format(date);
          String end = halfHourEndFormat.format(date.add(Duration(hours: 1)));
          return '$start - $end';
        }
      } else {
        throw new Error();
      }
  }

  void generateWindows(DateTime start, DateTime end, HHGroupType groupType) {
    if (groupType == HHGroupType.DAILY) {
      DateTime current = start;
      while (true) {
        String bucket = getBucket(current);
        final window = GroupWindow();
        window.count = 0;
        window.start = DateTime(current.year, 
                          current.month, current.day, 
                          00, 00, 00);
        window.end = DateTime(current.year, 
                          current.month, current.day, 
                          23, 59, 59);
        window.title = dayFormat.format(current);
        windows.add(window);
        windowedWinners[bucket] = [];
        current = current.add(Duration(days: 1));
        if (current.isAfter(end)) {
          break;
        }
      } 
    } else if(groupType == HHGroupType.HOURLY) {
      DateTime current = DateTime(start.year, 
                                  start.month, 
                                  start.day,
                                  0, 0, 0);

      DateFormat startFormat = DateFormat("MM/dd/yyyy hh:00 a");
      DateFormat endFormat = DateFormat("hh:00 a");
      
      while (true) {
        String bucket = getBucket(current);
        final window = GroupWindow();
        window.count = 0;
        window.start = current;
        window.end = DateTime(
                          current.year, 
                          current.month, 
                          current.day, 
                          current.hour, 
                          59, 59);

        window.title = startFormat.format(current) + ' - ' + endFormat.format(end);
        windows.add(window);
        windowedWinners[bucket] = [];
        current = current.add(Duration(hours: 1));
        if (current.isAfter(end)) {
          break;
        }
      } 
    }
  }

  void processItem(HighHandWinner winner) {
    String bucket = getBucket(winner.handTime);
    if (windowedWinners[bucket] != null) {
      windowedWinners[bucket].add(winner);
    }
  }

  // Map<String, List<HighHandWinner>> _process() {
  //   // sort the input winners array
  //   winners.sort((a, b) => b.handTime.compareTo(a.handTime));
  //   generateWindows(this.start, end, this.groupType);

  //   final Map<String, List<HighHandWinner>> groupedWinners = {};

  //   /* group winners as per _belongsToGroup function value */
  //   for (final winner in winners) {
  //     String bucket = getBucket(winner.handTime);
  //     // String belongsToGroup = _belongsToGroup(winner);

  //     if (groupedWinners.containsKey(belongsToGroup))
  //       groupedWinners[belongsToGroup].add(winner);
  //     else
  //       groupedWinners[belongsToGroup] = <HighHandWinner>[winner];
  //   }

  //   return groupedWinners;
  // }
  List<Widget> list() {
    final Map<String, List<HighHandWinner>> groupedWinners = _process();

    return groupedWinners.entries.map((entries) {
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
                  groupDate[groupName] + ' ' + groupTitle[groupName],
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
                        gameCode: w.gameCode, clubCode: clubCode))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList();
  }
}