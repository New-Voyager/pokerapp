import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:provider/provider.dart';

class NextActionService {
  NextActionService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    int seatNo = data['actionChange']['seatNo'];

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
  }
}
