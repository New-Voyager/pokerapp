import 'package:flutter/material.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/highrank_stats_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../routes.dart';

class ClubStatsScreen extends StatefulWidget {
  final String clubCode;
  const ClubStatsScreen({Key key, this.clubCode}) : super(key: key);

  @override
  _ClubStatsScreenState createState() => _ClubStatsScreenState();
}

class _ClubStatsScreenState extends State<ClubStatsScreen>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_statistics;
  TabController _tabController;
  HighRankStatsModel _clubStats;
  HighRankStatsModel _systemStats;

  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("clubStatsScreen");

    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchStats();
      //_fetchTestClubStats();
    });
    super.initState();
  }

  _fetchStats() async {
    _clubStats = await StatsService.getClubStats(widget.clubCode);
    _systemStats = await StatsService.getSystemStats();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              theme: theme,
              context: context,
              titleText: _appScreenText['clubStats'],
              subTitleText: widget.clubCode,
            ),
            body: _clubStats == null
                ? CircularProgressWidget(
                    text: _appScreenText['loadStats'],
                  )
                : Column(
                    children: [
                      AppDimensionsNew.getVerticalSizedBox(8),
                      TabBar(
                        physics: const BouncingScrollPhysics(),
                        controller: _tabController,
                        tabs: [
                          Text(_appScreenText['NOLIMITHOLDEM']),
                          Text(_appScreenText['PLO']),
                          Text(_appScreenText['5CARDPLO']),
                        ],
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: theme.accentColor,
                        labelColor: theme.secondaryColorWithLight(0.2),
                        unselectedLabelColor: theme.secondaryColorWithDark(0.2),
                      ),
                      AppDimensionsNew.getVerticalSizedBox(8),
                      Expanded(
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          controller: _tabController,
                          children: [
                            StatsDetailForGame(
                              action: _clubStats.holdem,
                              systemStats: _systemStats.holdem,
                              imagePath: AppAssetsNew.pathHoldemTypeImage,
                              appScreenText: _appScreenText,
                            ),
                            StatsDetailForGame(
                              action: _clubStats.plo,
                              systemStats: _systemStats.plo,
                              imagePath: AppAssetsNew.pathPLOTypeImage,
                              appScreenText: _appScreenText,
                            ),
                            StatsDetailForGame(
                              action: _clubStats.fivecardPlo,
                              systemStats: _systemStats.fivecardPlo,
                              imagePath: AppAssetsNew.pathFiveCardPLOTypeImage,
                              appScreenText: _appScreenText,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class StatsDetailForGame extends StatelessWidget {
  final Map<String, int> action;
  final Map<String, int> systemStats;
  final String imagePath;
  final AppTextScreen appScreenText;

  StatsDetailForGame(
      {this.action, this.systemStats, this.imagePath, this.appScreenText});
  final List<String> types = CardHelper.rankCards.keys.toList();
  //final List<List<int>> values = CardHelper.rankCards.values.toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 48.pw,
                      width: 48.pw,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppDecorators.tileDecoration(theme),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Club',
                          style: AppDecorators.getAccentTextStyle(theme: theme),
                        ),
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '# Games',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                Text(
                                  "${action['totalGames']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "# Hands",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                Text(
                                  "${action['totalHands']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ],
                            ),
                          ]),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '# Players',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                FittedBox(
                                    child: Text(
                                  "${action['totalPlayersInHand']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '# Showdown\n   Players',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                Text(
                                  "${action['totalPlayersInShowdown']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                  // Container(
                  //   height: 100,
                  //   width: 100,
                  //   child: Image.asset(
                  //     imagePath,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                ),
                AppDimensionsNew.getVerticalSizedBox(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppDecorators.tileDecoration(theme),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'All Time',
                          style: AppDecorators.getAccentTextStyle(theme: theme),
                        ),
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '# Games',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                Text(
                                  "${systemStats['totalGames']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "# Hands",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                Text(
                                  "${systemStats['totalHands']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ],
                            ),
                          ]),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '# Players',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                FittedBox(
                                    child: Text(
                                  "${systemStats['totalPlayersInHand']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '# Showdown\n   Players',
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                ),
                                Text(
                                  "${systemStats['totalPlayersInShowdown']}",
                                  style: AppDecorators.getAccentTextStyle(
                                      theme: theme),
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                ),
                AppDimensionsNew.getVerticalSizedBox(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppDecorators.tileDecoration(theme),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'High Ranking Hits',
                        style: AppDecorators.getHeadLine4Style(theme: theme),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              appScreenText['hand'],
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: Text(
                              'Club',
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                              textAlign: TextAlign.end,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(
                              'All Time',
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                              textAlign: TextAlign.end,
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      AppDimensionsNew.getVerticalSizedBox(8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: StackCardView02(
                                  cards: CardHelper.rankCards[types[index]],
                                  show: true,
                                ),
                                flex: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "${action[types[index]]}",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                  textAlign: TextAlign.end,
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                  "${systemStats[types[index]]}",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                  textAlign: TextAlign.end,
                                ),
                                flex: 2,
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            Divider(height: 8),
                        itemCount: CardHelper.rankCards.length,
                        cacheExtent: 20,
                      )
                    ],
                  ),
                ),
                AppDimensionsNew.getVerticalSizedBox(8.ph),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppDecorators.tileDecoration(theme),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '# Games: ',
                            style:
                                AppDecorators.getAccentTextStyle(theme: theme),
                          ),
                          TextSpan(
                            text: 'Total games played',
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          )
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '# Hands: ',
                            style:
                                AppDecorators.getAccentTextStyle(theme: theme),
                          ),
                          TextSpan(
                            text: 'Cumulative hands of all games',
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          )
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '# Players: ',
                            style:
                                AppDecorators.getAccentTextStyle(theme: theme),
                          ),
                          TextSpan(
                            text: 'Cumulative players played all hands',
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          )
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: '# Showdown Players: ',
                            style:
                                AppDecorators.getAccentTextStyle(theme: theme),
                          ),
                          TextSpan(
                            text: 'Cumulative players who were in showdown',
                            style:
                                AppDecorators.getHeadLine4Style(theme: theme),
                          )
                        ])),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
