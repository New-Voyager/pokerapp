import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import 'dart:convert';

import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

class PointsLineChart extends StatefulWidget {
  //final GameHistoryDetailModel gameDetail;
  final String gameCode;
  final bool showBackButton;
  final bool liveGame;

  PointsLineChart(
      {Key key,
      this.gameCode,
      this.showBackButton = true,
      this.liveGame = false})
      : super(key: key);

  @override
  _PointsLineChart createState() => _PointsLineChart();
}

class _PointsLineChart extends State<PointsLineChart> with RouteAwareAnalytics {
  @override
  String get routeName => Routes.pointsLineChart;
  static dynamic jsonData;
  bool loadingDone = false;
  Offset _tapPosition = Offset(100, 100);
  List<PlayerStackChartModel> stackList = [];
  bool _popUpVisible = false;
  charts.SelectionModel<num> _selectionModel;
  int refreshcount = 1;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("pointsLineChart");

    log('PointsLineChart: Loading line chart');
    //TestService.isTesting ? _fetchData() : _loadStackData();
    if (TestService.isTesting) {
      _fetchData();
    } else if (widget.liveGame) {
      _loadStackLiveData();
    } else {
      _loadStackData();
    }
  }

  _fetchData() async {
    rootBundle
        .loadString('assets/sample-data/completed-game2.json')
        .then((data) {
      jsonData = json.decode(data);
      final List playerStack = jsonData['stackStat'];
      debugPrint(data);
      stackList = playerStack.map((e) => new PlayerStackChartModel(e)).toList();
      stackList.sort((a, b) => a.handNum.compareTo(b.handNum));
      setState(() {
        loadingDone = true;
      });
    });
  }

  _loadStackData() async {
    stackList.clear();
    final data = await GameService.getStackStat(widget.gameCode);
    if (data.length >= 1) {
      // set handnum 0 with starting stack
      dynamic item0 = data[0];
      stackList.add(new PlayerStackChartModel(item0, first: true));

      for (dynamic item in data) {
        stackList.add(new PlayerStackChartModel(item));
      }
      stackList.sort((a, b) => a.handNum.compareTo(b.handNum));
    }
    setState(() {
      loadingDone = true;
    });
  }

  _loadStackLiveData() async {
    stackList.clear();
    final data = await GameService.getLiveStackStat(widget.gameCode);
    if (data != null && data.length >= 1) {
      // set handnum 0 with starting stack
      dynamic item0 = data[0];
      stackList.add(new PlayerStackChartModel(item0, first: true));

      for (dynamic item in data) {
        stackList.add(new PlayerStackChartModel(item));
      }
      stackList.sort((a, b) => a.handNum.compareTo(b.handNum));
    }
    setState(() {
      loadingDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _tapPosition = Offset((Screen.width - 100) / 2, Screen.height - 100);
    return Consumer<AppTheme>(builder: (_, theme, __) {
      return Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: _appScreenText['stackTimeline'],
            showBackButton: widget.showBackButton,
          ),
          body: !loadingDone
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            debugPrint(
                                '=====================\n\nStack item tapped');
                            // _tapPosition = Offset(details.localPosition.dx,
                            //     details.localPosition.dy);
                          });
                        },
                        child: GestureDetector(
                          onTapDown: (details) {
                            debugPrint(
                                '=====================\n\LineChart item tapped');
                          },
                          child: charts.LineChart(
                            _createSampleData(theme),
                            animate: false,
                            behaviors: [
                              // new charts.SlidingViewport(),
                              charts.PanAndZoomBehavior(),
                              charts.SelectNearest(),
                            ],
                            primaryMeasureAxis: charts.NumericAxisSpec(
                              showAxisLine: false,
                              renderSpec: charts.GridlineRendererSpec(
                                lineStyle: charts.LineStyleSpec(
                                  color: charts.ColorUtil.fromDartColor(
                                    theme.fillInColor,
                                  ),
                                ),
                                labelStyle: charts.TextStyleSpec(
                                  color: charts.ColorUtil.fromDartColor(
                                    theme.accentColorWithLight(),
                                  ),
                                ),
                              ),
                            ),
                            domainAxis: charts.NumericAxisSpec(
                              showAxisLine: false,
                              renderSpec: charts.GridlineRendererSpec(
                                lineStyle: charts.LineStyleSpec(
                                  color: charts.ColorUtil.fromDartColor(
                                    Colors.transparent,
                                  ),
                                ),
                                labelStyle: charts.TextStyleSpec(
                                  color: charts.ColorUtil.fromDartColor(
                                    theme.accentColorWithLight(),
                                  ),
                                ),
                              ),
                            ),
                            selectionModels: [
                              charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener:
                                      (charts.SelectionModel model) {
                                    if (model.hasDatumSelection) {
                                      setState(() {
                                        debugPrint(
                                            '\n circle tapped: ${model.hasDatumSelection}\n');
                                        debugPrint('=====================');
                                        _selectionModel = model;
                                        _popUpVisible = true;
                                      });
                                    }
                                  })
                            ],
                            defaultRenderer: new charts.LineRendererConfig(
                              includePoints: true,
                              radiusPx: 10,
                            ),
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
                ),
        ),
      );
    });
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<PlayerStackChartModel, int>> _createSampleData(
      AppTheme theme) {
    return [
      new charts.Series<PlayerStackChartModel, int>(
        id: 'Stack',
        //colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.transparent),
        fillColorFn: (PlayerStackChartModel stat, __) => (stat.neutral)
            ? charts.ColorUtil.fromDartColor(Colors.transparent)
            : stat.red
                ? charts.ColorUtil.fromDartColor(Colors.red)
                : charts.ColorUtil.fromDartColor(Colors.green),
        domainFn: (PlayerStackChartModel game, _) => game.handNum,
        measureFn: (PlayerStackChartModel game, _) => game.after,
        data: stackList,
        seriesColor: charts.ColorUtil.fromDartColor(theme.accentColor),
      )
    ];
  }

  _buildPopUp(BuildContext context) {
    double x = _tapPosition.dx, y = _tapPosition.dy;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    PlayerStackChartModel currentStack = _selectionModel.selectedDatum[0].datum;
    debugPrint('selected hand: ${currentStack.handNum}');
    if (_tapPosition.dx > width / 2) {
      x = _tapPosition.dx - 100.0;
    }
    if (_tapPosition.dy > height / 2) {
      y = _tapPosition.dy - 80.0;
    }

    if (widget.liveGame) {
      y = -50.ph;
    }

    if (currentStack.neutral) {
      debugPrint("Netural item selected");
      return Container();
    }

    BoxDecoration boxDecoration;
    Color textColor = Colors.white;
    if (currentStack.red) {
      boxDecoration = BoxDecoration(
          color: Colors.red[300],
          border: Border.all(
            color: Colors.red[500],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)));
      textColor = Colors.red[900];
    } else {
      boxDecoration = BoxDecoration(
          color: Colors.green[200],
          border: Border.all(
            color: Colors.green[500],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)));

      textColor = Colors.green[900];
    }

    return Positioned(
      bottom: 50.ph,
      left: x,
      child: InkWell(
        onTap: () {
          //HandLogModel handLogModel = HandLogModel("CG-7OF3IOXKBWJLDD", 1);
          Navigator.pushNamed(context, Routes.hand_log_view, arguments: {
            "gameCode": widget.gameCode,
            "handNum": currentStack.handNum
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 70,
          width: 140,
          //color: currentStack.color,
          decoration: boxDecoration,
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
                      "${_appScreenText['hand']}: #${currentStack.handNum}",
                      style: AppStylesNew.stackPopUpTextStyle,
                    ),
                    Text(
                      "${_appScreenText['before']}:${DataFormatter.chipsFormat(currentStack.before)}",
                      style: AppStylesNew.stackPopUpTextStyle,
                    ),
                    Text(
                      "${_appScreenText['after']}:${DataFormatter.chipsFormat(currentStack.after)}",
                      style: AppStylesNew.stackPopUpTextStyle,
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
                      color: textColor, //currentStack.color,
                    ),
                    Text(
                      "${DataFormatter.chipsFormat(currentStack.difference)}",
                      style: AppStylesNew.stackPopUpTextStyle.copyWith(
                        color: textColor,
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
}

/// Sample linear data type.
class PlayerStackChartModel {
  int handNum;
  double before;
  double after;
  double difference;
  double tenPer;
  bool green;
  bool red;
  bool neutral;
  Color color;

  PlayerStackChartModel(var e, {bool first: false}) {
    handNum = e["handNum"];
    before = double.parse(e["before"].toString()) / 100;
    if (first) {
      handNum = handNum - 1;
      after = double.parse(e["before"].toString()) / 100;
    } else {
      after = double.parse(e["after"].toString()) / 100;
    }
    difference = (after - before);
    var absDiff = difference.abs();
    tenPer = (before / 10).abs();
    neutral = true;
    red = false;
    green = false;
    color = Colors.blueGrey;
    if (absDiff > tenPer) {
      neutral = false;
      debugPrint(
          'stack view: handNum: $handNum, before: $before after: $after diff: $difference tenPercent: $tenPer');
      if (difference < 0) {
        red = true;
        color = Colors.red;
      } else {
        green = true;
        color = Colors.green;
      }
    }
  }

  PlayerStackChartModel.fromPlayerStack(PlayerStack stack) {
    handNum = stack.handNum;
    before = 10;
    after = before + double.parse(stack.balance.toString());
    difference = (after - before);
    var absDiff = difference.abs();
    tenPer = (before / 10).abs();
    neutral = true;
    red = false;
    green = false;
    color = Colors.blueGrey;
    if (absDiff > tenPer) {
      neutral = false;
      debugPrint(
          'stack view: handNum: $handNum, before: $before after: $after diff: $difference tenPercent: $tenPer');
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
