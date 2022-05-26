import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/game_play_objects.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/network_change_listener.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/drawer/game_play_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../main_helper.dart';
import '../../routes.dart';
import '../../services/test/test_service.dart';
import 'game_play_screen_util_methods.dart';

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
    this.customizationService,
    this.botGame = false,
    this.showTop = true,
    this.showBottom = true,
    this.gameInfoModel,
    this.isFromWaitListNotification = false,
  }) : assert(gameCode != null);

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
  bool _initiated = false;
  BuildContext _providerContext;
  OverlaySupportEntry demoHelpText = null;
  GamePlayObjects gamePlayObjects = GamePlayObjects();

  // instantiate a drawer controller
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    appState.isInGameScreen = false;
    appState.removeGameCode();
    // cancel listening to game play screen network changes
    gamePlayObjects.dispose();
    _streamSub?.cancel();
    Wakelock.disable();

    if (_binding != null) {
      _binding.removeObserver(this);
    }

    super.dispose();
  }

  // void _initGameInfoModel() async {
  //   final GameInfoModel gameInfoModel = await _init();
  //   if (mounted) {
  //     setState(() => _gameInfoModel = gameInfoModel);
  //   }
  // }

  StreamSubscription<ConnectivityResult> _streamSub;

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

  @override
  void initState() {
    super.initState();
    appState.isInGameScreen = true;

    // store in app state that we are in the game_play_screen
    appState.setCurrentScreenGameCode(widget.gameCode);

    _streamSub =
        context.read<NetworkChangeListener>().onConnectivityChange.listen(
              (_) => _reconnectGameComService(),
            );

    Wakelock.enable();

    // Register listener for lifecycle methods
    WidgetsBinding.instance.addObserver(this);
    _binding.addObserver(this);

    if (!PlatformUtils.isWeb) {
      PlayerService.getPendingApprovals().then((v) {
        appState.buyinApprovals.setPendingList(v);
      }).onError((error, stackTrace) {
        // ignore it
      });
    }

    AppTextScreen appScreenText = getAppTextScreen("gameScreen");
    gamePlayObjects.initialize(context, appScreenText, widget.gameCode);
    // gamePlayObjects.init().then((value) {
    //   _initiated = true;
    // });
  }

  void reload() {
    gamePlayObjects.close();
    gamePlayObjects.init();
  }

  Widget _buildBoardView(Size boardDimensions) {
    return Container(
      width: boardDimensions.width,
      height: boardDimensions.height,
      child: BoardView(
        gameComService: gamePlayObjects.gameContextObj?.gameComService,
        gameInfo: gamePlayObjects.gameInfoModel,
        onUserTap: gamePlayObjects.onJoinGame,
        onStartGame: startGame,
      ),
    );
  }

  void _queryCurrentHandIfNeeded() {
    /* THIS METHOD QUERIES THE CURRENT HAND AND POPULATE THE
       GAME SCREEN, IF AND ONLY IF THE GAME IS ALREADY PLAYING */

    if (TestService.isTesting == true || widget.customizationService != null)
      return;

    if (gamePlayObjects.gameInfoModel?.tableStatus ==
        AppConstants.GAME_RUNNING) {
      // query current hand to get game update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        log('network_reconnect: queryCurrentHand invoked');

        // if nats connection is broken, reconnect
        gamePlayObjects.gameContextObj.handActionProtoService
            .queryCurrentHand();
      });
    }
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

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        this.widget.showTop && gamePlayObjects.gameState.customizationMode
            ? Positioned(
                top: 10,
                right: 50,
                child: CircleImageButton(
                  onTap: () async {
                    await Navigator.of(context).pushNamed(Routes.select_table);
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
    );
  }

  Widget _buildFooterView() {
    return Consumer<RedrawFooterSectionState>(
      builder: (_, ___, __) {
        log('RedrawFooter: building footer view');
        return FooterViewWidget(
          gameCode: widget.gameCode,
          gameContextObject: gamePlayObjects.gameContextObj,
          currentPlayer: gamePlayObjects.gameContextObj.gameState.currentPlayer,
          gameInfo: gamePlayObjects.gameInfoModel,
          toggleChatVisibility: gamePlayObjects.showGameChat,
          onStartGame: startGame,
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

    if (PlatformUtils.isWeb) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: Screen.width,
            height: Screen.height,
            child: BoardView(
              gameComService: gamePlayObjects.gameContextObj?.gameComService,
              gameInfo: gamePlayObjects.gameInfoModel,
              onUserTap: gamePlayObjects.onJoinGame,
              onStartGame: startGame,
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          // header
          widget.showTop ? _buildHeaderView(theme) : kEmpty,
          // board view
          widget.showTop ? _buildMainBoardView(theme) : kEmpty,
          // footer view
          widget.showBottom ? _buildFooterView() : kEmpty,
        ],
      );
    }
  }

  Widget _buildBody(AppTheme theme) {
    // show a progress indicator if the game info object is null
    if (gamePlayObjects.gameInfoModel == null)
      return Center(child: CircularProgressWidget());

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

    return MultiProvider(
      providers: providers,
      builder: (BuildContext context, _) {
        _showWaitListHandlingNotification();
        this._providerContext = context;

        /* this function listens for marked cards in the result and sends as necessary */
        gamePlayObjects.initSendCardAfterFold(_providerContext);

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
          builder: (context, _) =>
              _buildCoreBody(context, gamePlayObjects.boardAttributes),
        );
      },
    );
  }

  void _reconnectGameComService() async {
    log('network_reconnect: _reconnectGameComService invoked');
    final nats = context.read<Nats>();
    if (nats.connectionBroken) {
      await nats.reconnect();
    }

    // drop connections -> re establish connections
    await gamePlayObjects.gameComService.reconnect(nats);

    // query current hand
    _queryCurrentHandIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isWeb) {
      Screen.init(context);
    }

    if (TestService.isTesting) {
      try {
        gamePlayObjects.currentPlayer = TestService.currentPlayer;
      } catch (e) {}
    }

    if (!_initiated) {
      return CircularProgressWidget();
    }

    if (widget.customizationService != null) {
      gamePlayObjects.currentPlayer = widget.customizationService.currentPlayer;
    }
    final body = Consumer<AppTheme>(
      builder: (_, theme, __) {
        Widget mainBody = Scaffold(
          endDrawer: Consumer<PendingApprovalsState>(builder: (_, __, ___) {
            log('PendingApprovalsState updated');
            return Drawer(
              child: GamePlayScreenDrawer(gameState: gamePlayObjects.gameState),
            );
          }),
          key: _scaffoldKey,
          floatingActionButton: GamePlayScreenUtilMethods.floatingActionButton(
            onReload: () {},
            isCustomizationMode: widget.customizationService != null,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: _buildBody(theme),
        );
        if (!PlatformUtils.isWeb) {
          if (!PlatformUtils.isIOS) {
            mainBody = SafeArea(child: mainBody);
          }
          if (gamePlayObjects.boardAttributes.useSafeArea) {
            return SafeArea(child: mainBody);
          }
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
  void afterFirstLayout(BuildContext context) {
    gamePlayObjects.boardAttributes = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
    );

    gamePlayObjects.init().then((v) {
      gamePlayObjects.timer = Timer(const Duration(seconds: 1), () {
        if (!TestService.isTesting) {
          if (!mounted) return;
          _queryCurrentHandIfNeeded();
          final nats = context.read<Nats>();
          log('dartnats: adding to disconnectListeners');
          nats.disconnectListeners.add(gamePlayObjects.onNatsDisconnect);
        }
      });

      if (gamePlayObjects.gameState.gameInfo.demoGame) {
        Future.delayed(Duration(seconds: 1), () {
          demoHelpText = Alerts.showNotification(
            titleText: "Tap on Open Seat to Join the Game!",
            duration: Duration(seconds: 5),
          );
        });
      }
    }).onError((error, stackTrace) {
      log('error: $error');
      log('stackTrace: $stackTrace');
    });
  }

  startGame() async {
    try {
      ConnectionDialog.show(context: context, loadingText: "Starting...");
      await GamePlayScreenUtilMethods.startGame(widget.gameCode);
      await gamePlayObjects.gameState.refresh();
      ConnectionDialog.dismiss(context: context);
    } catch (err) {
      ConnectionDialog.dismiss(context: context);
      showErrorDialog(context, 'Error',
          'Failed to start the game. Error: ${err.toString()}');
    }
    // final tableState = _gameState.tableState;
    // tableState.updateGameStatusSilent(AppConstants.GAME_RUNNING);
    // _gameState.myState.notify();
  }

  // Lifeccyle Methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("AppLifeCycleState : $state");
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        log("Leaving AudioConference from Lifecycle");
        gamePlayObjects.leaveAudioConference();
        AudioService.stop();
        if (gamePlayObjects.locationUpdates != null) {
          gamePlayObjects.locationUpdates.stop();
        }
        break;
      case AppLifecycleState.resumed:
        if (gamePlayObjects.gameState != null &&
            !gamePlayObjects.gameState.uiClosing) {
          AudioService.resume();
          log("Joining AudioConference from Lifecycle");
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
