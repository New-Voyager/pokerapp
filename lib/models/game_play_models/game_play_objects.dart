import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
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
import 'package:pokerapp/utils/platform.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import 'business/game_chat_notfi_state.dart';
import 'provider_models/marked_cards.dart';
import 'provider_models/seat.dart';
import 'ui/board_attributes_object/board_attributes_object.dart';

// FIXME: THIS NEEDS TO BE CHANGED AS PER DEVICE CONFIG
const kScrollOffsetPosition = 40.0;

class GamePlayObjects {
  String gameCode;
  PlayerInfo currentPlayer;
  GameComService gameComService;
  GameInfoModel gameInfoModel;
  GameContextObject gameContextObj;
  GameState _gameState;
  List<PlayerInSeat> hostSeatChangeSeats;
  bool hostSeatChangeInProgress;
  LocationUpdates locationUpdates;
  Nats _nats;
  NetworkConnectionDialog _dialog;
  BoardAttributesObject boardAttributes;
  Timer timer;
  CustomizationService customizationService;
  bool _initiated = false;
  bool botGame = false;
  BuildContext context;
  AppTextScreen _appScreenText;

  GamePlayObjects();

  Future<void> initialize(BuildContext context, AppTextScreen appScreenText,
      String gameCode) async {
    this.context = context;
    this.gameCode = gameCode;
    this._appScreenText = appScreenText;
  }

  GameState get gameState => _gameState;

