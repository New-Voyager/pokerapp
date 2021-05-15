import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/services/game_replay_service/game_replay_service.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ReplayHandScreenUtils {
  ReplayHandScreenUtils._();

  static List<SingleChildWidget> getProviders() => [
        /* this holds all the players related state */
        ListenableProvider<Players>(
          create: (_) => Players(
            players: const [],
          ),
        ),

        /* table state holds all the table related states - community cards, game status, pots, update pots */
        ListenableProvider<TableState>(
          create: (_) => TableState(),
        ),

        /* this is for having random card back for every new hand */
        ListenableProvider<CardDistributionModel>(
          create: (_) => CardDistributionModel(),
        ),

        /* this is for having random card back for every new hand */
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(CardBackAssets.getRandom()),
        ),

        /* board object used for changing board attributes */
        /* default is horizontal view */
        ListenableProvider<BoardAttributesObject>(
          create: (BuildContext c) => BoardAttributesObject(
            screenSize: Screen(c).diagonalInches(),
          ),
        ),
      ];

  /* this method calls the API to fetch the handlog, process it and return a game replay controller */
  static Future<GameReplayController> getGameReplayController({
    @required int playerID,
    @required int handNumber,
    @required String gameCode,
  }) async {
    /* fixme: for now, use handlog data from sample */
    /* todo: the network call can be made here */

    final String dataString = await rootBundle.loadString(
      'assets/sample-data/handlog/holdem/onewinner.json',
    );

    final data = jsonDecode(dataString);

    /* process the handlog data to build a GameReplayController */
    return GameReplayService.buildController(data);
  }
}
