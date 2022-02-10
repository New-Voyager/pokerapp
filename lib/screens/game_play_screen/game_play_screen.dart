import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';
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
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/app_constants.dart';
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
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/drawer/game_play_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

import '../../main_helper.dart';
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
  Nats _nats;
  NetworkConnectionDialog _dialog;
  BoardAttributesObject boardAttributes;

  // instantiate a drawer controller
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      debugPrint('fetching game data: ${widget.gameCode}');
      gameInfo = widget.gameInfoModel ??
          await GameService.getGameInfo(widget.gameCode);
      debugPrint('fetching game data: ${widget.gameCode} done');
      this._currentPlayer = await PlayerService.getMyInfo(widget.gameCode);
      debugPrint('getting current player: ${widget.gameCode} done');
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

    if (widget.customizationService != null) {
    } else if (TestService.isTesting) {
      return clubInfo;
    } else {
      debugPrint('fetching club data: ${widget.gameCode}');
      try {
        clubInfo = await ClubsService.getClubInfoForGame(clubCode);
        return clubInfo;
      } catch (e) {
        // we can still run the game
      }
      debugPrint('fetching club data: ${widget.gameCode} done');
    }
    return clubInfo;
  }

  /* The init method returns a Future of all the initial game constants
  * This method is also responsible for subscribing to the NATS channels */
  Future<GameInfoModel> _init() async {
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
    if (_initiated == true) return _gameInfoModel;

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

    if (!TestService.isTesting && widget.customizationService == null) {
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
    _gameState.isBotGame = widget.botGame;
    if (widget.customizationService != null) {
      _gameState.customizationMode = true;
    }
    _gameState.gameComService = _gameComService;

    if (widget.customizationService != null) {
      _gameState = widget.customizationService.gameState;
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
    if (!TestService.isTesting && widget.customizationService == null) {
      _initChatListeners(_gameComService.gameMessaging);
    }
    // send my information
    //_gameState.gameMessageService.sendMyInfo();

    if (_gameInfoModel?.audioConfEnabled ?? false) {
      log('joining audio conference');

      // initialize agora
      // agora = Agora(
      //     gameCode: widget.gameCode,
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
            await _reconnectGameComService();
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

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    appState.removeGameCode();

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
    // if (_gameContextObj != null &&
    //     _gameContextObj.ionAudioConferenceService != null) {
    //   _gameContextObj.ionAudioConferenceService.leave();
    // }

    if (_binding != null) {
      _binding.removeObserver(this);
    }

    close();
    super.dispose();
  }

  void _sendMarkedCards(BuildContext context) {
    if (TestService.isTesting || widget.customizationService != null) return;
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

  void _showGameChat(BuildContext context) async {
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
      // if the game is paused, don't let the user to switch
      if (tableState.gameStatus == AppConstants.GAME_PAUSED) {
        showErrorDialog(
            context, 'Error', 'Cannot switch seat when game is paused');
        return;
      }

      log('Player ${me.name} switches seat to ${seat.serverSeatPos}');
      try {
        await SeatChangeService.switchSeat(widget.gameCode, seat.serverSeatPos);
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
        await GamePlayScreenUtilMethods.joinGame(
          context: _providerContext,
          seat: seat,
          gameCode: widget.gameCode,
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

  @override
  void initState() {
    super.initState();

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
    _voiceTextPlayer = AudioPlayer();

    // Register listener for lifecycle methods
    WidgetsBinding.instance.addObserver(this);
    _binding.addObserver(this);

    init().then((v) {
      Future.delayed(Duration(seconds: 1), () async {
        if (!TestService.isTesting) {
          _queryCurrentHandIfNeeded();
          final nats = context.read<Nats>();
          log('dartnats: adding to disconnectListeners');
          nats.disconnectListeners.add(this.onNatsDisconnect);
        }
      });

      if (appService.appSettings.showRefreshBanner) {
        appService.appSettings.showRefreshBanner = false;
        Alerts.showNotification(
            duration: Duration(seconds: 8),
            titleText: 'Beta Issue',
            subTitleText:
                "If you see any issues in this screen or in the audio conference, go back from this game screen and return to this screen. Most issues will be resolved. You will still be in the game and in the hand.");
      }
      if (appService.appSettings.showReportInfoDialog) {
        appService.appSettings.showReportInfoDialog = false;

        // showErrorDialog(context, 'Report an issue?',
        //     "If you run into any issues while using the app or want us to implement a feature, please tap the hamburger menu on the bottom left and tap Report Issue.",
        //     info: true);
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
      Navigator.pop(context);
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
      _voiceTextPlayer?.dispose();
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }
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
    );

    _gcsController.addListener(() {
      if (_gcsController.offset < kScrollOffsetPosition) {
        _providerContext.read<GameChatNotifState>().readAll();
      }
    });
  }

//<<<<<<< HEAD
  // Widget _buildChatWindow() => Consumer<ValueNotifier<bool>>(
  //       builder: (context, vnChatVisibility, __) {
  //         _isChatScreenVisible = vnChatVisibility.value;
  //         return AnimatedSwitcher(
  //           duration: const Duration(milliseconds: 200),
  //           child: vnChatVisibility.value
  //               ? Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: GameChat(
  //                     scrollController: _gcsController,
  //                     chatService: _gameContextObj.gameComService.gameMessaging,
  //                     onChatVisibilityChange: () => _toggleChatVisibility(
  //                       context,
  //                     ),
  //                   ),
  //                 )
  //               : const SizedBox.shrink(),
  //         );
  //       },
  //     );
// =======
//   Widget _buildChatWindow() {
//     return Consumer<ValueNotifier<bool>>(
//       builder: (context, vnChatVisibility, __) {
//         _isChatScreenVisible = vnChatVisibility.value;
//         return AnimatedSwitcher(
//           duration: const Duration(milliseconds: 200),
//           child: vnChatVisibility.value
//               ? Align(
//                   alignment: Alignment.bottomCenter,
//                   child: GameChat(
//                     scrollController: _gcsController,
//                     chatService: _gameContextObj.gameComService.gameMessaging,
//                     onChatVisibilityChange: () => _toggleChatVisibility(
//                       context,
//                     ),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         );
//       },
//     );
//   }
// >>>>>>> master

  Widget _buildBoardView(Size boardDimensions, double boardScale) {
    // log('RedrawTop: Rebuilding board view');
    return Container(
      // key: UniqueKey(),
      width: boardDimensions.width,
      height: boardDimensions.height,
      child: Transform.scale(
        scale: boardScale,
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

        // if nats connection is broken, reconnect
        _gameContextObj.handActionProtoService.queryCurrentHand();
      });
    }
  }

  Widget _buildCoreBody(
    BuildContext context,
    BoardAttributesObject boardAttributes,
  ) {
    final width = MediaQuery.of(context).size.width;

    final boardDimensions = boardAttributes.dimensions(context);
    double boardScale = boardAttributes.boardScale;
    final theme = AppTheme.getTheme(context);

    List<Widget> children = [];

    Widget headerView;
    if (this.widget.showTop) {
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
        headerView = Container(
          width: Screen.width,
          child: HeaderView(
            gameState: _gameState,
            scaffoldKey: _scaffoldKey,
          ),
        );
      }

      children.addAll(
        [
          // main board view
          Stack(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.topCenter,
            children: [
              this.widget.showTop && _gameState.customizationMode
                  ? Positioned(
                      top: 10.ph,
                      left: width - 50.pw,
                      child: CircleImageButton(
                        onTap: () async {
                          await Navigator.of(context)
                              .pushNamed(Routes.select_table);
                          await _gameState.assets.initialize();
                          final redrawTop = _gameState.redrawBoardSectionState;
                          redrawTop.notify();
                          setState(() {});
                        },
                        theme: theme,
                        icon: Icons.edit,
                      ),
                    )
                  : Container(),

              // board view
              Positioned(
                top: 0, //Screen.height / 2,
                child: _buildBoardView(
                  boardDimensions,
                  boardScale,
                ),
              ),
            ],
          ),

          /* divider that divides the board view and the footer */
          // Divider(color: AppColorsNew.dividerColor, thickness: 3),
        ],
      );
    }

    Widget topView = Stack(
      children: children,
    );

    List<Widget> gameScreenChildren = [];
    if (widget.showTop) {
      gameScreenChildren.add(headerView);
      // top view
      gameScreenChildren.add(
        Container(
          clipBehavior: Clip.none,
          height: boardDimensions.height,
          width: Screen.width,
          child: topView,
        ),
      );
    }

    if (widget.showBottom) {
      gameScreenChildren.add(Align(
        alignment: Alignment.bottomCenter,
        child: Consumer<RedrawFooterSectionState>(
          builder: (_, ___, __) {
            log('RedrawFooter: building footer view');
            return FooterViewWidget(
                gameCode: widget.gameCode,
                gameContextObject: _gameContextObj,
                currentPlayer: _gameContextObj.gameState.currentPlayer,
                gameInfo: _gameInfoModel,
                toggleChatVisibility: _showGameChat,
                onStartGame: startGame);
          },
        ),
      ));
    }
    Widget column = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: gameScreenChildren,
    );

    Stack allWidgets = Stack(children: [
      column,

      /* chat window widget */
      // this.widget.showBottom ? _buildChatWindow() : const SizedBox.shrink(),
    ]);
    return allWidgets;
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

  void _reconnectGameComService() async {
    log('network_reconnect: _reconnectGameComService invoked');
    final nats = context.read<Nats>();
    if (nats.connectionBroken) {
      await nats.reconnect();
    }

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
          /* FIXME: THIS FLOATING ACTION BUTTON IS FOR SHOWING THE TESTS */
          floatingActionButton: GamePlayScreenUtilMethods.floatingActionButton(
            onReload: () {},
            isCustomizationMode: widget.customizationService != null,
          ),
          // floating button to refresh network TEST
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.android_rounded),
          //   onPressed: _reconnectGameComService,
          // ),
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

  Future<void> leaveAudioConference() async {
    if (_gameState != null) {
      _voiceTextPlayer?.pause();
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
}
