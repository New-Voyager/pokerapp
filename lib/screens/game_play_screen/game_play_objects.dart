import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/main_helper.dart';
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
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_chat.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/location_updates.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/connectivity_check/liveness_sender.dart';
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

// FIXME: THIS NEEDS TO BE CHANGED AS PER DEVICE CONFIG
const kScrollOffsetPosition = 40.0;

class GamePlayObjects {
  String gameCode;
  bool _initiated;
  BuildContext context;
  BuildContext _providerContext;
  PlayerInfo _currentPlayer;
  GameComService _gameComService;
  GameInfoModel _gameInfoModel;
  GameContextObject _gameContextObj;
  GameState _gameState;
  List<PlayerInSeat> _hostSeatChangeSeats;
  bool _hostSeatChangeInProgress;
  LocationUpdates _locationUpdates;
  Nats _nats;
  NetworkConnectionDialog _dialog;
  BoardAttributesObject boardAttributes;
  OverlaySupportEntry demoHelpText = null;
  AppTextScreen _appScreenText;
  CustomizationService customizationService;
  GameInfoModel gameInfoModel;
  bool botGame;

  GamePlayObjects();

  GameState get gameState => _gameState;
  GameContextObject get gameContextObj => _gameContextObj;
  BuildContext get providerContext => _providerContext;
  List<PlayerInSeat> get hostSeatChangeSeats => _hostSeatChangeSeats;
  bool get hostSeatChangeInProgress => _hostSeatChangeInProgress;
  PlayerInfo get currentPlayer => _currentPlayer;
  Nats get nats => _nats;
  LocationUpdates get locationUpdates => _locationUpdates;
  void set locationUpdates(LocationUpdates locationUpdates) {
    _locationUpdates = locationUpdates;
  }

  void set currentPlayer(PlayerInfo player) {
    _currentPlayer = player;
  }

  void set providerContext(BuildContext context) {
    _providerContext = context;
  }

