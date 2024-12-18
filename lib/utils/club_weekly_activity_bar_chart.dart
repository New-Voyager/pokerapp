import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class ClubWeeklyActivityBarChart extends StatelessWidget {
  final ClubWeeklyActivityModel _weeklyActivityData;

  ClubWeeklyActivityBarChart(this._weeklyActivityData);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ClubDailyActivityModel, String>> series = [
      charts.Series(
          id: "Weekly Activity",
          data: _weeklyActivityData.activityList,
          domainFn: (ClubDailyActivityModel day, _) => day.dayOfWeek,
          measureFn: (ClubDailyActivityModel day, _) => day.buyIn - day.balance,
          colorFn: (ClubDailyActivityModel day, _) => day.color),
    ];

    return charts.BarChart(
      series,
      animate: true,
      vertical: true,
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 3,
          desiredMaxTickCount: 7,
          desiredTickCount: 5,
        ),
        showAxisLine: false,
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: 8.dp.toInt(),
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(
              AppColorsNew.listViewDividerColor,
            ),
          ),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: 8.dp.toInt(),
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.transparent,
          ),
        ),
      ),
    );
  }
}
