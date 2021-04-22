import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:provider/provider.dart';

class NextActionService {
  NextActionService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn

    final gameState = Provider.of<GameState>(
      context,
      listen: false,
    );

    int handNum = data['handNum'];
    Provider.of<GameContextObject>(
      context,
      listen: false,
    ).currentHandNum = handNum;

    var actionChange = data['actionChange'];
    int seatNo = actionChange['seatNo'];

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    final player = gameState.fromSeat(context, seatNo);
    assert(player != null);

    if (!player.isMe) {
      // hide action widget
      gameState.showAction(context, false);
    }

    // highlight next action player
    player.highlight = true;
    final seat = gameState.getSeat(context, seatNo);
    seat.setActionTimer(gameState.gameInfo.actionTime);
    seat.notify();

    /* check if pot is available, if true, update the pot value in the table state object */
    try {
      List<int> pots = actionChange['pots']
          ?.map<int>((e) => int.parse(e.toString()))
          ?.toList();
      var potUpdates = actionChange['potUpdates'];

      tableState.updatePotChipsSilent(
        potChips: pots,
        potUpdatesChips: potUpdates,
      );
    } catch (e) {}

    tableState.updateTableStatusSilent(null);
    tableState.notifyAll();
  }
}
