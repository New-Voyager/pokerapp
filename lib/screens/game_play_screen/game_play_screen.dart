import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dart_nats/dart_nats.dart' as nats;
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/game_play/action_services/game_action_service/game_action_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/hand_action_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/services/game_play/utils/audio_buffer.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/*
* This is the screen which will have contact with the NATS server
* Every sub view of this screen will update according to the data fetched from the NATS
* */

class GamePlayScreen extends StatefulWidget {
  final String gameCode;

  GamePlayScreen({
    @required this.gameCode,
  }) : assert(gameCode != null);

  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  GameComService _gameComService;
  BuildContext _providerContext;

  /*
  * Call back function, which lets the current player join the game
  * the passed setPosition info is used to join the game
  * This function can be disabled, when the current user get's in the game */

  void _joinGame(int seatPos) async {
    assert(seatPos != null);

    log('joining game with seat no $seatPos');

    // if setPos is -1 that means block this function call
    if (seatPos == -1) return;

    int seatNumber = seatPos;
    await GameService.joinGame(
      widget.gameCode,
      seatNumber,
    );
  }

  void _startGame() async {
    log('Starting the game...');
    await GameService.startGame(widget.gameCode);
  }
  /*
  * _init function is run only for the very first time,
  * and only once, the initial game screen is populated from here
  * also the NATS channel subscriptions are done here */

  Future<GameInfoModel> _fetchGameInfo() async {
    GameInfoModel _gameInfoModel =
        await GameService.getGameInfo(widget.gameCode);

    String myUUID = await AuthService.getUuid();

    // mark the isMe field
    for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
      if (_gameInfoModel.playersInSeats[i].playerUuid == myUUID)
        _gameInfoModel.playersInSeats[i].isMe = true;
    }

