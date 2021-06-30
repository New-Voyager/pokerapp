import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ClubWeeklyActivityModel {
  List<ClubDailyActivityModel> _activityList = [];

  ClubWeeklyActivityModel.fromJson(var jsonData) {
    var activityListJson =
        jsonData["weeklyActivity"] ?? jsonData["weeklyActivity"];

    if (activityListJson != null) {
      _activityList = activityListJson
          .map<ClubDailyActivityModel>(
              (activity) => ClubDailyActivityModel.fromJson(activity))
          .toList();
    }
  }

  get activityList => this._activityList;
}

class ClubDailyActivityModel {
  String dayOfWeek;
  int buyIn;
  int balance;
  charts.Color color;

  ClubDailyActivityModel.fromJson(var jsonData) {
    this.dayOfWeek = jsonData["dayOfWeek"] ?? "";
    this.buyIn = jsonData["buyIn"] ?? 0;
    this.balance = jsonData["balance"] ?? 0;
    this.color = this.buyIn - this.balance > 0
        ? charts.ColorUtil.fromDartColor(Colors.green)
        : charts.ColorUtil.fromDartColor(Colors.red);
  }
}
