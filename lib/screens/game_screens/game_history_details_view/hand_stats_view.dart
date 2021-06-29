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
import 'package:pokerapp/screens/game_screens/game_history_details_view/hands_chart_view.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../../routes.dart';

class HandStatsView extends StatefulWidget {
  final GameHistoryDetailModel gameHistoryModel;

  const HandStatsView({Key key, this.gameHistoryModel}) : super(key: key);

  @override
  _HandStatsViewState createState() => _HandStatsViewState();
}

class _HandStatsViewState extends State<HandStatsView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.hand_statistics;
  GameHistoryDetailModel model;
  HandStatsModel stats;

  @override
  void initState() {
    model = widget.gameHistoryModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchStats();
      // testStats();
    });
    super.initState();
  }

  testStats() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/stats.json");

    final jsonResult = json.decode(data);
    stats = HandStatsModel.fromJson(jsonResult);
    stats.loadData();

    setState(() {});
  }

  fetchStats() async {
    stats = await StatsService.getStatsForAGame(model.gameCode);
    if (stats != null) {
      stats.loadData();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          context: context,
          titleText: 'Hand Statistics',
          subTitleText: 'Game: ${model?.gameCode} ',
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
                                    Text("This Game"),
                                    Text(
                                        "Hands : ${stats.thisGame.totalHands}"),
                                    Container(
                                        height: 150,
                                        child:
                                            HandStatPieChart(stats.thisGame)),
                                  ],
                                ),
                              ),
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
                                  "This Game",
                                  textAlign: TextAlign.center,
                                  style: AppStylesNew.labelTextStyle,
                                ),
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
                            thisVal: stats.thisGame.inPreflop,
                            allVal: stats.alltime.inPreflop,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Flop", AppColorsNew.flopColor),
                            thisVal: stats.thisGame.inFlop,
                            allVal: stats.alltime.inFlop,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Turn", AppColorsNew.turnColor),
                            thisVal: stats.thisGame.inTurn,
                            allVal: stats.alltime.inTurn,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "River", AppColorsNew.riverColor),
                            thisVal: stats.thisGame.inRiver,
                            allVal: stats.alltime.inRiver,
                          ),
                          _buildOneStageRow(
                            title: buildOneItemInLegend(
                                "Showdown", AppColorsNew.showDownColor),
                            thisVal: stats.thisGame.wentToShowDown,
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
                                  "This Game",
                                  textAlign: TextAlign.center,
                                  style: AppStylesNew.labelTextStyle,
                                ),
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
                            thisVal: stats.thisGame.vpipCount,
                            allVal: stats.alltime.vpipCount,
                          ),
                          _buildOneStatRow(
                            title: "Cont Bet",
                            thisVal: stats.thisGame.contBet,
                            allVal: stats.alltime.contBet,
                          ),
                          _buildOneStatRow(
                            title: "3 Bet",
                            thisVal: stats.thisGame.threeBet,
                            allVal: stats.alltime.threeBet,
                          ),
                          _buildOneStatRow(
                            title: "WTSD",
                            thisVal: stats.thisGame.wentToShowDown,
                            allVal: stats.alltime.wentToShowDown,
                          ),
                          _buildOneStatRow(
                            title: "W\$SD",
                            thisVal: stats.thisGame.wonAtShowDown,
                            allVal: stats.alltime.wonAtShowDown,
                          ),
                          _buildOneStatRow(
                            title: "Headsup",
                            thisVal: stats.thisGame.headsupHands,
                            allVal: stats.alltime.headsupHands,
                          ),
                          _buildOneStatRow(
                            title: "Headsup Won",
                            thisVal: stats.thisGame.wonHeadsupHands,
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
                    Container(
                      decoration: AppStylesNew.actionRowDecoration,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Headsup",
                                textAlign: TextAlign.left,
                                style: AppStylesNew.cardHeaderTextStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SizedBox.shrink(),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  "This Game",
                                  textAlign: TextAlign.center,
                                  style: AppStylesNew.labelTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  "All Time",
                                  textAlign: TextAlign.center,
                                  style: AppStylesNew.labelTextStyle,
                                ),
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
                                flex: 6,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Hands",
                                        textAlign: TextAlign.center,
                                        style: AppStylesNew.labelTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Won",
                                        textAlign: TextAlign.center,
                                        style: AppStylesNew.labelTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "%",
                                        textAlign: TextAlign.center,
                                        style: AppStylesNew.labelTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Hands",
                                        textAlign: TextAlign.center,
                                        style: AppStylesNew.labelTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Won",
                                        textAlign: TextAlign.center,
                                        style: AppStylesNew.labelTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "%",
                                        textAlign: TextAlign.center,
                                        style: AppStylesNew.labelTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ...getHeadsupRows(),
                        ],
                      ),
                    ),
                    AppDimensionsNew.getVerticalSizedBox(56),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildOneStageRow({Widget title, int thisVal, int allVal}) {
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: title,
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    thisVal.toString(),
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.thisGame.totalHands == 0
                        ? 0
                        : "${((thisVal / stats.thisGame.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
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

  Widget _buildOneStatRow({String title, int thisVal, int allVal}) {
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
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    thisVal.toString(),
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.thisGame.totalHands == 0
                        ? 0
                        : "${((thisVal / stats.thisGame.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
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

  Widget _buildOnePlayerHeadsupRow(
      {String player, int thisHands, int thisWon, int allHands, int allWon}) {
    return Container(
      decoration: AppStylesNew.actionRowDecoration,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              player,
              style: AppStylesNew.labelTextStyle,
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "$thisHands",
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    "$thisWon",
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    thisHands == 0
                        ? "$thisHands"
                        : "${((thisWon / thisHands) * 100).floor()}%",
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    allHands.toString(),
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    allWon.toString(),
                    textAlign: TextAlign.center,
                    style: AppStylesNew.statValTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    allHands == 0
                        ? 0
                        : "${((allWon / allHands) * 100).floor()}%",
                    textAlign: TextAlign.center,
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

  getHeadsupRows() {
    List<Widget> list = [];
    stats.alltime.headsupHandSummary.forEach((key, value) {
      log("${key.runtimeType} ${stats.headsupThisGame.keys}");
      int playerId = int.parse(key);
      final playerName = stats.playerIdToName[playerId];
      final verses = stats.headsupThisGame[int.parse(key)];
      list.add(_buildOnePlayerHeadsupRow(
        player: playerName,
        thisHands: verses == null ? 0 : verses.count,
        thisWon: verses == null ? 0 : verses.won,
        allHands: value.total,
        allWon: value.won,
      ));
    });
    if (list.isEmpty) {
      list.add(Container(
        height: 100,
        child: Center(
            child: Text(
          "No headsup data",
          style: AppStylesNew.labelTextStyle,
        )),
      ));
    }
    return list;
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
