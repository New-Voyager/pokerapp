import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_colors.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/services.dart' show rootBundle;
import 'package:pokerapp/resources/app_strings.dart';

import 'dart:convert';

import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/routes.dart';

class PointsLineChart extends StatefulWidget {
  final GameHistoryDetailModel gameDetail;

  PointsLineChart({Key key, this.gameDetail}) : super(key: key);
  @override
  _PointsLineChart createState() => _PointsLineChart();
}

class _PointsLineChart extends State<PointsLineChart> {
  static dynamic jsonData;
  bool loadingDone = false;
  Offset _tapPostion = Offset(100, 100);
  List<PlayerStack> stackList = [];
  bool _popUpVisible = false;
  charts.SelectionModel<num> _selectionModel;
  int refreshcount = 1;

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
                title: Text(
                  "Stack",
                  style: AppStyles.titleBarTextStyle,
                )),
            body: !loadingDone
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      GestureDetector(
                        onTapDown: (details) {
                          print("ONTAP : ");
                          setState(() {
                            _tapPostion = Offset(details.localPosition.dx,
                                details.localPosition.dy);
                          });
                        },
                        child: charts.LineChart(
                          _createSampleData(),
                          animate: false,
                          behaviors: [
                            // new charts.SlidingViewport(),
                            charts.PanAndZoomBehavior(),
                            charts.SelectNearest()
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig(
                                type: charts.SelectionModelType.info,
                                changedListener: (charts.SelectionModel model) {
                                  print("cccUpdate Refresh: ${refreshcount++}");
                                  if (model.hasDatumSelection) {
                                    setState(() {
                                      _selectionModel = model;
                                      _popUpVisible = true;
                                    });
                                  }
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) =>
                                  //             HighHandLogView(widget.gameDetail.gameCode)));
/* 
                                              showMenu(
                                                  context: context,
                                                  position: RelativeRect.fromLTRB(
                                                      _tapPostion.dx,
                                                      _tapPostion.dy,
                                                      MediaQuery.of(context).size.width -
                                                          _tapPostion.dx,
                                                      MediaQuery.of(context).size.height -
                                                          _tapPostion.dy),
                                                  items: [
                                                   PopupMenuItem(
                                                     textStyle: TextStyle(backgroundColor: Colors.black),

                                                      child: Container(color : Colors.yellow, child: Text("Helow"),), ),
                                                    
                                                    PopupMenuItem(child: Text("adfs")),
                                                    PopupMenuItem(child: Text("asdfdsf")),
                                                  ]); */
                                  /* print(model.selectedSeries[0]
                                      .measureFn(model.selectedDatum[0].index));

                                  print(model.selectedSeries[0]
                                      .domainFn(model.selectedDatum[0].index)); */
                                })
                          ],
                          defaultRenderer: new charts.LineRendererConfig(
                            includePoints: true,
                            radiusPx: 5,
                          ),
                        ),
                      ),
                      Visibility(
                        child: _selectionModel != null
                            ? _buildPopUp(context)
                            : Container(),
                        visible: _popUpVisible,
                      ),
                    ],
                  ),
          );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<PlayerStack, int>> _createSampleData() {
    return [
      new charts.Series<PlayerStack, int>(
          id: 'Sales',
          //colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.transparent),
          fillColorFn: (PlayerStack stat, __) => (stat.neutral)
              ? charts.ColorUtil.fromDartColor(Colors.transparent)
              : stat.red
                  ? charts.ColorUtil.fromDartColor(Colors.red)
                  : charts.ColorUtil.fromDartColor(Colors.green),
          domainFn: (PlayerStack game, _) => game.handNum,
          measureFn: (PlayerStack game, _) => game.after,
          data: stackList,
          seriesColor: charts.ColorUtil.fromDartColor(AppColors.appAccentColor))
    ];
  }

  _buildPopUp(BuildContext context) {
    print("Building pipup");
    double x = _tapPostion.dx, y = _tapPostion.dy;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    PlayerStack currentStack = _selectionModel.selectedDatum[0].datum;

    if (_tapPostion.dx > width / 2) {
      x = _tapPostion.dx - 100.0;
    }
    if (_tapPostion.dy > height / 2) {
      y = _tapPostion.dy - 50.0;
    }

    if (currentStack.neutral) {
      print("Netural item selected");
      return Container();
    }

    return Positioned(
      top: y,
      left: x,
      child: InkWell(
        onTap: () {
          HandLogModel handLogModel = HandLogModel("CG-7OF3IOXKBWJLDD", 1);
          Navigator.pushNamed(context, Routes.hand_log_view,
              arguments: handLogModel);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          height: 60,
          width: 120,
          color: Colors.black,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hand: #${currentStack.handNum}",
                      style: AppStyles.stackPopUpTextStyle,
                    ),
                    Text(
                      "Before:${getFormattedString(currentStack.before)}",
                      style: AppStyles.stackPopUpTextStyle,
                    ),
                    Text(
                      "After:${getFormattedString(currentStack.after)}",
                      style: AppStyles.stackPopUpTextStyle,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      currentStack.green
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: currentStack.color,
                    ),
                    Text(
                      "${getFormattedString(currentStack.difference)}",
                      style: AppStyles.stackPopUpTextStyle.copyWith(
                        color: currentStack.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFormattedString(double amount) {
    var a = amount.toString().split(".");
    if (a.length > 1 && int.parse(a[1]) > 0) {
      return amount.toString();
    } else {
      return a[0];
    }
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
  Color color;
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
    color = Colors.blueGrey;
    if (absDiff > tenPer) {
      neutral = false;
      log('stack view: handNum: $handNum, before: $before after: $after diff: $difference tenPercent: $tenPer');
      if (difference < 0) {
        red = true;
        color = Colors.red;
      } else {
        green = true;
        color = Colors.green;
      }
    }
  }
}
