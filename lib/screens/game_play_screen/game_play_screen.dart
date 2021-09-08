import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
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
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/which_winner_widget.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/util_action_services.dart';
import 'package:pokerapp/services/game_play/action_services/game_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/services/janus/janus.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';

import '../../main.dart';
import '../../routes.dart';
import '../../services/test/test_service.dart';
import 'game_play_screen_util_methods.dart';

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
  AudioPlayer _audioPlayer;
  AudioPlayer _voiceTextPlayer;

  //Agora agora;
  GameInfoModel _gameInfoModel;
  GameContextObject _gameContextObj;
  GameState _gameState;
  List<PlayerInSeat> _hostSeatChangeSeats;
  bool _hostSeatChangeInProgress;

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

  Future _joinAudio() async {
    return;
    try {
      if (_audioPlayer != null) {
        _audioPlayer.resume();
      }
    } catch (err) {
      log('Error when resuming audio');
    }
    if (!_gameState.audioConfEnabled) {
      try {
        if (_voiceTextPlayer != null) {
          _voiceTextPlayer.resume();
        }
      } catch (err) {
        log('Error when resuming audio');
      }
      return;
    }

    final player = _gameState.currentPlayer;
    if (_gameState.useAgora) {
      try {
        debugLog(widget.gameCode,
            'agora: Player ${player.name} is joining audio conference');
        log('agora: Player ${player.name} is joining audio conference');

        _gameState.agoraEngine.joinChannel(_gameState.agoraToken);
        log('agora: Player ${player.name} has joined audio conference');
        debugLog(widget.gameCode,
            'Player ${player.name} has joined audio conference');
        this._gameState.getCommunicationState().notify();
      } catch (err) {
        debugLog(widget.gameCode,
            'Player ${player.name} failed to join audio conference. Error: ${err.toString()}');
        log('Error when resuming audio');
      }
    } else {
      try {
        debugLog(widget.gameCode,
            'Player ${player.name} is joining audio conference');
        _gameState.janusEngine.joinChannel('test');
        debugLog(widget.gameCode,
            'Player ${player.name} has joined audio conference');
      } catch (err) {
        debugLog(widget.gameCode,
            'Player ${player.name} failed to join audio conference. Error: ${err.toString()}');
        log('Error when resuming audio');
      }
    }
    return;

    // agora code
    // this._audioToken = await GameService.getLiveAudioToken(widget.gameCode);
    // print('Audio token: ${this._audioToken}');
    // print('audio token: ${this._audioToken}');
    // if (this._audioToken != null && this._audioToken != '') {
    //   agora.initEngine().then((_) async {
    //     print('Joining audio channel ${widget.gameCode}');
    //     await agora.joinChannel(this._audioToken);
    //     print('Joined audio channel ${widget.gameCode}');
    //   });
    // }
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

    final gameComService = GameComService(
      currentPlayer: this._currentPlayer,
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
      gameChatChannel: _gameInfoModel.gameChatChannel,
      pingChannel: _gameInfoModel.pingChannel,
      pongChannel: _gameInfoModel.pongChannel,
    );

    final encryptionService = EncryptionService();

    if (!TestService.isTesting && widget.customizationService == null) {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await gameComService.init(natsClient);
      await encryptionService.init();
    }

    _gameState = GameState();
    _gameState.isBotGame = widget.botGame;
    if (widget.customizationService != null) {
      _gameState.customizationMode = true;
    }
    _gameState.gameComService = gameComService;

    if (widget.customizationService != null) {
      _gameState = widget.customizationService.gameState;
    } else {
      await _gameState.initialize(
        gameCode: _gameInfoModel.gameCode,
        gameInfo: _gameInfoModel,
        currentPlayer: _currentPlayer,
        gameMessagingService: gameComService.gameMessaging,
        hostSeatChangeInProgress: _hostSeatChangeInProgress,
        hostSeatChangeSeats: _hostSeatChangeSeats,
      );
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
          // player is in the table
          await this._joinAudio();
          break;
        }
      }
    } else {}

    // _audioPlayer = AudioPlayer();

    if (TestService.isTesting || widget.customizationService != null) {
      // testing code goes here
      _gameContextObj = GameContextObject(
        gameCode: widget.gameCode,
        player: this._currentPlayer,
        gameComService: gameComService,
        encryptionService: encryptionService,
        gameState: _gameState,
      );
    } else {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await gameComService.init(natsClient);

      _gameContextObj = GameContextObject(
        gameCode: widget.gameCode,
        player: this._currentPlayer,
        gameComService: gameComService,
        encryptionService: encryptionService,
        gameState: _gameState,
      );

      // if the current player is in the table, then join audio
      for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
        if (_gameInfoModel.playersInSeats[i].playerUuid ==
            _currentPlayer.uuid) {
          this.initPlayingTimer();
          // player is in the table
          this._joinAudio();
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
    log('gameComService.active = ${gameComService.active}');
    if (gameComService.active) {
      _gameState.getCommunicationState().voiceChatEnable = true;
      _gameState.getCommunicationState().notify();
    }
    if (!TestService.isTesting && widget.customizationService == null) {
      _initChatListeners(gameComService.gameMessaging);
    }

    return _gameInfoModel;
  }

  Timer _timer;

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    Wakelock.disable();
    if (_gameState != null) {
      _gameState.uiClosing = true;
    }
    super.dispose();
  }

  void _sendMarkedCards(BuildContext context) {
    if (TestService.isTesting || widget.customizationService != null) return;

    final MarkedCards markedCards = _gameState.getMarkedCards(context);

    /* collect the cards needs to be revealed */
    List<CardObject> _cardsToBeRevealed = markedCards.getCards();
    List<int> cardNumbers = [];
    for (final c in _cardsToBeRevealed) {
      cardNumbers.add(c.cardNum);
    }

    /* clear all the marked cards */
    // FIXME: markedCards.clear();

    final gameService = _gameState.getGameMessagingService(context);
    final Players players = _gameState.getPlayers(context);

    gameService.sendCards(
      context.read<HandInfoState>().handNum,
      cardNumbers,
      players.me?.seatNo,
    );
  }

  void _initSendCardAfterFold(BuildContext context) {
    final vnFooterStatus = context.read<ValueNotifier<FooterStatus>>();
    final MarkedCards markedCards = context.read<MarkedCards>();

    void onMarkingCards() {
      // if new cards are marked, send them back
      _sendMarkedCards(context);
    }

    vnFooterStatus.addListener(() {
      if (vnFooterStatus.value == FooterStatus.Result) {
        // send the marked cards for the first time
        _sendMarkedCards(context);

        // start listening for changes in markedCards value
        markedCards.addListener(onMarkingCards);
      } else {
        markedCards.clear();
        markedCards.removeListener(onMarkingCards);
      }
    });
  }

  void _onRabbitHunt(ChatMessage message) {
    Alerts.showRabbitHuntNotification(chatMessage: message);
  }

  void _onCards(ChatMessage message) {
      UtilActionServices.showCardsOfFoldedPlayers(
        _gameState.currentPlayerId,
        _providerContext,
        message,
      );
  }

  void _onAudio(ChatMessage message) async {
    log('Audio message is sent ${message.messageId} from player ${message.fromPlayer}');
    return;
    final gameState = GameState.getState(_providerContext);
    final seat = gameState.getSeatByPlayer(message.fromPlayer);
    if (_voiceTextPlayer != null &&
        message.audio != null &&
        message.audio.length > 0) {
      if (seat != null && seat.player != null) {
        seat.player.talking = true;
        seat.notify();
        try {
          int res = await _voiceTextPlayer.playBytes(message.audio);
          if (res == 1) {
            log("Pls wait for ${message.duration} seconds");
            await Future.delayed(Duration(seconds: message.duration ?? 0));
          }

          seat.player.talking = false;
          seat.notify();
        } catch (e) {
          // ignore the exception
        }
      } else {
        // Play voice text from observer.
        try {
          int res = await _voiceTextPlayer.playBytes(message.audio);
          if (res == 1) {
            log("Playing observer sound");
            await Future.delayed(Duration(seconds: message.duration ?? 0));
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

  Future _onJoinGame(int seatPos) async {
    final gameState = GameState.getState(_providerContext);
    final tableState = gameState.tableState;
    final me = gameState.me;

    /* ignore the open seat tap as the player is seated and game is running */
    if (me != null &&
        me.status == AppConstants.PLAYING &&
        tableState.gameStatus == AppConstants.GAME_RUNNING) {
      log('Ignoring the open seat tap as the player is seated and game is running');
      return;
    }

    if (me != null && me.seatNo != null && me.seatNo != 0) {
      log('Player ${me.name} switches seat to $seatPos');
      await GameService.switchSeat(widget.gameCode, seatPos);
    } else {
      try {
        await GamePlayScreenUtilMethods.joinGame(
          context: _providerContext,
          seatPos: seatPos,
          gameCode: widget.gameCode,
          gameState: gameState,
        );
      } catch (e) {
        showError(context, error: e);
        return;
      }
      // join audio
      await _joinAudio();
    }
  }

  void _initGameInfoModel() async {
    final GameInfoModel gameInfoModel = await _init();
    if (mounted) {
      setState(() => _gameInfoModel = gameInfoModel);
    }
    _queryCurrentHandIfNeeded();
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    _audioPlayer = AudioPlayer();
    _voiceTextPlayer = AudioPlayer();

    // Register listener for lifecycle methods
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  void initPlayingTimer() {
    // diamonds timer, which invokes every 30 seconds
    // but adds diamonds ONLY after the duration of AppConstants.diamondUpdateDuration
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      PlayerModel me;
      try {
        me = _gameState.getPlayers(_providerContext).me;
      } catch (e) {}

      if (me != null) _gameState.gameHiveStore.addDiamonds();
    });
  }

  void reload() {
    close();
    init();
  }

  void init() {
    log('game screen initState');
    _initGameInfoModel();
  }

  void close() {
    _timer?.cancel();

    try {
      _gameContextObj?.dispose();
      _gameState?.close();
      _audioPlayer?.dispose();
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

  Widget _buildAudioWidget() => _gameState?.audioConfEnabled ?? false
      ? Consumer<JanusEngine>(
          builder: (_, __, ___) {
            return _gameState.janusEngine.audioWidget();
          },
        )
      : SizedBox.shrink();

  Widget _buildBoardView(Size boardDimensions, double tableScale) {
    return Container(
      width: boardDimensions.width,
      height: boardDimensions.height,
      child: Transform.scale(
        scale: tableScale,
        child: BoardView(
          gameComService: _gameContextObj?.gameComService,
          gameInfo: _gameInfoModel,
          audioPlayer: _audioPlayer,
          onUserTap: _onJoinGame,
          onStartGame: startGame,
        ),
      ),
    );
  }

  Widget _buildFooterView(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bottom_pattern.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: FooterView(
          gameContext: _gameContextObj,
          gameCode: widget.gameCode,
          playerUuid: _currentPlayer.uuid,
          chatVisibilityChange: () => _toggleChatVisibility(context),
          clubCode: _gameInfoModel.clubCode,
        ),
      ),
    );
  }

  void _setupGameContextObject() {
    if (_gameContextObj.gameUpdateService == null) {
      /* setup the listeners to the channels
            * Any messages received from these channel updates,
            * will be taken care of by the respective class
            * and actions will be taken in the UI
            * as there will be Listeners implemented down this hierarchy level */

      _gameContextObj.gameUpdateService =
          GameUpdateService(_providerContext, _gameState, this._audioPlayer);
      _gameContextObj.gameUpdateService.loop();

      _gameContextObj.gameComService.gameToPlayerChannelStream
          ?.listen((nats.Message message) {
        if (!_gameContextObj.gameComService.active) return;

        // log('gameToPlayerChannel(${message.subject}): ${message.string}');

        /* This stream will receive game related messages
                            * e.g.
                            * 1. Player Actions - Sitting on table, getting more chips, leaving game, taking break,
                            * 2. Game Actions - New hand, informing about Next actions, PLayer Acted
                            *  */

        _gameContextObj.gameUpdateService.handle(message.string);
      });
    }

    if (_gameContextObj.handActionProtoService == null) {
      _gameContextObj.handActionProtoService = HandActionProtoService(
        _providerContext,
        _gameState,
        _gameContextObj.gameComService,
        _gameContextObj.encryptionService,
        _gameContextObj.currentPlayer,
        audioPlayer: _audioPlayer,
      );

      _gameContextObj.handActionProtoService.loop();

      if (!TestService.isTesting && widget.customizationService == null) {
        _gameContextObj.gameComService.handToAllChannelStream.listen(
          (nats.Message message) {
            if (!_gameContextObj.gameComService.active) return;

            if (_gameContextObj.handActionProtoService == null) return;

            /* This stream receives hand related messages that is common to all players
                              * e.g
                              * New Hand - contains hand status, dealerPos, sbPos, bbPos, nextActionSeat
                              * Next Action - contains the seat No which is to act next
                              *
                              * This stream also contains the output for the query of current hand */
            _gameContextObj.handActionProtoService.handle(message.data);
          },
        );

        _gameContextObj.gameComService.handToPlayerChannelStream.listen(
          (nats.Message message) {
            if (!_gameContextObj.gameComService.active) return;

            if (_gameContextObj.handActionProtoService == null) return;

            /* This stream receives hand related messages that is specific to THIS player only
                              * e.g
                              * Deal - contains seat No and cards
                              * Your Action - seat No, available actions & amounts */

            _gameContextObj.handActionProtoService
                .handle(message.data, encrypted: true);
          },
        );
      }
    }
  }

  void _queryCurrentHandIfNeeded() {
    /* THIS METHOD QUERIES THE CURRENT HAND AND POPULATE THE
       GAME SCREEN, IF AND ONLY IF THE GAME IS ALREADY PLAYING */

    if (TestService.isTesting == true || widget.customizationService != null)
      return;

    if (_gameInfoModel?.tableStatus == AppConstants.GAME_RUNNING) {
      // query current hand to get game update
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
      children.addAll([
        _buildAudioWidget(),

        // header view
        HeaderView(gameState: _gameState),

        // seperator
        // SizedBox(width: width, height: divider1 / 2),

        // this widget, shows which winner is currently showing - high winner / low winner
        // this widget also acts as a natural seperator between header and board view
        WhichWinnerWidget(seperator: divider1),

        // seperator
        // SizedBox(width: width, height: divider1 / 2),

        // main board view
        Consumer<RedrawTopSectionState>(builder: (_, ___, __) {
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
          return FooterViewWidget(
              gameCode: widget.gameCode,
              gameContextObject: _gameContextObj,
              currentPlayer: _gameContextObj.gameState.currentPlayer,
              gameInfo: _gameInfoModel);
        }),
      ]);
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        this.widget.showTop ? BackgroundView() : Container(),
        this.widget.showTop
            ? Positioned(
                top: 50.pw,
                left: width - 50.pw,
                child: GameCircleButton(
                  onClickHandler: () {
                    log('refresh button is clicked');
                    //this.reload();
                  },
                  child: Icon(Icons.refresh_rounded,
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

        if (_gameContextObj != null) _setupGameContextObject();

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
              ),
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

  startGame() {
    GamePlayScreenUtilMethods.startGame(widget.gameCode);
    final tableState = _gameState.tableState;
    tableState.updateGameStatusSilent(AppConstants.GAME_RUNNING);
    _gameState.myState.notify();
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
        break;
      case AppLifecycleState.resumed:
        log("Joining AudioConference from Lifecycle");
        _joinAudio();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  leaveAudioConference() {
    if (_gameState != null) {
      _audioPlayer?.pause();
      _voiceTextPlayer?.pause();
      _gameState.janusEngine?.leaveChannel();
      if (_gameState.useAgora) {
        _gameState.agoraEngine?.leaveChannel();
      }
    }
  }
}
