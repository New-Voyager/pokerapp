import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/models/player_info.dart';
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

            return ReplayHandUtilScreen(
              gameReplayController: snapshot.data,
              gameCode: gameCode,
              playerID: playerID,
            );
          },
        ),
      );
}

class ReplayHandUtilScreen extends StatefulWidget {
  ReplayHandUtilScreen({
    @required this.gameReplayController,
    @required this.gameCode,
    @required this.playerID,
  });

  final GameReplayController gameReplayController;
  final String gameCode;
  final int playerID;

  @override
  _ReplayHandUtilScreenState createState() => _ReplayHandUtilScreenState();
}

class _ReplayHandUtilScreenState extends State<ReplayHandUtilScreen> {
  @override
  void dispose() {
    widget.gameReplayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: GamePlayScreenUtilMethods.getProviders(
        currentPlayerInfo: PlayerInfo(
          id: widget.playerID,
          uuid: widget.gameReplayController.playerUuid,
        ),
        gameInfoModel: widget.gameReplayController.gameInfoModel,
        gameCode: widget.gameCode,
        agora: null,
        sendPlayerToHandChannel: null,
      ),
      builder: (BuildContext context, _) {
        /* initialize the game controller, after we have the context
                  that can give access to the provider models*/
        widget.gameReplayController.initController(context);

        return SafeArea(
          child: Column(
            children: [
              /* game view */
              Expanded(
                child: ReplayHandGameView(
                  gameInfoModel: widget.gameReplayController.gameInfoModel,
                ),
              ),

              /* controls */
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ReplayHandControls(
                    gameReplayController: widget.gameReplayController,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
