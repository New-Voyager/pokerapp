/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';

class HandsPieChart extends StatelessWidget {
  bool animate;
  final List<HandData> handsData;
  HandsPieChart(this.handsData);

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(data(),
        animate: animate,
        behaviors: [
          new charts.DatumLegend(
            // Positions for "start" and "end" will be left and right respectively
            // for widgets with a build context that has directionality ltr.
            // For rtl, "start" and "end" will be right and left respectively.
            // Since this example has directionality of ltr, the legend is
            // positioned on the right side of the chart.
            position: charts.BehaviorPosition.end,
            // For a legend that is positioned on the left or right of the chart,
            // setting the justification for [endDrawArea] is aligned to the
            // bottom of the chart draw area.
            outsideJustification: charts.OutsideJustification.endDrawArea,
            // By default, if the position of the chart is on the left or right of
            // the chart, [horizontalFirst] is set to false. This means that the
            // legend entries will grow as new rows first instead of a new column.
            horizontalFirst: false,
            // By setting this value to 2, the legend entries will grow up to two
            // rows before adding a new column.
            desiredMaxRows: 5,
            // This defines the padding around each legend entry.
            cellPadding: new EdgeInsets.only(right: 4.0, top: 4.0),
            // Render the legend entry text with custom styles.
            entryTextStyle: charts.TextStyleSpec(
              color: charts.Color.white,
              fontSize: 8,
            ),
          )
        ],

        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 40,
        ));
  }

  dynamic getColor(HandData hand) {
    if (hand != null) {
      if (hand.round == 'Pre-flop') {
        return charts.MaterialPalette.gray.shadeDefault;
      }
      if (hand.round == 'Flop') {
        return charts.MaterialPalette.yellow.shadeDefault;
      } else if (hand.round == 'Turn') {
        return charts.MaterialPalette.red.shadeDefault.lighter;
      } else if (hand.round == 'River') {
        return charts.MaterialPalette.blue.shadeDefault.darker;
      } else if (hand.round == 'Showdown') {
        return charts.MaterialPalette.teal.shadeDefault.darker;
      }
    }
  }

  List<charts.Series<HandData, String>> data() {
    return [
      new charts.Series<HandData, String>(
        id: 'Hands',
        domainFn: (HandData hand, _) => hand.round,
        measureFn: (HandData hand, _) => hand.percent,
        colorFn: (HandData hand, _) => getColor(hand),
        data: handsData,
      )
    ];
  }
}
