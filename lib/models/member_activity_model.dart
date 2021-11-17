import 'dart:convert';

class MemberActivity {
  String name;
  String playerUuid;
  double credits;
  DateTime lastPlayedDate;

  // info with date filter
  bool tipsIncluded;
  double buyin;
  double profit;
  int gamesPlayed;
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
    activity.profit = double.parse((json['profit'] ?? 0).toString());
    activity.buyin = double.parse((json['buyin'] ?? 0).toString());
    return activity;
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
