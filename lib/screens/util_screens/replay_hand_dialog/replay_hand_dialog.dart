import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_controls/replay_hand_controls.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_game_view/replay_hand_game_view.dart';
import 'package:pokerapp/screens/util_screens/replay_hand_dialog/replay_hand_dialog_utils.dart';
import 'package:pokerapp/services/app/hand_service.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';

class ReplayHandDialog extends StatelessWidget {
  static Future<HandResultData> _fetchData({
    @required BuildContext context,
    @required String gameCode,
    @required int handNumber,
  }) async {
    // show connection dialog
    ConnectionDialog.show(context: context, loadingText: "Loading hand ...");

    // fetch the hand result data
    final HandResultData data = await HandService.getHandLog(
      gameCode,
      handNumber,
    );

    // close connection dialog
    Navigator.pop(context);

    // finally send back data
    return data;
  }

  static void show({
    @required BuildContext context,
    @required int playerID,
    @required int handNumber,
    @required String gameCode,
  }) async {
    // get hand log data
    final HandResultData data = await _fetchData(
      context: context,
      gameCode: gameCode,
      handNumber: handNumber,
    );

    // finally show the replay hand dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ReplayHandDialog(
        playerID: playerID,
        handNumber: handNumber,
        gameCode: gameCode,
        data: data,
      ),
    );
  }

  final int playerID;
  final int handNumber;
  final String gameCode;
  final HandResultData data;

  ReplayHandDialog({
    @required this.playerID,
    @required this.handNumber,
    @required this.gameCode,
    @required this.data,
  });

  @override
  Widget build(BuildContext _) => Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<GameReplayController>(
          future: ReplayHandScreenUtils.getGameReplayController(
            playerID: playerID,
            handNumber: handNumber,
            gameCode: gameCode,
            data: data,
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

class ReplayHandUtilScreen extends StatelessWidget {
  ReplayHandUtilScreen({
    @required this.gameReplayController,
  });

  final GameReplayController gameReplayController;

  @override
  Widget build(BuildContext context) {
    final BoardAttributesObject boardAttributesObject = BoardAttributesObject(
      screenSize: Screen.diagonalInches,
    );

    return MultiProvider(
      providers: ReplayHandScreenUtils.getProviders(
        boardAttributesObject,
        gameReplayController.gameState,
      ),
      builder: (BuildContext context, _) {
        /* initialize the game controller, after we have the context
           that can give access to the provider models */
        gameReplayController.initController(context);

        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* game view */
              ReplayHandGameView(
                gameInfoModel: gameReplayController.gameInfoModel,
              ),

              /* controls */
              ReplayHandControls(
                gameReplayController: gameReplayController,
              ),
            ],
          ),
        );
      },
    );
  }
}
