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
  final  GameHistoryDetailModel gameDetail;

  PointsLineChart({Key key, this.gameDetail}) : super(key: key);
  @override
  _PointsLineChart createState() => _PointsLineChart();

}

class _PointsLineChart extends State<PointsLineChart> {
  static dynamic jsonData;
  bool loadingDone = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    rootBundle
        .loadString('assets/sample-data/completed-game.json')
        .then((data) {
      jsonData = json.decode(data);
      setState(() {
        loadingDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
            // style: TextStyle(
            //   color: AppColors.appAccentColor,
            //   fontSize: 14.0,
            //   fontFamily: AppAssets.fontFamilyLato,
            //   fontWeight: FontWeight.w600,
            // ),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              HighHandLogView(widget.gameDetail.gameCode)));
                  print(model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index));
                })
              ],
              defaultRenderer:
                  new charts.LineRendererConfig(includePoints: true)),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<PlayerStack, int>> _createSampleData() {
    final List playerStack = jsonData['data']['completedGame']['stackStat'];
    final data = playerStack
        .map((e) => new PlayerStack(
            e["handNum"],e["before"],e["after"],(e["after"]-e["before"]), (e["before"]/10)))
        .toList();

    return [
      new charts.Series<PlayerStack, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (PlayerStack game, __) =>
            (game.difference < game.tenPer)
                ? charts.MaterialPalette.transparent
            : ((game.difference < 0)
                    ? charts.MaterialPalette.red.shadeDefault
                    : charts.MaterialPalette.green.shadeDefault),
        domainFn: (PlayerStack game, _) => game.handNum,
        measureFn: (PlayerStack game, _) => game.after,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class PlayerStack {
  final int handNum;
  final int before;
  final int after;
  final difference;
  final tenPer;
  PlayerStack(this.handNum, this.before, this.after, this.difference, this.tenPer);
}
