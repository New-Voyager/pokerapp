import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';

class HandTableBarChartProfit extends StatelessWidget {
  final TableRecord _handTableRecord;

  HandTableBarChartProfit(this._handTableRecord);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TableRecordRow, String>> series = [
      charts.Series(
        id: "Buy In",
        data: _handTableRecord.rows,
        domainFn: (TableRecordRow tableRow, _) => tableRow.playerName,
        measureFn: (TableRecordRow tableRow, _) => tableRow.buyIn,
        colorFn: (TableRecordRow tableRow, _) =>
            charts.ColorUtil.fromDartColor(Colors.amber),
      )..setAttribute(
          charts.measureAxisIdKey, charts.Axis.secondaryMeasureAxisId),
      charts.Series(
        id: "Profit",
        data: _handTableRecord.rows,
        domainFn: (TableRecordRow tableRow, _) => tableRow.playerName,
        measureFn: (TableRecordRow tableRow, _) => tableRow.profit,
        colorFn: (TableRecordRow tableRow, _) => tableRow.profit > 0
            ? charts.ColorUtil.fromDartColor(Colors.green)
            : charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
      vertical: false,
      // behaviors: [
      //   charts.ChartTitle(
      //     "Balance",
      //     behaviorPosition: charts.BehaviorPosition.top,
      //     titleStyleSpec: charts.TextStyleSpec(
      //       color: charts.MaterialPalette.white,
      //       fontFamily: AppAssets.fontFamilyLato,
      //       fontSize: 14,
      //     ),
      //   ),
      //   charts.ChartTitle(
      //     "Profit",
      //     behaviorPosition: charts.BehaviorPosition.bottom,
      //     titleStyleSpec: charts.TextStyleSpec(
      //       color: charts.MaterialPalette.white,
      //       fontFamily: AppAssets.fontFamilyLato,
      //       fontSize: 14,
      //     ),
      //   ),
      // ],
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.top,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          entryTextStyle: charts.TextStyleSpec(
            color: charts.ColorUtil.fromDartColor(Colors.white),
          ),
        ),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 3,
        ),
        showAxisLine: false,
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: 10,
          ),
          lineStyle: charts.LineStyleSpec(
            color:
                charts.ColorUtil.fromDartColor(AppColors.listViewDividerColor),
          ),
        ),
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 3,
        ),
        showAxisLine: false,
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: 10,
          ),
          lineStyle: charts.LineStyleSpec(
            color:
                charts.ColorUtil.fromDartColor(AppColors.listViewDividerColor),
          ),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: 10,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.transparent,
          ),
        ),
      ),
    );
  }
}
