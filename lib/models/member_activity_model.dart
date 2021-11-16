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
  double tips;
  double tipsBack;
  double tipsBackAmount;

  MemberActivity();
  factory MemberActivity.fromJson(dynamic json) {
    MemberActivity activity = MemberActivity();
    activity.name = json['name'];
    activity.playerUuid = json['playerUuid'];
    activity.credits = double.parse(json['credits'].toString());
    activity.lastPlayedDate = DateTime.parse(json['lastPlayedDate']).toLocal();
    activity.tips = double.parse((json['tips'] ?? 0).toString());
    activity.tipsBack = double.parse((json['tipsBack'] ?? 0).toString());
    activity.tipsBackAmount =
        double.parse((json['tipsBackAmount'] ?? 0).toString());
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
