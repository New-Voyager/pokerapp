import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/heading_widget.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';

class LiveGamesScreen extends StatefulWidget {
  @override
  _LiveGamesScreenState createState() => _LiveGamesScreenState();
}

class _LiveGamesScreenState extends State<LiveGamesScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isPlayedGamesLoading = true;
  List<GameModelNew> liveGames = [];
  List<GameModelNew> _playedGames = [];

  TabController _tabController;

  Timer _refreshTimer;

  Future<void> _fillLiveGames() async {
    //print('fetching live games');
    liveGames = await GameService.getLiveGamesNew();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TestService.isTesting ? _loadTestLiveGames() : _fetchLiveGames();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TestService.isTesting ? _loadTestLiveGames() : _fetchPlayedGames();
    });

    // THIS IS A TEMPORARY SOLUTION
    // _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   await _fillLiveGames();
    //   if(mounted) setState(() {});
    // });
  }

  _fetchLiveGames() async {
    ConnectionDialog.show(
      context: context,
      loadingText: AppStringsNew.LoadingGamesText,
    );
    await _fillLiveGames();
    setState(() => _isLoading = false);
    ConnectionDialog.dismiss(context: context);
  }

  _fetchPlayedGames() async {
    ConnectionDialog.show(
      context: context,
      loadingText: AppStringsNew.LoadingGamesText,
    );
    await _fillLiveGames();
    setState(() => _isPlayedGamesLoading = false);
    ConnectionDialog.dismiss(context: context);
  }

  _loadTestLiveGames() async {
    ConnectionDialog.show(
        context: context, loadingText: AppStringsNew.LoadingGamesText);
    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/livegames.json");
    // log(data);

    final jsonResult = json.decode(data);

    for (var item in jsonResult['liveGames']) {
      liveGames.add(GameModelNew.fromJson(item));
    }
    log("Size : ${liveGames.length}");
    setState(() {
      _isLoading = false;
      _isPlayedGamesLoading = false;
    });
    ConnectionDialog.dismiss(context: context);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.bgDecoration,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(children: [
            TabBar(
              tabs: [
                Tab(
                  text: "Live Games",
                  icon: Image.asset(
                    AppAssetsNew.liveGamesTabImagePath,
                    height: 24,
                    width: 24,
                    color: AppColorsNew.newGreenButtonColor,
                  ),
                ),
                Tab(
                  text: "Game Record",
                  icon: Image.asset(
                    AppAssetsNew.playedGamesTabImagePath,
                    height: 24,
                    width: 24,
                    color: AppColorsNew.newGreenButtonColor,
                  ),
                ),
              ],
              indicatorColor: AppColorsNew.yellowAccentColor,
              labelColor: AppColorsNew.newGreenButtonColor,
              unselectedLabelColor:
                  AppColorsNew.newGreenButtonColor.withAlpha(150),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppStylesNew.valueTextStyle,
              controller: _tabController,
            ),
            // HeadingWidget(
            //   heading: 'Live Games',
            // ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _isLoading
                      ? Container()
                      : liveGames.isEmpty
                          ? Center(
                              child: Text(
                                AppStringsNew.NoGamesText,
                                style: AppStylesNew.titleTextStyle,
                              ),
                            )
                          : ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return LiveGameItem(
                                  game: liveGames[index],
                                  onTapFunction: () async {
                                    await Navigator.of(context).pushNamed(
                                      Routes.game_play,
                                      arguments: liveGames[index].gameCode,
                                    );
                                    // Refreshes livegames again
                                    TestService.isTesting
                                        ? _loadTestLiveGames()
                                        : _fetchLiveGames();
                                  },
                                );
                              },
                              padding: EdgeInsets.only(
                                bottom: 64.ph,
                                top: 16.ph,
                              ),
                              separatorBuilder: (
                                context,
                                index,
                              ) =>
                                  AppDimensionsNew.getVerticalSizedBox(16.ph),
                              itemCount: liveGames.length,
                            ),
                  _isPlayedGamesLoading
                      ? Container()
                      : _playedGames.isEmpty
                          ? Center(
                              child: Text(
                                AppStringsNew.noGameRecordsText,
                                style: AppStylesNew.titleTextStyle,
                              ),
                            )
                          : ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return LiveGameItem(
                                    game: _playedGames[index],
                                    onTapFunction: () async {
                                      await Navigator.of(context).pushNamed(
                                        Routes.game_play,
                                        arguments: _playedGames[index].gameCode,
                                      );
                                      // Refreshes livegames again
                                      if (TestService.isTesting) {
                                        _loadTestLiveGames();
                                      } else {
                                        _fetchLiveGames();
                                        _fetchPlayedGames();
                                      }
                                    });
                              },
                              padding: EdgeInsets.only(
                                bottom: 64.ph,
                                top: 16.ph,
                              ),
                              separatorBuilder: (
                                context,
                                index,
                              ) =>
                                  AppDimensionsNew.getVerticalSizedBox(16.ph),
                              itemCount: liveGames.length,
                            ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
