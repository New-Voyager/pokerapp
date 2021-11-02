import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_stats_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stat_chart.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class HandStatsView extends StatefulWidget {
  final GameHistoryDetailModel gameHistoryModel;
  final bool isAlltimeOnly;

  const HandStatsView(
      {Key key, this.gameHistoryModel, this.isAlltimeOnly = false})
      : super(key: key);

  @override
  _HandStatsViewState createState() => _HandStatsViewState();
}

class _HandStatsViewState extends State<HandStatsView>
    with RouteAwareAnalytics {
  @override
  String get routeName => Routes.hand_statistics;
  GameHistoryDetailModel model;
  HandStatsModel stats;
  bool showThisGame = false;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("handStatsView");

    model = widget.gameHistoryModel;
    showThisGame = !(widget.isAlltimeOnly ?? false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // fetchStats();
      showThisGame ? fetchStats() : fetchAllTimeStatsOnly();
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

  fetchStats() async {
    if (model != null) {
      stats = await StatsService.getStatsForAGame(model.gameCode);
      if (stats != null) {
        stats.loadData();

        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: showThisGame
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
                  text: _appScreenText['loadingStatistics'])
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
                                Visibility(
                                  maintainState: false,
                                  visible: showThisGame,
                                  child: Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Text(_appScreenText['thisGame'],
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme)),
                                        Text(
                                            "${_appScreenText['hands']}: ${stats.thisGame.totalHands}",
                                            style:
                                                AppDecorators.getSubtitle1Style(
                                                    theme: theme)),
                                        Container(
                                            height: 150.ph,
                                            child: HandStatPieChart(
                                                stats.thisGame)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(_appScreenText['allTime'],
                                          style:
                                              AppDecorators.getHeadLine4Style(
                                                  theme: theme)),
                                      Text(
                                          "${_appScreenText['hands']} : ${stats.alltime.totalHands}"),
                                      Container(
                                          height: 150,
                                          child:
                                              HandStatPieChart(stats.alltime)),
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
                                Visibility(
                                  visible: showThisGame,
                                  child: Expanded(
                                    flex: 2,
                                    child: Text(_appScreenText['thisGame'],
                                        textAlign: TextAlign.center,
                                        style: AppDecorators.getSubtitle3Style(
                                            theme: theme)),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(_appScreenText['allTime'],
                                      textAlign: TextAlign.center,
                                      style: AppDecorators.getSubtitle3Style(
                                          theme: theme)),
                                ),
                              ],
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['preflop'],
                                  AppColorsNew.preflopColor,
                                  theme),
                              thisVal: stats.thisGame.inPreflop,
                              allVal: stats.alltime.inPreflop,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['flop'],
                                  AppColorsNew.flopColor,
                                  theme),
                              thisVal: stats.thisGame.inFlop,
                              allVal: stats.alltime.inFlop,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['turn'],
                                  AppColorsNew.turnColor,
                                  theme),
                              thisVal: stats.thisGame.inTurn,
                              allVal: stats.alltime.inTurn,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['river'],
                                  AppColorsNew.riverColor,
                                  theme),
                              thisVal: stats.thisGame.inRiver,
                              allVal: stats.alltime.inRiver,
                              theme: theme,
                            ),
                            _buildOneStageRow(
                              title: buildOneItemInLegend(
                                  _appScreenText['showdown'],
                                  AppColorsNew.showDownColor,
                                  theme),
                              thisVal: stats.thisGame.wentToShowDown,
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
                                Visibility(
                                  visible: showThisGame,
                                  child: Expanded(
                                    flex: 2,
                                    child: Text(
                                      _appScreenText['thisGame'],
                                      textAlign: TextAlign.center,
                                      style: AppDecorators.getSubtitle3Style(
                                          theme: theme),
                                    ),
                                  ),
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
                              thisVal: stats.thisGame.vpipCount,
                              allVal: stats.alltime.vpipCount,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['contBet'],
                              thisVal: stats.thisGame.contBet,
                              allVal: stats.alltime.contBet,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['threeBet'],
                              thisVal: stats.thisGame.threeBet,
                              allVal: stats.alltime.threeBet,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['wtsd'],
                              thisVal: stats.thisGame.wentToShowDown,
                              allVal: stats.alltime.wentToShowDown,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['wsd'],
                              thisVal: stats.thisGame.wonAtShowDown,
                              allVal: stats.alltime.wonAtShowDown,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['headsup'],
                              thisVal: stats.thisGame.headsupHands,
                              allVal: stats.alltime.headsupHands,
                              theme: theme,
                            ),
                            _buildOneStatRow(
                              title: _appScreenText['headsupWon'],
                              thisVal: stats.thisGame.wonHeadsupHands,
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
                      Container(
                        decoration: AppDecorators.tileDecoration(theme),
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _appScreenText['headsup'],
                                  textAlign: TextAlign.left,
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: SizedBox.shrink(),
                                ),
                                Visibility(
                                  visible: showThisGame,
                                  child: Expanded(
                                    flex: 6,
                                    child: Text(
                                      _appScreenText['thisGame'],
                                      textAlign: TextAlign.center,
                                      style: AppDecorators.getSubtitle3Style(
                                          theme: theme),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    _appScreenText['allTime'],
                                    textAlign: TextAlign.center,
                                    style: AppDecorators.getSubtitle3Style(
                                        theme: theme),
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
                                Visibility(
                                  visible: showThisGame,
                                  child: Expanded(
                                    flex: 6,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _appScreenText['hands'],
                                            textAlign: TextAlign.center,
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _appScreenText['won'],
                                            textAlign: TextAlign.center,
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _appScreenText['perSymbol'],
                                            textAlign: TextAlign.center,
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _appScreenText['hands'],
                                          textAlign: TextAlign.center,
                                          style:
                                              AppDecorators.getSubtitle3Style(
                                                  theme: theme),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _appScreenText['won'],
                                          textAlign: TextAlign.center,
                                          style:
                                              AppDecorators.getSubtitle3Style(
                                                  theme: theme),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _appScreenText['perSymbol'],
                                          textAlign: TextAlign.center,
                                          style:
                                              AppDecorators.getSubtitle3Style(
                                                  theme: theme),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ...getHeadsupRows(theme),
                          ],
                        ),
                      ),
                      AppDimensionsNew.getVerticalSizedBox(56),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOneStageRow(
      {Widget title, int thisVal, int allVal, @required AppTheme theme}) {
    return Container(
      decoration: AppDecorators.tileDecorationWithoutBorder(theme),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: title,
          ),
          Visibility(
            visible: showThisGame,
            child: Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      thisVal.toString(),
                      textAlign: TextAlign.center,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      stats.thisGame.totalHands == 0
                          ? 0
                          : "${((thisVal / stats.thisGame.totalHands) * 100).floor()}%",
                      textAlign: TextAlign.right,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: showThisGame ? 2 : 5,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    allVal.toString(),
                    textAlign: TextAlign.right,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.alltime.totalHands == 0
                        ? 0
                        : "${((allVal / stats.alltime.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOneStatRow(
      {String title, int thisVal, int allVal, @required AppTheme theme}) {
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
          Visibility(
            visible: showThisGame,
            child: Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      thisVal.toString(),
                      textAlign: TextAlign.center,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      stats.thisGame.totalHands == 0
                          ? 0
                          : "${((thisVal / stats.thisGame.totalHands) * 100).floor()}%",
                      textAlign: TextAlign.right,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: showThisGame ? 2 : 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    allVal.toString(),
                    textAlign: TextAlign.center,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    stats.alltime.totalHands == 0
                        ? 0
                        : "${((allVal / stats.alltime.totalHands) * 100).floor()}%",
                    textAlign: TextAlign.right,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
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
      {String player,
      int thisHands,
      int thisWon,
      int allHands,
      int allWon,
      @required AppTheme theme}) {
    return Container(
      decoration: AppDecorators.tileDecoration(theme),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              player,
              style: AppDecorators.getSubtitle3Style(theme: theme),
            ),
          ),
          Visibility(
            visible: showThisGame,
            child: Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "$thisHands",
                      textAlign: TextAlign.center,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "$thisWon",
                      textAlign: TextAlign.center,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      thisHands == 0
                          ? "$thisHands"
                          : "${((thisWon / thisHands) * 100).floor()}%",
                      textAlign: TextAlign.center,
                      style: AppDecorators.getSubtitle1Style(theme: theme),
                    ),
                  ),
                ],
              ),
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
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    allWon.toString(),
                    textAlign: TextAlign.center,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                  ),
                ),
                Expanded(
                  child: Text(
                    allHands == 0
                        ? 0
                        : "${((allWon / allHands) * 100).floor()}%",
                    textAlign: TextAlign.center,
                    style: AppDecorators.getSubtitle1Style(theme: theme),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getHeadsupRows(AppTheme theme) {
    List<Widget> list = [];
    stats.alltime.headsupHandSummary.forEach((key, value) {
      log("${key.runtimeType} ${stats.headsupThisGame.keys}");
      int playerId = int.parse(key);
      final playerName = stats.playerIdToName[playerId];
      final verses = stats.headsupThisGame[int.parse(key)];
      if (playerName != null) {
        list.add(_buildOnePlayerHeadsupRow(
          player: playerName,
          thisHands: verses == null ? 0 : verses.count,
          thisWon: verses == null ? 0 : verses.won,
          allHands: value.total,
          allWon: value.won,
          theme: theme,
        ));
      }
    });
    if (list.isEmpty) {
      list.add(Container(
        height: 100,
        child: Center(
            child: Text(
          _appScreenText['noHeadsupData'],
          style: AppDecorators.getSubtitle3Style(theme: theme),
        )),
      ));
    }
    return list;
  }

  buildOneItemInLegend(String text, Color color, AppTheme theme) {
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
          Text(
            text,
            style: AppDecorators.getSubtitle1Style(theme: theme),
          ),
        ],
      ),
    );
  }
}
