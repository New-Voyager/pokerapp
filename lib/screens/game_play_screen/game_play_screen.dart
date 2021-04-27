import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/chat.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/background_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/notifications/notifications.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/game_action_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/util_action_services.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/hand_action_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/result_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:pokerapp/services/game_play/utils/audio_buffer.dart';
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

class _GamePlayScreenState extends State<GamePlayScreen> {
  bool _initiated;
  GameComService _gameComService;
  BuildContext _providerContext;
  PlayerInfo _currentPlayer;
  String _audioToken = '';
  bool liveAudio = false;
  AudioPlayer _audioPlayer;
  Agora agora;
  GameInfoModel _gameInfoModel;

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
    if (!liveAudio) {
      return;
    }

    this._audioToken = await GameService.getLiveAudioToken(widget.gameCode);
    print('Audio token: ${this._audioToken}');
    print('audio token: ${this._audioToken}');
    if (this._audioToken != null && this._audioToken != '') {
      agora.initEngine().then((_) async {
        print('Joining audio channel ${widget.gameCode}');
        await agora.joinChannel(this._audioToken);
        print('Joined audio channel ${widget.gameCode}');
      });
    }
  }

  /* The init method returns a Future of all the initial game constants
  * This method is also responsible for subscribing to the NATS channels */

  Future<GameInfoModel> _init() async {
    GameInfoModel _gameInfoModel = await _fetchGameInfo();

    if (_initiated == true) return _gameInfoModel;

    if (liveAudio) {
      // initialize agora
      agora = Agora(
          gameCode: widget.gameCode,
          uuid: this._currentPlayer.uuid,
          playerId: this._currentPlayer.id);

      // if the current player is in the table, then join audio
      for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
        if (_gameInfoModel.playersInSeats[i].playerUuid ==
            _currentPlayer.uuid) {
          // player is in the table
          await this.joinAudio();
          break;
        }
      }
    } else {
      _audioPlayer = AudioPlayer();
    }
    _gameComService = GameComService(
      currentPlayer: this._currentPlayer,
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
      gameChatChannel: _gameInfoModel.gameChatChannel,
    );
    // subscribe the NATs channels
    // await _gameComService.init();
    final natsClient = Provider.of<Nats>(context, listen: false);

    log('natsClient: $natsClient');
    await _gameComService.init2(natsClient);

    /* setup the listeners to the channels
      * Any messages received from these channel updates,
      * will be taken care of by the respective class
      * and actions will be taken in the UI
      * as there will be Listeners implemented down this hierarchy level */

    _gameComService.gameToPlayerChannelStream.listen((nats.Message message) {
      if (!_gameComService.active) return;

      // log('gameToPlayerChannel(${message.subject}): ${message.string}');

      /* This stream will receive game related messages
        * e.g.
        * 1. Player Actions - Sitting on table, getting more chips, leaving game, taking break,
        * 2. Game Actions - New hand, informing about Next actions, PLayer Acted
        *  */

      GameActionService.handle(
        context: _providerContext,
        message: message.string,
      );
    });

    _gameComService.handToAllChannelStream.listen((nats.Message message) {
      if (!_gameComService.active) return;

      // log('handToAllChannel(${message.subject}): ${message.string}');

      /* This stream receives hand related messages that is common to all players
        * e.g
        * New Hand - contains hand status, dealerPos, sbPos, bbPos, nextActionSeat
        * Next Action - contains the seat No which is to act next
        *
        * This stream also contains the output for the query of current hand*/
      HandActionService.handle(
        context: _providerContext,
        message: message.string,
      );
    });

    _gameComService.handToPlayerChannelStream.listen((nats.Message message) {
      if (!_gameComService.active) return;

      // log('handToPlayerChannel(${message.subject}): ${message.string}');

      /* This stream receives hand related messages that is specific to THIS player only
        * e.g
        * Deal - contains seat No and cards
        * Your Action - seat No, available actions & amounts */
      HandActionService.handle(
        context: _providerContext,
        message: message.string,
      );

      // _gameComService.chat.listen(onText: this.onText);
      _gameComService.gameMessaging.listen(
        onCards: this.onCards,
        onText: this.onText,
        onAudio: this.onAudio,
        // onAnimation: this.onAnimation,
      );
    });

    _initiated = true;
    return _gameInfoModel;
  }

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    // TestService.isTesting = false;

    agora?.disposeObject();
    _gameComService?.dispose();
    Audio.dispose(context: _providerContext);

    if (_audioPlayer != null) {
      _audioPlayer.dispose();
      _audioPlayer = null;
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
    if (_audioPlayer != null &&
        message.audio != null &&
        message.audio.length > 0) {
      try {
        await _audioPlayer.playBytes(message.audio);
      } catch (e) {
        // ignore the exception
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
      (gameInfoModel) => setState(() => _gameInfoModel = gameInfoModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final data = MediaQuery.of(context);
    log('rebuilding game screen. Screen: $screenSize Query data: $data');

    if (TestService.isTesting) {
      try {
        this._currentPlayer = TestService.currentPlayer;
      } catch (e) {
        print('test data loading error: $e');
      }
    }

    var width = MediaQuery.of(context).size.width;
    // var heightOfTopView = MediaQuery.of(context).size.height / 2;

    bool isBoardHorizontal = true;
    var boardDimensions = BoardView.dimensions(context, isBoardHorizontal);

    return WillPopScope(
      onWillPop: () async {
        if (GameChat.globalKey.currentState.isEmojiVisible) {
          GameChat.globalKey.currentState.toggleEmojiKeyboard();
          return false;
        } else {
          Navigator.pop(context);
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          /* FIXME: THIS FLOATING ACTION BUTTON IS FOR SHOWING THE TESTS */
          floatingActionButton: GamePlayScreenUtilMethods.floatingActionButton(
            onReload: () {},
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: Builder(
            builder: (_) {
              // show a progress indicator if the game info object is null
              if (_gameInfoModel == null)
                return Center(child: CircularProgressIndicator());

              if (_gameInfoModel.tableStatus == AppConstants.GAME_RUNNING) {
                // query current hand to get game update
                GameService.queryCurrentHand(
                  _gameInfoModel.gameCode,
                  _gameComService.sendPlayerToHandChannel,
                );
              }

              var dividerTotalHeight = MediaQuery.of(context).size.height / 6;
              Screen screen = Screen(context);
              BoardAttributesObject boardAttributes =
                  BoardAttributesObject(screenSize: screen.diagonalInches());

              double tableScale = boardAttributes.getTableScale();
              double divider1 = boardAttributes.getTableDividerHeightScale() *
                  dividerTotalHeight; // 5inch 0.40, 10 inch: 1*
              final providers = GamePlayScreenUtilMethods.getProviders(
                context: context,
                gameMessagingService: _gameComService.gameMessaging,
                gameInfoModel: _gameInfoModel,
                gameCode: widget.gameCode,
                currentPlayerInfo: this._currentPlayer,
                agora: agora,
                boardAttributes: boardAttributes,
                sendPlayerToHandChannel:
                    _gameComService.sendPlayerToHandChannel,
              );
              return MultiProvider(
                providers: providers,
                builder: (BuildContext context, _) {
                  this._providerContext = context;

                  /* set proper context for test service */
                  TestService.context = context;

                  // handle test code
                  if (TestService.isTesting) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      TestService.addBoardCards();
                    });

                    // TestService.showBets(_providerContext);

                    if (TestService.showResult) {
                      log('Show handresult');
                      ResultService.handle(
                          context: context, data: TestService.handResult);
                      log('Show handresult');
                    }
                  }

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
                            // header section
                            HeaderView(_gameComService),
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
                                scale: tableScale, // 10 inch: 0.85, 5inch: 1.0
                                child: BoardView(
                                  gameComService: _gameComService,
                                  gameInfo: _gameInfoModel,
                                  onUserTap: onJoinGame,
                                  onStartGame: () =>
                                      GamePlayScreenUtilMethods.startGame(
                                    widget.gameCode,
                                  ),
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
                                this._gameComService,
                                widget.gameCode,
                                _currentPlayer.uuid,
                                () => toggleChatVisibility(context),
                                _gameInfoModel.clubCode,
                              ),
                            ),
                          ],
                        ),
                        Consumer<ValueNotifier<bool>>(
                          builder: (_, vnChatVisibility, __) =>
                              vnChatVisibility.value
                                  ? Align(
                                      child: GameChat(
                                        this._gameComService.gameMessaging,
                                        () => toggleChatVisibility(context),
                                      ),
                                      alignment: Alignment.bottomCenter,
                                    )
                                  : const SizedBox.shrink(),
                        ),
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
}
