import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class DealService {
  DealService._();

  static Uint8List dealSoundBytes;

  static void handle({
    BuildContext context,
    var data,
  }) async {
    // play the deal sound effect
    Audio.play(
      context: context,
      assetFile: AppAssets.dealSound,
    );

    int mySeatNo = data['dealCards']['seatNo'];
    String cards = data['dealCards']['cards'];

    List<int> myCards = CardHelper.getRawCardNumbers(cards);

    List<int> seatNos = Provider.of<Players>(
      context,
      listen: false,
    ).players.map((p) => p.seatNo).toList();
    seatNos.sort();

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    for (int i = 0; i < myCards.length; i++) {
      /* for distributing the ith card, go through all the players, and give them */
      for (int seatNo in seatNos) {
        int localSeatNo =
            mySeatNo == null ? seatNo : ((seatNo - mySeatNo) % 9) + 1;

        // start the animation
        Provider.of<CardDistributionModel>(
          context,
          listen: false,
        ).seatNo = localSeatNo;
        // wait for the animation to finish
        await Future.delayed(AppConstants.cardDistributionAnimationDuration);

        final players = Provider.of<Players>(
          context,
          listen: false,
        );

        if (seatNo == mySeatNo) {
          // this is me - give me my cards one by one
          players.updateCardSilent(
            mySeatNo,
            myCards.sublist(0, i + 1),
          );
        }

        players.updateVisibleCardNumberSilent(seatNo, i + 1);
        players.notifyAll();
      }
    }

    /* card distribution ends, put the value to NULL */
    Provider.of<CardDistributionModel>(
      context,
      listen: false,
    ).seatNo = null;
  }
}
