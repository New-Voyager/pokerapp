import 'package:charts_flutter/flutter.dart' as charts;

class ClubWeeklyActivityModel {
  String dayOfWeek;
  int buyIn;
  int balance;
  final charts.Color color;

  ClubWeeklyActivityModel(
    this.dayOfWeek,
    this.buyIn,
    this.balance,
    this.color,
  );
}
