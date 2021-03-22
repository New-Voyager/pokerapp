import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class DealStartedService {
  DealStartedService._();

  static void handle({
    BuildContext context,
  }) async {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    bool isMePresent = players.players.indexWhere((p) => p.isMe == true) != -1;

    /* if I am present in this game,
     Deal Start message is unnecessary */
    if (isMePresent) return;

    // play the deal sound effect
    Audio.play(
      context: context,
      assetFile: AppAssets.dealSound,
    );

    List<int> seatNos = players.players.map((p) => p.seatNo).toList();
    seatNos.sort();

    // int noOfCards = Provider.of<ValueNotifier<int>>(
    //   context,
    //   listen: false,
    // ).value;

    GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
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
  }
}
