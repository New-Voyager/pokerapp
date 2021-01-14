import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pokerapp/utils/club_weekly_activity_bar_chart.dart';

class ClubGraphicsView extends StatelessWidget {
  final double _unsettledBalance;
  final List<ClubWeeklyActivityModel> _weeklyActivity = [
    ClubWeeklyActivityModel(
      "Mon",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    ClubWeeklyActivityModel(
      "Tue",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    ClubWeeklyActivityModel(
      "Wed",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    ClubWeeklyActivityModel(
      "Thu",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    ClubWeeklyActivityModel(
      "Fri",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    ClubWeeklyActivityModel(
      "Sat",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    ),
    ClubWeeklyActivityModel(
      "Sun",
      50,
      30,
      charts.ColorUtil.fromDartColor(Colors.amber),
    )
  ];

  ClubGraphicsView(this._unsettledBalance);

  Color getBalanceColor(double number) {
    if (number == null) {
      return Colors.white;
    }

    return number == 0
        ? Colors.white
        : number > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Card(
                color: AppColors.cardBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        "Unsettled",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        _unsettledBalance.toString(),
                        style: TextStyle(
                          color: getBalanceColor(_unsettledBalance),
                          fontSize: 14.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Card(
                color: AppColors.cardBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        "Weekly Activity",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: AppAssets.fontFamilyLato,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ClubWeeklyActivityBarChart(_weeklyActivity),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
