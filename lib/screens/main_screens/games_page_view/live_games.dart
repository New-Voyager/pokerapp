import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
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
import 'package:pokerapp/services/test/mock_data.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
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

    if (appState != null) {
      appState.addListener(() async {
        final int currentIndex = appState.currentIndex;
        if (appState.newGame || appState.gameEnded) {
          if (currentIndex == 0) {
            if (_tabController.index == 0) {
              await _fetchLiveGames();
            } else if (_tabController.index == 1) {
              await _fetchPlayedGames();
            }
          }
          appState.setNewGame(false);
          appState.setGameEnded(false);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    if (TestService.isTesting) {
      return;
    }
    log('fetching live games');

    var appState = Provider.of<AppState>(context, listen: false);
    var updatedLiveGames;
    if (appState != null && appState.mockScreens) {
      updatedLiveGames = await MockData.getLiveGames();
    } else {
      updatedLiveGames = await GameService.getLiveGamesNew();
    }

    print("__________________");
    bool refresh = true;
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
        context: context, loadingText: _appScreenText['gettingGames']);
    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/sample-data/livegames.json");
    // log(data);

    final jsonResult = json.decode(data);
    log('${jsonResult}');
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
          _appScreenText['gameCode'],
          style: AppDecorators.getSubtitle2Style(theme: appTheme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              theme: appTheme,
              hintText: _appScreenText['enterGameCode'],
              onChanged: (val) {
                //log("VALUE : $val");
                gameCode = val;
              },
              keyboardType: TextInputType.name,
            ),
          ],
        ),
        actions: [
          RoundRectButton(
            text: _appScreenText['join'],
            onTap: () async {
              if (gameCode.isEmpty) {
                toast(_appScreenText['emptyGameCode']);
                return;
              }

              Navigator.of(context).pop(gameCode);
            },
            theme: appTheme,
          ),
        ],
      ),
    );

    if (result != null) {
      // Check game exists or not
      final gameInfo = await GameService.getGameInfo(gameCode);
      if (gameInfo == null) {
        Alerts.showNotification(titleText: _appScreenText['gameNotFound']);
      } else {
        Navigator.of(context).pushNamed(Routes.game_play, arguments: result);
      }
    }
  }

  void _handleGameRefresh(AppState appState) {
    if (!mounted) return;
    final int currentIndex = appState.currentIndex;
    if (currentIndex != 0) return;
    if (appState.newGame || appState.gameEnded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchLiveGames();
        appState.setNewGame(false);
        if (appState.gameEnded) {
          _fetchPlayedGames();
          appState.setGameEnded(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    _handleGameRefresh(appState);

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
                      RoundRectButton(
                        onTap: () async {
                          await hostGame();
                        },
                        text: _appScreenText["host"],
                        theme: appTheme,
                      ),
                      Expanded(
                          child: HeadingWidget(
                              heading: _appScreenText['appName'])),
                      RoundRectButton(
                        onTap: () async {
                          await joinGame(appTheme);
                        },
                        theme: appTheme,
                        text: _appScreenText['join'],
                      ),
                    ],
                  ),
                ),

                TabBar(
                  physics: const BouncingScrollPhysics(),
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
                            _appScreenText['liveGames'],
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
                            _appScreenText['gameRecord'],
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
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Stack(
                        children: [
                          _isLoading
                              ? Container()
                              : liveGames.isEmpty
                                  ? Center(
                                      child: Text(
                                        _appScreenText['noLiveGames'],
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
                                            await Navigator.of(context)
                                                .pushNamed(
                                              Routes.game_play,
                                              arguments:
                                                  liveGames[index].gameCode,
                                            );
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
              _appScreenText['noGames'],
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
