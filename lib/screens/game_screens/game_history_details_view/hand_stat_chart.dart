/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_stats_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';

class HandStatPieChart extends StatefulWidget {
  final StatModel stat;
  HandStatPieChart(this.stat);

  @override
  _HandStatPieChartState createState() => _HandStatPieChartState();
}

class _HandStatPieChartState extends State<HandStatPieChart> {
  bool animate;
  List<HandData> handsData;
  bool loading;

  @override
  void initState() {
    super.initState();
    handsData = [];
    loading = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculatePercentage();
    });
  }

  calculatePercentage() {
    int handsPlayed = widget.stat.totalHands;
    handsData.add(new HandData(
        'Pre-flop', (widget.stat.inPreflop / handsPlayed) * 100.0));
    handsData
        .add(new HandData('Flop', (widget.stat.inFlop / handsPlayed) * 100.0));
    handsData
        .add(new HandData('Turn', (widget.stat.inTurn / handsPlayed) * 100.0));
    handsData.add(
        new HandData('River', (widget.stat.inRiver / handsPlayed) * 100.0));
    handsData.add(new HandData(
        'Showdown', (widget.stat.wentToShowDown / handsPlayed) * 100.0));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressWidget(
            showText: false,
          )
        : charts.PieChart(data(),
            animate: animate,
            defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 40,
            ));
  }

  dynamic getColor(HandData hand) {
    if (hand != null) {
      if (hand.round == 'Pre-flop') {
        return charts.ColorUtil.fromDartColor(AppColorsNew.preflopColor);
      }
      if (hand.round == 'Flop') {
        return charts.ColorUtil.fromDartColor(AppColorsNew.flopColor);
      } else if (hand.round == 'Turn') {
        return charts.ColorUtil.fromDartColor(AppColorsNew.turnColor);
      } else if (hand.round == 'River') {
        return charts.ColorUtil.fromDartColor(AppColorsNew.riverColor);
      } else if (hand.round == 'Showdown') {
        return charts.ColorUtil.fromDartColor(AppColorsNew.showDownColor);
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
