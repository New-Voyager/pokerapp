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
    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();
    // update the pot
    updatePot(data, key, context);

    players.notifyAll();

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
      tableState.addFlopCards(1, cards);

      // // wait for a brief moment, then flip the cards
      // await Future.delayed(AppConstants.communityCardPushDuration);
    } else if (key == 'turn') {
      tableState.addTurnOrRiverCard(
          1, CardHelper.getCard(data[key]['${key}Card']));
    } else if (key == 'river') {
      tableState.addTurnOrRiverCard(
          1, CardHelper.getCard(data[key]['${key}Card']));
    }

    tableState.notifyAll();
  }
}
