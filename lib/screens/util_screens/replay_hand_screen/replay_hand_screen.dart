import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_controls/replay_hand_controls.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_game_view/replay_hand_game_view.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_screen/replay_hand_screen_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

class ReplayHandScreen extends StatelessWidget {
  final int playerID;
  final int handNumber;
  final String gameCode;

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

            if (!snapshot.hasData || snapshot.hasError) {
              log(snapshot.stackTrace.toString());
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              );
            }

            return ReplayHandUtilScreen(
              gameReplayController: snapshot.data,
            );
          },
        ),
      );
}

class ReplayHandUtilScreen extends StatefulWidget {
  ReplayHandUtilScreen({
    @required this.gameReplayController,
  });

  final GameReplayController gameReplayController;

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
    final BoardAttributesObject boardAttributesObject = BoardAttributesObject(
      screenSize: Screen(context).diagonalInches(),
    );

    return MultiProvider(
      providers: ReplayHandScreenUtils.getProviders(
        boardAttributesObject,
        widget.gameReplayController.gameState,
      ),
      builder: (BuildContext context, _) {
        /* initialize the game controller, after we have the context
           that can give access to the provider models */
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
