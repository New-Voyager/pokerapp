import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_objects.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view_vertical.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/network_change_listener.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:pokerapp/services/nats/client.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:pokerapp/widgets/drawer/game_play_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../main_helper.dart';
import '../../routes.dart';
import '../../services/test/test_service.dart';
import 'game_play_screen_util_methods.dart';
import 'main_views/board_view/board_view.dart';
import 'main_views/board_view/board_view_vertical_web.dart';

/*
7 inch tablet
[log] rebuilding game screen. Screen: Size(600.0, 912.0)
[log] Table width: 650.0 height: 294.8
[log] board width: 600.0 height: 364.8

10 inch tablet
[log] rebuilding game screen. Screen: Size(800.0, 1232.0)
Table width: 850.0 height: 422.8
board width: 800.0 height: 492.8

*/

/*
* This is the screen which will have contact with the NATS server
* Every sub view of this screen will update according to the data fetched from the NATS
* */
class GamePlayScreen extends StatefulWidget {
  final String gameCode;
  final CustomizationService customizationService;
  final bool showTop;
  final bool showBottom;
  final bool botGame;
  final GameInfoModel gameInfoModel;
  final bool isFromWaitListNotification;
  // NOTE: Enable this for agora audio testing
  GamePlayScreen({
    @required this.gameCode,
    Key key,
    this.customizationService,
    this.botGame = false,
    this.showTop = true,
    this.showBottom = true,
    this.gameInfoModel,
    this.isFromWaitListNotification = false,
  }) : super(key: key);

  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen>
    with
        AfterLayoutMixin<GamePlayScreen>,
        RouteAwareAnalytics,
        WidgetsBindingObserver {
  @override
  String get routeName => Routes.game_play;

  WidgetsBinding _binding = WidgetsBinding.instance;
  GamePlayObjects gamePlayObjects;

  // instantiate a drawer controller
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    appState.isInGameScreen = false;
    appState.removeGameCode();
    natsConnectionLostCallback = null;

    gamePlayObjects.gameState.refreshGameState.removeListener(refreshGame);

    _timer?.cancel();

    if (gamePlayObjects.gameState != null) {
      gamePlayObjects.gameState.uiClosing = true;
    }

    if (gamePlayObjects.nats != null) {
      gamePlayObjects.nats.disconnectListeners
          .remove(gamePlayObjects.onNatsDisconnect);
    }

    // cancel listening to game play screen network changes
    _streamSub?.cancel();

    if (!PlatformUtils.isWeb) {
      Wakelock.disable();
    }
    if (gamePlayObjects.locationUpdates != null) {
      gamePlayObjects.locationUpdates.stop();
      gamePlayObjects.locationUpdates = null;
    }
    gamePlayObjects.leaveAudioConference();

    if (_binding != null) {
      _binding.removeObserver(this);
    }

    close();
    super.dispose();
  }

  void _initSendCardAfterFold(BuildContext context) {
    final MarkedCards markedCards = context.read<MarkedCards>();

    void onMarkingCards() {
      // if new cards are marked, send them back
      if (gamePlayObjects.gameState.handState == HandState.RESULT) {
        gamePlayObjects.sendMarkedCards(context);
      }
    }

    gamePlayObjects.gameState.handChangeState.addListener(() {
      if (gamePlayObjects.gameState.handState == HandState.RESULT) {
        // send the marked cards for the first time
        gamePlayObjects.sendMarkedCards(context);

        // start listening for changes in markedCards value
        markedCards.addListener(onMarkingCards);
      }
    });

    gamePlayObjects.gameState.audioConfState.addListener(() async {
      if (gamePlayObjects.gameState.audioConfState.join) {
        gamePlayObjects.joinAudioConference().then((value) {
          if (mounted) {
            gamePlayObjects.gameState.audioConfState.joinedConf();
          }
        }).onError((error, stackTrace) {
          // do nothing
        });
      } else if (gamePlayObjects.gameState.audioConfState.leave) {
        gamePlayObjects.leaveAudioConference().then((value) {
          if (mounted) {
            gamePlayObjects.gameState.audioConfState.leftConf();
          }
        }).onError((error, stackTrace) {
          // do nothing
        });
      }
    });
  }

  void _initGameInfoModel() async {
    await gamePlayObjects.load();
    if (mounted) {
      setState(() {});
    }
  }

  StreamSubscription<ConnectivityResult> _streamSub;

  AppTextScreen _appScreenText;

