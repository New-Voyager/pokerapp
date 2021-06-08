import 'dart:developer';
import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/game_chat.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
//import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/util_action_services.dart';
import 'package:pokerapp/services/game_play/action_services/game_update_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/utils/audio_buffer.dart';
import 'package:pokerapp/services/janus/janus.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

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

  // NOTE: Enable this for agora audio testing
  GamePlayScreen({
    @required this.gameCode,
  }) : assert(gameCode != null);

  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen>
    with AfterLayoutMixin<GamePlayScreen> {
  bool _initiated;
  BuildContext _providerContext;
  PlayerInfo _currentPlayer;

  // String _audioToken = '';
  // bool liveAudio = true;
  AudioPlayer _audioPlayer;
  //Agora agora;
  GameInfoModel _gameInfoModel;
  GameContextObject _gameContextObj;
  GameState _gameState;

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
      } catch (e) {
        print('test data loading error: $e');
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

    if (_initiated == true) return _gameInfoModel;

    final gameComService = GameComService(
      currentPlayer: this._currentPlayer,
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
      gameChatChannel: _gameInfoModel.gameChatChannel,
    );

    if (!TestService.isTesting) {
      // subscribe the NATs channels
      final natsClient = Provider.of<Nats>(context, listen: false);

      log('natsClient: $natsClient');
      await gameComService.init(natsClient);
    }

    _gameState = GameState();
    _gameState.initialize(
      gameCode: _gameInfoModel.gameCode,
      gameInfo: _gameInfoModel,
      currentPlayer: _currentPlayer,
      gameMessagingService: gameComService.gameMessaging,
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

    _audioPlayer = AudioPlayer();

    if (TestService.isTesting) {
      // testing code goes here
      _gameContextObj = GameContextObject(
        gameCode: widget.gameCode,
        player: this._currentPlayer,
        gameComService: gameComService,
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
      );
    }

    _initiated = true;

    print('gameInfo players: ${_gameInfoModel.playersInSeats}');

    return _gameInfoModel;
  }

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    // TestService.isTesting = false;
    try {
      _gameContextObj?.dispose();
      // agora?.disposeObject();
      // Audio.dispose(context: _providerContext);
      _gameState?.janusEngine?.disposeObject();

      if (_audioPlayer != null) {
        _audioPlayer.dispose();
        _audioPlayer = null;
      }
    } catch (e) {
      log('Caught exception: ${e.toString()}');
    }

    super.dispose();
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
    if (_audioPlayer != null &&
        message.audio != null &&
        message.audio.length > 0) {
      if (seat != null && seat.player != null) {
        seat.player.talking = true;
        seat.notify();
        try {
          int res = await _audioPlayer.playBytes(message.audio);
          if (res == 1) {
            log("Pls wait for ${message.duration} seconds");
            await Future.delayed(Duration(seconds: message.duration ?? 0));
          }

          seat.player.talking = false;
          seat.notify();
        } catch (e) {
          // ignore the exception
        }
      }
    }
  }

  void onAnimation(ChatMessage message) async {
    log('Animation message is sent ${message.messageId} from player ${message.fromSeat} to ${message.toSeat}. Animation id: ${message.animationID}');
    // todo initiate animation
  }

  void toggleChatVisibility(BuildContext context) {
    ValueNotifier<bool> chatVisibilityNotifier =
        Provider.of<ValueNotifier<bool>>(
      context,
      listen: false,
    );
    chatVisibilityNotifier.value = !chatVisibilityNotifier.value;
  }

  Future onJoinGame(int seatPos) async {
    final gameState = GameState.getState(_providerContext);
    final me = gameState.me(_providerContext);

    if (me != null && me.seatNo != null && me.seatNo != 0) {
      log('Player ${me.name} switches seat to $seatPos');
      await GameService.switchSeat(widget.gameCode, seatPos);
    } else {
      try {
        await GamePlayScreenUtilMethods.joinGame(
          seatPos: seatPos,
          gameCode: widget.gameCode,
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
    log('game screen initState');
    /* the init method is invoked only once */
    _init().then(
      (gameInfoModel) => setState(
        () => _gameInfoModel = gameInfoModel,
      ),
    );
  }

  Widget _buildChatWindow(BuildContext context) =>
      Consumer<ValueNotifier<bool>>(
        builder: (_, vnChatVisibility, __) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: vnChatVisibility.value
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: GameChat(
                    chatService:
                        this._gameContextObj.gameComService.gameMessaging,
                    onChatVisibilityChange: () => toggleChatVisibility(context),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (TestService.isTesting) {
      try {
        this._currentPlayer = TestService.currentPlayer;
      } catch (e) {
        print('test data loading error: $e');
      }
    } else {
      // if (!TestService.isTesting) {
      if (_gameInfoModel?.tableStatus == AppConstants.GAME_RUNNING) {
        // query current hand to get game update
        Future.delayed(Duration(milliseconds: 500), () {
          _gameContextObj.handActionService.queryCurrentHand();
        });
      }
    }

    var width = MediaQuery.of(context).size.width;
    // var heightOfTopView = MediaQuery.of(context).size.height / 2;

    bool isBoardHorizontal = true;
    var boardDimensions = BoardView.dimensions(context, isBoardHorizontal);
    return WillPopScope(
      onWillPop: () async {
        // if (GameChat.globalKey.currentState.isEmojiVisible) {
        //   GameChat.globalKey.currentState.toggleEmojiKeyboard();
        //   return false;
        // } else {
        //   Navigator.pop(context);
        //   return true;
        // }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          /* FIXME: THIS FLOATING ACTION BUTTON IS FOR SHOWING THE TESTS */
          floatingActionButton: GamePlayScreenUtilMethods.floatingActionButton(
            onReload: () {},
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.black,
          body: Builder(
            builder: (_) {
              // show a progress indicator if the game info object is null
              if (_gameInfoModel == null)
                return Center(child: CircularProgressIndicator());

              var dividerTotalHeight = MediaQuery.of(context).size.height / 6;

              /* get the screen sizes, and initialize the board attributes */
              Screen screen = Screen(context);
              BoardAttributesObject boardAttributes = BoardAttributesObject(
                screenSize: screen.diagonalInches(),
              );

              double tableScale = boardAttributes.tableScale;
              double divider1 =
                  boardAttributes.tableDividerHeightScale * dividerTotalHeight;
              final providers = GamePlayScreenUtilMethods.getProviders(
                context: context,
                gameInfoModel: _gameInfoModel,
                gameCode: widget.gameCode,
                gameState: _gameState,
                //agora: agora,
                boardAttributes: boardAttributes,
                gameContextObject: _gameContextObj,
              );
              return MultiProvider(
                providers: providers,
                builder: (BuildContext context, _) {
                  this._providerContext = context;

                  if (_gameContextObj != null) {
                    if (_gameContextObj.gameUpdateService == null) {
                      /* setup the listeners to the channels
                        * Any messages received from these channel updates,
                        * will be taken care of by the respective class
                        * and actions will be taken in the UI
                        * as there will be Listeners implemented down this hierarchy level */

                      _gameContextObj.gameUpdateService = GameUpdateService(
                        _providerContext,
                        _gameState,
                      );
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

                        _gameContextObj.gameUpdateService
                            .handle(message.string);
                      });
                    }

                    if (_gameContextObj.handActionService == null) {
                      _gameContextObj.handActionService = HandActionService(
                        _providerContext,
                        _gameState,
                        _gameContextObj.gameComService,
                        _gameContextObj.currentPlayer,
                        audioPlayer: _audioPlayer,
                      );
                      _gameContextObj.handActionService.loop();

                      if (!TestService.isTesting) {
                        _gameContextObj.gameComService.handToAllChannelStream
                            .listen((nats.Message message) {
                          if (!_gameContextObj.gameComService.active) return;
                          if (_gameContextObj.handActionService == null) return;
                          /* This stream receives hand related messages that is common to all players
                          * e.g
                          * New Hand - contains hand status, dealerPos, sbPos, bbPos, nextActionSeat
                          * Next Action - contains the seat No which is to act next
                          *
                          * This stream also contains the output for the query of current hand*/
                          _gameContextObj.handActionService
                              .handle(message.string);
                        });

                        _gameContextObj.gameComService.handToPlayerChannelStream
                            .listen((nats.Message message) {
                          if (!_gameContextObj.gameComService.active) return;
                          if (_gameContextObj.handActionService == null) return;
                          /* This stream receives hand related messages that is specific to THIS player only
                          * e.g
                          * Deal - contains seat No and cards
                          * Your Action - seat No, available actions & amounts */
                          _gameContextObj.handActionService
                              .handle(message.string);
                        });
                      }
                    }
                  }

                  /* set proper context for test service */
                  TestService.context = context;

                  AudioBufferService.create().then(
                    (Map<String, String> tmpAudioFiles) =>
                        Provider.of<ValueNotifier<Map<String, String>>>(
                      context,
                      listen: false,
                    ).value = tmpAudioFiles,
                  );

                  /* This listenable provider takes care of showing or hiding the chat widget */
                  return ListenableProvider<ValueNotifier<bool>>(
                    create: (_) => ValueNotifier<bool>(false),
                    builder: (context, _) => Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        BackgroundView(),

                        /* main view */
                        Column(
                          children: [
                            _gameState?.audioConfEnabled ?? false
                                ? Consumer<JanusEngine>(
                                    builder: (_, __, ___) {
                                      return _gameState.janusEngine
                                          .audioWidget();
                                    },
                                  )
                                : SizedBox.shrink(),

                            // header section
                            HeaderView(
                              gameCode: widget.gameCode,
                            ),
                            // empty space to highlight the background view
                            SizedBox(
                              width: width,
                              height: divider1,
                            ),
                            // main board view
                            Container(
                              width: boardDimensions.width,
                              height: boardDimensions.height,
                              child: Transform.scale(
                                scale: tableScale,
                                // 10 inch: 0.85, 5inch: 1.0
                                child: BoardView(
                                  gameComService:
                                      _gameContextObj?.gameComService,
                                  gameInfo: _gameInfoModel,
                                  audioPlayer: _audioPlayer,
                                  onUserTap: onJoinGame,
                                  onStartGame: startGame,
                                ),
                              ),
                            ),

                            /* divider that divides the board view and the footer */
                            Divider(
                              color: Colors.amberAccent,
                              thickness: 3,
                            ),

                            // footer section
                            Expanded(
                              child: FooterView(
                                this._gameContextObj,
                                widget.gameCode,
                                _currentPlayer.uuid,
                                () => toggleChatVisibility(context),
                                _gameInfoModel.clubCode,
                              ),
                            ),
                          ],
                        ),

                        /* chat window widget */
                        _buildChatWindow(context),

                        /* notification view */
                        Notifications.buildNotificationWidget(),
                      ],
                    ),
                  );
                },
              );
            },
          ),
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
}
