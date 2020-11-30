import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_in_seat_model.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/chip_buy_pop_up.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_info_service.dart';
import 'package:pokerapp/services/game_play/graphql/join_game_service.dart';

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
  GameInfoModel _gameInfoModel;
  GameComService _gameComService;

  String myUUID;

  // todo: we need a timer for the prompt, or else, throw the player out of the game
  void _promptBuyIn() async {
    // check if prompt is necessary
    PlayerInSeatModel player =
        _gameInfoModel.playersInSeats.firstWhere((e) => e.isMe, orElse: null);

    if (player == null) return; // current user is not in game

    if (player.stack != 0) return; // buy is prompt only when stack is 0

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChipBuyPopUp(
        gameCode: widget.gameCode,
        minBuyIn: _gameInfoModel.buyInMin,
        maxBuyIn: _gameInfoModel.buyInMax,
      ),
    );

    // fetch game info to get updated values
    await _fetchGameInfo();

    if (mounted) setState(() {});

    // fixme, remove this, this is just for testing
    String playerID = await AuthService.getPlayerID();
    bool value = _gameComService.sendPlayerToHandChannel("""
      {
        "gameCode": "${widget.gameCode}",
        "messageType": "QUERY_CURRENT_HAND",
        "playerId": "$playerID"
      }""");
    log('value: $value');
  }

  // todo: figure out a way to enable or disable this callback function
  void _joinGame(int index) async {
    log('joining game with seat no ${index + 1}');

    assert(index != null);
    int seatNumber = index + 1;

    await JoinGameService.joinGame(
      widget.gameCode,
      seatNumber,
    );

    // fetch the game info again to get updated positions
    await _fetchGameInfo();

    // refresh the UI to show the new user
    if (mounted) setState(() {});

    // whenever stack is 0 for me prompt for more chips buy in
    _promptBuyIn();
  }

  /*
  * _init function is run only for the very first time,
  * and only once, the initial game screen is populated from here
  * also the NATS channel subscriptions are done here
  * */

  Future<void> _fetchGameInfo() async {
    _gameInfoModel = await GameInfoService.getGameInfo(widget.gameCode);

    // mark the isMe field
    for (int i = 0; i < _gameInfoModel.playersInSeats.length; i++) {
      if (_gameInfoModel.playersInSeats[i].playerUuid == myUUID)
        _gameInfoModel.playersInSeats[i].isMe = true;
    }
  }

  void _init() async {
    myUUID = await AuthService.getUuid();

    await _fetchGameInfo();

    assert(_gameInfoModel != null);

    // nats subscribe the required channels
    _gameComService = GameComService(
      gameToPlayerChannel: _gameInfoModel.gameToPlayerChannel,
      handToAllChannel: _gameInfoModel.handToAllChannel,
      handToPlayerChannel: _gameInfoModel.handToPlayerChannel,
      playerToHandChannel: _gameInfoModel.playerToHandChannel,
    );

    if (_gameInfoModel != null && mounted) setState(() {});

    // todo: use of provider here, to update and push to objects as per changes, and the UI can be instantly updated anywhere down the hierarchy

    _gameComService.gameToPlayerChannelStream.listen((message) {
      log('gameToPlayerChannel: ${message.string}');
    });

    _gameComService.handToAllChannelStream.listen((message) {
      log('handToAllChannel: ${message.string}');
    });

    _gameComService.handToPlayerChannelStream.listen((message) {
      log('handToPlayerChannel: ${message.string}');
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

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
        body: _gameInfoModel == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                decoration: _screenBackgroundDecoration,
                child: Column(
                  children: [
                    // header section
                    HeaderView(),

                    // main board view
                    Expanded(
                      child: BoardView(
                        users: _gameInfoModel.playersInSeats,
                        onUserTap: _joinGame,
                        tableStatus: _gameInfoModel.tableStatus,
                      ),
                    ),

                    // footer section
                    FooterView(),
                  ],
                ),
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
