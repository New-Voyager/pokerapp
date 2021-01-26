import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:provider/provider.dart';

class NextActionService {
  NextActionService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    // Audio.stop(context: context); fixme: this also does not play when we need to notify the user of his/her turn

    int handNum = data['handNum'];
    Provider.of<HeaderObject>(
      context,
      listen: false,
    ).currentHandNum = handNum;

    var actionChange = data['actionChange'];
    int seatNo = actionChange['seatNo'];

    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);

    // highlight --> true
    players.updateHighlightSilent(idx, true);
    players.notifyAll();

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
