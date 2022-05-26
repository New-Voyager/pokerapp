import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view.dart';
import 'package:pokerapp/screens/layouts/layout_holder.dart';
import 'package:pokerapp/services/app/asset_service.dart';
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
    if (TestService.isTesting) {
      await TestService.load();
      _gameInfoModel = TestService.gameInfo;
      await TestService.initialize();
      _gameState = TestService.gameState();
      await AssetService.initWebAssets();
      log("Gameinfomodel, assets and gamestate initialized");
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
    Screen.init(context);

    return Scaffold(
      body: ((_gameInfoModel != null) && (_gameState != null))
          ? _buildGameScreen()
          : CircularProgressWidget(),
      floatingActionButton: GamePlayScreenUtilMethods.floatingActionButton(
        onReload: () {},
        isCustomizationMode: false,
      ),
    );
  }

  void onJoinGame(Seat seat) {}

  void startGame() {}

  Widget _buildGameScreen() {
    final BoardAttributesObject boardAttributes =
        BoardAttributesObject(screenSize: Screen.diagonalInches);

    final GameContextObject _gameContextObj = GameContextObject(
      player: TestService.currentPlayer,
      gameCode: TestService.gameInfo.gameCode,
    );
    final providers = GamePlayScreenUtilMethods.getProviders(
      context: context,
      gameInfoModel: _gameInfoModel,
      gameCode: TestService.gameInfo.gameCode,
      gameState: _gameState,
      boardAttributes: boardAttributes,
      gameContextObject: _gameContextObj,
      // hostSeatChangePlayers: _hostSeatChangeSeats,
      // seatChangeInProgress: _hostSeatChangeInProgress,
    );

    final delegate = LayoutHolder.getGameDelegate(context);
    final boardDimensions = boardAttributes.dimensions(context);

    return MultiProvider(
        providers: providers,
        builder: (context, __) {
          if (TestService.isTesting) {
            TestService.context = context;
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: Screen.width,
                height: Screen.height,
                child: BoardView(
                  gameComService: _gameContextObj?.gameComService,
                  gameInfo: _gameInfoModel,
                  onUserTap: onJoinGame,
                  onStartGame: startGame,
                ),
              )
            ],
          );
        });
  }
}
