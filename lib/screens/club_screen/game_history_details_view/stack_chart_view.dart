import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';

class StackChartView extends StatelessWidget {
  final List<PlayerStack> stack;
  final bool animate;

  StackChartView(this.stack, {this.animate});

  charts.NumericTickProviderSpec getTickerSpec() {
    final maxValue = stack.reduce((value, element) => value.balance > element.balance? value: element);
    return new charts.StaticNumericTickProviderSpec(
      <charts.TickSpec<num>>[
        charts.TickSpec<num>(maxValue.balance),
      ],
    );
  }

  charts.NumericAxisSpec getAxisSpec() {
    return new charts.NumericAxisSpec(viewport: charts.NumericExtents(1, stack.last.handNum));
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(data(),
        animate: animate,
        domainAxis: getAxisSpec(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
            labelOffsetFromAxisPx: -20,
            labelAnchor: charts.TickLabelAnchor.after,
            labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.gray.shade500,
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade500,
              thickness: 0,
            )
        ),
        tickProviderSpec: getTickerSpec(),
      ) ,
    );
  }

  /// Create one series with sample hard coded data.
    List<charts.Series<PlayerStack, int>> data() {
    return [
      new charts.Series<PlayerStack, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PlayerStack stack, _) => stack.handNum,
        measureFn: (PlayerStack stack, _) => stack.balance,
        data: stack,
      )
    ];
  }
}
