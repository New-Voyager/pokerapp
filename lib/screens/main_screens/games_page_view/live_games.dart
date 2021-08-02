import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_strings.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/game_record_item.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service_bin.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/heading_widget.dart';

import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/rounded_accent_button.dart';
import 'package:provider/provider.dart';

class LiveGamesScreen extends StatefulWidget {
  @override
  _LiveGamesScreenState createState() => _LiveGamesScreenState();
}

class _LiveGamesScreenState extends State<LiveGamesScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isLoading = true;
  bool _isPlayedGamesLoading = true;
  List<GameModelNew> liveGames = [];
  List<GameHistoryModel> playedGames = [];

  TabController _tabController;

  Timer _refreshTimer;

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
    WidgetsBinding.instance.addObserver(this);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _serverPolling();
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initTimer();
    });
  }

  @override
  void dispose() {
    _disposeTimer();
    _tabController.dispose();
    super.dispose();
  }

  // Lifeccyle Methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("AppLifeCycleState : $state");
    switch (state) {
      case AppLifecycleState.paused:
        log("0-0-0- PAUSED");
        _disposeTimer();
        break;
      case AppLifecycleState.detached:
        log("0-0-0- detached");
        _disposeTimer();
        break;
      case AppLifecycleState.inactive:
        log("0-0-0- INACTIVE");
        _disposeTimer();
        break;
      case AppLifecycleState.resumed:
        log("0-0-0- resumed");
        _initTimer();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  _initTimer() async {
    log("0-0-0- In Init Timer");
    if (_refreshTimer == null || !_refreshTimer.isActive) {
      log("0-0-0- In Init Timer - Timer initialized Again!");
      _refreshTimer =
          Timer.periodic(const Duration(seconds: 30), (timer) async {
        if (mounted) {
          final int currentIndex =
              Provider.of<AppState>(context, listen: false).currentIndex;
          if (currentIndex == 0) {
            if (_tabController.index == 0) {
              log("0-0-0-In LiveGames Refresh");
              await _fetchLiveGames();
            } else if (_tabController.index == 1) {
              log("0-0-0-In Game record refresh ");
              await _fetchPlayedGames();
            }
          }
        }
      });
    }
  }

  _disposeTimer() {
    log("0-0-0- In dispose Timer");
    if (_refreshTimer != null || _refreshTimer.isActive) {
      log("0-0-0- In dispose Timer - cancelled timer");
      _refreshTimer.cancel();
    }
  }

  // _serverPolling() async {
  //   while (true) {
  //     await Future.delayed(Duration(seconds: 10));
  //     if (mounted) {
  //       final int currentIndex =
  //           Provider.of<AppState>(context, listen: false).currentIndex;
  //       if (currentIndex == 0) {
  //         if (_tabController.index == 0) {
  //           log("0-0-0-In LiveGames");
  //         } else if (_tabController.index == 1) {
  //           log("0-0-0-In Game record");
  //         }
  //       }
  //     }
  //   }
  // }

  _fetchLiveGames() async {
    ConnectionDialog.show(
      context: context,
      loadingText: AppStringsNew.LoadingGamesText,
    );
    liveGames.clear();
    liveGames.addAll(await GameService.getLiveGamesNew());
    setState(() => _isLoading = false);
    ConnectionDialog.dismiss(context: context);
  }

  _fetchPlayedGames() async {
    ConnectionDialog.show(
      context: context,
      loadingText: AppStringsNew.LoadingGamesText,
    );
    playedGames.clear();
    //print('fetching live games');

    playedGames.addAll(await GameService.getPastGames());
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
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStylesNew.bgDecoration,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(children: [
            // AppBar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedAccentButton(
                    onTapFunction: () async {
                      testHand();
                      // _disposeTimer();
                      // final dynamic result = await Navigator.of(context)
                      //     .pushNamed(Routes.new_game_settings);
                      // if (result != null) {
                      //   /* show game settings dialog */
                      //   await NewGameSettings2.show(
                      //     context,
                      //     clubCode: "",
                      //     mainGameType: result['gameType'],
                      //     subGameTypes: List.from(
                      //           result['gameTypes'],
                      //         ) ??
                      //         [],
                      //   );
                      // }
                      // _initTimer();
                    },
                    text: "HOST",
                  ),
                  Expanded(
                    child: Text(
                      AppStringsNew.appName,
                      style: AppStylesNew.accentTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.dp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RoundedAccentButton(
                    onTapFunction: () async {
                      _disposeTimer();
                      String gameCode = "";
                      final String result = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actionsPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: AppColorsNew.actionRowBgColor,
                          title: Text("Game code"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CardFormTextField(
                                hintText: "Enter Game code",
                                onChanged: (val) {
                                  //log("VALUE : $val");
                                  gameCode = val;
                                },
                                keyboardType: TextInputType.name,
                              ),
                            ],
                          ),
                          actions: [
                            RoundedColorButton(
                                text: AppStringsNew.Join,
                                backgroundColor: AppColorsNew.yellowAccentColor,
                                textColor: AppColorsNew.darkGreenShadeColor,
                                onTapFunction: () async {
                                  if (gameCode.isEmpty) {
                                    toast("GameCode can't be empty");
                                    return;
                                  }

                                  Navigator.of(context).pop(gameCode);
                                }),
                          ],
                        ),
                      );

                      if (result != null) {
                        // Check game exists or not
                        final gameInfo =
                            await GameService.getGameInfo(gameCode);
                        if (gameInfo == null) {
                          Alerts.showNotification(titleText: "Game not found!");
                        } else {
                          Navigator.of(context)
                              .pushNamed(Routes.game_play, arguments: result);
                        }
                      }
                      _initTimer();
                    },
                    text: "JOIN",
                  ),
                ],
              ),
            ),

            TabBar(
              tabs: [
                Tab(
                  text: AppStringsNew.liveGamesText,
                  icon: Image.asset(
                    AppAssetsNew.liveGamesTabImagePath,
                    height: 24,
                    width: 24,
                    color: AppColorsNew.newGreenButtonColor,
                  ),
                ),
                Tab(
                  text: AppStringsNew.gameRecordText,
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
                  Stack(
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
                                        _disposeTimer();
                                        await Navigator.of(context).pushNamed(
                                          Routes.game_play,
                                          arguments: liveGames[index].gameCode,
                                        );
                                        // Refreshes livegames again
                                        _initTimer();
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
                                      AppDimensionsNew.getVerticalSizedBox(
                                          16.ph),
                                  itemCount: liveGames.length,
                                ),
                    ],
                  ),
                  _isPlayedGamesLoading ? Container() : getPlayedGames(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget getPlayedGames() {
    return playedGames.isEmpty
        ? Center(
            child: Text(
              AppStringsNew.noGameRecordsText,
              style: AppStylesNew.titleTextStyle,
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: gameHistoryItem,
            padding: EdgeInsets.only(
              bottom: 64.ph,
              top: 16.ph,
            ),
            separatorBuilder: (
              context,
              index,
            ) =>
                AppDimensionsNew.getVerticalSizedBox(16.ph),
            itemCount: playedGames.length,
          );
  }

  Widget gameHistoryItem(BuildContext context, int index) {
    final item = playedGames[index];
    return GestureDetector(
        onTap: () {
          GameHistoryDetailModel model =
              GameHistoryDetailModel(item.gameCode, true);
          Navigator.pushNamed(
            context,
            Routes.game_history_detail_view,
            arguments: {'model': model, 'clubCode': item.clubCode},
          );
        },
        child: GameHistoryItemNew(
          game: playedGames[index],
          showClubName: true,
        ));
  }
}