  /* _init function is run only for the very first time,
  * and only once, the initial game screen is populated from here
  * also the NATS channel subscriptions are done here */
  Future<GameInfoModel> _fetchGameInfo() async {
    GameInfoModel gameInfo;

    if (customizationService != null) {
      try {
        await customizationService.load();
        gameInfo = customizationService.gameInfo;
        this.currentPlayer = customizationService.currentPlayer;
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
        this.currentPlayer = TestService.currentPlayer;
      } catch (e, s) {
        log('game_play_screen: _fetchGameInfo: $e');
        return null;
      }
    } else {
      debugPrint('fetching game data: ${gameCode}');
      gameInfoModel = gameInfoModel ?? await GameService.getGameInfo(gameCode);
      debugPrint('fetching game data: ${gameCode} done');

      if (PlatformUtils.isWeb) {
        // temporary code
        this.currentPlayer = TestService.currentPlayer;
      } else {
        this.currentPlayer = await PlayerService.getMyInfo(gameCode);
      }
      debugPrint('getting current player: ${gameCode} done');
    }

    // mark the isMe field
    for (int i = 0; i < gameInfo.playersInSeats.length; i++) {
      if (gameInfo.playersInSeats[i].playerUuid == currentPlayer.uuid)
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

  /* The init method returns a Future of all the initial game constants
  * This method is also responsible for subscribing to the NATS channels */
  Future<GameInfoModel> _init(BuildContext context) async {
    // check if there is a gameInfo passed, if not, then fetch the game info
    GameInfoModel gameInfoModel = await _fetchGameInfo();
    ClubInfo clubInfo = ClubInfo();
    if (gameInfoModel.clubCode != null && !gameInfoModel.clubCode.isEmpty) {
      clubInfo = await _fetchClubInfo(gameInfoModel.clubCode);
    }
    hostSeatChangeInProgress = false;
    if (gameInfoModel.status == AppConstants.GAME_PAUSED &&
        gameInfoModel.tableStatus ==
            AppConstants.TABLE_STATUS_HOST_SEATCHANGE_IN_PROGRESS) {
      hostSeatChangeSeats = await SeatChangeService.hostSeatChangeSeatPositions(
        gameInfoModel.gameCode,
      );
      log('host seat change: $hostSeatChangeSeats');
      hostSeatChangeInProgress = true;
    }
    if (_initiated == true) return gameInfoModel;

    log('establishing game communication service');
    gameComService = GameComService(
      currentPlayer: this.currentPlayer,
      gameToPlayerChannel: gameInfoModel.gameToPlayerChannel,
      handToAllChannel: gameInfoModel.handToAllChannel,
      handToPlayerChannel: gameInfoModel.handToPlayerChannel,
      playerToHandChannel: gameInfoModel.playerToHandChannel,
      handToPlayerTextChannel: gameInfoModel.handToPlayerTextChannel,
      gameChatChannel: gameInfoModel.gameChatChannel,
    );

    final encryptionService = EncryptionService();
    // instantiate the dialog object
    _dialog = NetworkConnectionDialog();
    _gameState = GameState();

    if (!TestService.isTesting && customizationService == null) {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);
      _nats = natsClient;
      if (PlatformUtils.isWeb) {
        await natsClient.reconnect();
      } else {
        if (natsClient.connectionBroken) {
          await natsClient.reconnect();
        }
      }

      log('natsClient: $natsClient');
      await gameComService.init(natsClient);
      await encryptionService.init();
    }
    log('game communication service is established');

    final livenessSender = LivenessSender(
      gameInfoModel.gameID,
      gameInfoModel.gameCode,
      currentPlayer.id,
      _nats,
      gameInfoModel.clientAliveChannel,
    );

    _gameState.clubInfo = clubInfo;
    _gameState.isBotGame = botGame;
    if (customizationService != null) {
      _gameState.customizationMode = true;
    }
    _gameState.gameComService = gameComService;

    if (customizationService != null) {
      _gameState = customizationService.gameState;
    } else {
      if (!TestService.isTesting) {
        gameComService.gameMessaging.onPlayerInfo = this.onPlayerInfo;
        gameComService.gameMessaging.getMyInfo = this.getPlayerInfo;
      }
      log('initializing game state');

      await _gameState.initialize(
        gameCode: gameInfoModel.gameCode,
        gameInfo: gameInfoModel,
        currentPlayer: currentPlayer,
        gameMessagingService: gameComService.gameMessaging,
        hostSeatChangeInProgress: hostSeatChangeInProgress,
        hostSeatChangeSeats: hostSeatChangeSeats,
      );
      if (!TestService.isTesting) {
        await _gameState.refreshSettings();
        await _gameState.refreshPlayerSettings();
        await _gameState.refreshNotes();
      }

      // ask for game messages
      // tdo: reqplayerinfo
      // gameComService.gameMessaging.askForChatMessages();
      gameComService.gameMessaging?.requestPlayerInfo();

      log('initializing game state done');
    }

    // _audioPlayer = AudioPlayer();
    log('establishing audio conference');

    if (TestService.isTesting || customizationService != null) {
      // testing code goes here
      gameContextObj = GameContextObject(
        gameCode: gameCode,
        player: this.currentPlayer,
        gameComService: gameComService,
        encryptionService: encryptionService,
        gameState: _gameState,
      );
    } else {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await gameComService.init(natsClient);

      gameContextObj = GameContextObject(
        gameCode: gameCode,
        player: this.currentPlayer,
        gameComService: gameComService,
        encryptionService: encryptionService,
        livenessSender: livenessSender,
        gameState: _gameState,
      );

      // if the current player is in the table, then join audio
      for (int i = 0; i < gameInfoModel.playersInSeats.length; i++) {
        if (gameInfoModel.playersInSeats[i].playerUuid == currentPlayer.uuid) {
          // send my information
          // _gameState.gameMessageService.requestPlayerInfo();

          // this.initPlayingTimer();
          // player is in the table
          joinAudioConference();

          // if gps check is enabled
          if (gameInfoModel.gpsCheck) {
            locationUpdates = new LocationUpdates(_gameState);
            locationUpdates.start();
          }
          break;
        }
      }

      gameContextObj.gameComService.gameMessaging.listen(
        onCards: this._onCards,
        onAudio: this._onAudio,
        onRabbitHunt: this._onRabbitHunt,
      );
    }
    log('establishing audio conference done');

    _initiated = true;

    // setting voiceChatEnable to true if gameComService is active
    log('gameComService.active = ${gameComService.active}');
    if (gameComService.active) {
      _gameState.communicationState.voiceChatEnable = true;
      _gameState.communicationState.notify();
    }
    if (!TestService.isTesting && customizationService == null) {
      _initChatListeners(gameComService.gameMessaging);
    }
    // send my information
    //_gameState.gameMessageService.sendMyInfo();

    if (gameInfoModel?.audioConfEnabled ?? false) {
      log('joining audio conference');

      // initialize agora
      // agora = Agora(
      //     gameCode: widget.gameCode,
      //     uuid: this.currentPlayer.uuid,
      //     playerId: this.currentPlayer.id);
      // if current player is host/admin then put the player in audio chat
      if (currentPlayer.isAdmin()) {
        // join the audio conference
        //await joinAudioConference();
      }

      // if the current player is in the table, then join audio
      for (int i = 0; i < gameInfoModel.playersInSeats.length; i++) {
        if (gameInfoModel.playersInSeats[i].playerUuid == currentPlayer.uuid) {
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
    return gameInfoModel;
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
            //await _reconnectGameComService();
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

  Future<void> init() async {
    log('game screen initState');
    try {
      gameInfoModel = await _init(context);
    } catch (e) {
      log(e.toString());
      throw e;
      //if (mounted) Navigator.pop(context);
    }
  }

  void close() {
    // timer?.cancel();

    try {
      if (locationUpdates != null) {
        locationUpdates.stop();
      }
      gameContextObj?.dispose();
      _gameState?.close();
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }
  }

  void dispose() {
    timer?.cancel();

    if (_gameState != null) {
      _gameState.uiClosing = true;
    }

    if (_nats != null) {
      _nats.disconnectListeners.remove(this.onNatsDisconnect);
    }

    if (locationUpdates != null) {
      locationUpdates.stop();
      locationUpdates = null;
    }
    leaveAudioConference();
  }

  void _sendMarkedCards(BuildContext context) {
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

  void initSendCardAfterFold(BuildContext context) {
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
          // if (mounted) {
          //   _gameState.audioConfState.joinedConf();
          // }
        }).onError((error, stackTrace) {
          // do nothing
        });
      } else if (_gameState.audioConfState.leave) {
        leaveAudioConference().then((value) {
          // if (mounted) {
          //   _gameState.audioConfState.leftConf();
          // }
        }).onError((error, stackTrace) {
          // do nothing
        });
      }
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
        if (locationUpdates == null) {
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
        // if (demoHelpText != null) {
        //   demoHelpText.dismiss();
        // }
        await GamePlayScreenUtilMethods.joinGame(
          context: this.context,
          seat: seat,
          gameCode: gameCode,
          gameState: gameState,
        );

        // player joined the game (send player info)
        // _gameState.gameMessageService.sendMyInfo();
        // _gameState.gameMessageService.requestPlayerInfo();

        if (_gameState.gameInfo.gpsCheck || _gameState.gameInfo.ipCheck) {
          locationUpdates = locationUpdates;
          locationUpdates.start();
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

  Future<void> leaveAudioConference() async {
    if (_gameState != null) {
      gameContextObj?.leaveAudio();
    }
  }

  Future<void> joinAudioConference() async {
    if (TestService.isTesting || _gameState.customizationMode) {
      return;
    }
    if (context != null) {
      if (!_gameState.uiClosing) {
        if (_gameState.isPlaying) {
          if (gameContextObj.joiningAudio) {
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

            await gameContextObj.joinAudio(context);

            if (!PlatformUtils.isWeb) {
              _gameState.gameMessageService.sendMyInfo();
            }
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
    playerInfo.playerId = currentPlayer.id;
    playerInfo.name = currentPlayer.name;
    playerInfo.uuid = currentPlayer.uuid;
    if (_gameState.me != null) {
      playerInfo.streamId = _gameState.me.streamId;
      playerInfo.namePlateId = _gameState.me.namePlateId;
    }
    return playerInfo;
  }

  final ScrollController _gcsController = ScrollController();

  bool _isChatScreenVisible = false;

  void showGameChat(BuildContext context) async {
    gameState.chatScreenVisible = true;

    await showGeneralDialog(
      barrierLabel: "Chat",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.10),
      context: context,
      pageBuilder: (context, _, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider<GameContextObject>.value(
              value: gameContextObj),
          ChangeNotifierProvider<GameChatNotifState>.value(
              value: gameState.gameChatNotifState),
        ],
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GameChat(
            scrollController: _gcsController,
            chatService: gameContextObj.gameComService.gameMessaging,
            gameState: gameState,
          ),
        ),
      ),
    );

    gameState.chatScreenVisible = false;
  }

  void _onChatMessage(ChatMessage message) {
    if (gameState.chatScreenVisible) {
      gameState.gameChatNotifState.notifyNewMessage();
      // notify of new messages & rebuild the game message list
      /* if user is scrolled away, we need to notify */
      if (_gcsController.hasClients &&
          (_gcsController.offset > kScrollOffsetPosition)) {
        if (message.fromPlayer != gameState.currentPlayer.id) {
          gameState.gameChatNotifState.addUnread();
        }
      }
    } else {
      gameState.gameChatNotifState.addUnread();
    }

    gameState.gameChatBubbleNotifyState.addBubbleMessge(message);
  }

  void _initChatListeners(GameMessagingService gms) {
    gms.listen(
      onText: (ChatMessage message) => _onChatMessage(message),
      onGiphy: (ChatMessage message) => _onChatMessage(message),
      onSticker: (ChatMessage message) => _onChatMessage(message),
    );

    _gcsController.addListener(() {
      if (_gcsController.offset < kScrollOffsetPosition) {
        context.read<GameChatNotifState>().readAll();
      }
    });
  }
}
