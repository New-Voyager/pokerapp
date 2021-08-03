import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_stats_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stat_chart.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

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

  @override
  void initState() {
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
      // stats.loadData();

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
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.showToolbar
            ? CustomAppBar(
                context: context,
                titleText: 'Hand Statistics',
                subTitleText: 'Game: ${model?.gameCode} ',
              )
            : AppBar(
                toolbarHeight: 0,
              ),
        body: stats == null
            ? CircularProgressWidget(
                text: "Loading Statistics..",
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Pie Charts
                    Container(
                      decoration: AppStylesNew.actionRowDecoration,
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
                                    Text("All Time"),
                                    Text("Hands : ${stats.alltime.totalHands}"),
                                    Container(
                                        height: 150,
                                        child: HandStatPieChart(stats.alltime)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Legend for PieChart
                          Wrap(
                            children: [
                              buildOneItemInLegend(
                                  "Preflop", AppColorsNew.preflopColor),
                              buildOneItemInLegend(
                                  "Flop", AppColorsNew.flopColor),
                              buildOneItemInLegend(
                                  "Turn", AppColorsNew.turnColor),
                              buildOneItemInLegend(
                                  "River", AppColorsNew.riverColor),
                              buildOneItemInLegend(
                                  "Showdown", AppColorsNew.showDownColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action Statistics
                    Container(
                      decoration: AppStylesNew.actionRowDecoration,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Stage Statistics",
                                textAlign: TextAlign.left,
                                style: AppStylesNew.cardHeaderTextStyle,
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
                                  "All Time",
                                  textAlign: TextAlign.center,
                                  style: AppStylesNew.labelTextStyle,
                                ),
                              ),
                            ],
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Preflop", AppColorsNew.preflopColor),
                            allVal: stats.alltime.inPreflop,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Flop", AppColorsNew.flopColor),
                            allVal: stats.alltime.inFlop,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Turn", AppColorsNew.turnColor),
                            allVal: stats.alltime.inTurn,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "River", AppColorsNew.riverColor),
                            allVal: stats.alltime.inRiver,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Showdown", AppColorsNew.showDownColor),
                            allVal: stats.alltime.wentToShowDown,
                          ),
                          AppDimensionsNew.getVerticalSizedBox(16),
                        ],
                      ),
                    ),

                    // Action Statistics
                    Container(
                      decoration: AppStylesNew.actionRowDecoration,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Action Statistics",
                                textAlign: TextAlign.left,
                                style: AppStylesNew.cardHeaderTextStyle,
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
                                  "All Time",
                                  textAlign: TextAlign.center,
                                  style: AppStylesNew.labelTextStyle,
                                ),
                              ),
                            ],
                          ),
                          _buildOneStatRow(
                            title: "Vpip",
                            allVal: stats.alltime.vpipCount,
                          ),
                          _buildOneStatRow(
                            title: "Cont Bet",
                            allVal: stats.alltime.contBet,
                          ),
                          _buildOneStatRow(
                            title: "3 Bet",
                            allVal: stats.alltime.threeBet,
                          ),
                          _buildOneStatRow(
                            title: "WTSD",
                            allVal: stats.alltime.wentToShowDown,
                          ),
                          _buildOneStatRow(
                            title: "W\$SD",
                            allVal: stats.alltime.wonAtShowDown,
                          ),
                          _buildOneStatRow(
                            title: "Headsup",
                            allVal: stats.alltime.headsupHands,
                          ),
                          _buildOneStatRow(
                            title: "Headsup Won",
                            allVal: stats.alltime.wonHeadsupHands,
                          ),
                          AppDimensionsNew.getVerticalSizedBox(16),
                          Text(
                            "WTSD : Went To Show Down",
                            style: AppStylesNew.appBarSubTitleTextStyle,
                          ),
                          Text(
                            "W\$SD : Won at Show Down",
                            style: AppStylesNew.appBarSubTitleTextStyle,
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
    );
  }

  Widget _buildOneStageRow({Widget title, int allVal}) {
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
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
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.alltime.totalHands == 0
                        ? 0
                        : "${((allVal / stats.alltime.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOneStatRow({String title, int allVal}) {
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
      padding: EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: AppStylesNew.labelTextStyle,
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
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.alltime.totalHands == 0
                        ? 0
                        : "${((allVal / stats.alltime.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildOneItemInLegend(String text, Color color) {
    return Container(
      constraints: BoxConstraints(minWidth: 50),
      margin: EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10.ph,
            width: 10.pw,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          AppDimensionsNew.getHorizontalSpace(4),
          Text(text),
        ],
      ),
    );
  }
}
