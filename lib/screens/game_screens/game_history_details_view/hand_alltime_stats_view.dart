import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_stats_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stat_chart.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class HandAlltimeStatsView extends StatefulWidget {
  final bool showToolbar;

  const HandAlltimeStatsView({Key key, this.showToolbar}) : super(key: key);

  @override
  _HandAlltimeStatsViewState createState() => _HandAlltimeStatsViewState();
}

class _HandAlltimeStatsViewState extends State<HandAlltimeStatsView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.hand_statistics;
  GameHistoryDetailModel model;
  HandStatsModel stats;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("handAlltimeStatsView");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAllTimeStatsOnly();
      //testStats();
    });
    super.initState();
  }

  fetchAllTimeStatsOnly() async {
    log("Fetching alltimeStats only");
    stats = await StatsService.getAlltimeStatsOnly();
    if (stats != null) {
      setState(() {});
    }
  }

  testStats() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/stats_new.json");

    final jsonResult = json.decode(data);
    stats = HandStatsModel.fromJson(jsonResult['data']);
    stats.loadData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: widget.showToolbar
              ? CustomAppBar(
                  theme: theme,
                  context: context,
                  titleText: _appScreenText['handStatistics'],
                  subTitleText:
                      '${_appScreenText['game']}: ${model?.gameCode} ',
                )
              : AppBar(
                  toolbarHeight: 0,
                ),
          body: stats == null
              ? CircularProgressWidget(
                  text: "${_appScreenText['loadingStatistics']}",
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Pie Charts
                      Container(
                        decoration: AppDecorators.tileDecoration(theme),
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        _appScreenText['allTime'],
                                        style: AppDecorators.getSubtitle3Style(
                                            theme: theme),
                                      ),
                                      Text(
                                        "${_appScreenText['hands']} : ${stats.alltime.totalHands}",
                                        style: AppDecorators.getHeadLine4Style(
                                            theme: theme),
                                      ),
                                      Container(
                                        height: 150,
                                        child: HandStatPieChart(stats.alltime),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Legend for PieChart
                            Wrap(
                              children: [
                                buildOneItemInLegend(_appScreenText['preflop'],
                                    theme.preFlopColor, theme),
                                buildOneItemInLegend(_appScreenText['flop'],
                                    theme.flopColor, theme),
                                buildOneItemInLegend(_appScreenText['turn'],
                                    theme.turnColor, theme),
                                buildOneItemInLegend(_appScreenText['river'],
                                    theme.riverColor, theme),
                                buildOneItemInLegend(_appScreenText['showdown'],
                                    theme.showDownColor, theme),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Action Statistics
                      Container(
                        decoration: AppDecorators.tileDecoration(theme),
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _appScreenText['stageStatistics'],
                                  textAlign: TextAlign.left,
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: SizedBox.shrink(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _appScreenText['allTime'],
                                    textAlign: TextAlign.center,
                                    style: AppDecorators.getSubtitle3Style(
                                        theme: theme),
                                  ),
                                ),
                              ],
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['preflop'],
                                  theme.preFlopColor,
                                  theme),
                              allVal: stats.alltime.inPreflop,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['flop'],
                                  theme.flopColor,
                                  theme),
                              allVal: stats.alltime.inFlop,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['turn'],
                                  theme.turnColor,
                                  theme),
                              allVal: stats.alltime.inTurn,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['river'],
                                  theme.riverColor,
                                  theme),
                              allVal: stats.alltime.inRiver,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['showdown'],
                                  theme.showDownColor,
                                  theme),
                              allVal: stats.alltime.wentToShowDown,
                              theme: theme,
                            ),
                            AppDimensionsNew.getVerticalSizedBox(16),
                          ],
                        ),
                      ),

                      // Action Statistics
                      Container(
                        decoration: AppDecorators.tileDecoration(theme),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _appScreenText['actionStatistics'],
                                  textAlign: TextAlign.left,
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: SizedBox.shrink(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _appScreenText['allTime'],
                                    textAlign: TextAlign.center,
                                    style: AppDecorators.getSubtitle3Style(
                                        theme: theme),
                                  ),
                                ),
                              ],
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['vpip'],
                              allVal: stats.alltime.vpipCount,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['contBet'],
                              allVal: stats.alltime.contBet,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['threeBet'],
                              allVal: stats.alltime.threeBet,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['wtsd'],
                              allVal: stats.alltime.wentToShowDown,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['wsd'],
                              allVal: stats.alltime.wonAtShowDown,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['headsup'],
                              allVal: stats.alltime.headsupHands,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['headsupWon'],
                              allVal: stats.alltime.wonHeadsupHands,
                              theme: theme,
                            ),
                            AppDimensionsNew.getVerticalSizedBox(16),
                            Text(
                              _appScreenText['WTSDWentToShowDown'],
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                            ),
                            Text(
                              _appScreenText['WSDWonatShowDown'],
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                            ),
                          ],
                        ),
                      ),
                      // Action Statistics
                      AppDimensionsNew.getVerticalSizedBox(56),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOneStageRow({Widget title, int allVal, AppTheme theme}) {
    return Container(
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: title,
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    allVal.toString(),
                    textAlign: TextAlign.right,
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.alltime.totalHands == 0
                        ? 0
                        : "${((allVal / stats.alltime.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOneStatRow({String title, int allVal, AppTheme theme}) {
    return Container(
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      padding: EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: AppDecorators.getSubtitle3Style(theme: theme),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    allVal.toString(),
                    textAlign: TextAlign.center,
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.alltime.totalHands == 0
                        ? 0
                        : "${((allVal / stats.alltime.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppDecorators.getHeadLine4Style(theme: theme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildOneItemInLegend(String text, Color color, AppTheme theme) {
    return Container(
      constraints: BoxConstraints(minWidth: 50),
      margin: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 12.ph,
            width: 12.pw,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          AppDimensionsNew.getHorizontalSpace(8),
          Text(
            text,
            style: AppDecorators.getSubtitle3Style(theme: theme),
          ),
        ],
      ),
    );
  }
}
