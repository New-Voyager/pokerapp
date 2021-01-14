import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ClubWeeklyActivityModel {
  String dayOfWeek;
  int buyIn;
  int balance;
  charts.Color color;

  ClubWeeklyActivityModel(this.dayOfWeek, this.buyIn, this.balance) {
    this.color = this.buyIn - this.balance > 0
        ? charts.ColorUtil.fromDartColor(Colors.green)
        : charts.ColorUtil.fromDartColor(Colors.red);
  }
}
