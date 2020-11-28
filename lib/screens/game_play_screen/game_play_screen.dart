import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_in_seat_model.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/header_view.dart';
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
  List<UserObject> _users;

  // firstly get the game details
  void _getGameDetails() async {
    _gameInfoModel = await GameInfoService.getGameInfo(widget.gameCode);

    if (_gameInfoModel != null && mounted) setState(() {});

    // get the users from the game info model
    _users = _gameInfoModel.playersInSeats
        .map<UserObject>((PlayerInSeatModel m) => UserObject(
              seatPosition: m.seatNo - 1,
              name: m.name,
              chips: m.stack,
            ))
        .toList();

    // todo: nats subscribe the required channels

    // todo: after a particular time, let the user select a seat
    await Future.delayed(const Duration(seconds: 5));
    int seatNo = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _gameInfoModel.availableSeats
                .map<Widget>((i) => InkWell(
                      onTap: () => Navigator.pop(context, i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Text(i.toString()),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );

    log('seat no: $seatNo');

    // fixme: this is not the usual join methodology, but this is for testing
    String playerGameStatus = await JoinGameService.joinGame(
      widget.gameCode,
      seatNo,
    );

    log('player game status: $playerGameStatus');

    // TODO: /*******************THE UI WILL BE REFRESHED IN A DIFFERENT WAY*********************/

    // todo: this is just for debugging, if the code is working properly
    _gameInfoModel = await GameInfoService.getGameInfo(widget.gameCode);
    if (_gameInfoModel != null && mounted) setState(() {});
    // get the users from the game info model
    _users = _gameInfoModel.playersInSeats
        .map<UserObject>((PlayerInSeatModel m) => UserObject(
              seatPosition: m.seatNo - 1,
              name: m.name,
              chips: m.stack,
            ))
        .toList();
  }

  @override
  void initState() {
    _getGameDetails();
    super.initState();
  }

  @override
  void dispose() {
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
                        users: _users,
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
