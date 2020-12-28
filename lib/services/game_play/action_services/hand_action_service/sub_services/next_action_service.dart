import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/services/game_play/utils/audio.dart';
import 'package:provider/provider.dart';

class NextActionService {
  NextActionService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    Audio.stop(context: context);

    int handNum = data['handNum'];
    Provider.of<HeaderObject>(
      context,
      listen: false,
    ).currentHandNum = handNum;

    var actionChange = data['actionChange'];
    int seatNo = actionChange['seatNo'];

    // highlight the current seat No
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);

    // highlight --> true
    Provider.of<Players>(
      context,
      listen: false,
    ).updateHighlight(idx, true);

    /* check if pot is available, if true, update the pot value in the table state object */
    try {
      List<int> pots = actionChange['pots']
          ?.map<int>((e) => int.parse(e.toString()))
          ?.toList();
      var potUpdates = actionChange['potUpdates'];

      Provider.of<TableState>(
        context,
        listen: false,
      ).updatePotChips(
        potChips: pots,
        potUpdatesChips: potUpdates,
      );
    } catch (e) {}
  }
}
