import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/services/game_replay_service/game_replay_service.dart';

class ReplayHandScreenUtils {
  ReplayHandScreenUtils._();

  /* this method calls the API to fetch the handlog.json data */
  static Future<GameReplayController> getGameReplayController({
    @required int playerID,
    @required int handNumber,
    @required String gameCode,
  }) async {
    /* fixme: for now, use handlog.json data from sample */
    /* todo: the network call can be made here */
    String dataString = await rootBundle.loadString(
      AppAssets.handlog,
    );

    dynamic data = jsonDecode(dataString);

    /* logging game data, to verify if the correct file is loaded */
    String gameID = data['gameId'];
    int handNum = data['handNum'];
    String gameType = data['gameType'];

    log('handlog: gameID: $gameID :: handNum: $handNum :: gameType: $gameType');

    /* process the data to build a GameReplayController */
    return GameReplayService.buildController(data);
  }
}
