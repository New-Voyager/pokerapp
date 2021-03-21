import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/general_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/count_down_timer.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/seat_change_confirmation_pop_up.dart';
import 'package:pokerapp/services/game_play/graphql/seat_change_service.dart';
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
      handlePlayerSeatChange(context: context, data: data);
    } else if (type == AppConstants.TableHostSeatChangeProcessStart) {
      handleHostSeatChangeStart(context: context, data: data);
    } else if (type == AppConstants.TableHostSeatChangeMove) {
      handleHostSeatChangeMove(context: context, data: data);
    } else if (type == AppConstants.TableHostSeatChangeProcessEnd) {
      handleHostSeatChangeDone(context: context, data: data);
    }
  }

  static void handlePlayerSeatChange({
    BuildContext context,
    var data,
  }) async {
    var tableUpdate = data['tableUpdate'];
    /* when this message is received, clear the table & show a notification */

    /* clear everything */
    _clearTable(context: context);

    /* show notification */
    int seatChangeTime = tableUpdate['seatChangeTime'] as int;
    List<int> seatChangeSeatNo =
        tableUpdate['seatChangeSeatNo'].map<int>((s) => int.parse(s)).toList();

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
    if (player.isMe) {
      SeatChangeConfirmationPopUp.dialog(
        context: context,
      );
    }

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
        remainingTime:
            seatChangeTime * seatChangeSeatNo.length, // TODO: MULTIPLE PLAYERS?
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

  static void handleHostSeatChangeStart({
    BuildContext context,
    var data,
  }) async {
    // if the current player is making the seat changes, then show additional buttons
    // Confirm Changes, Cancel Changes
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeInProcessStart", "seatChangeHost":"122"}}

    // for other players, show the banner sticky (stay at the top)
    // Seat arrangement in progress
    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      context,
      listen: false,
    );

    valueNotifierNotModel.value = GeneralNotificationModel(
      titleText: 'Seat change',
      subTitleText: 'Host is making changes to the table',
    );

    final gameCode = data["gameCode"].toString();
    final seatChangeHost =
        int.parse(data["tableUpdate"]["seatChangeHost"].toString());
    final seatChange = Provider.of<HostSeatChange>(context, listen: false);
    seatChange.updateSeatChangeInProgress(true);
    seatChange.updateSeatChangeHost(seatChangeHost);

    // get current seat positions
    List<PlayerInSeat> playersInSeats =
        await SeatChangeService.hostSeatChangeSeatPositions(gameCode);
    seatChange.updatePlayersInSeats(playersInSeats);

    seatChange.notifyAll();
  }

  static void handleHostSeatChangeDone({
    BuildContext context,
    var data,
  }) async {
    // if the current player is making the seat changes, remove the additional buttons
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeInProcessEnd", "seatChangeHost":"122"}}
    final ValueNotifier<GeneralNotificationModel> valueNotifierNotModel =
        Provider.of<ValueNotifier<GeneralNotificationModel>>(
      context,
      listen: false,
    );
    /* remove notification */
    valueNotifierNotModel.value = null;

    final seatChange = Provider.of<HostSeatChange>(context, listen: false);
    seatChange.updateSeatChangeInProgress(false);
    seatChange.notifyAll();
  }

  static void handleHostSeatChangeMove({
    BuildContext context,
    var data,
  }) async {
    // {"gameId":"18", "gameCode":"CG-LBH8IW24N7XGE5", "messageType":"TABLE_UPDATE", "tableUpdate":{"type":"HostSeatChangeMove", "seatMoves":[{"playerId":"131", "playerUuid":"290bf492-9dde-448e-922d-40270e163649", "name":"rich", "oldSeatNo":6, "newSeatNo":1}, {"playerId":"122", "playerUuid":"c2dc2c3d-13da-46cc-8c66-caa0c77459de", "name":"yong", "oldSeatNo":1, "newSeatNo":6}]}}
    // player is moved, show animation of the move

    final seatChange = Provider.of<HostSeatChange>(context, listen: false);
    var seatMoves = data['tableUpdate']['seatMoves'];
    for (var move in seatMoves) {
      int from = int.parse(move['oldSeatNo'].toString());
      int to = int.parse(move['newSeatNo'].toString());
      String name = move['name'].toString();
      double stack = double.parse(move['stack'].toString());
      debugPrint('Seatchange: Player $name from seat $from to $to');

      //seatChange.updateSeatChangePlayer(from, to, name, stack);
      //seatChange.animate = true;
      seatChange.onSeatdrop(from, to);
      // run animation now
      await Future.delayed(AppConstants.notificationDuration);
      //seatChange.updateSeatChangePlayer(null, null, null, null);
      //seatChange.animate = false;
    }
    final gameCode = data["gameCode"].toString();
    // get current seat positions

    final players = Provider.of<Players>(
      context,
      listen: false,
    );

    /* refresh the player model */
    players.refreshWithPlayerInSeat(
      await SeatChangeService.hostSeatChangeSeatPositions(gameCode),
    );

    // List<PlayerInSeat> playersInSeats = ;
    // seatChange.updatePlayersInSeats(playersInSeats);
    // seatChange.notifyAll();
  }
}
