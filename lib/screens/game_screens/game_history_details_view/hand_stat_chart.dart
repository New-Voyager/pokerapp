/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_stats_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
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
    if (handsPlayed == 0) {
      // setting to 1 to avoid 0 in denominator. if total hands 0 means widget.stat.{each stage} will be also 0
      handsPlayed = 1;
    }
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
    final theme = AppTheme.getTheme(context);
    return loading
        ? CircularProgressWidget(
            showText: false,
          )
        : charts.PieChart(data(theme),
            animate: animate,
            defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 40,
            ));
  }

  dynamic getColor(HandData hand, AppTheme theme) {
    if (hand != null) {
      if (hand.round == 'Pre-flop') {
        return charts.ColorUtil.fromDartColor(theme.preFlopColor);
      }
      if (hand.round == 'Flop') {
        return charts.ColorUtil.fromDartColor(theme.flopColor);
      } else if (hand.round == 'Turn') {
        return charts.ColorUtil.fromDartColor(theme.turnColor);
      } else if (hand.round == 'River') {
        return charts.ColorUtil.fromDartColor(theme.riverColor);
      } else if (hand.round == 'Showdown') {
        return charts.ColorUtil.fromDartColor(theme.showDownColor);
      }
    }
  }

  List<charts.Series<HandData, String>> data(AppTheme theme) {
    return [
      new charts.Series<HandData, String>(
        id: 'Hands',
        domainFn: (HandData hand, _) => hand.round,
        measureFn: (HandData hand, _) => hand.percent,
        colorFn: (HandData hand, _) => getColor(hand, theme),
        data: handsData,
      )
    ];
  }
}
