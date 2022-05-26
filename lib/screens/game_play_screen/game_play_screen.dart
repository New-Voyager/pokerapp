import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_chat.dart';
import 'package:pokerapp/screens/game_play_screen/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/liveness_sender.dart';
import 'package:pokerapp/services/connectivity_check/network_change_listener.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/util_action_services.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/services/gql_errors.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
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
import 'location_updates.dart';

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

  bool _initiated;
  BuildContext _providerContext;
  PlayerInfo _currentPlayer;

  // String _audioToken = '';
  // bool liveAudio = true;
  //AudioPlayer _voiceTextPlayer;

  //Agora agora;
  GameComService _gameComService;
  GameInfoModel _gameInfoModel;
  GameContextObject _gameContextObj;
  GameState _gameState;
  List<PlayerInSeat> _hostSeatChangeSeats;
  bool _hostSeatChangeInProgress;
  WidgetsBinding _binding = WidgetsBinding.instance;
  LocationUpdates _locationUpdates;
  Nats _nats;
  NetworkConnectionDialog _dialog;
  BoardAttributesObject boardAttributes;
  OverlaySupportEntry demoHelpText = null;

  // instantiate a drawer controller
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    appState.isInGameScreen = false;
    appState.removeGameCode();

    _timer?.cancel();

    if (_gameState != null) {
      _gameState.uiClosing = true;
    }

    if (_nats != null) {
      _nats.disconnectListeners.remove(this.onNatsDisconnect);
    }

    // cancel listening to game play screen network changes
    _streamSub?.cancel();

    Wakelock.disable();
    if (_locationUpdates != null) {
      _locationUpdates.stop();
      _locationUpdates = null;
    }
    leaveAudioConference();

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
      if (_gameState.handState == HandState.RESULT) {
        _sendMarkedCards(context);
      }
    }

    _gameState.handChangeState.addListener(() {
      if (_gameState.handState == HandState.RESULT) {
        // send the marked cards for the first time
        _sendMarkedCards(context);

        // start listening for changes in markedCards value
        markedCards.addListener(onMarkingCards);
      }
    });

    _gameState.audioConfState.addListener(() async {
      if (_gameState.audioConfState.join) {
        joinAudioConference().then((value) {
          if (mounted) {
            _gameState.audioConfState.joinedConf();
          }
        }).onError((error, stackTrace) {
          // do nothing
        });
      } else if (_gameState.audioConfState.leave) {
        leaveAudioConference().then((value) {
          if (mounted) {
            _gameState.audioConfState.leftConf();
          }
        }).onError((error, stackTrace) {
          // do nothing
        });
      }
    });
  }

  void _initGameInfoModel() async {
    final GameInfoModel gameInfoModel = await _init();
    if (mounted) {
      setState(() => _gameInfoModel = gameInfoModel);
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

    boardAttributes = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
    );

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

    init().then((v) {
      _timer = Timer(const Duration(seconds: 1), () {
        if (!TestService.isTesting) {
          if (!mounted) return;
          _queryCurrentHandIfNeeded();
          final nats = context.read<Nats>();
          log('dartnats: adding to disconnectListeners');
          nats.disconnectListeners.add(this.onNatsDisconnect);
        }
      });

      if (appService.appSettings.showRefreshBanner) {
        appService.appSettings.showRefreshBanner = false;
      }
      if (appService.appSettings.showReportInfoDialog) {
        appService.appSettings.showReportInfoDialog = false;
      }

      if (_gameState.gameInfo.demoGame) {
        Future.delayed(Duration(seconds: 1), () {
          demoHelpText = Alerts.showNotification(
            titleText: "Tap on Open Seat to Join the Game!",
            duration: Duration(seconds: 5),
          );
        });
      }
    });

    PlayerService.getPendingApprovals().then((v) {
      appState.buyinApprovals.setPendingList(v);
    }).onError((error, stackTrace) {
      // ignore it
    });

    _appScreenText = getAppTextScreen("gameScreen");
  }

  void reload() {
    close();
    init();
  }

  Future<void> init() async {
    log('game screen initState');
    try {
      await _initGameInfoModel();
    } catch (e) {
      log(e.toString());
      if (mounted) Navigator.pop(context);
    }
  }

  void close() {
    // _timer?.cancel();

    try {
      if (_locationUpdates != null) {
        _locationUpdates.stop();
      }
      _gameContextObj?.dispose();
      _gameState?.close();
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }
  }

  Widget _buildBoardView(Size boardDimensions) {
    return Container(
      width: boardDimensions.width,
      height: boardDimensions.height,
      child: BoardView(
        gameComService: _gameContextObj?.gameComService,
        gameInfo: _gameInfoModel,
        onUserTap: _onJoinGame,
        onStartGame: startGame,
      ),
    );
  }

  Widget _buildHeaderView(AppTheme theme) {
    if (_gameState.customizationMode) {
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
            gameState: _gameState,
            scaffoldKey: _scaffoldKey,
          ),
        ),
      );
    }
  }

  Widget _buildMainBoardView(AppTheme theme) {
    final boardDimensions = boardAttributes.dimensions(context);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        this.widget.showTop && _gameState.customizationMode
            ? Positioned(
                top: 10,
                right: 50,
                child: CircleImageButton(
                  onTap: () async {
                    await Navigator.of(context).pushNamed(Routes.select_table);
                    await _gameState.assets.initialize();
                    final redrawTop = _gameState.redrawBoardSectionState;
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
          gameContextObject: _gameContextObj,
          currentPlayer: _gameContextObj.gameState.currentPlayer,
          gameInfo: _gameInfoModel,
          toggleChatVisibility: _showGameChat,
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

  Widget _buildBody(AppTheme theme) {
    // show a progress indicator if the game info object is null
    if (_gameInfoModel == null) return Center(child: CircularProgressWidget());

    /* get the screen sizes, and initialize the board attributes */
    final providers = GamePlayScreenUtilMethods.getProviders(
      context: context,
      gameInfoModel: _gameInfoModel,
      gameCode: widget.gameCode,
      gameState: _gameState,
      boardAttributes: boardAttributes,
      gameContextObject: _gameContextObj,
      hostSeatChangePlayers: _hostSeatChangeSeats,
      seatChangeInProgress: _hostSeatChangeInProgress,
    );

    return MultiProvider(
      providers: providers,
      builder: (BuildContext context, _) {
        _showWaitListHandlingNotification();
        this._providerContext = context;

        /* this function listens for marked cards in the result and sends as necessary */
        _initSendCardAfterFold(_providerContext);

        if (_gameContextObj != null) {
          if (!TestService.isTesting && widget.customizationService == null) {
            _gameContextObj.setup(context);
          }
        }

        /* set proper context for test service */
        TestService.context = context;

        // _setupAudioBufferService();

        /* This listenable provider takes care of showing or hiding the chat widget */
        return ListenableProvider<ValueNotifier<bool>>(
          // default value false means, we keep the chat window hidden initially
          create: (_) => ValueNotifier<bool>(false),
          builder: (context, _) => _buildCoreBody(context, boardAttributes),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (TestService.isTesting) {
      try {
        this._currentPlayer = TestService.currentPlayer;
      } catch (e) {}
    }
    if (widget.customizationService != null) {
      this._currentPlayer = widget.customizationService.currentPlayer;
    }
    final body = Consumer<AppTheme>(
      builder: (_, theme, __) {
        Widget mainBody = Scaffold(
          endDrawer: Consumer<PendingApprovalsState>(builder: (_, __, ___) {
            log('PendingApprovalsState updated');
            return Drawer(
              child: GamePlayScreenDrawer(gameState: _gameState),
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
        if (!Platform.isIOS) {
          mainBody = SafeArea(child: mainBody);
        }
        if (boardAttributes.useSafeArea) {
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
        log("Leaving AudioConference from Lifecycle");
        leaveAudioConference();
        AudioService.stop();
        if (_locationUpdates != null) {
          _locationUpdates.stop();
        }
        break;
      case AppLifecycleState.resumed:
        if (_gameState != null && !_gameState.uiClosing) {
          AudioService.resume();
          log("Joining AudioConference from Lifecycle");
          joinAudioConference();
          if (_locationUpdates != null) {
            _locationUpdates.start();
          }
        }
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
