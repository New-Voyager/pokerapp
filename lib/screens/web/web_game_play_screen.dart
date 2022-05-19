import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/layouts/layout_holder.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:provider/provider.dart';

class WebGamePlayScreen extends StatefulWidget {
  final String gameCode;
  final bool isBotGame;
  final bool isFromWaitListNotification;
  const WebGamePlayScreen({
    Key key,
    this.gameCode,
    this.isBotGame,
    this.isFromWaitListNotification,
  }) : super(key: key);

  @override
  State<WebGamePlayScreen> createState() => _WebGamePlayScreenState();
}

class _WebGamePlayScreenState extends State<WebGamePlayScreen> {
  GameInfoModel _gameInfoModel;
  @override
  void initState() {
    super.initState();
    log("GameCode : ${widget.gameCode}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchGameInfo();
    });
  }

  void _fetchGameInfo() async {
    if (TestService.isTesting) {
      _gameInfoModel = TestService.gameInfo;
    } else {
      _gameInfoModel = await GameService.getGameInfo(widget.gameCode);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gameInfoModel != null
          ? _buildGameScreen()
          : CircularProgressWidget(),
    );
  }

  Widget _buildGameScreen() {
    final delegate = LayoutHolder.getGameDelegate(context);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        delegate.tableBuilder(),
        delegate.centerViewBuilder(),
        //  delegate.playersOnTableBuilder(Size(300, 200)),
        // ignore: sized_box_for_whitespace
        /*  Container(
          width: 140,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // used for testing different things
              //testGameLog(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 15.0,
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Test',
                // style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
     */
      ],
    );
  }
}
