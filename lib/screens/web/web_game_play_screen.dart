import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/layouts/layout_holder.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/test/test_service_web.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:pokerapp/utils/utils.dart';
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
  GameState _gameState;
  @override
  void initState() {
    super.initState();
    log("GameCode : ${widget.gameCode}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchGameInfo();
    });
  }

  void _fetchGameInfo() async {
    if (TestServiceWeb.isTesting) {
      _gameInfoModel = TestServiceWeb.gameInfo;
      _gameState = await TestServiceWeb.getGameState();
      log("Gameinfomodel and gamestate initialized");
    } else {
      _gameInfoModel = await GameService.getGameInfo(widget.gameCode);
      _gameState = GameState();
      await _gameState.initialize(
        gameInfo: _gameInfoModel,
        gameCode: widget.gameCode,
        customizationMode: false,
        replayMode: false,
        currentPlayer: TestService.currentPlayer,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ((_gameInfoModel != null) && (_gameState != null))
          ? _buildGameScreen()
          : CircularProgressWidget(),
    );
  }

  Widget _buildGameScreen() {
    final BoardAttributesObject boardAttributes =
        BoardAttributesObject(screenSize: Screen.diagonalInches);

    final GameContextObject _gameContextObj = GameContextObject(
      player: TestServiceWeb.currentPlayer,
      gameCode: TestServiceWeb.testGameCode,
      
    );
    final providers = GamePlayScreenUtilMethods.getProviders(
      context: context,
      gameInfoModel: _gameInfoModel,
      gameCode: widget.gameCode,
      gameState: _gameState,
      boardAttributes: boardAttributes,
      gameContextObject: _gameContextObj,
      // hostSeatChangePlayers: _hostSeatChangeSeats,
      // seatChangeInProgress: _hostSeatChangeInProgress,
    );

    final delegate = LayoutHolder.getGameDelegate(context);
    return MultiProvider(
      providers: providers,
      builder: (_, __) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            delegate.tableBuilder(_gameState),
            delegate.centerViewBuilder(_gameState),
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
      },
    );
  }
}
