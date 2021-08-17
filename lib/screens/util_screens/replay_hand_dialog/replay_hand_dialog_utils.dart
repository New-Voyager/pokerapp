import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/services/game_replay_service/game_replay_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ReplayHandScreenUtils {
  ReplayHandScreenUtils._();

  static List<SingleChildWidget> getProviders(
    BoardAttributesObject boardAttributesObject,
    GameState gameState,
  ) {
    final providers = [
      /* dummy providers, that do not do anything */
      /* seat change model */
      ListenableProvider<ValueNotifier<SeatChangeModel>>(
        create: (_) => ValueNotifier<SeatChangeModel>(null),
      ),
      /* host seat change model */
      ListenableProvider<SeatChangeNotifier>(
        create: (_) => SeatChangeNotifier(),
      ),
      /* game info model */
      ListenableProvider<ValueNotifier<GameInfoModel>>(
        create: (_) => ValueNotifier(gameState.gameInfo),
      ),
      /* game context object */
      ListenableProvider<GameContextObject>(
        create: (_) => GameContextObject(
          gameCode: gameState.gameCode,
          player: gameState.currentPlayer,
        ),
      ),

      /* game state */
      Provider<GameState>(
        create: (_) => gameState,
      ),

      /* footer status */
      ListenableProvider<ValueNotifier<FooterStatus>>(
        create: (_) => ValueNotifier(
          FooterStatus.None,
        ),
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
        create: (_) => boardAttributesObject,
      ),
    ];

    providers.addAll(gameState.providers);
    return providers;
  }

  /* this method process the hand log data and return a game replay controller */
  static Future<GameReplayController> getGameReplayController({
    int playerID,
    int handNumber,
    String gameCode,
    HandResultData data,
  }) async {
    assert(playerID != null);
    assert(handNumber != null);
    assert(gameCode != null);
    assert(data != null);

    final gameReplayService = GameReplayService(
      data,
      playerID: playerID,
      gameCode: gameCode,
      handNumber: handNumber,
    );

    /* process the handlog data to build a GameReplayController */
    return gameReplayService.buildController();
  }
}
