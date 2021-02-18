import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/highhand_log.dart';
import 'package:pokerapp/services/app/game_service.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';

class PointsLineChart extends StatefulWidget {
  final GameHistoryDetailModel gameDetail;

  PointsLineChart({Key key, this.gameDetail}) : super(key: key);
  @override
  _PointsLineChart createState() => _PointsLineChart();
}

class _PointsLineChart extends State<PointsLineChart> {
  static dynamic jsonData;
  bool loadingDone = false;
  List<PlayerStack> stackList = new List<PlayerStack>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    rootBundle
        .loadString('assets/sample-data/completed-game2.json')
        .then((data) {
      jsonData = json.decode(data);
      final List playerStack = jsonData['stackStat'];
      stackList = playerStack.map((e) => new PlayerStack(e)).toList();
      setState(() {
        loadingDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loadingDone
        ? Center(child: CircularProgressIndicator())
        : new Scaffold(
            backgroundColor: AppColors.screenBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 14,
                  color: AppColors.appAccentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleSpacing: 0,
              elevation: 0.0,
              backgroundColor: AppColors.screenBackgroundColor,
              title: FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Stack",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            body: !loadingDone
                ? Center(child: CircularProgressIndicator())
                : charts.LineChart(_createSampleData(),
                    animate: false,
                    behaviors: [
                      new charts.SlidingViewport(),
                      new charts.PanAndZoomBehavior(),
                    ],
                    selectionModels: [
                      new charts.SelectionModelConfig(
                          changedListener: (SelectionModel model) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) =>
                        //             HighHandLogView(widget.gameDetail.gameCode)));
                        print(model.selectedSeries[0]
                            .measureFn(model.selectedDatum[0].index));

                        print(model.selectedSeries[0]
                            .domainFn(model.selectedDatum[0].index));
                      })
                    ],
                    defaultRenderer:
                        new charts.LineRendererConfig(includePoints: true)),
          );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<PlayerStack, int>> _createSampleData() {
    return [
      new charts.Series<PlayerStack, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (PlayerStack stat, __) => (stat.neutral)
            ? charts.MaterialPalette.transparent
            : stat.red
                ? charts.MaterialPalette.red.shadeDefault
                : charts.MaterialPalette.green.shadeDefault,
        domainFn: (PlayerStack game, _) => game.handNum,
        measureFn: (PlayerStack game, _) => game.after,
        data: stackList,
      )
    ];
  }
}

/// Sample linear data type.
class PlayerStack {
  int handNum;
  double before;
  double after;
  double difference;
  double tenPer;
  bool green;
  bool red;
  bool neutral;
  PlayerStack(var e) {
    handNum = e["handNum"];
    before = double.parse(e["before"].toString());
    after = double.parse(e["after"].toString());
    difference = (after - before);
    var absDiff = difference.abs();
    tenPer = (before / 10).abs();
    neutral = true;
    red = false;
    green = false;
    if (absDiff > tenPer) {
      neutral = false;
      log('stack view: handNum: $handNum, before: $before after: $after diff: $difference tenPercent: $tenPer');
      if (difference < 0) {
        red = true;
      } else {
        green = true;
      }
    }
  }
}
