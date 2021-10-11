import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_chat.dart';
import 'package:pokerapp/screens/game_play_screen/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/which_winner_widget.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
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
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';

import '../../main.dart';
import '../../routes.dart';
import '../../services/test/test_service.dart';
import 'game_play_screen_util_methods.dart';
import 'location_updates.dart';

// FIXME: THIS NEEDS TO BE CHANGED AS PER DEVICE CONFIG
const kScrollOffsetPosition = 40.0;

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
  // NOTE: Enable this for agora audio testing
  GamePlayScreen({
    @required this.gameCode,
    this.customizationService,
    this.botGame = false,
    this.showTop = true,
    this.showBottom = true,
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
  AudioPlayer _voiceTextPlayer;

  //Agora agora;
  GameComService _gameComService;
  GameInfoModel _gameInfoModel;
  GameContextObject _gameContextObj;
  GameState _gameState;
  List<PlayerInSeat> _hostSeatChangeSeats;
  bool _hostSeatChangeInProgress;
  WidgetsBinding _binding = WidgetsBinding.instance;
  LocationUpdates _locationUpdates;
  // Timer _timer;

  /* _init function is run only for the very first time,
  * and only once, the initial game screen is populated from here
  * also the NATS channel subscriptions are done here */
  Future<GameInfoModel> _fetchGameInfo() async {
    GameInfoModel gameInfo;

    if (widget.customizationService != null) {
      try {
        await widget.customizationService.load();
        gameInfo = widget.customizationService.gameInfo;
        this._currentPlayer = widget.customizationService.currentPlayer;
      } catch (e, s) {
        print('test data loading error: $s');
        return null;
      }
    } else if (TestService.isTesting) {
      try {
        debugPrint('Loading game from test data');
        // load test data
        await TestService.load();
        gameInfo = TestService.gameInfo;
        this._currentPlayer = TestService.currentPlayer;
      } catch (e, s) {
        print('test data loading error: $s');
        return null;
      }
    } else {
      debugPrint('fetching game data: ${widget.gameCode}');
      gameInfo = await GameService.getGameInfo(widget.gameCode);
      this._currentPlayer = await PlayerService.getMyInfo(widget.gameCode);
    }

    // mark the isMe field
    for (int i = 0; i < gameInfo.playersInSeats.length; i++) {
      if (gameInfo.playersInSeats[i].playerUuid == _currentPlayer.uuid)
        gameInfo.playersInSeats[i].isMe = true;
    }
    return gameInfo;
  }

  /* The init method returns a Future of all the initial game constants
  * This method is also responsible for subscribing to the NATS channels */
  Future<GameInfoModel> _init() async {
    GameInfoModel _gameInfoModel = await _fetchGameInfo();
    _hostSeatChangeInProgress = false;
    if (_gameInfoModel.status == AppConstants.GAME_PAUSED &&
        _gameInfoModel.tableStatus ==
            AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      _hostSeatChangeSeats =
          await SeatChangeService.hostSeatChangeSeatPositions(
              _gameInfoModel.gameCode);
      log('host seat change: $_hostSeatChangeSeats');
      _hostSeatChangeInProgress = true;
    }

    if (_initiated == true) return _gameInfoModel;

    _gameComService = GameComService(
      currentPlayer: this._currentPlayer,
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
      handToPlayerTextChannel: _gameInfoModel.handToPlayerTextChannel,
      gameChatChannel: _gameInfoModel.gameChatChannel,
      pingChannel: _gameInfoModel.pingChannel,
      pongChannel: _gameInfoModel.pongChannel,
    );

    final encryptionService = EncryptionService();

    if (!TestService.isTesting && widget.customizationService == null) {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await _gameComService.init(natsClient);
      await encryptionService.init();
    }

    _gameState = GameState();
    _gameState.isBotGame = widget.botGame;
    if (widget.customizationService != null) {
      _gameState.customizationMode = true;
    }
    _gameState.gameComService = _gameComService;

    if (widget.customizationService != null) {
      _gameState = widget.customizationService.gameState;
    } else {
      _gameComService.gameMessaging.onPlayerInfo = this.onPlayerInfo;
      _gameComService.gameMessaging.getMyInfo = this.getPlayerInfo;

      await _gameState.initialize(
        gameCode: _gameInfoModel.gameCode,
        gameInfo: _gameInfoModel,
        currentPlayer: _currentPlayer,
        gameMessagingService: _gameComService.gameMessaging,
        hostSeatChangeInProgress: _hostSeatChangeInProgress,
        hostSeatChangeSeats: _hostSeatChangeSeats,
      );
      if (!TestService.isTesting) {
        await _gameState.refreshSettings();
        await _gameState.refreshPlayerSettings();
        await _gameState.refreshNotes();
      }
    }

    // _audioPlayer = AudioPlayer();

    if (TestService.isTesting || widget.customizationService != null) {
      // testing code goes here
      _gameContextObj = GameContextObject(
        gameCode: widget.gameCode,
        player: this._currentPlayer,
        gameComService: _gameComService,
        encryptionService: encryptionService,
        gameState: _gameState,
      );
    } else {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await _gameComService.init(natsClient);

      _gameContextObj = GameContextObject(
        gameCode: widget.gameCode,
        player: this._currentPlayer,
        gameComService: _gameComService,
        encryptionService: encryptionService,
        gameState: _gameState,
      );

      // if the current player is in the table, then join audio
      for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
        if (_gameInfoModel.playersInSeats[i].playerUuid ==
            _currentPlayer.uuid) {
          // send my information
          _gameState.gameMessageService.sendMyInfo();
          _gameState.gameMessageService.requestPlayerInfo();

          // this.initPlayingTimer();
          // player is in the table
          joinAudioConference();

          // if gps check is enabled
          if (_gameInfoModel.gpsCheck) {
            _locationUpdates = new LocationUpdates(_gameState);
            _locationUpdates.start();
          }
          break;
        }
      }

      _gameContextObj.gameComService.gameMessaging.listen(
        onCards: this._onCards,
        onAudio: this._onAudio,
        onRabbitHunt: this._onRabbitHunt,
      );
    }

    _initiated = true;

    print('gameInfo players: ${_gameInfoModel.playersInSeats}');

    // setting voiceChatEnable to true if gameComService is active
    log('gameComService.active = ${_gameComService.active}');
    if (_gameComService.active) {
      _gameState.communicationState.voiceChatEnable = true;
      _gameState.communicationState.notify();
    }
    if (!TestService.isTesting && widget.customizationService == null) {
      _initChatListeners(_gameComService.gameMessaging);
    }

    if (_gameInfoModel?.audioConfEnabled ?? false) {
      // initialize agora
      // agora = Agora(
      //     gameCode: widget.gameCode,
      //     uuid: this._currentPlayer.uuid,
      //     playerId: this._currentPlayer.id);

      // if the current player is in the table, then join audio
      for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
        if (_gameInfoModel.playersInSeats[i].playerUuid ==
            _currentPlayer.uuid) {
          // send my information
          _gameState.gameMessageService.sendMyInfo();
          _gameState.gameMessageService.requestPlayerInfo();
          // request other player info
          // player is in the table
          joinAudioConference();
          break;
        }
      }
    } else {}

    return _gameInfoModel;
  }

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    // cancel listening to game play screen network changes
    _streamSub?.cancel();

    Wakelock.disable();
    if (_locationUpdates != null) {
      _locationUpdates.stop();
      _locationUpdates = null;
    }
    if (_gameContextObj.ionAudioConferenceService != null) {
      _gameContextObj.ionAudioConferenceService.leave();
    }

    if (_gameState != null) {
      _gameState.uiClosing = true;
    }

    if (_binding != null) {
      _binding.removeObserver(this);
    }

    super.dispose();
  }

  void _sendMarkedCards(BuildContext context) {
    if (TestService.isTesting || widget.customizationService != null) return;
    log('GameScreen: Trying to sending marked cards');
    final MarkedCards markedCards = _gameState.markedCardsState;

    /* collect the cards needs to be revealed */
    List<CardObject> _cardsToBeRevealed = markedCards.getCards();
    List<int> cardNumbers = [];
    for (final c in _cardsToBeRevealed) {
      cardNumbers.add(c.cardNum);
    }

    if (cardNumbers.length == 0) {
      return;
    }
    markedCards.cardsSent(cardNumbers);
    log('GameScreen: Sending cards');

    /* clear all the marked cards */
    // FIXME: markedCards.clear();

    final me = _gameState.me;
    _gameState.gameMessageService.sendCards(
      context.read<HandInfoState>().handNum,
      cardNumbers,
      me?.seatNo,
    );
  }

  void _initSendCardAfterFold(BuildContext context) {
    final MarkedCards markedCards = context.read<MarkedCards>();

    void onMarkingCards() {
      // if new cards are marked, send them back
      _sendMarkedCards(context);
    }

    _gameState.handChangeState.addListener(() {
      log('GameScreen: Hand State: ${_gameState.handState.toString()}');
      if (_gameState.handState == HandState.RESULT) {
        // send the marked cards for the first time
        _sendMarkedCards(context);

        // start listening for changes in markedCards value
        markedCards.addListener(onMarkingCards);
      }
      // else {
      //   markedCards.clear();
      //   markedCards.removeListener(onMarkingCards);
      // }
    });
  }

  void _onRabbitHunt(ChatMessage message) {
    Alerts.showRabbitHuntNotification(chatMessage: message);
  }

  void _onCards(ChatMessage message) {
    UtilActionServices.showCardsOfFoldedPlayers(
      _gameState.currentPlayerId,
      _gameState,
      message,
    );
  }

  void _onAudio(ChatMessage message) async {
    log('Audio message is sent ${message.messageId} from player ${message.fromPlayer}');
    // final gameState = GameState.getState(_providerContext);
    final seat = _gameState.getSeatByPlayer(message.fromPlayer);
    if (_voiceTextPlayer != null &&
        message.audio != null &&
        message.audio.length > 0) {
      if (seat != null && seat.player != null) {
        seat.player.talking = true;
        seat.notify();
        try {
          _voiceTextPlayer.playBytes(message.audio).then((value) {
            seat.player.talking = false;
            seat.notify();
          });
        } catch (e) {
          // ignore the exception
        }
      } else {
        // Play voice text from observer.
        try {
          int res = await _voiceTextPlayer.playBytes(message.audio);
          if (res == 1) {
            log("Playing observer sound");
            //await Future.delayed(Duration(seconds: message.duration ?? 0));
          }
        } catch (e) {
          // ignore the exception
        }
      }
    }
  }

  void _toggleChatVisibility(BuildContext context) {
    final chatVisibilityNotifier = context.read<ValueNotifier<bool>>();
    chatVisibilityNotifier.value = !chatVisibilityNotifier.value;
  }

  Future _onJoinGame(Seat seat) async {
    final gameState = GameState.getState(_providerContext);
    final tableState = gameState.tableState;
    final me = gameState.me;
    /* ignore the open seat tap as the player is seated and game is running */
    if (me != null &&
        me.status == AppConstants.PLAYING &&
        (tableState.gameStatus == AppConstants.GAME_RUNNING ||
            tableState.tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING)) {
      bool ret = await showPrompt(
          context, 'Switch Seat', 'Do you want to switch seat next hand?');
      if (ret) {
        await SeatChangeService.switchSeat(widget.gameCode, seat.serverSeatPos);
      }
      log('Ignoring the open seat tap as the player is seated and game is running');
      return;
    }

    if (me != null && me.seatNo != null && me.seatNo != 0) {
      log('Player ${me.name} switches seat to ${seat.serverSeatPos}');
      await SeatChangeService.switchSeat(widget.gameCode, seat.serverSeatPos);
    } else {
      try {
        LocationUpdates locationUpdates;
        // show connection dialog
        if (_locationUpdates == null) {
          if (_gameState.gameInfo.gpsCheck || _gameState.gameInfo.ipCheck) {
            locationUpdates = LocationUpdates(_gameState);

            if (_gameState.gameInfo.gpsCheck &&
                !await locationUpdates.requestPermission()) {
              await showErrorDialog(context, 'Permission',
                  'Game uses gps locations. You cannot participate without providing GPS access',
                  info: false);
              return;
            }
          }
        }

        if (gameState.gameInfo.audioConfEnabled) {
          if (!await Permission.microphone.isGranted) {
            await showErrorDialog(context, 'Permission',
                'Game uses audio conference. Please grant mic access to participate in Audio conference.',
                info: true);
            // request audio permission
            PermissionStatus status = await Permission.microphone.request();
            if (status != PermissionStatus.granted) {
              gameState.gameInfo.audioConfEnabled = false;
            }
          }
        }
        await GamePlayScreenUtilMethods.joinGame(
          context: _providerContext,
          seat: seat,
          gameCode: widget.gameCode,
          gameState: gameState,
        );

        // player joined the game (send player info)
        _gameState.gameMessageService.sendMyInfo();
        _gameState.gameMessageService.requestPlayerInfo();

        if (_gameState.gameInfo.gpsCheck || _gameState.gameInfo.ipCheck) {
          _locationUpdates = locationUpdates;
          _locationUpdates.start();
        }

        // join audio conference
        joinAudioConference();
      } catch (e) {
        // close connection dialog
        //ConnectionDialog.dismiss(context: context);

        if (e is GqlError) {
          if (e.code != null) {
            if (e.code == 'LOC_PROXMITY_ERROR') {
              showErrorDialog(context, 'Error',
                  'GPS check is enabled in this game. You are close to another player.');
            } else if (e.code == 'SAME_IP_ERROR') {
              showErrorDialog(context, 'Error',
                  'IP check is enabled in this game. There is another player in the table with the same IP.');
            }
          } else {
            showErrorDialog(context, 'Error', e.message);
          }
        } else {
          showErrorDialog(context, 'Error', e.message);
        }
        return;
      }
      // join audio
      joinAudioConference();
    }
  }

  void _initGameInfoModel() async {
    final GameInfoModel gameInfoModel = await _init();
    if (mounted) {
      setState(() => _gameInfoModel = gameInfoModel);
    }
  }

  StreamSubscription<ConnectivityResult> _streamSub;

  @override
  void initState() {
    super.initState();

    _streamSub =
        context.read<NetworkChangeListener>().onConnectivityChange.listen(
              (_) => _reconnectGameComService(),
            );

    Wakelock.enable();
    _voiceTextPlayer = AudioPlayer();

    // Register listener for lifecycle methods
    WidgetsBinding.instance.addObserver(this);
    _binding.addObserver(this);

    init().then((v) {
      Future.delayed(Duration(seconds: 1), () {
        _queryCurrentHandIfNeeded();
      });
    });
  }

  // void initPlayingTimer() {
  //   // diamonds timer, which invokes every 30 seconds
  //   // but adds diamonds ONLY after the duration of AppConstants.diamondUpdateDuration
  //   _timer = Timer.periodic(const Duration(seconds: 30), (_) {
  //     PlayerModel me;
  //     try {
  //       me = _gameState.me;
  //     } catch (e) {}

  //     if (me != null) _gameState.gameHiveStore.addDiamonds();
  //   });
  // }

  void reload() {
    close();
    init();
  }

  Future<void> init() async {
    log('game screen initState');
    await _initGameInfoModel();
  }

  void close() {
    // _timer?.cancel();

    try {
      if (_locationUpdates != null) {
        _locationUpdates.stop();
      }
      _gameContextObj?.dispose();
      _gameState?.close();
      _voiceTextPlayer?.dispose();
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }
  }

  final ScrollController _gcsController = ScrollController();

  bool _isChatScreenVisible = false;

  void _onChatMessage() {
    if (_isChatScreenVisible) {
      // notify of new messages & rebuild the game message list
      _providerContext.read<GameChatNotifState>().notifyNewMessage();

      /* if user is scrolled away, we need to notify */
      if (_gcsController.hasClients &&
          (_gcsController.offset > kScrollOffsetPosition)) {
        _providerContext.read<GameChatNotifState>().addUnread();
      }
    } else {
      _providerContext.read<GameChatNotifState>()?.addUnread();
    }
  }

  void _initChatListeners(GameMessagingService gms) {
    gms.listen(
      onText: (ChatMessage _) => _onChatMessage(),
      onGiphy: (ChatMessage _) => _onChatMessage(),
    );

    _gcsController.addListener(() {
      if (_gcsController.offset < kScrollOffsetPosition) {
        _providerContext.read<GameChatNotifState>().readAll();
      }
    });
  }

  Widget _buildChatWindow() => Consumer<ValueNotifier<bool>>(
        builder: (context, vnChatVisibility, __) {
          _isChatScreenVisible = vnChatVisibility.value;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: vnChatVisibility.value
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: GameChat(
                      scrollController: _gcsController,
                      chatService: _gameContextObj.gameComService.gameMessaging,
                      onChatVisibilityChange: () => _toggleChatVisibility(
                        context,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      );

  Widget _buildBoardView(Size boardDimensions, double tableScale) {
    log('RedrawTop: Rebuilding board view');
    return Container(
      key: UniqueKey(),
      width: boardDimensions.width,
      height: boardDimensions.height,
      child: Transform.scale(
        scale: tableScale,
        child: BoardView(
          gameComService: _gameContextObj?.gameComService,
          gameInfo: _gameInfoModel,
          onUserTap: _onJoinGame,
          onStartGame: startGame,
        ),
      ),
    );
  }

  void _queryCurrentHandIfNeeded() {
    /* THIS METHOD QUERIES THE CURRENT HAND AND POPULATE THE
       GAME SCREEN, IF AND ONLY IF THE GAME IS ALREADY PLAYING */

    if (TestService.isTesting == true || widget.customizationService != null)
      return;

    if (_gameInfoModel?.tableStatus == AppConstants.GAME_RUNNING) {
      // query current hand to get game update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        log('network_reconnect: queryCurrentHand invoked');
        _gameContextObj.handActionProtoService.queryCurrentHand();
      });
    }
  }

  Widget _buildCoreBody(
    BuildContext context,
    BoardAttributesObject boardAttributes,
  ) {
    var dividerTotalHeight = MediaQuery.of(context).size.height / 6;

    final width = MediaQuery.of(context).size.width;

    bool isBoardHorizontal = true;
    final boardDimensions = BoardView.dimensions(context, isBoardHorizontal);

    double tableScale = boardAttributes.tableScale;
    double divider1 =
        boardAttributes.tableDividerHeightScale * dividerTotalHeight;
    final theme = AppTheme.getTheme(context);

    List<Widget> children = [];

    if (this.widget.showTop) {
      Widget headerView;
      if (_gameState.customizationMode) {
        headerView = Align(
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
        headerView = HeaderView(gameState: _gameState);
      }

      children.addAll([
        //_buildAudioWidget(),

        // header view
        headerView,

        // RoundRectButton(
        //     text: 'Refresh',
        //     onTap: () {
        //       log('RedrawTop: on refresh');
        //       _gameState.redrawTop();
        //     }),
        // seperator
        // SizedBox(width: width, height: divider1 / 2),

        // this widget, shows which winner is currently showing - high winner / low winner
        // this widget also acts as a natural seperator between header and board view
        WhichWinnerWidget(seperator: divider1),

        // seperator
        // SizedBox(width: width, height: divider1 / 2),

        // main board view
        Consumer<RedrawTopSectionState>(builder: (_, ___, __) {
          log('RedrawTop: Rebuilding top section');
          return _buildBoardView(boardDimensions, tableScale);
        }),

        /* divider that divides the board view and the footer */
        Divider(color: AppColorsNew.dividerColor, thickness: 3),
      ]);
    }

    if (this.widget.showBottom) {
      children.addAll([
        // footer section
        Consumer<RedrawFooterSectionState>(builder: (_, ___, __) {
          log('RedrawFooter: building footer view');
          return FooterViewWidget(
            gameCode: widget.gameCode,
            gameContextObject: _gameContextObj,
            currentPlayer: _gameContextObj.gameState.currentPlayer,
            gameInfo: _gameInfoModel,
            toggleChatVisibility: _toggleChatVisibility,
          );
        }),
      ]);
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        this.widget.showTop ? BackgroundView() : Container(),
        this.widget.showTop && _gameState.customizationMode
            ? Positioned(
                top: 50.pw,
                left: width - 50.pw,
                child: GameCircleButton(
                  onClickHandler: () async {
                    await Navigator.of(context).pushNamed(Routes.select_table);
                    await _gameState.assets.initialize();
                    final redrawTop = _gameState.redrawTopSectionState;
                    redrawTop.notify();
                    setState(() {});
                  },
                  child: Icon(Icons.edit,
                      size: 24.pw, color: theme.primaryColorWithDark()),
                ))
            : Container(),

        /* main view */
        Column(
          children: children,
        ),

        /* chat window widget */
        this.widget.showBottom ? _buildChatWindow() : Container(),

        /* notification view */
        this.widget.showBottom
            ? Notifications.buildNotificationWidget()
            : Container(),
      ],
    );
  }

  Widget _buildBody(AppTheme theme) {
    // show a progress indicator if the game info object is null
    if (_gameInfoModel == null) return Center(child: CircularProgressWidget());

    /* get the screen sizes, and initialize the board attributes */
    BoardAttributesObject boardAttributes = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
    );

    final providers = GamePlayScreenUtilMethods.getProviders(
      context: context,
      gameInfoModel: _gameInfoModel,
      gameCode: widget.gameCode,
      gameState: _gameState,
      //agora: agora,
      boardAttributes: boardAttributes,
      gameContextObject: _gameContextObj,
      hostSeatChangePlayers: _hostSeatChangeSeats,
      seatChangeInProgress: _hostSeatChangeInProgress,
    );

    return MultiProvider(
      providers: providers,
      builder: (BuildContext context, _) {
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

  void _reconnectGameComService() async {
    log('network_reconnect: _reconnectGameComService invoked');
    final nats = context.read<Nats>();

    // drop connections -> re establish connections
    await _gameComService.reconnect(nats);

    // query current hand
    _queryCurrentHandIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    if (TestService.isTesting) {
      try {
        this._currentPlayer = TestService.currentPlayer;
      } catch (e) {
        print('test data loading error: $e');
      }
    }
    if (widget.customizationService != null) {
      this._currentPlayer = widget.customizationService.currentPlayer;
    }
    return Consumer<AppTheme>(
      builder: (_, theme, __) {
        return Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          child: SafeArea(
            child: Scaffold(
              /* FIXME: THIS FLOATING ACTION BUTTON IS FOR SHOWING THE TESTS */
              floatingActionButton:
                  GamePlayScreenUtilMethods.floatingActionButton(
                onReload: () {},
                isCustomizationMode: widget.customizationService != null,
              ),
              // floating button to refresh network TEST
              // floatingActionButton: FloatingActionButton(
              //   child: Icon(Icons.android_rounded),
              //   onPressed: _reconnectGameComService,
              // ),
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              body: _buildBody(theme),
            ),
          ),
        );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  startGame() async {
    try {
      ConnectionDialog.show(context: context, loadingText: "Starting...");
      await GamePlayScreenUtilMethods.startGame(widget.gameCode);
      await _gameState.refresh();
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

  leaveAudioConference() {
    if (_gameState != null) {
      _voiceTextPlayer?.pause();
      _gameContextObj.leaveAudio();
    }
  }

  void joinAudioConference() async {
    if (context != null) {
      await _gameContextObj.joinAudio(context);
      if (!_gameState.uiClosing) {
        // ui is still running
        // send stream id
        _gameState.gameMessageService.sendMyInfo();
      }
    }
  }

  void onPlayerInfo(GamePlayerInfo info) {
    final player = _gameState.getPlayerById(info.playerId);
    if (player != null) {
      // update seat to change the name plate
      final seat = _gameState.getSeatByPlayer(info.playerId);
      if (seat != null && seat.player != null) {
        final player = seat.player;
        log('PlayerInfo: name: ${player.name} streamId: ${player.streamId} namePlateId: ${player.namePlateId}');
        if (player.streamId != info.streamId ||
            player.namePlateId != info.namePlateId) {
          player.streamId = info.streamId;
          player.namePlateId = info.namePlateId;
          seat.notify();
        }
      }
    }
  }

  GamePlayerInfo getPlayerInfo() {
    GamePlayerInfo playerInfo = GamePlayerInfo();
    if (_gameState.me == null) {
      return null;
    }
    playerInfo.streamId = _gameState.me.streamId;
    playerInfo.playerId = _gameState.me.playerId;
    playerInfo.namePlateId = _gameState.me.namePlateId;
    return playerInfo;
  }
}