  void initialize(
      {BuildContext context,
      bool botGame,
      String gameCode,
      GameInfoModel gameInfoModel,
      AppTextScreen appScreenText,
      CustomizationService customizationService}) {
    this.gameCode = gameCode;
    this.gameInfoModel = gameInfoModel;
    this._appScreenText = appScreenText;
    this.customizationService = customizationService;
    this.botGame = botGame;
    this.context = context;
    this.boardAttributes = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
    );
  }

  /* _init function is run only for the very first time,
  * and only once, the initial game screen is populated from here
  * also the NATS channel subscriptions are done here */
  Future<GameInfoModel> _fetchGameInfo() async {
    GameInfoModel gameInfo;

    if (customizationService != null) {
      try {
        await customizationService.load();
        gameInfo = customizationService.gameInfo;
        this._currentPlayer = customizationService.currentPlayer;
      } catch (e, s) {
        log('customization load failed: $e');
        return null;
      }
    } else if (TestService.isTesting) {
      try {
        log('Loading game from test data');
        // load test data
        await TestService.load();
        gameInfo = TestService.gameInfo;
        this._currentPlayer = TestService.currentPlayer;
      } catch (e, s) {
        log('game_play_screen: _fetchGameInfo: $e');
        return null;
      }
    } else {
      debugPrint('fetching game data: ${gameCode}');
      gameInfo = gameInfoModel ?? await GameService.getGameInfo(gameCode);
      debugPrint('fetching game data: ${gameCode} done');
      this._currentPlayer = await PlayerService.getMyInfo(gameCode);
      debugPrint('getting current player: ${gameCode} done');
    }

    // mark the isMe field
    for (int i = 0; i < gameInfo.playersInSeats.length; i++) {
      if (gameInfo.playersInSeats[i].playerUuid == _currentPlayer.uuid)
        gameInfo.playersInSeats[i].isMe = true;
    }
    return gameInfo;
  }

  Future<ClubInfo> _fetchClubInfo(String clubCode) async {
    ClubInfo clubInfo = ClubInfo();

    if (customizationService != null) {
    } else if (TestService.isTesting) {
      return clubInfo;
    } else {
      debugPrint('fetching club data: ${gameCode}');
      try {
        clubInfo = await ClubsService.getClubInfoForGame(clubCode);
        return clubInfo;
      } catch (e) {
        // we can still run the game
      }
      debugPrint('fetching club data: ${gameCode} done');
    }
    return clubInfo;
  }

  void onNatsDisconnect() async {
    log('dartnats: onNatsDiconnect');
    if (_gameState != null && _gameState.uiClosing) {
      return;
    }

    if (_nats != null && _nats.connectionBroken) {
      final BuildContext context = navigatorKey.currentState.overlay.context;
      // we don't have connection to Nats server
      _dialog?.show(
        context: context,
        loadingText: 'Connecting ...',
      );
      try {
        log('1 dartnats: Reconnecting');
        while (!_gameState.uiClosing && _nats != null) {
          if (!await _nats.connectionBroken) {
            log('1 dartnats: Connection is not broken');
            break;
          }
          log('2 dartnats: Reconnecting');
          bool ret = await _nats.tryReconnect();
          if (ret) {
            log('dartnats: Connection is available. Reconnecting');
            await _nats.reconnect();
            // resubscribe to messages
            await reconnectGameComService();
            log('dartnats: reconnected. _nats.connectionBroken ${_nats.connectionBroken}');
            break;
          }
          //await _nats.reconnect();
          log('3 dartnats: Reconnecting connection broken: ${_nats.connectionBroken}');
          // wait for a bit
          await Future.delayed(const Duration(milliseconds: 1000));
          log('4 dartnats: Trying to reconnect');
        }
      } catch (err) {}
      // if we are outside the while loop, means we have internet connection
      // dismiss the dialog box
      _dialog?.dismiss(context: context);
    }
  }

  void reconnectGameComService() async {
    log('network_reconnect: _reconnectGameComService invoked');
    final nats = context.read<Nats>();
    if (nats.connectionBroken) {
      await nats.reconnect();
    }

    // drop connections -> re establish connections
    await _gameComService.reconnect(nats);

    // query current hand
    queryCurrentHandIfNeeded();
  }

  void queryCurrentHandIfNeeded() {
    /* THIS METHOD QUERIES THE CURRENT HAND AND POPULATE THE
       GAME SCREEN, IF AND ONLY IF THE GAME IS ALREADY PLAYING */

    if (TestService.isTesting == true || customizationService != null) return;

    if (_gameInfoModel?.tableStatus == AppConstants.GAME_RUNNING) {
      // query current hand to get game update
      WidgetsBinding.instance.addPostFrameCallback((_) {
        log('network_reconnect: queryCurrentHand invoked');

        // if nats connection is broken, reconnect
        _gameContextObj.handActionProtoService.queryCurrentHand();
      });
    }
  }

  startGame() async {
    try {
      ConnectionDialog.show(context: context, loadingText: "Starting...");
      await GamePlayScreenUtilMethods.startGame(gameCode);
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

  Future<void> leaveAudioConference() async {
    if (_gameState != null) {
      _gameContextObj?.leaveAudio();
    }
  }

  Future<void> joinAudioConference() async {
    if (TestService.isTesting || _gameState.customizationMode) {
      return;
    }
    if (context != null) {
      if (!_gameState.uiClosing) {
        if (_gameState.isPlaying) {
          if (_gameContextObj.joiningAudio) {
            return;
          }
          if (!_gameState.gameInfo.audioConfEnabled) {
            return;
          }
          if (!_gameState.playerLocalConfig.inCall) {
            return;
          }
          OverlaySupportEntry notification;
          try {
            notification = Alerts.showNotification(
              titleText: _appScreenText['audioTitle'],
              subTitleText: _appScreenText['joiningAudio'],
              leadingIcon: Icons.mic_sharp,
            );

            await _gameContextObj.joinAudio(context);
            _gameState.gameMessageService.sendMyInfo();
            // ui is still running
            // send stream id
            log('AudioConf: 1 Requesting information about the other players');
            // _gameState.gameMessageService.requestPlayerInfo();
            notification.dismiss();
            notification = Alerts.showNotification(
                titleText: _appScreenText['audioTitle'],
                subTitleText: _appScreenText['joinedAudio'],
                leadingIcon: Icons.mic_sharp,
                duration: Duration(seconds: 2));
          } catch (err) {
            if (notification != null) {
              notification.dismiss();
            }
          }
        }
      }
    }
  }

  void onPlayerInfo(GamePlayerInfo info) {
    log('player: ${info.name} has joined the game');
    // story player information
    _gameState.players[info.playerId] = info;
  }

  GamePlayerInfo getPlayerInfo() {
    GamePlayerInfo playerInfo = GamePlayerInfo();
    playerInfo.playerId = _currentPlayer.id;
    playerInfo.name = _currentPlayer.name;
    playerInfo.uuid = _currentPlayer.uuid;
    if (_gameState.me != null) {
      playerInfo.streamId = _gameState.me.streamId;
      playerInfo.namePlateId = _gameState.me.namePlateId;
    }
    return playerInfo;
  }

  final ScrollController _gcsController = ScrollController();

  bool _isChatScreenVisible = false;

  void _onChatMessage(ChatMessage message) {
    if (this._gameState.chatScreenVisible) {
      _gameState.gameChatNotifState.notifyNewMessage();
      // notify of new messages & rebuild the game message list
      /* if user is scrolled away, we need to notify */
      if (_gcsController.hasClients &&
          (_gcsController.offset > kScrollOffsetPosition)) {
        if (message.fromPlayer != this._gameState.currentPlayer.id) {
          _gameState.gameChatNotifState.addUnread();
        }
      }
    } else {
      _gameState.gameChatNotifState.addUnread();
    }

    _gameState.gameChatBubbleNotifyState.addBubbleMessge(message);
  }

  void _initChatListeners(GameMessagingService gms) {
    gms.listen(
      onText: (ChatMessage message) => _onChatMessage(message),
      onGiphy: (ChatMessage message) => _onChatMessage(message),
      onSticker: (ChatMessage message) => _onChatMessage(message),
    );

    _gcsController.addListener(() {
      if (_gcsController.offset < kScrollOffsetPosition) {
        _providerContext.read<GameChatNotifState>().readAll();
      }
    });
  }

  // Timer _timer;
  /* The init method returns a Future of all the initial game constants
  * This method is also responsible for subscribing to the NATS channels */
  Future<GameInfoModel> load() async {
    // check if there is a gameInfo passed, if not, then fetch the game info
    GameInfoModel _gameInfoModel = await _fetchGameInfo();
    ClubInfo clubInfo = ClubInfo();
    if (_gameInfoModel.clubCode != null && !_gameInfoModel.clubCode.isEmpty) {
      clubInfo = await _fetchClubInfo(_gameInfoModel.clubCode);
    }
    _hostSeatChangeInProgress = false;
    if (_gameInfoModel.status == AppConstants.GAME_PAUSED &&
        _gameInfoModel.tableStatus ==
            AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      _hostSeatChangeSeats =
          await SeatChangeService.hostSeatChangeSeatPositions(
        _gameInfoModel.gameCode,
      );
      log('host seat change: $_hostSeatChangeSeats');
      _hostSeatChangeInProgress = true;
    }
    gameInfoModel = _gameInfoModel;
    if (_initiated == true) {
      return _gameInfoModel;
    }

    log('establishing game communication service');
    _gameComService = GameComService(
      currentPlayer: this._currentPlayer,
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
      handToPlayerTextChannel: _gameInfoModel.handToPlayerTextChannel,
      gameChatChannel: _gameInfoModel.gameChatChannel,
    );

    final encryptionService = EncryptionService();
    // instantiate the dialog object
    _dialog = NetworkConnectionDialog();
    _gameState = GameState();

    if (!TestService.isTesting && customizationService == null) {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);
      _nats = natsClient;
      if (natsClient.connectionBroken) {
        await natsClient.reconnect();
      }

      log('natsClient: $natsClient');
      await _gameComService.init(natsClient);
      await encryptionService.init();
    }
    log('game communication service is established');

    final livenessSender = LivenessSender(
      _gameInfoModel.gameID,
      _gameInfoModel.gameCode,
      _currentPlayer.id,
      _nats,
      _gameInfoModel.clientAliveChannel,
    );

    _gameState.clubInfo = clubInfo;
    _gameState.isBotGame = botGame;
    if (customizationService != null) {
      _gameState.customizationMode = true;
    }
    _gameState.gameComService = _gameComService;

    if (customizationService != null) {
      _gameState = customizationService.gameState;
    } else {
      if (!TestService.isTesting) {
        _gameComService.gameMessaging.onPlayerInfo = this.onPlayerInfo;
        _gameComService.gameMessaging.getMyInfo = this.getPlayerInfo;
      }
      log('initializing game state');

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

      // ask for game messages
      // tdo: reqplayerinfo
      // _gameComService.gameMessaging.askForChatMessages();
      _gameComService.gameMessaging?.requestPlayerInfo();

      log('initializing game state done');
    }

    // _audioPlayer = AudioPlayer();
    log('establishing audio conference');

    if (TestService.isTesting || customizationService != null) {
      // testing code goes here
      _gameContextObj = GameContextObject(
        gameCode: gameCode,
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
        gameCode: gameCode,
        player: this._currentPlayer,
        gameComService: _gameComService,
        encryptionService: encryptionService,
        livenessSender: livenessSender,
        gameState: _gameState,
      );

      // if the current player is in the table, then join audio
      for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
        if (_gameInfoModel.playersInSeats[i].playerUuid ==
            _currentPlayer.uuid) {
          // send my information
          // _gameState.gameMessageService.requestPlayerInfo();

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
    log('establishing audio conference done');

    _initiated = true;

    // setting voiceChatEnable to true if gameComService is active
    log('gameComService.active = ${_gameComService.active}');
    if (_gameComService.active) {
      _gameState.communicationState.voiceChatEnable = true;
      _gameState.communicationState.notify();
    }
    if (!TestService.isTesting && customizationService == null) {
      _initChatListeners(_gameComService.gameMessaging);
    }
    // send my information
    //_gameState.gameMessageService.sendMyInfo();

    if (_gameInfoModel?.audioConfEnabled ?? false) {
      log('joining audio conference');

      // initialize agora
      // agora = Agora(
      //     gameCode: gameCode,
      //     uuid: this._currentPlayer.uuid,
      //     playerId: this._currentPlayer.id);
      // if current player is host/admin then put the player in audio chat
      if (_currentPlayer.isAdmin()) {
        // join the audio conference
        //await joinAudioConference();
      }

      // if the current player is in the table, then join audio
      for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
        if (_gameInfoModel.playersInSeats[i].playerUuid ==
            _currentPlayer.uuid) {
          // send my information
          //_gameState.gameMessageService.sendMyInfo();
          // _gameState.gameMessageService.requestPlayerInfo();
          // request other player info
          // player is in the table
          joinAudioConference();
          break;
        }
      }
      log('joining audio conference done');
    } else {}
    Future.delayed(Duration(seconds: 3), () {
      log('publishing my information');
      _gameState.gameMessageService?.sendMyInfo();
      log('publishing my information done');
    });
    return _gameInfoModel;
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
    if (message.audio != null && message.audio.length > 0) {
      if (seat != null && seat.player != null) {
        seat.player.talking = true;
        seat.notify();
        try {
          AudioService.playVoice(message.audio).then((value) {
            seat.player.talking = false;
            seat.notify();
          }).onError((error, stackTrace) {
            seat.player.talking = false;
            seat.notify();
          });
        } catch (e) {
          // ignore the exception
        }
      } else {
        // Play voice text from observer.
        try {
          int res = await AudioService.playVoice(message.audio);
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

  void showGameChat(BuildContext context) async {
    _gameState.chatScreenVisible = true;

    await showGeneralDialog(
      barrierLabel: "Chat",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.10),
      context: context,
      pageBuilder: (context, _, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider<GameContextObject>.value(
              value: _gameContextObj),
          ChangeNotifierProvider<GameChatNotifState>.value(
              value: _gameState.gameChatNotifState),
        ],
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GameChat(
            scrollController: _gcsController,
            chatService: _gameContextObj.gameComService.gameMessaging,
            gameState: _gameState,
          ),
        ),
      ),
    );

    _gameState.chatScreenVisible = false;
  }

  void showDemoGameHelp() {
    Future.delayed(Duration(seconds: 1), () {
      demoHelpText = Alerts.showNotification(
        titleText: "Tap on Open Seat to Join the Game!",
        duration: Duration(seconds: 5),
      );
    });
  }

  Future onJoinGame(Seat seat) async {
    final gameState = _gameState;
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
        await SeatChangeService.switchSeat(gameCode, seat.serverSeatPos);
      }
      log('Ignoring the open seat tap as the player is seated and game is running');
      return;
    }

    if (me != null && me.seatNo != null && me.seatNo != 0) {
      // if the game is paused, don't let the user to switch
      if (tableState.gameStatus == AppConstants.GAME_PAUSED) {
        showErrorDialog(
            context, 'Error', 'Cannot switch seat when game is paused');
        return;
      }

      log('Player ${me.name} switches seat to ${seat.serverSeatPos}');
      try {
        await SeatChangeService.switchSeat(gameCode, seat.serverSeatPos);
      } catch (err) {
        showErrorDialog(context, 'Switch Seat', 'Switching seat failed');
      }
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

        // dismiss demo help text
        if (demoHelpText != null) {
          demoHelpText.dismiss();
        }
        await GamePlayScreenUtilMethods.joinGame(
          context: _providerContext,
          seat: seat,
          gameCode: gameCode,
          gameState: gameState,
        );

        // player joined the game (send player info)
        // _gameState.gameMessageService.sendMyInfo();
        // _gameState.gameMessageService.requestPlayerInfo();

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
            } else if (e.code == 'SEAT_RESERVED') {
              showErrorDialog(context, 'Error', e.message);
              if (e.extensions['seatNo'] != null) {
                final seatNo = int.parse(e.extensions['seatNo']);
                final seat = gameState.getSeat(seatNo);
                if (seat != null && seat.isOpen) {
                  seat.reserved = true;
                  seat.notify();
                }
              }
            } else {
              showErrorDialog(context, 'Error', e.message);
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

  void sendMarkedCards(BuildContext context) {
    if (TestService.isTesting || customizationService != null) return;
    final MarkedCards markedCards = _gameState.markedCardsState;
    if (_gameState.handState != HandState.RESULT) {
      return;
    }

    /* collect the cards needs to be revealed */
    List<CardObject> _cardsToBeRevealed = markedCards.getCards();
    // log('RevealCards: Trying to sending marked cards ${_cardsToBeRevealed}');
    List<int> cardNumbers = [];
    for (final c in _cardsToBeRevealed) {
      cardNumbers.add(c.cardNum);
    }

    if (cardNumbers.length == 0) {
      return;
    }
    // log('RevealCards: cards sent ${cardNumbers}');
    markedCards.cardsSent(cardNumbers);
    // log('GameScreen: Sending cards');

    /* clear all the marked cards */
    // FIXME: markedCards.clear();

    final me = _gameState.me;
    _gameState.gameMessageService.sendCards(
      context.read<HandInfoState>().handNum,
      cardNumbers,
      me?.seatNo,
    );
  }
}
