import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_stats_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/stats_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:provider/provider.dart';

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
  ClubStatsModel _clubStats;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchClubStats();
      //_fetchTestClubStats();
    });
    super.initState();
  }

  _fetchClubStats() async {
    _clubStats = await StatsService.getClubStats(widget.clubCode);
    if (_clubStats != null) {
      setState(() {});
    }
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
              titleText: AppStringsNew.clubStatisticsTitle,
              subTitleText: widget.clubCode,
            ),
            body: _clubStats == null
                ? CircularProgressWidget(
                    text: AppStringsNew.loadingStatistics,
                  )
                : Column(
                    children: [
                      AppDimensionsNew.getVerticalSizedBox(8),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Text(AppStringsNew.tabNLHText),
                          Text(AppStringsNew.tabPLOText),
                          Text(AppStringsNew.tab5CardPLOText),
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
                          controller: _tabController,
                          children: [
                            StatsDetailForGame(
                              action: _clubStats.holdem,
                              imagePath: AppAssetsNew.pathHoldemTypeImage,
                            ),
                            StatsDetailForGame(
                              action: _clubStats.plo,
                              imagePath: AppAssetsNew.pathPLOTypeImage,
                            ),
                            StatsDetailForGame(
                              action: _clubStats.fivecardPlo,
                              imagePath: AppAssetsNew.pathFiveCardPLOTypeImage,
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
  final String imagePath;
  StatsDetailForGame({this.action, this.imagePath});
  final List<String> types = CardHelper.rankCards.keys.toList();
  //final List<List<int>> values = CardHelper.rankCards.values.toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: AppDecorators.tileDecoration(theme),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStringsNew.totalGamesText,
                                style: AppDecorators.getSubtitle3Style(
                                    theme: theme),
                              ),
                              Text(
                                "${action['totalGames']}",
                                style: AppDecorators.getHeadLine3Style(
                                    theme: theme),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStringsNew.totalHandsText,
                                style: AppDecorators.getSubtitle3Style(
                                    theme: theme),
                              ),
                              Text(
                                "${action['totalHands']}",
                                style: AppDecorators.getHeadLine3Style(
                                    theme: theme),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
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
                        AppStringsNew.oddsSoFarText,
                        style: AppDecorators.getHeadLine4Style(theme: theme),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppStringsNew.hand,
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: Text(
                              AppStringsNew.hitsText,
                              style:
                                  AppDecorators.getSubtitle3Style(theme: theme),
                              textAlign: TextAlign.end,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(
                              AppStringsNew.odds,
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
                                  (action['totalHands'] == 0 ||
                                          action[types[index]] == 0)
                                      ? "NA"
                                      : "${(action[types[index]] / action['totalHands']).toStringAsFixed(4)}",
                                  style: AppDecorators.getHeadLine4Style(
                                      theme: theme),
                                  textAlign: TextAlign.end,
                                ),
                                flex: 3,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