  bool _showWaitListHandlingNotificationCalled = false;
  void _showWaitListHandlingNotification() {
    if (_showWaitListHandlingNotificationCalled) return;
    _showWaitListHandlingNotificationCalled = true;

    if (widget.isFromWaitListNotification == true) {
      // if we are from the wait list notification, show a banner
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Alerts.showNotification(
          titleText: "Tap on an open seat to join the game!",
          duration: Duration(seconds: 10),
        );
      });
    }
  }

  Timer _timer;

  @override
  void initState() {
    super.initState();
    appState.isInGameScreen = true;
    gamePlayObjects = GamePlayObjects();
    final appScreenText = getAppTextScreen("gameScreen");

    gamePlayObjects.initialize(
        context: context,
        botGame: widget.botGame,
        gameCode: widget.gameCode,
        customizationService: widget.customizationService,
        gameInfoModel: widget.gameInfoModel,
        appScreenText: appScreenText);

    // store in app state that we are in the game_play_screen
    appState.setCurrentScreenGameCode(widget.gameCode);

    if (!PlatformUtils.isWeb) {
      _streamSub =
          context.read<NetworkChangeListener>().onConnectivityChange.listen(
                (_) => gamePlayObjects.reconnectGameComService(),
              );
    }

    if (!PlatformUtils.isWeb) {
      Wakelock.enable();
    }

    // Register listener for lifecycle methods
    WidgetsBinding.instance.addObserver(this);
    _binding.addObserver(this);

    init().then((v) {
      _timer = Timer(const Duration(seconds: 1), () {
        if (!TestService.isTesting) {
          if (!mounted) return;
          gamePlayObjects.queryCurrentHandIfNeeded();
          final nats = context.read<Nats>();
          log('dartnats: adding to disconnectListeners');
          nats.disconnectListeners.add(gamePlayObjects.onNatsDisconnect);
        }
      });

      if (!PlatformUtils.isWeb) {
        if (appService.appSettings.showRefreshBanner) {
          appService.appSettings.showRefreshBanner = false;
        }
        if (appService.appSettings.showReportInfoDialog) {
          appService.appSettings.showReportInfoDialog = false;
        }

        if (gamePlayObjects.gameState.gameInfo.demoGame) {
          gamePlayObjects.showDemoGameHelp();
        }
      }

      // set callback to call when connection is lost
      natsConnectionLostCallback = onNatsLostConnectionCallback;

      setState(() {});
    });

    PlayerService.getPendingApprovals().then((v) {
      appState.buyinApprovals.setPendingList(v);
    }).onError((error, stackTrace) {
      // ignore it
    });
  }

  void onNatsLostConnectionCallback(bool reconnect) {
    // Alerts.showNotification(
    //   titleText: "Connection Lost",
    //   subTitleText: "Reconnecting to the servers",
    //   duration: Duration(seconds: 3),
    // );
    gamePlayObjects.reconnectGameComService(
        reconnectNats: true, forceQueryCurrentHand: true);
  }

  void refreshGame() {
    // Alerts.showNotification(
    //   titleText: "Refresh",
    //   subTitleText: "Reload game",
    //   duration: Duration(seconds: 3),
    // );
    gamePlayObjects.reconnectGameComService(
        reconnectNats: true, forceQueryCurrentHand: true);
  }

  void reload() {
    close();
    init();
  }

  Future<void> init() async {
    log('game screen initState');
    try {
      await _initGameInfoModel();
      gamePlayObjects.gameState.refreshGameState.addListener(refreshGame);
    } catch (e) {
      Alerts.showNotification(
        titleText: "Game not found",
        subTitleText:
            "Gamecode: '${widget.gameCode}' not found in our servers!",
        duration: Duration(seconds: 3),
      );
      log(e.toString());
      if (mounted) Navigator.pop(context);
    }
  }

  void close() {
    // _timer?.cancel();

    try {
      natsConnectionLostCallback = null;
      if (gamePlayObjects.locationUpdates != null) {
        gamePlayObjects.locationUpdates.stop();
      }
      gamePlayObjects.gameContextObj?.dispose();
      gamePlayObjects.gameState?.close();
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }
  }

  Widget _buildBoardView(Size boardDimensions) {
// =======
//       height: boardDimensions.height,
//       child: BoardView(
//         gameComService: gamePlayObjects.gameContextObj?.gameComService,
//         gameInfo: gamePlayObjects.gameInfoModel,
//         onUserTap: gamePlayObjects.onJoinGame,
//         onStartGame: gamePlayObjects.startGame,
// >>>>>>> master

    final boardAttributes = gamePlayObjects.boardAttributes;
    final gameInfo = gamePlayObjects.gameInfoModel;
    final gameContextObj = gamePlayObjects.gameContextObj;
    final onJoinGame = gamePlayObjects.onJoinGame;
    final startGame = gamePlayObjects.startGame;

    double footerHeight =
        MediaQuery.of(context).size.height * boardAttributes.footerViewScale;

    footerHeight += boardAttributes.bottomHeightAdjust;
    double boardHeight = boardDimensions.height;

    double boardWidth = boardDimensions.width;
    Widget boardView = BoardView(
      gameComService: gameContextObj?.gameComService,
      gameInfo: gameInfo,
      onUserTap: onJoinGame,
      onStartGame: startGame,
    );
    EdgeInsets padding = null;
    if (PlatformUtils.isWeb) {
      if (boardAttributes.isOrientationHorizontal) {
      } else {
        boardView = BoardViewVerticalWeb(
          gameComService: gameContextObj?.gameComService,
          gameInfo: gameInfo,
          onUserTap: onJoinGame,
          onStartGame: startGame,
        );
      }
    } else {
      if (boardAttributes.isOrientationHorizontal) {
      } else {
        boardView = BoardViewVertical(
          gameComService: gameContextObj?.gameComService,
          gameInfo: gameInfo,
          onUserTap: onJoinGame,
          onStartGame: startGame,
        );
        // boardHeight = null;
        // padding = EdgeInsets.only(bottom: footerHeight / 3);
      }
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: boardWidth,
        height: boardHeight,
        padding: padding,
        child: DebugBorderWidget(
          color: Color.fromARGB(255, 95, 108, 223),
          child: boardView,
        ),
      ),
    );
  }

  Widget _buildHeaderView(AppTheme theme) {
    if (gamePlayObjects.gameState.customizationMode) {
      return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
            borderRadius: BorderRadius.circular(32.pw),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: AppDecorators.bgRadialGradient(theme),
              child: SvgPicture.asset(
                'assets/images/backarrow.svg',
                color: AppColorsNew.newGreenButtonColor,
                width: 32.pw,
                height: 32.ph,
                fit: BoxFit.cover,
              ),
            )),
      );
    } else {
      return SizedBox(
        width: Screen.width,
        child: IntrinsicHeight(
          child: HeaderView(
            gameState: gamePlayObjects.gameState,
            scaffoldKey: _scaffoldKey,
          ),
        ),
      );
    }
  }

  Widget _buildMainBoardView(AppTheme theme) {
    final boardDimensions = gamePlayObjects.boardAttributes.dimensions(context);

    return DebugBorderWidget(
      color: Colors.purple,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          this.widget.showTop && gamePlayObjects.gameState.customizationMode
              ? Positioned(
                  top: 10,
                  right: 50,
                  child: CircleImageButton(
                    onTap: () async {
                      await Navigator.of(context)
                          .pushNamed(Routes.select_table);
                      await gamePlayObjects.gameState.assets.initialize();
                      final redrawTop =
                          gamePlayObjects.gameState.redrawBoardSectionState;
                      redrawTop.notify();
                      setState(() {});
                    },
                    theme: theme,
                    icon: Icons.edit,
                  ),
                )
              : const SizedBox.shrink(),

          // board view
          _buildBoardView(boardDimensions),
        ],
      ),
    );
  }

  Widget _buildFooterView() {
    return Consumer<RedrawFooterSectionState>(
      builder: (_, ___, __) {
        log('RedrawFooter: building footer view');
        return FooterViewWidget(
          gameCode: widget.gameCode,
          gameContextObject: gamePlayObjects.gameContextObj,
          currentPlayer: gamePlayObjects.gameState.currentPlayer,
          gameInfo: gamePlayObjects.gameInfoModel,
          toggleChatVisibility: gamePlayObjects.showGameChat,
          onStartGame: gamePlayObjects.startGame,
        );
      },
    );
  }

  Widget _buildCoreBody(
    BuildContext context,
    BoardAttributesObject boardAttributes,
  ) {
    final theme = AppTheme.getTheme(context);
    const kEmpty = const SizedBox.shrink();

    var dimensions = boardAttributes.dimensions(context);

    return (boardAttributes.isOrientationHorizontal)
        ? Column(
            children: [
              // header
              widget.showTop ? _buildHeaderView(theme) : kEmpty,
              // board view
              widget.showTop ? _buildMainBoardView(theme) : kEmpty,
              // footer view
              widget.showBottom ? _buildFooterView() : kEmpty,
            ],
          )
        : Column(
            children: [
              // header
              widget.showTop ? _buildHeaderView(theme) : kEmpty,
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.maxFinite,
                      // height: dimensions.height,
                      child: BackgroundView(),
                    ),
                    Column(
                      children: [
                        // board view
                        widget.showTop
                            ? Expanded(child: _buildMainBoardView(theme))
                            : kEmpty,
                        // footer view
                        widget.showBottom
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: _buildFooterView())
                            : kEmpty,
                      ],
                    )
                  ],
                ),
              )
            ],
          );
  }

  Widget _buildBody(AppTheme theme) {
    log('======== 1 _buildBody ========');
    // show a progress indicator if the game info object is null
    if (gamePlayObjects.gameInfoModel == null ||
        gamePlayObjects.gameState == null) {
      return Center(child: CircularProgressWidget());
    }
    log('======== 2 _buildBody ========');

    /* get the screen sizes, and initialize the board attributes */
    final providers = GamePlayScreenUtilMethods.getProviders(
      context: context,
      gameInfoModel: gamePlayObjects.gameInfoModel,
      gameCode: widget.gameCode,
      gameState: gamePlayObjects.gameState,
      boardAttributes: gamePlayObjects.boardAttributes,
      gameContextObject: gamePlayObjects.gameContextObj,
      hostSeatChangePlayers: gamePlayObjects.hostSeatChangeSeats,
      seatChangeInProgress: gamePlayObjects.hostSeatChangeInProgress,
    );
    var body = MultiProvider(
      providers: providers,
      builder: (BuildContext context, _) {
        _showWaitListHandlingNotification();
        gamePlayObjects.providerContext = context;

        /* this function listens for marked cards in the result and sends as necessary */
        _initSendCardAfterFold(gamePlayObjects.providerContext);

        if (gamePlayObjects.gameContextObj != null) {
          if (!TestService.isTesting && widget.customizationService == null) {
            gamePlayObjects.gameContextObj.setup(context);
          }
        }

        /* set proper context for test service */
        TestService.context = context;

        // _setupAudioBufferService();

        /* This listenable provider takes care of showing or hiding the chat widget */
        return ListenableProvider<ValueNotifier<bool>>(
            // default value false means, we keep the chat window hidden initially
            create: (_) => ValueNotifier<bool>(false),
            builder: (context, _) {
              return ListenableProvider<BoardAttributesObject>(
                  create: (_) => gamePlayObjects.gameState.boardAttributes,
                  builder: (context, _) {
                    Profile.startBoardBuildTime();

                    var body = _buildCoreBody(
                        context, gamePlayObjects.boardAttributes);
                    Profile.stopBoardBuildTime();
                    Profile.stopGameLoading();
                    return body;
                  });
            });
      },
    );

    return body;
  }

  @override
  Widget build(BuildContext context) {
    log('======== build game play screen ========');
    if (TestService.isTesting) {
      try {
        gamePlayObjects.currentPlayer = TestService.currentPlayer;
      } catch (e) {}
    }
    if (widget.customizationService != null) {
      gamePlayObjects.currentPlayer = widget.customizationService.currentPlayer;
    }

    if (PlatformUtils.isWeb) {
      Screen.init(context);
      gamePlayObjects.initialzeBoardAttributes();
    }

    final body = Consumer<AppTheme>(
      builder: (_, theme, __) {
        log('======== 2 build game play screen ========');

        Widget mainBody = Scaffold(
          endDrawer: Consumer<PendingApprovalsState>(builder: (_, __, ___) {
            log('PendingApprovalsState updated');
            return Drawer(
              child: GamePlayScreenDrawer(gameState: gamePlayObjects.gameState),
            );
          }),
          key: _scaffoldKey,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: GamePlayScreenUtilMethods.floatingActionButton(
              onReload: () {},
              isCustomizationMode: widget.customizationService != null,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: _buildBody(theme),
        );
        if (!PlatformUtils.isIOS) {
          mainBody = SafeArea(child: mainBody);
        }
        if (gamePlayObjects.boardAttributes.useSafeArea) {
          return SafeArea(child: mainBody);
        }

        return WillPopScope(
          child: Container(
            decoration: AppDecorators.bgRadialGradient(theme),
            child: mainBody,
          ),
          onWillPop: () async {
            // don't go back if the user swipes
            return false;
          },
        );
      },
    );

    // return SafeArea(
    //   bottom: false,
    //   child:

    return body;
    //);
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  // Lifeccyle Methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("AppLifeCycleState : $state");
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        log("AppLifecycleState:: Leaving AudioConference from Lifecycle");
        gamePlayObjects.leaveAudioConference();
        AudioService.stop();
        if (gamePlayObjects.locationUpdates != null) {
          gamePlayObjects.locationUpdates.stop();
        }
        break;
      case AppLifecycleState.resumed:
        if (gamePlayObjects.gameState != null &&
            !gamePlayObjects.gameState.uiClosing) {
          gamePlayObjects.gameState.communityCardState.refresh();
          AudioService.resume();
          log("AppLifecycleState:: Joining AudioConference from Lifecycle");
          gamePlayObjects.joinAudioConference();
          if (gamePlayObjects.locationUpdates != null) {
            gamePlayObjects.locationUpdates.start();
          }
        }
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
