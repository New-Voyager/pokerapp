import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/insta_refresh_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
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
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _appScreenText = getAppTextScreen("liveGame");

    _tabController.addListener(() {
      log("Listeners//..");
      setState(() {});
    });

    // context.read<AppState>().addListener(() async {
    //   int currentIndex = context.read<AppState>().currentIndex;
    //   if (currentIndex == 0) {
    //     log('live games screen refreshing');
    //     _fetchLiveGames();
    //     _fetchPlayedGames();
    //   }
    // });

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
        _disposeTimer();
        break;
      case AppLifecycleState.detached:
        _disposeTimer();
        break;
      case AppLifecycleState.inactive:
        _disposeTimer();
        break;
      case AppLifecycleState.resumed:
        _initTimer();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  _initTimer() async {
    if (TestService.isTesting) {
      // don't fetch live games in test mode
      return;
    }
    if (_refreshTimer == null || !_refreshTimer.isActive) {
      _refreshTimer =
          Timer.periodic(const Duration(seconds: 30), (timer) async {
        if (mounted) {
          final int currentIndex =
              Provider.of<AppState>(context, listen: false).currentIndex;
          if (currentIndex == 0) {
            if (_tabController.index == 0) {
              await _fetchLiveGames();
            } else if (_tabController.index == 1) {
              await _fetchPlayedGames();
            }
          }
        }
      });
    }
  }

  _disposeTimer() {
    if (TestService.isTesting) {
      return;
    }
    if (_refreshTimer != null || _refreshTimer.isActive) {
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
    log('fetching live games');
    final updatedLiveGames = await GameService.getLiveGamesNew();
    bool refresh = true;
    // if (updatedLiveGames.length == liveGames.length) {
    //   final prevList = liveGames.map((e) => e.gameCode).toSet();
    //   for (final liveGame in updatedLiveGames) {
    //     if (!prevList.contains(liveGame.gameCode)) {
    //       refresh = true;
    //       break;
    //     }
    //   }
    // } else {
    //   refresh = true;
    // }
    if (refresh) {
      liveGames = updatedLiveGames;
      // liveGames.addAll(updatedLiveGames);
      setState(() => _isLoading = false);
    }
  }

  _fetchPlayedGames() async {
    log('fetching played games');
    final updatedPlayedGames = await GameService.getPastGames();
    bool refresh = true;
    // if (updatedPlayedGames.length == playedGames.length) {
    //   final prevList = playedGames.map((e) => e.gameCode).toSet();
    //   for (final pastGame in updatedPlayedGames) {
    //     if (!prevList.contains(pastGame.gameCode)) {
    //       refresh = true;
    //       break;
    //     }
    //   }
    // } else {
    //   refresh = true;
    // }
    if (refresh) {
      // playedGames.clear();
      playedGames = updatedPlayedGames;
      setState(() => _isPlayedGamesLoading = false);
    }
  }

  _loadTestLiveGames() async {
    ConnectionDialog.show(
        context: context, loadingText: _appScreenText['GETTINGGAMES']);
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

  Future<void> hostGame() async {
    // if the player does not have enough coins
    // don't host the game
    if (AppConfig.availableCoins < 10) {
      showErrorDialog(context, 'Error', 'Not enough coins to host a game');
      return;
    }

    final dynamic result =
        await Navigator.of(context).pushNamed(Routes.new_game_settings);
    if (result != null) {
      /* show game settings dialog */
      await NewGameSettings2.show(
        context,
        clubCode: "",
        mainGameType: result['gameType'],
        subGameTypes: List.from(
              result['gameTypes'],
            ) ??
            [],
      );
    }
  }

  Future<void> joinGame(AppTheme appTheme) async {
    String gameCode = "";
    final String result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: appTheme.fillInColor,
        title: Text(
          _appScreenText['GAMECODE'],
          style: AppDecorators.getSubtitle2Style(theme: appTheme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              theme: appTheme,
              hintText: _appScreenText['ENTERGAMECODE'],
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
            text: _appScreenText['JOIN'],
            backgroundColor: appTheme.accentColor,
            textColor: appTheme.primaryColorWithDark(),
            onTapFunction: () async {
              if (gameCode.isEmpty) {
                toast(_appScreenText['GAMECODECANTBEEMPTY']);
                return;
              }

              Navigator.of(context).pop(gameCode);
            },
          ),
        ],
      ),
    );

    if (result != null) {
      // Check game exists or not
      final gameInfo = await GameService.getGameInfo(gameCode);
      if (gameInfo == null) {
        Alerts.showNotification(titleText: _appScreenText['GAMENOTFOUND']);
      } else {
        Navigator.of(context).pushNamed(Routes.game_play, arguments: result);
      }
    }
  }

  void _handleGameRefresh(InstaRefreshService irs) {
    if (!mounted) return;
    // final InstaRefreshService irs = context.read<InstaRefreshService>();
    log('pauldebug: _handleGameRefresh is being called: ${irs.needToRefreshLiveGames}');

    // for live games
    if (irs.needToRefreshLiveGames) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchLiveGames();
        irs.refreshLiveGamesDone();
      });
    }

    // for played games
    if (irs.needToRefreshGameRecord) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPlayedGames();
        irs.refreshGameRecordDone();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final irs = Provider.of<InstaRefreshService>(context);
    _handleGameRefresh(irs);

    return Consumer<AppTheme>(
      builder: (_, appTheme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(appTheme),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(children: [
                // AppBar
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedColorButton(
                        onTapFunction: () async {
                          _disposeTimer();
                          await hostGame();
                          _initTimer();
                        },
                        text: _appScreenText["HOST"],
                        backgroundColor: appTheme.accentColor,
                        textColor: appTheme.primaryColorWithDark(),
                      ),
                      Expanded(
                          child: HeadingWidget(
                              heading: _appScreenText['POKERCLUBAPP'])),
                      RoundedColorButton(
                        onTapFunction: () async {
                          _disposeTimer();
                          await joinGame(appTheme);
                          _initTimer();
                        },
                        backgroundColor: appTheme.accentColor,
                        textColor: appTheme.primaryColorWithDark(),
                        text: _appScreenText['JOIN'],
                      ),
                    ],
                  ),
                ),

                TabBar(
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssetsNew.liveGamesTabImagePath,
                            height: 16.ph,
                            width: 16.pw,
                            color: _tabController.index == 0
                                ? appTheme.secondaryColor
                                : appTheme.secondaryColorWithDark(),
                          ),
                          AppDimensionsNew.getHorizontalSpace(8),
                          Text(
                            _appScreenText['LIVEGAMES'],
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssetsNew.playedGamesTabImagePath,
                            height: 16.ph,
                            width: 16.pw,
                            color: _tabController.index == 1
                                ? appTheme.secondaryColor
                                : appTheme.secondaryColorWithDark(),
                          ),
                          AppDimensionsNew.getHorizontalSpace(8),
                          Text(
                            _appScreenText['GAMERECORD'],
                          )
                        ],
                      ),
                    ),
                  ],
                  indicatorColor: appTheme.accentColor,
                  labelColor: appTheme.secondaryColor,
                  unselectedLabelColor: appTheme.secondaryColorWithDark(0.2),
                  indicatorSize: TabBarIndicatorSize.label,
                  //labelStyle: AppDecorators.getSubtitle2Style(theme: appTheme),
                  //unselectedLabelStyle: AppDecorators.getSubtitle1Style(theme: appTheme),
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
                                        _appScreenText['NOLIVEGAMES'],
                                        style: AppDecorators.getAccentTextStyle(
                                            theme: appTheme),
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
                                            await Navigator.of(context)
                                                .pushNamed(
                                              Routes.game_play,
                                              arguments:
                                                  liveGames[index].gameCode,
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
                                        16.ph,
                                      ),
                                      itemCount: liveGames?.length,
                                    ),
                        ],
                      ),
                      _isPlayedGamesLoading
                          ? Container()
                          : getPlayedGames(appTheme),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget getPlayedGames(AppTheme appTheme) {
    return playedGames.isEmpty
        ? Center(
            child: Text(
              _appScreenText['NOGAMES'],
              style: AppDecorators.getAccentTextStyle(theme: appTheme),
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
            itemCount: playedGames?.length,
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
      ),
    );
  }
}
