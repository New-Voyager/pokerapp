import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_info_service.dart';
import 'package:pokerapp/services/game_play/join_game_service.dart';

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

    // todo: after init if the user is here to play the game, show a kind of popup to let them know that they can now choose a seat
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
