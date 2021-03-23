import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class DealStartedService {
  DealStartedService._();

  static void handle({
    BuildContext context,
    fromGameReplay = false,
  }) async {
    GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    final me = gameState.me(context);

    /* if I am present in this game,
     Deal Start message is unnecessary */
    if (fromGameReplay == false && me == null) return;

    /* show card shuffling */
    final TableState tableState = gameState.getTableState(context);
    /* stop showing card shuffling */
    tableState.clear();
    tableState.notifyAll();

    // play the deal sound effect
    Audio.play(
      context: context,
      assetFile: AppAssets.dealSound,
    );
    final players = gameState.getPlayers(context);
    List<int> seatNos = players.players.map((p) => p.seatNo).toList();
    seatNos.sort();

    final handInfo = gameState.getHandInfo(context);

    CardDistributionModel cardDistributionModel =
        Provider.of<CardDistributionModel>(
      context,
      listen: false,
    );

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    for (int i = 0; i < handInfo.noCards; i++) {
      /* for distributing the ith card, go through all the players, and give them */
      for (int seatNo in seatNos) {
        // start the animation
        cardDistributionModel.seatNo = seatNo;

        // wait for the animation to finish
        await Future.delayed(AppConstants.cardDistributionAnimationDuration);

        players.updateVisibleCardNumberSilent(seatNo, i + 1);
        players.notifyAll();
      }
    }

    /* card distribution ends, put the value to NULL */
    cardDistributionModel.seatNo = null;

    tableState.updateTableStatusSilent(null);
    tableState.notifyAll();
  }
}
