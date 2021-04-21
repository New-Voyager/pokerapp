import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/card_back_assets.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class NewHandService {
  NewHandService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    /* play the new hand sound effect */
    Audio.play(
      context: context,
      assetFile: AppAssets.newHandSound,
    );

    /* data contains the dealer, small blind and big blind seat Positions
    * Update the Players object with these information */

    final handData = jsonEncode(data);
    log('New Hand: $handData');

    var newHand = data['newHand'];

    // there are seat nos
    int dealerPos = newHand['buttonPos'];
    int sbPos = newHand['sbPos'];
    int bbPos = newHand['bbPos'];
    int noCards = newHand['noCards'];
    int bigBlind = double.parse(newHand['bigBlind'].toString()).toInt();
    int smallBlind = double.parse(newHand['smallBlind'].toString()).toInt();

    GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    final handInfo = gameState.getHandInfo(context);
    handInfo.update(noCards: noCards);

    final Players players = gameState.getPlayers(context);

    final TableState tableState = gameState.getTableState(context);

    gameState.resetPlayers(context, notify: false);

    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.None;

    // update player's state and stack
    final dynamic playersInSeats = newHand['playersInSeats'];
    for (final seatNoStr in playersInSeats.keys) {
      final seatNo = int.parse(seatNoStr);
      final seat = gameState.getSeat(context, seatNo);
      if (seat != null && seat.player != null) {
        final dynamic playerUpdate = playersInSeats[seatNoStr];
        final double stack = double.parse(playerUpdate['stack'].toString());
        seat.player.stack = stack.toInt();

        final String statusStr = playerUpdate['status'].toString();
        final status = PlayerStatus.values.firstWhere(
            (element) => (element.toString() == 'PlayerStatus.' + statusStr));
        seat.player.status = playerUpdate['status'].toString();
        if (status == PlayerStatus.WAIT_FOR_BUYIN ||
            status == PlayerStatus.WAIT_FOR_BUYIN_APPROVAL) {
          // show buyin timer
          seat.player.showBuyIn = true;
          seat.player.buyInTimeExpAt =
              DateTime.parse(playerUpdate['buyInExpTime'].toString());

          // show buyin button
          if (seat.player.isMe) {
            gameState.getMyState(context).notify();
          }
        } else {
          seat.player.showBuyIn = false;
          seat.player.buyInTimeExpAt = null;
        }
      }
    }

    /* marking the small blind */
    int smallBlindIdx = players.players.indexWhere((p) => p.seatNo == sbPos);
    assert(smallBlindIdx != -1);

    players.updatePlayerTypeSilent(
      smallBlindIdx,
      TablePosition.SmallBlind,
      coinAmount: smallBlind,
    );

    /* marking the big blind */
    int bigBlindIdx = players.players.indexWhere((p) => p.seatNo == bbPos);
    assert(bigBlindIdx != -1);
    players.updatePlayerTypeSilent(
      bigBlindIdx,
      TablePosition.BigBlind,
      coinAmount: bigBlind,
    );

    /* marking the dealer */
    int dealerIdx = players.players.indexWhere((p) => p.seatNo == dealerPos);
    //print('dealer index: $dealerIdx');
    assert(dealerIdx != -1);
    players.updatePlayerTypeSilent(
      dealerIdx,
      TablePosition.Dealer,
    );

    players.notifyAll();

    /* get a new card back asset to be shown */
    Provider.of<ValueNotifier<String>>(
      context,
      listen: false,
    ).value = CardBackAssets.getRandom();

    // wait for the fastAnimationDuration completion
    // this is done to wait until the footerResult section is removed
    await Future.delayed(AppConstants.fastAnimationDuration);

    // remove all the community cards
    tableState.clear();
    /* put new hand message */
    tableState.updateTableStatusSilent(AppConstants.NEW_HAND);

    tableState.notifyAll();
  }
}
