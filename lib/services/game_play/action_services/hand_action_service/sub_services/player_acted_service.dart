import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:provider/provider.dart';

class PlayerActedService {
  PlayerActedService._();

  static void handle({
    BuildContext context,
    var data,
  }) async {
    var playerActed = data['playerActed'];

    int seatNo = playerActed['seatNo'];

    // show a prompt regarding last player action
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere((p) => p.seatNo == seatNo);

    // before showing the prompt --> turn off the highlight
    Provider.of<Players>(
      context,
      listen: false,
    ).updateHighlight(idx, false);

    // todo: how should the UI be updated?
    // show the status message
    Provider.of<Players>(
      context,
      listen: false,
    ).updateStatus(
      idx,
      "${playerActed['action']} ${playerActed['amount'] ?? ''}",
    );

    /* FIXME: IS THIS INTENDED TO BE DONE LOCALLY?
        update the stack amount */
    int amountUsed = playerActed['amount'];

    if (amountUsed != null) {
      // subtract the amountUsed from the stack of the current player
      Provider.of<Players>(
        context,
        listen: false,
      ).subtractStack(
        idx,
        amountUsed,
      );
    }

    await Future.delayed(AppConstants.userPopUpMessageHoldDuration);

    // remove the status message
    Provider.of<Players>(
      context,
      listen: false,
    ).updateStatus(idx, null);
  }
}
