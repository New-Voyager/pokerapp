import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_controls/replay_hand_controls.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_game_view/replay_hand_game_view.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

class ReplayHandDialog extends StatelessWidget {
  static void show({
    @required BuildContext context,
    @required int playerID,
    int handNumber,
    String gameCode,
    dynamic hand,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ReplayHandDialog(
        playerID: playerID,
        handNumber: handNumber,
        gameCode: gameCode,
        hand: hand,
      ),
    );
  }

  final int playerID;
  final int handNumber;
  final String gameCode;
  final dynamic hand;

  ReplayHandDialog({
    this.playerID,
    this.handNumber,
    this.gameCode,
    this.hand,
  });

  @override
  Widget build(BuildContext _) => Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<GameReplayController>(
          future: ReplayHandScreenUtils.getGameReplayController(
            playerID: playerID,
            handNumber: handNumber,
            gameCode: gameCode,
            hand: hand,
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
    widget.gameReplayController.dispose(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BoardAttributesObject boardAttributesObject = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* game view */
              ReplayHandGameView(
                gameInfoModel: widget.gameReplayController.gameInfoModel,
              ),

              /* controls */
              ReplayHandControls(
                gameReplayController: widget.gameReplayController,
              ),
            ],
          ),
        );
      },
    );
  }
}
