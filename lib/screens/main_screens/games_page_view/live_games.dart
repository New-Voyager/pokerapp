import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/app_state.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/help_text.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/new_game_settings2.dart';
import 'package:pokerapp/screens/game_screens/tournament/tournament_settings.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/widgets/live_games_item.dart';
import 'package:pokerapp/screens/profile_screens/bug_features_dialog.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:pokerapp/services/onboarding.dart';
import 'package:pokerapp/services/test/mock_data.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';
import 'package:provider/provider.dart';

import '../../../main_helper.dart';

class LiveGamesScreen extends StatefulWidget {
  @override
  _LiveGamesScreenState createState() => _LiveGamesScreenState();
}

class _LiveGamesScreenState extends State<LiveGamesScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  bool _isLoading = true;
  bool _isPlayedGamesLoading = true;
  List<GameModel> liveGames = [];
  List<GameHistoryModel> playedGames = [];
  bool closed = false;
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
        //final int currentIndex = appState.currentIndex;
        if (appState.newGame || appState.gameEnded) {
          await _fetchLiveGames();
          await _fetchPlayedGames();
          appState.setNewGame(false);
          appState.setGameEnded(false);
          // if (currentIndex == 0) {
          //   if (_tabController.index == 0) {
          //   } else if (_tabController.index == 1) {
          //   }
          // }
        }
      });
    }

    focusNodes = List<FocusNode>.generate(
      3,
      (int i) => FocusNode(),
      growable: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final OnboardingState onboarding = onboardingKey.currentState;
      if (onboarding != null) {
        onboarding.show();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    closed = true;
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

    var updatedLiveGames;
    if (appState != null && appState.mockScreens) {
      updatedLiveGames = await MockData.getLiveGames();
    } else {
      updatedLiveGames = await GameService.getLiveGamesNew();
      await playerState.open();
      // get friends games
      final gameCodes = playerState.getFriendsGameCodes();
      if (gameCodes.length > 0) {
        for (final gameCode in gameCodes) {
          final game = await GameService.getGameInfo(gameCode);
          if (game == null) {
            // game probaly ended
            playerState.removeFriendsGameCodes(gameCode);
            showErrorDialog(context, 'Not Found', 'Game is not found');
          } else {
            // add the game to the list
            GameModel gameModel = GameModel.fromGameInfo(game);
            updatedLiveGames.add(gameModel);
          }
        }
      }
    }

    bool refresh = true;
    if (refresh) {
      liveGames = updatedLiveGames;
      if (closed) {
        return;
      }
      // liveGames.addAll(updatedLiveGames);
      setState(() => _isLoading = false);
    }
  }

  _fetchPlayedGames() async {
    log('fetching played games');

    if (appState != null && appState.mockScreens) {
      playedGames = await MockData.getPlayedGames();
    } else {
      final updatedPlayedGames = await GameService.getPastGames();
      bool refresh = true;
      if (refresh) {
        // playedGames.clear();
        playedGames = updatedPlayedGames;
        if (closed) {
          return;
        }
      }
    }
    setState(() => _isPlayedGamesLoading = false);
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
      liveGames.add(GameModel.fromJson(item));
    }
    log("Size : ${liveGames.length}");
    if (closed) {
      return;
    }

    setState(() {
      _isLoading = false;
      _isPlayedGamesLoading = false;
    });
    ConnectionDialog.dismiss(context: context);
  }

  Future<void> hostGame() async {
    // if the player does not have enough coins
    // don't host the game
    // if (AppConfig.availableCoins < 10) {
    //   showErrorDialog(context, 'Error', 'Not enough coins to host a game');
    //   return;
    // }

    final dynamic result = await Navigator.of(context).pushNamed(
      Routes.new_game_settings,
    );
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
            text: 'Join',
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
        // Alerts.showNotification(titleText: _appScreenText['gameNotFound']);
      } else {
        if (gameInfo.clubCode == null || gameInfo.clubCode.isEmpty) {
          // we joined this game, save the game code
          playerState.addFriendsGameCodes(gameCode);
          // add the game to the list
          GameModel gameModel = GameModel.fromGameInfo(gameInfo);
          liveGames.add(gameModel);
        }
        Navigator.of(context).pushNamed(Routes.game_play, arguments: result);
      }
    }
  }

  Future<void> hostTournament() async {
    int tournamentId = await TournamentSettingsView.show(
      context,
    );
    Alerts.showNotification(titleText: 'Tournament: $tournamentId is created');
  }

  void _handleGameRefresh(AppState appState) {
    if (!mounted) return;
    final int currentIndex = appState.currentIndex;
    if (currentIndex != 0) return;
    if (appState.newGame || appState.gameEnded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchLiveGames();
        _fetchPlayedGames();
        appState.setNewGame(false);
        appState.setGameEnded(false);
        if (appState.gameEnded) {
          //_fetchPlayedGames();
          appState.setGameEnded(false);
        }
      });
    }
  }

  List<FocusNode> focusNodes;
  Map<int, OnboardingType> onboardOptions = {};

  List<OnboardingStep> getOnboardingSteps(AppTheme appTheme) {
    List<OnboardingStep> steps = [];

    bool onboardHostButton = OnboardingService.showHostButton;
    bool onboardJoinButton = OnboardingService.showJoinButton;

    if (onboardHostButton) {
      onboardOptions[steps.length] = OnboardingType.HOST_BUTTON;
      steps.add(OnboardingStep(
        focusNode: focusNodes[0],
        title: 'Host a game',
        bodyText: "Tap here to host a game",
        titleTextColor: Colors.white,
        labelBoxPadding: const EdgeInsets.all(16.0),
        labelBoxDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: appTheme.fillInColor,
          border: Border.all(
            color: appTheme.secondaryColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        arrowPosition: ArrowPosition.top,
        hasArrow: true,
        hasLabelBox: true,
        fullscreen: true,
      ));
    }

    if (onboardJoinButton) {
      onboardOptions[steps.length] = OnboardingType.JOIN_BUTTON;
      steps.add(
        OnboardingStep(
          focusNode: focusNodes[1],
          title: "Join a game",
          bodyText: "Tap here to join a friend's a game",
          titleTextColor: Colors.white,
          labelBoxPadding: const EdgeInsets.all(16.0),
          labelBoxDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: appTheme.fillInColor,
            border: Border.all(
              color: appTheme.secondaryColor,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
          arrowPosition: ArrowPosition.top,
          hasArrow: true,
          hasLabelBox: true,
          fullscreen: true,
        ),
      );
    }

    if (OnboardingService.showReportButton) {
      onboardOptions[steps.length] = OnboardingType.REPORT_BUTTON;
      steps.add(
        OnboardingStep(
          focusNode: focusNodes[2],
          title: "Report",
          bodyText: "Tap here to report bugs and features",
          titleTextColor: Colors.white,
          labelBoxPadding: const EdgeInsets.all(16.0),
          labelBoxDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: appTheme.fillInColor,
            border: Border.all(
              color: appTheme.secondaryColor,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
          arrowPosition: ArrowPosition.top,
          hasArrow: true,
          hasLabelBox: true,
          fullscreen: true,
        ),
      );
    }
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    _handleGameRefresh(appState);

    return Consumer<AppTheme>(
      builder: (_, appTheme, __) {
        //List<OnboardingStep> steps = getOnboardingSteps(appTheme);
        List<OnboardingStep> steps = [];
        Widget mainView = getMainView(appTheme);
        if (steps.length == 0) {
          return mainView;
        }

        return Onboarding(
            key: onboardingKey,
            autoSizeTexts: true,
            steps: steps,
            onChanged: (int index) {
              log('Onboarding: index: $index, type: ${onboardOptions[index]}');
              if (onboardOptions[index] == OnboardingType.HOST_BUTTON) {
                OnboardingService.showHostButton = false;
              } else if (onboardOptions[index] == OnboardingType.JOIN_BUTTON) {
                OnboardingService.showJoinButton = false;
              } else if (onboardOptions[index] ==
                  OnboardingType.REPORT_BUTTON) {
                OnboardingService.showReportButton = false;
              }
            },
            child: mainView);
      },
    );
  }

  Widget getMainView(AppTheme appTheme) {
    List<Widget> secondRowChildren = [];
    bool tournament = false;
    if (tournament) {
      secondRowChildren.addAll([
        Align(
            alignment: Alignment.centerLeft,
            child: RoundRectButton(
              onTap: () async {
                hostTournament();
              },
              text: 'Host Tournament', //_appScreenText["host"],
              theme: appTheme,
            )),
        Align(
            alignment: Alignment.center,
            child: RoundRectButton(
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  Routes.tournaments,
                );
              },
              text: 'Tournaments', //_appScreenText["host"],
              theme: appTheme,
            ))
      ]);
    }
    Widget secondRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...secondRowChildren,
        Align(
            alignment: Alignment.centerRight,
            child: RoundRectButton(
              onTap: () async {
                Alerts.showDailog(
                  context: context,
                  child: BugsFeaturesWidget(),
                );
              },
              text: 'Feedback', //_appScreenText["host"],
              theme: appTheme,
            )),
      ],
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // RoundRectButton(
                  //   onTap: () async {
                  //     startDemoGame();
                  //   },
                  //   text: 'Demo Game', //_appScreenText["host"],
                  //   theme: appTheme,
                  //   focusNode: focusNodes[0],
                  // ),
                  RoundRectButton(
                    onTap: () async {
                      await hostGame();
                    },
                    text: 'Host', //_appScreenText["host"],
                    theme: appTheme,
                    focusNode: focusNodes[0],
                  ),
                  Expanded(
                      child: Column(children: [
                    HeadingWidget(
                      heading: _appScreenText['appName'],
                    ),
                  ])),
                  // CircleImageButton(
                  //     focusNode: focusNodes[2],
                  //     height: 30,
                  //     width: 30,
                  //     imageWidth: 18,
                  //     theme: appTheme,
                  //     icon: Icons.info,
                  //     onTap: () {
                  //       Alerts.showDailog(
                  //         context: context,
                  //         child: BugsFeaturesWidget(),
                  //       );
                  //     }),
                  RoundRectButton(
                    onTap: () async {
                      await joinGame(appTheme);
                    },
                    theme: appTheme,
                    text: 'Join', //_appScreenText['join'],
                    focusNode: focusNodes[1],
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: RoundRectButton(
                  onTap: () async {
                    Alerts.showDailog(
                      context: context,
                      child: BugsFeaturesWidget(),
                    );
                  },
                  text: 'Feedback', //_appScreenText["host"],
                  theme: appTheme,
                )),
            // Align(
            //     alignment: Alignment.centerRight,
            //     child: CircleImageButton(
            //       onTap: () {},
            //       icon: Icons.email,
            //       theme: appTheme,
            //     )),

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
                              ? LiveGamesHelpText(appTheme)
                              : ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return LiveGameItem(
                                      game: liveGames[index],
                                      onTapFunction: () async {
                                        // get game info again to see whether the game is still active
                                        final gameInfo =
                                            await GameService.getGameInfo(
                                                liveGames[index].gameCode);
                                        await playerState.open();
                                        bool validGameCode = true;
                                        if (!TestService.isTesting) {
                                          if (gameInfo == null) {
                                            // game ended
                                            playerState.removeFriendsGameCodes(
                                                liveGames[index].gameCode);
                                            // refresh screen
                                            _fetchLiveGames();
                                            validGameCode = false;
                                          }
                                        }
                                        if (validGameCode) {
                                          await Navigator.of(context).pushNamed(
                                            Routes.game_play,
                                            arguments:
                                                liveGames[index].gameCode,
                                          );
                                        }
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

class LiveGamesHelpText extends StatelessWidget {
  final AppTheme appTheme;

  LiveGamesHelpText(this.appTheme);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(height: 50),
      Row(
        children: [
          SizedBox(width: 20.pw),
          Text('Tap Host button on top left '),
          // RoundRectButton(
          //   onTap: () async {},
          //   text: 'Host',
          //   theme: appTheme,
          // ),
          //SizedBox(width: 8.pw),
          Flexible(
            child: Text('to host a new game'),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        children: [
          SizedBox(width: 20.pw),
          Flexible(
              child: Text(
                  'Tap Join button on top right to join a game with game code')),
          // RoundRectButton(
          //   onTap: () async {},
          //   text: 'Join',
          //   theme: appTheme,
          // ),
          // SizedBox(width: 8.pw),
          // Flexible(
          //   child: Text('to join a game with game code'),
          // ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        children: [
          SizedBox(width: 20.pw),
          Flexible(
            child:
                Text('Tap on Clubs tab to see your clubs or create a new club'),
          ),
        ],
      ),
      SizedBox(height: 20),
      RoundRectButton(
        onTap: () async {
          startDemoGame(context);
        },
        text: 'Try It!', //_appScreenText["host"],
        theme: appTheme,
      ),
      SizedBox(height: 20),
    ]);

    // Center(
    //   child: Text(
    //     'No games',
    //     style: AppDecorators.getAccentTextStyle(theme: appTheme),
    //   ),
    // );
  }

  void startDemoGame(BuildContext context) async {
    final demoGame = NewGameModel.demoGame();
    String gameCode = await GameService.configurePlayerGame(demoGame);

    if (gameCode == null) return;

    // wait for all the bots taken the seats
    ConnectionDialog.show(context: context, loadingText: 'Starting demo game');
    try {
      while (true) {
        final gameInfo = await GameService.getGameInfo(gameCode);
        if (gameInfo.availableSeats.length == 1) {
          break;
        } else {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } catch (err) {}
    ConnectionDialog.dismiss(context: context);

    navigatorKey.currentState.pushNamed(
      Routes.game_play,
      arguments: gameCode,
    );
  }
}
