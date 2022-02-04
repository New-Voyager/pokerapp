import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class MemberActivity {
  String name;
  String playerUuid;
  String externalId;
  bool followup;
  double credits;
  DateTime lastPlayedDate;
  String contactInfo;

  // info with date filter
  bool tipsIncluded;
  double buyin;
  double profit;
  int gamesPlayed;
  int handsPlayed;
  double tips;
  double tipsBack;
  double tipsBackAmount;

  MemberActivity();
  factory MemberActivity.fromJson(dynamic json) {
    MemberActivity activity = MemberActivity();
    if (json['name'] != null) {
      activity.name = json['name'];
    } else {
      activity.name = json['playerName'];
    }
    if (json['contactInfo'] != null) {
      activity.contactInfo = json['contactInfo'] ?? '';
    }

    if (json['playerUuid'] != null) {
      activity.playerUuid = json['playerUuid'];
    } else if (json['playerId'] != null) {
      activity.playerUuid = json['playerId'];
    }
    if (json['credits'] != null) {
      activity.credits = double.parse(json['credits'].toString());
    }
    if (json['availableCredit'] != null) {
      activity.credits = double.parse(json['availableCredit'].toString());
    }

    if (json['externalId'] != null) {
      activity.externalId = json['externalId'];
    }

    activity.followup = false;
    if (json['followup'] != null) {
      activity.followup = json['followup'];
    }

    activity.lastPlayedDate = DateTime.parse(json['lastPlayedDate']).toLocal();
    activity.tips = double.parse((json['tips'] ?? 0).toString());
    activity.tipsBack = double.parse((json['tipsBack'] ?? 0).toString());
    activity.tipsBackAmount =
        double.parse((json['tipsBackAmount'] ?? 0).toString());
    if (activity.tips > 0 && activity.tipsBack > 0) {
      activity.tipsBackAmount =
          (((activity.tips * activity.tipsBack) / 100.0).floor()).toDouble();
    }
    activity.profit = double.parse((json['profit'] ?? 0).toString());
    activity.buyin = double.parse((json['buyIn'] ?? 0).toString());
    activity.gamesPlayed = int.parse((json['gamesPlayed'] ?? 0).toString());
    activity.handsPlayed = int.parse((json['handsPlayed'] ?? 0).toString());
    activity.profit = double.parse((json['profit'] ?? 0).toString());
    activity.buyin = double.parse((json['buyIn'] ?? 0).toString());
    return activity;
  }

/*
headers.add('Name');
    headers.add('Credits');
    if (includeTips) {
      headers.add('Tips');
      headers.add('TB %');
      headers.add('TB');
      headers.add('Buyin');
      headers.add('Profit');
    }
    if (includeLastPlayedDate) {
      headers.add('Contact');
      headers.add('Last Active');
    }*/

  static String _getValue(MemberActivity activity, String h) {
    switch (h.toLowerCase()) {
      case 'name':
        return activity.name;

      case 'credits':
        return activity.credits.toString();

      case 'tips':
        return activity.tips.toString();

      case 'tb %':
        return activity.tipsBack.toString();

      case 'buyin':
        return activity.buyin.toString();

      case 'profit':
        return activity.profit.toString();

      case 'contact':
        return activity.contactInfo;

      // yyyy-mm-dd hh:mm
      case 'last active':
        return DateFormat('yyyy-MM-dd hh:mm a').format(
          activity.lastPlayedDate.toLocal(),
        );

      default:
        return "";
    }
  }

  static String makeCsv({
    @required final List<String> headers,
    @required final List<MemberActivity> activities,
  }) {
    final csvList = <List<dynamic>>[];

    for (final a in activities) {
      csvList.add(headers.map((h) => _getValue(a, h)).toList());
    }

    final csvConverter = ListToCsvConverter();
    return csvConverter.convert([headers, ...csvList]);
  }

  static String makeActivitiesCsv({
    @required final List<String> headers,
    @required final List<MemberActivity> activities,
  }) {
    final csvList = <List<dynamic>>[];

    for (final a in activities) {
      csvList.add([a.externalId, a.name, a.credits]);
    }

    final csvConverter = ListToCsvConverter();
    return csvConverter.convert([headers, ...csvList]);
  }

  static String makeActivitiesFilteredCsv({
    @required final List<String> headers,
    @required final List<MemberActivity> activities,
  }) {
    final csvList = <List<dynamic>>[];

    for (final a in activities) {
      csvList.add([
        a.externalId,
        a.name,
        a.credits,
        a.tips,
        a.tipsBack,
        a.tipsBackAmount,
        a.buyin,
        a.profit
      ]);
    }

    final csvConverter = ListToCsvConverter();
    return csvConverter.convert([headers, ...csvList]);
  }

  static List<MemberActivity> getMockData() {
    String data = '''
        [
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },
          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          },

          {
            "name": "bob",
            "playerUuid": "bob",
            "credits": -1000,
            "lastPlayedDate": "2021-11-11T05:00:00",
            "tips": 100,
            "tipsBack": 10,
            "profit": -3000,
            "buyin": 2000
          }
        ]
      ''';

    List<MemberActivity> activities = [];
    dynamic activityData = jsonDecode(data);
    for (final json in activityData) {
      activities.add(MemberActivity.fromJson(json));
    }
    return activities;
  }
}
