import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:pokerapp/models/player_performance_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class PerformanceView extends StatefulWidget {
  final String playerUuid;
  PerformanceView({@required this.playerUuid});

  @override
  _PerformanceViewState createState() => _PerformanceViewState();
}

class _PerformanceViewState extends State<PerformanceView> {
  bool loading = true;
  PlayerPerformanceList performance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetch();
    });
  }

  Future<void> _fetch() async {
    // TODO: get from the service

    performance = await PlayerPerformanceList.fromSampleData();
    if (performance != null) {
      setState(() {
        loading = false;
      });
      return;
    }
  }

  Color getBalanceColor(double number) {
    if (number == null) {
      return AppColorsNew.newTextColor;
    }

    return number == 0
        ? AppColorsNew.newTextColor
        : number > 0
            ? AppColors.positiveColor
            : AppColors.negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: AppStylesNew.BgGreenRadialGradient,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              context: context,
              titleText: AppStringsNew.PerformanceTitle,
            ),
            body: loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Column(
                    children: [
                      Expanded(
                        child: performance.performanceList.length == 0
                            ? Center(
                                child: Text(
                                  "No data available!",
                                  style: AppStyles.disabledButtonTextStyle,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(8.pw),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.pw),
                                  color: AppColorsNew.newBackgroundBlackColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.pw),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Recent Games",
                                            style: AppStylesNew
                                                .gameActionTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: PerformanceBarChart(performance),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ))));
  }

  String getBalanceFormatted(double bal) {
    if (bal.abs() > 999999999) {
      double val = bal / 1000000000;
      return "${val.toStringAsFixed(1)}B";
    }
    if (bal.abs() > 999999) {
      double val = bal / 1000000;
      return "${val.toStringAsFixed(1)}M";
    }
    if (bal.abs() > 999) {
      double val = bal / 1000;
      return "${val.toStringAsFixed(1)}K";
    }
    return "${bal.toStringAsFixed(1)}";
  }
}

class PerformanceBarChart extends StatelessWidget {
  final PlayerPerformanceList performance;

  PerformanceBarChart(this.performance);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PlayerPerformance, String>> series = [
      charts.Series(
          id: "Performance",
          data: performance.performanceList,
          domainFn: (PlayerPerformance day, _) {
            return day.dayStr;
          },
          measureFn: (PlayerPerformance day, _) => day.profit,
          colorFn: (PlayerPerformance day, _) => day.color),
    ];

    return charts.BarChart(
      series,
      animate: false,
      vertical: true,
      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        new charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        new charts.PanAndZoomBehavior(),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 3,
          desiredMaxTickCount: 7,
          desiredTickCount: 5,
        ),
        showAxisLine: false,
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontFamily: AppAssets.fontFamilyLato,
            fontSize: 8.dp.toInt(),
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(
              AppColors.listViewDividerColor,
            ),
          ),
        ),
      ),
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.white,
              fontFamily: AppAssets.fontFamilyLato,
              fontSize: 8.dp.toInt(),
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.Color.transparent,
            ),
            //labelRotation: 90,
          ),
          viewport:
              new charts.OrdinalViewport(performance.recentPerf.dayStr, 5)),
    );
  }
}