    return _gameInfoModel;
  }

  /*
  * The init method returns a Future of all the initial game constants
  * This method is also responsible for subscribing to the NATS channels */

  Future<GameInfoModel> _init() async {
    GameInfoModel _gameInfoModel = await _fetchGameInfo();

    _gameComService = GameComService(
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
    );

    // subscribe the NATs channels
    await _gameComService.init();

    /* setup the listeners to the channels
    * Any messages received from these channel updates,
    * will be taken care of by the respective class
    * and actions will be taken in the UI
    * as there will be Listeners implemented down this hierarchy level */

    _gameComService.gameToPlayerChannelStream.listen((nats.Message message) {
      if (!_gameComService.active) return;

      log('gameToPlayerChannel(${message.subject}): ${message.string}');

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

      log('handToAllChannel(${message.subject}): ${message.string}');

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

      log('handToPlayerChannel(${message.subject}): ${message.string}');

      /* This stream receives hand related messages that is specific to THIS player only
      * e.g
      * Deal - contains seat No and cards
      * Your Action - seat No, available actions & amounts */
      HandActionService.handle(
        context: _providerContext,
        message: message.string,
      );
    });

    return _gameInfoModel;
  }

  /* provider method, returns list of all the providers used in the below hierarchy */
  List<SingleChildWidget> _getProviders({
    @required GameInfoModel gameInfoModel,
  }) =>
      [
        /* this is for having random card back for every new hand */
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(CardBackAssets.getRandom()),
        ),

        /* a simple value notifier, holding INT which
        * resembles number of cards to deal with */
        ListenableProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier(2), // todo: default be 2?
        ),

        /* a header object is used to update the header section of
        * the game screen - it contains data regarding the current hand no, club name,
        * club code and so on */
        ListenableProvider<HeaderObject>(
          create: (_) => HeaderObject(
            gameCode: widget.gameCode,
          ),
        ),

        /* a copy of Game Info Model is kept in the provider
        * This is used to get the max or min BuyIn amounts
        * or the game code, or for further info about the game */
        ListenableProvider<ValueNotifier<GameInfoModel>>(
          create: (_) => ValueNotifier(gameInfoModel),
        ),

        /*
        * This Listenable Provider updates the activities of players
        *  Player joins, buy Ins, Stacks, everything is notified by the Players objects
        * */
        ListenableProvider<Players>(
          create: (_) => Players(
            players: gameInfoModel.playersInSeats,
          ),
        ),

        /* TableStatus is updated as a string value */
        ListenableProvider<TableState>(
          create: (_) => TableState(
            tableStatus: gameInfoModel.tableStatus,
          ),
        ),

        /* footer view, is maintained by this Provider - either how action buttons,
        * OR prompt for buy in are shown
        * */
        ListenableProvider<ValueNotifier<FooterStatus>>(
          create: (_) => ValueNotifier(
            FooterStatus.None,
          ),
        ),

        /* If footer status become RESULT, then we need to have the
        * result data available, the footer result model holds the result data */
        ListenableProvider<FooterResult>(
          create: (_) => FooterResult(),
        ),

        /* This provider gets a value when YOUR_ACTION message is received,
        * other time this value is kept null, signifying,
        * there is no action to take on THIS user's end
        * */
        ListenableProvider<ValueNotifier<PlayerAction>>(
          create: (_) => ValueNotifier<PlayerAction>(
            null,
          ),
        ),

        /* This provider contains and updates the game info
        * required for player to make an action
        * this provider holds --> clubID, gameID and seatNo */
        ListenableProvider<ValueNotifier<ActionInfo>>(
          create: (_) => ValueNotifier<ActionInfo>(
            null,
          ),
        ),

        /* This provider contains the sendPlayerToHandChannel function
        * so that the function can be called from anywhere down the widget tree */
        Provider<Function(String)>(
          create: (_) => _gameComService.sendPlayerToHandChannel,
        ),

        /* This provider holds the audioPlayer object, which facilitates playing
        * audio in the game */
        Provider<AudioPlayer>(
          create: (_) => AudioPlayer(
            mode: PlayerMode.LOW_LATENCY,
          ),
        ),

        /* managing audio assets as temporary files */
        ListenableProvider<ValueNotifier<Map<String, String>>>(
          create: (_) => ValueNotifier(
            Map<String, String>(),
          ),
        ),

        /* This provider contains the remainingActionTime - this provider
        * is used only when QUERY_CURRENT_HAND message is processed */
        ListenableProvider<RemainingTime>(
          create: (_) => RemainingTime(),
        ),
      ];

  /* After the entire table is drawn, if the current player (isMe == true)
    * is waiting for buyIn,then show the footer prompt */
  void _checkForCurrentUserPrompt(BuildContext context) => Provider.of<Players>(
        context,
        listen: false,
      ).players.forEach((p) {
        if (p.isMe && p.stack == 0)
          Provider.of<ValueNotifier<FooterStatus>>(
            context,
            listen: false,
          ).value = FooterStatus.Prompt;
      });

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    _gameComService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<GameInfoModel>(
          future: _init(),
          initialData: null,
          builder: (_, AsyncSnapshot<GameInfoModel> snapshot) {
            GameInfoModel _gameInfoModel = snapshot.data;

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

            return MultiProvider(
              providers: _getProviders(
                gameInfoModel: _gameInfoModel,
              ),
              builder: (BuildContext context, _) {
                this._providerContext = context;

                AudioBufferService.create().then(
                    (Map<String, String> tmpAudioFiles) =>
                        Provider.of<ValueNotifier<Map<String, String>>>(
                          context,
                          listen: false,
                        ).value = tmpAudioFiles);

                // check for the current user prompt, after the following tree is built
                // waiting for a brief moment should suffice
                Future.delayed(
                  AppConstants.buildWaitDuration,
                  () => _checkForCurrentUserPrompt(context),
                );

                return Container(
                  decoration: _screenBackgroundDecoration,
                  child: Column(
                    children: [
                      // header section
                      HeaderView(),

                      // main board view
                      Expanded(
                        child: BoardView(
                          onUserTap: _joinGame,
                          onStartGame: _startGame,
                        ),
                      ),

                      // footer section
                      FooterView(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/* design constants */
const _screenBackgroundDecoration = const BoxDecoration(
  color: Colors.black,
  // gradient: const LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     const Color(0xff353535),
  //     const Color(0xff464646),
  //     Colors.black,
  //   ],
  // ),
);
