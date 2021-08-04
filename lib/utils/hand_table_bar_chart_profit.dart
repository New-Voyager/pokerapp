import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';

class HandTableBarChartProfit extends StatelessWidget {
  final TableRecord _handTableRecord;

  HandTableBarChartProfit(this._handTableRecord);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TableRecordRow, String>> series = [
      // charts.Series(
      //   id: "Buy In",
      //   data: _handTableRecord.rows,
      //   domainFn: (TableRecordRow tableRow, _) => tableRow.playerName,
      //   measureFn: (TableRecordRow tableRow, _) => tableRow.buyIn,
      //   colorFn: (TableRecordRow tableRow, _) =>
      //       charts.ColorUtil.fromDartColor(Colors.blue[200]),
      // )..setAttribute(
      //     charts.measureAxisIdKey, charts.Axis.secondaryMeasureAxisId),
      charts.Series<TableRecordRow, String>(
        id: "Profit/Loss",
        data: _handTableRecord.rows,
        domainFn: (TableRecordRow tableRow, _) => tableRow.playerName,
        measureFn: (TableRecordRow tableRow, _) => tableRow.profit,
        colorFn: (TableRecordRow tableRow, _) => tableRow.profit > 0
            ? charts.ColorUtil.fromDartColor(Colors.green)
            : charts.ColorUtil.fromDartColor(Colors.red),
        labelAccessorFn: (TableRecordRow tableRow, index) =>
            '  ${tableRow.profit.toStringAsFixed(0)}',
        insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
          color: charts.ColorUtil.fromDartColor(Colors.white),
          fontSize: 14,
          fontFamily: AppAssets.fontFamilyLato,
        ),
        outsideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
          color: charts.ColorUtil.fromDartColor(Colors.white),
          fontSize: 14,
          fontFamily: AppAssets.fontFamilyLato,
        ),
      ),
    ];

    final chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
      behaviors: [
        // charts.SeriesLegend(
        //   position: charts.BehaviorPosition.top,
        //   outsideJustification: charts.OutsideJustification.endDrawArea,
        //   entryTextStyle: charts.TextStyleSpec(
        //     color: charts.ColorUtil.fromDartColor(Colors.white),
        //   ),
        // ),
      ],
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.auto,
      ),
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
            color: charts.ColorUtil.fromDartColor(
                AppColorsNew.listViewDividerColor),
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
            color: charts.ColorUtil.fromDartColor(
                AppColorsNew.listViewDividerColor),
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

    return chart;
  }
}
