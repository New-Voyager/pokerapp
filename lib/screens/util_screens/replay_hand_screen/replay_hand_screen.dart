import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_controls/replay_hand_controls.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_game_view/replay_hand_game_view.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_screen/replay_hand_screen_utils.dart';
import 'package:provider/provider.dart';

class ReplayHandScreen extends StatelessWidget {
  final int playerID;
  final int handNumber;
  final String gameCode;

  /*
  * TODO: WHILE INTEGRATING THE API, TAKE CARE OF THE FOLLOWING VARIABLES
  * */

  ReplayHandScreen({
    @required this.playerID,
    @required this.handNumber,
    @required this.gameCode,
  });

  @override
  Widget build(BuildContext _) => Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: FutureBuilder<GameReplayController>(
          future: ReplayHandScreenUtils.getGameReplayController(
            playerID: playerID,
            handNumber: handNumber,
            gameCode: gameCode,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            /* todo: handle error */
            if (!snapshot.hasData || snapshot.hasError)
              return Center(
                child: Text('Something went wrong'),
              );

            GameReplayController _gameReplayController = snapshot.data;

            return MultiProvider(
              providers: GamePlayScreenUtilMethods.getProviders(
                gameInfoModel: _gameReplayController.gameInfoModel,
                gameCode: gameCode,
                playerID: playerID,
                playerUuid: null,
                agora: null,
                sendPlayerToHandChannel: null,
              ),
              builder: (BuildContext context, _) => SafeArea(
                child: Column(
                  children: [
                    /* game view */
                    Expanded(
                      child: ReplayHandGameView(
                        gameInfoModel: _gameReplayController.gameInfoModel,
                      ),
                    ),

                    /* controls */
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ReplayHandControls(
                          gameReplayController: _gameReplayController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
