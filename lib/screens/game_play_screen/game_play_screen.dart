import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_chat.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/auth_service.dart';

//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/encryption/encryption_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/util_action_services.dart';
import 'package:pokerapp/services/game_play/action_services/game_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
import 'package:pokerapp/services/game_play/utils/audio_buffer.dart';
import 'package:pokerapp/services/janus/janus.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

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

  // NOTE: Enable this for agora audio testing
  GamePlayScreen({
    @required this.gameCode,
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

    if (TestService.isTesting) {
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

  Future joinAudio() async {
    if (!_gameState.audioConfEnabled) {
      return;
    }
    if (_audioPlayer != null) {
      _audioPlayer.resume();
    }
    if (_voiceTextPlayer != null) {
      _voiceTextPlayer.resume();
    }

    //final janusEngine = _gameState.getJanusEngine(_providerContext);
    _gameState.janusEngine.joinChannel('test');
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

    if (!TestService.isTesting) {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await gameComService.init(natsClient);
      await encryptionService.init();
    }

    _gameState = GameState();
    _gameState.gameComService = gameComService;
    _gameState.initialize(
      gameCode: _gameInfoModel.gameCode,
      gameInfo: _gameInfoModel,
      currentPlayer: _currentPlayer,
      gameMessagingService: gameComService.gameMessaging,
      hostSeatChangeInProgress: _hostSeatChangeInProgress,
      hostSeatChangeSeats: _hostSeatChangeSeats,
    );

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
          await this.joinAudio();
          break;
        }
      }
    } else {}

    // _audioPlayer = AudioPlayer();

    if (TestService.isTesting) {
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
          // player is in the table
          this.joinAudio();
          break;
        }
      }

      _gameContextObj.gameComService.gameMessaging.listen(
        onCards: this.onCards,
        onAudio: this.onAudio,
        onRabbitHunt: this.onRabbitHunt,
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
    if (!TestService.isTesting) {
      _initChatListeners(gameComService.gameMessaging);
    }

    // diamonds timer, which invokes every 30 seconds
    // but adds diamonds ONLY after the duration of AppConstants.diamondUpdateDuration
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      PlayerModel me;
      try {
        me = _gameState.getPlayers(_providerContext).me;
      } catch (e) {}

      if (me != null) _gameState.gameHiveStore.addDiamonds();
    });

    return _gameInfoModel;
  }

  Timer _timer;

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    // TestService.isTesting = false;
    Wakelock.disable();
    _timer?.cancel();
    try {
      _gameContextObj?.dispose();
      // agora?.disposeObject();
      // Audio.dispose(context: _providerContext);
      _gameState?.janusEngine?.disposeObject();
      _gameState?.close();

      if (_audioPlayer != null) {
        _audioPlayer.dispose();
        _audioPlayer = null;
      }
      if (_voiceTextPlayer != null) {
        _voiceTextPlayer.dispose();
        _voiceTextPlayer = null;
      }
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }

    super.dispose();
  }

  void _sendMarkedCards(BuildContext context) {
    if (TestService.isTesting) return;

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

  void onRabbitHunt(ChatMessage message) {
    Alerts.showRabbitHuntNotification(chatMessage: message);
  }

  void onCards(ChatMessage message) =>
      UtilActionServices.showCardsOfFoldedPlayers(
        _providerContext,
        message,
      );

  void onText(ChatMessage message) {
    log(message.text);
  }

  void onAudio(ChatMessage message) async {
    log('Audio message is sent ${message.messageId} from player ${message.fromPlayer}');
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

  // void onAnimation(ChatMessage message) async {
  //   log('Animation message is sent ${message.messageId} from player ${message.fromSeat} to ${message.toSeat}. Animation id: ${message.animationID}');
  //   // todo initiate animation
  // }

  void toggleChatVisibility(BuildContext context) {
    ValueNotifier<bool> chatVisibilityNotifier =
        context.read<ValueNotifier<bool>>();
    chatVisibilityNotifier.value = !chatVisibilityNotifier.value;
  }

  Future onJoinGame(int seatPos) async {
    final gameState = GameState.getState(_providerContext);
    final me = gameState.me(_providerContext);

    /* ignore the open seat tap as the player is seated and game is running */
    if (gameState.myState.status == PlayerStatus.PLAYING &&
        gameState.myState.gameStatus == GameStatus.RUNNING) {
      log('Ignoring the open seat tap as the player is seated and game is running');
      return;
    }

    if (me != null && me.seatNo != null && me.seatNo != 0) {
      log('Player ${me.name} switches seat to $seatPos');
      await GameService.switchSeat(widget.gameCode, seatPos);
    } else {
      try {
        await GamePlayScreenUtilMethods.joinGame(
          seatPos: seatPos,
          gameCode: widget.gameCode,
          gameState: gameState,
        );
      } catch (e) {
        showError(context, error: e);
        return;
      }
      // join audio
      await joinAudio();
    }
  }

  @override
  void initState() {
    super.initState();
    // Register listener for lifecycle methods
    WidgetsBinding.instance.addObserver(this);
    log('game screen initState');
    /* the init method is invoked only once */
    _audioPlayer = AudioPlayer();
    _voiceTextPlayer = AudioPlayer();
    Wakelock.enable();
    _init().then(
      (gameInfoModel) => setState(
        () {
          _gameInfoModel = gameInfoModel;
          _queryCurrentHand();
        },
      ),
    );
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

  Widget _buildChatWindow(BuildContext context) =>
      Consumer<ValueNotifier<bool>>(
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
                      onChatVisibilityChange: () =>
                          toggleChatVisibility(context),
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

  Widget _buildBoardView(Size boardDimensions, double tableScale) => Container(
        width: boardDimensions.width,
        height: boardDimensions.height,
        child: Transform.scale(
          scale: tableScale,
          // 10 inch: 0.85, 5inch: 1.0
          child: BoardView(
            gameComService: _gameContextObj?.gameComService,
            gameInfo: _gameInfoModel,
            audioPlayer: _audioPlayer,
            onUserTap: onJoinGame,
            onStartGame: startGame,
          ),
        ),
      );

  Widget _buildFooterView() => Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/bottom_pattern.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: FooterView(
            this._gameContextObj,
            widget.gameCode,
            _currentPlayer.uuid,
            () => toggleChatVisibility(context),
            _gameInfoModel.clubCode,
          ),
        ),
      );

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

    if (_gameContextObj.handActionService == null) {
      _gameContextObj.handActionService = HandActionService(
        _providerContext,
        _gameState,
        _gameContextObj.gameComService,
        _gameContextObj.encryptionService,
        _gameContextObj.currentPlayer,
        audioPlayer: _audioPlayer,
      );

      _gameContextObj.handActionService.loop();

      if (!TestService.isTesting) {
        _gameContextObj.gameComService.handToAllChannelStream.listen(
          (nats.Message message) {
            if (!_gameContextObj.gameComService.active) return;

            if (_gameContextObj.handActionService == null) return;

            /* This stream receives hand related messages that is common to all players
                              * e.g
                              * New Hand - contains hand status, dealerPos, sbPos, bbPos, nextActionSeat
                              * Next Action - contains the seat No which is to act next
                              *
                              * This stream also contains the output for the query of current hand */
            _gameContextObj.handActionService.handle(message.string);
          },
        );

        _gameContextObj.gameComService.handToPlayerChannelStream.listen(
          (nats.Message message) {
            if (!_gameContextObj.gameComService.active) return;

            if (_gameContextObj.handActionService == null) return;

            /* This stream receives hand related messages that is specific to THIS player only
                              * e.g
                              * Deal - contains seat No and cards
                              * Your Action - seat No, available actions & amounts */

            if (TestService.isTesting) {
              _gameContextObj.handActionService.handle(message.string);
            } else {
              Future<List<int>> decryptedMessage =
                  _gameContextObj.encryptionService.decrypt(message.data);
              decryptedMessage.then((decryptedBytes) => _gameContextObj
                  .handActionService
                  .handle(utf8.decode(decryptedBytes)));
            }
          },
        );
      }
    }
  }

  void _setupAudioBufferService() {
    // TODO: DO WE NEED THIS?
    AudioBufferService.create().then(
      (Map<String, String> tmpAudioFiles) =>
          Provider.of<ValueNotifier<Map<String, String>>>(
        context,
        listen: false,
      ).value = tmpAudioFiles,
    );
  }

  void _queryCurrentHand() {
    /* THIS METHOD QUERIES THE CURRENT HAND AND POPULATE THE
       GAME SCREEN, IF AND ONLY IF THE GAME IS ALREADY PLAYING */

    if (TestService.isTesting == true) return;

    if (_gameInfoModel?.tableStatus == AppConstants.GAME_RUNNING) {
      // query current hand to get game update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _gameContextObj.handActionService.queryCurrentHand();
      });
    }
  }

  Widget _buildCoreBody(BoardAttributesObject boardAttributes) {
    var dividerTotalHeight = MediaQuery.of(context).size.height / 6;

    final width = MediaQuery.of(context).size.width;

    bool isBoardHorizontal = true;
    final boardDimensions = BoardView.dimensions(context, isBoardHorizontal);

    double tableScale = boardAttributes.tableScale;
    double divider1 =
        boardAttributes.tableDividerHeightScale * dividerTotalHeight;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        BackgroundView(),

        /* main view */
        Column(
          children: [
            _buildAudioWidget(),

            // header view
            HeaderView(gameCode: widget.gameCode),

            // empty space to highlight the background view
            SizedBox(width: width, height: divider1),

            // main board view
            _buildBoardView(boardDimensions, tableScale),

            /* divider that divides the board view and the footer */
            Divider(color: AppColors.dividerColor, thickness: 3),

            // footer section
            _buildFooterView(),
          ],
        ),

        /* chat window widget */
        _buildChatWindow(context),

        /* notification view */
        Notifications.buildNotificationWidget(),
      ],
    );
  }

  Widget _buildBody() {
    // show a progress indicator if the game info object is null
    if (_gameInfoModel == null)
      return Center(child: CircularProgressIndicator());

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
          create: (_) => ValueNotifier<bool>(false),
          builder: (context, _) => _buildCoreBody(boardAttributes),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('GamePlayScreen:  ::build::');

    if (TestService.isTesting) {
      try {
        this._currentPlayer = TestService.currentPlayer;
      } catch (e) {
        print('test data loading error: $e');
      }
    }

    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      child: SafeArea(
        child: Scaffold(
          /* FIXME: THIS FLOATING ACTION BUTTON IS FOR SHOWING THE TESTS */
          floatingActionButton: GamePlayScreenUtilMethods.floatingActionButton(
            onReload: () {},
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: _buildBody(),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  startGame() {
    GamePlayScreenUtilMethods.startGame(widget.gameCode);
    _gameState.myState.gameStatus = GameStatus.RUNNING;
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
        joinAudio();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  leaveAudioConference() {
    if (_gameState != null) {
      _audioPlayer?.pause();
      _voiceTextPlayer?.pause();
      _gameState.janusEngine?.leaveChannel();
    }
  }
}
