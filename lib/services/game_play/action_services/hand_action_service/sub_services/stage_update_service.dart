import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class StageUpdateService {
  StageUpdateService._();

  static void updatePot(var data, String key, BuildContext context) {
    try {
      List<int> pots =
          data[key]['pots']?.map<int>((e) => int.parse(e.toString()))?.toList();

      final GameState gameState = Provider.of<GameState>(
        context,
        listen: false,
      );
      final tableState = gameState.getTableState(context);

      tableState.updatePotChipsSilent(
        potChips: pots,
        potUpdatesChips: null,
      );
      tableState.notifyAll();
    } catch (e) {
      log('exception from StageUpdateService: $e');
    }
  }

  static void handle({
    BuildContext context,
    var data,
    String key,
  }) async {
    assert(key != null);
    //log('StageUpdate: $data');
    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    final TableState tableState = gameState.getTableState(context);
    final players = gameState.getPlayers(context);

    // show the move coin to pot animation, after that update the pot
    players.moveCoinsToPot().then(
      (_) async {
        // update the pot
        updatePot(data, key, context);

        // remove all the status (last action) of all the players
        players.removeAllPlayersStatusSilent();
        players.notifyAll();
      },
    );

    // update the community cards
    if (key == 'flop') {
      var board = data[key]['board'];

      List<CardObject> cards = board
          .map<CardObject>(
            (c) => CardHelper.getCard(
              int.parse(
                c.toString(),
              ),
            ),
          )
          .toList();

      //log('1 StageUpdate flop: ${cards.length}');
      tableState.flop(1, cards);

      // animate board1 flop
      tableState.setAnimateBoard1Flop(true);
      tableState.notifyAll();
      await Future.delayed(AppConstants.communityCardPushDuration);
      tableState.setAnimateBoard1Flop(false);
      // stop animation board1 flop
      tableState.notifyAll();

      // // wait for a brief moment, then flip the cards
      // await Future.delayed(AppConstants.communityCardPushDuration);
    } else if (key == 'turn') {
      //log('2 StageUpdate turn');

      tableState.turn(1, CardHelper.getCard(data[key]['${key}Card']));
      tableState.setAnimateBoard1Turn(true);
      tableState.notifyAll();

      // wait for a brief moment, then flip the last card
      await Future.delayed(AppConstants.communityCardPushDuration);
      //
      // // tableState.flipLastCard(); FIXME: WE NEED A DIFFERENT ANIMATION
      tableState.setAnimateBoard1Turn(false);
      tableState.notifyAll();
    } else if (key == 'river') {
      //log('2 StageUpdate river');

      tableState.river(1, CardHelper.getCard(data[key]['${key}Card']));
      tableState.setAnimateBoard1River(true);
      tableState.notifyAll();

      // wait for a brief moment, then flip the last card
      await Future.delayed(AppConstants.communityCardPushDuration);
      //
      // // tableState.flipLastCard(); FIXME: WE NEED A DIFFERENT ANIMATION
      tableState.setAnimateBoard1River(false);
      tableState.notifyAll();
    }
  }
}
