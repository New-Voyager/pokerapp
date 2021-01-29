import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/seat_change_confirmation_pop_up.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/count_down_timer.dart';
import 'package:provider/provider.dart';

class TableUpdateService {
  TableUpdateService._();

  /* this method clears the result views and
  removes community cards, pots and everything */
  static void _clearTable({
    BuildContext context,
  }) {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    // remove all highlight winners
    players.removeWinnerHighlightSilent();

    // before marking the small, big blind or the dealer, remove any marking from the old hand
    players.removeMarkersFromAllPlayerSilent();

    // remove all the status (last action) of all the players
    players.removeAllPlayersStatusSilent();

    // remove all the folder players
    players.removeAllFoldedPlayersSilent();

    /* reset the noCardsVisible of each player and remove my cards too */
    players.removeCardsFromAllSilent();

    /* reset the reverse pot chips animation */
    players.resetMoveCoinsFromPotSilent();

    players.notifyAll();

    /* clean up from result views */
    /* set footer status to none  */
    /* clearing the footer result */
    Provider.of<FooterResult>(
      context,
      listen: false,
    ).reset();

    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.None;

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );
    // remove all the community cards
    tableState.updateCommunityCardsSilent([]);
    tableState.updatePotChipsSilent(
      potChips: null,
      potUpdatesChips: null,
    );
    /* put new hand message */
    tableState.updateTableStatusSilent(AppConstants.SeatChangeInProgress);
    tableState.notifyAll();
  }

  static void handle({
    BuildContext context,
    var data,
  }) async {
    var tableUpdate = data['tableUpdate'];
    String type = tableUpdate['type'];

    // TODO: HOW TO HANDLE MULTIPLE PLAYER'S SEAT CHANGE?
    if (type == AppConstants.SeatChangeInProgress) {
      /* when this message is received, clear the table & show a notification */

      /* clear everything */
      _clearTable(context: context);

      /* show notification */
      int seatChangeTime = tableUpdate['seatChangeTime'] as int;
      List<int> seatChangeSeatNo = tableUpdate['seatChangeSeatNo']
          .map<int>((s) => int.parse(s))
          .toList();

      final Players players = Provider.of<Players>(
        context,
        listen: false,
      );

      final int idx = players.players.indexWhere(
        (p) =>
            p.seatNo ==
            seatChangeSeatNo[0], // FIXME: FOR NOW JUST SHOWING THE FIRST USER
      );

      assert(idx != -1);

      final PlayerModel player = players.players[idx];

      /* If I am in this list, show me a confirmation popup */
      if (player.isMe)
        SeatChangeConfirmationPopUp.dialog(
          context: context,
        );

      final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
          Provider.of<ValueNotifier<GeneralNotificationModel>>(
        context,
        listen: false,
      );

      valueNotifierNotModel.value = GeneralNotificationModel(
        titleText: 'Seat change in progress',
        subTitleText:
            'Seat change requested by ${player.name} at seat no ${player.seatNo}',
        trailingWidget: CountDownTimer(
          remainingTime: seatChangeTime *
              seatChangeSeatNo.length, // TODO: MULTIPLE PLAYERS?
        ),
      );

      await Future.delayed(
        Duration(
          seconds: seatChangeTime * seatChangeSeatNo.length,
        ), // TODO: MULTIPLE PLAYERS?
      );

      /* remove notification */
      valueNotifierNotModel.value = null;
    }
  }
}
