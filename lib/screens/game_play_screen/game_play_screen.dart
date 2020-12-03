import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/chip_buy_pop_up.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_info_service.dart';
import 'package:pokerapp/services/game_play/graphql/join_game_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/*
* todo: instead of calling fetch game info multiple times, if the NATS gives update about player joining, or player buying chips, the UI update would be ease
* */

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
    await JoinGameService.joinGame(
      widget.gameCode,
      seatNumber,
    );
  }

  /*
  * _init function is run only for the very first time,
  * and only once, the initial game screen is populated from here
  * also the NATS channel subscriptions are done here */

  Future<GameInfoModel> _fetchGameInfo() async {
    GameInfoModel _gameInfoModel =
        await GameInfoService.getGameInfo(widget.gameCode);

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

    _gameComService.gameToPlayerChannelStream.listen((message) {
      log('gameToPlayerChannel(${message.subject}): ${message.string}');
    });

    _gameComService.handToAllChannelStream.listen((message) {
      log('handToAllChannel(${message.subject}): ${message.string}');
    });

    _gameComService.handToPlayerChannelStream.listen((message) {
      log('handToPlayerChannel(${message.subject}): ${message.string}');
    });

    return _gameInfoModel;
  }

  /* provider method, returns list of all the providers used in the below hierarchy */
  List<SingleChildWidget> _getProviders({
    @required GameInfoModel gameInfoModel,
  }) =>
      [
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
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(
            gameInfoModel.tableStatus,
          ),
        ),

        /* This provider, holds the current user's cards (DEAL) */
        ListenableProvider<ValueNotifier<List<CardObject>>>(
          create: (_) => ValueNotifier(
            List<CardObject>.empty(),
          ),
        ),

        /* footer view, is maintained by this Provider - either how action buttons,
        * OR prompt for buy in, OR todo: more functionalities can be added
        * */
        ListenableProvider<ValueNotifier<FooterStatus>>(
          create: (_) => ValueNotifier(
            FooterStatus.None,
          ),
        ),
      ];

  /* dispose method for closing connections and un subscribing to channels */
  @override
  void dispose() {
    _gameComService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
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

            return MultiProvider(
              providers: _getProviders(
                gameInfoModel: _gameInfoModel,
              ),
              builder: (BuildContext context, _) {
                this._providerContext = context;

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
  gradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      const Color(0xff353535),
      const Color(0xff464646),
      Colors.black,
    ],
  ),
);
