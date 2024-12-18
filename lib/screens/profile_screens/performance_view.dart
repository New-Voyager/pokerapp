import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pokerapp/models/player_performance_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_alltime_stats_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

class PerformanceView extends StatefulWidget {
  final String playerUuid;
  PerformanceView({@required this.playerUuid});

  @override
  _PerformanceViewState createState() => _PerformanceViewState();
}

class _PerformanceViewState extends State<PerformanceView>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  PlayerPerformanceList performance;
  TabController _tabController;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("performanceView");

    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetch();
    });
    super.initState();
  }

  Future<void> _fetch() async {
    try {
      performance = await StatsService.getPlayerRecentPerformance();
    } catch (err) {}
    //performance = await PlayerPerformanceList.fromSampleData();
    setState(() {
      loading = false;
    });
    return;
  }

  Color getBalanceColor(double number) {
    if (number == null) {
      return AppColorsNew.newTextColor;
    }

    return number == 0
        ? AppColorsNew.newTextColor
        : number > 0
            ? AppColorsNew.positiveColor
            : AppColorsNew.negativeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
            decoration: AppDecorators.bgRadialGradient(theme),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBar(
                theme: theme,
                context: context,
                titleText: _appScreenText['STATISTICS'],
              ),
              body: loading
                  ? Center(child: CircularProgressWidget())
                  : (performance == null) ||
                          performance.performanceList == null ||
                          performance.performanceList.length == 0
                      ? Center(
                          child: Text(
                            _appScreenText['dataNotAvailable'],
                            style: AppStylesNew.disabledButtonTextStyle,
                          ),
                        )
                      : Column(
                          children: [
                            TabBar(
                              physics: const BouncingScrollPhysics(),
                              controller: _tabController,
                              tabs: [
                                Tab(text: _appScreenText['handStats']),
                                //Tab(text: _appScreenText['performance']),
                              ],
                              labelColor: theme.secondaryColorWithLight(),
                              unselectedLabelColor:
                                  theme.secondaryColorWithDark(),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: theme.accentColor,
                            ),
                            Expanded(
                              child: TabBarView(
                                physics: const BouncingScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  // Hand statistics
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: HandAlltimeStatsView(
                                      showToolbar: false,
                                    ),
                                  ),

                                  // Performance
                                  // performanceView(theme),
                                ],
                              ),
                            ),
                          ],
                        ),
            ));
      },
    );
  }

  Widget performanceView(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(16.pw),
          child: Column(
            children: [
              Text(
                _appScreenText['recentGames'],
                style: AppDecorators.getSubtitle3Style(theme: theme),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            padding: EdgeInsets.all(8),
            decoration: AppDecorators.tileDecoration(theme),
            child: PerformanceBarChart(performance),
          ),
        ),
      ],
    );
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
              AppColorsNew.listViewDividerColor,
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
