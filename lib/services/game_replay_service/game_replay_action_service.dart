import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/deal_started_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class GameReplayActionService {
  GameReplayActionService._();

  static void _preflopStartedAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    int pot = action.actionData['pot'] as int;

    tableState.updatePotChipsSilent(potChips: [pot]);
    tableState.notifyAll();
  }

  static void _playerAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    /*
    "seatNo":7,
    "action":"SB",
    "amount":1,
    "timedOut":false,
    "stack":0
    */

    int seatNo = action.actionData['seatNo'] as int;
    String actionName = action.actionData['action'] as String;
    int amount = action.actionData['amount'] as int;
    bool timedOut = action.actionData['timedOut'] as bool;
    int stack = action.actionData['stack'] as int;

    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere(
      (p) => p.seatNo == seatNo,
    );

    assert(idx != -1);

    if (actionName == AppConstants.FOLD)
      players.updatePlayerFoldedStatusSilent(
        idx,
        true,
      );
    else {
      players.updateCoinAmountSilent(
        idx,
        amount,
      );

      players.updateStatusSilent(
        idx,
        actionName,
      );

      players.updateStackWithValueSilent(
        idx,
        stack,
      );
    }

    players.notifyAll();
  }

  static Future<void> _stageUpdateUtilAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    // show the move coin to pot animation, after that update the pot
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    await players.moveCoinsToPot();

    tableState.updatePotChipsSilent(
      potChips: [action.actionData['pot']],
      potUpdatesChips: null,
    );
    tableState.notifyAll();

    // remove all the status (last action) of all the players
    players.removeAllPlayersStatusSilent();
    players.notifyAll();
  }

  static void _flopStartedAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(
      action,
      context,
    );

    /* finally update the community cards */
    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    /* FIXME: HARD CODED FOR BOARD 1 */
    tableState.flop(
      1,
      action.actionData['cards']
          .map<CardObject>(
            (c) => CardHelper.getCard(c as int),
          )
          .toList(),
    );

    tableState.notifyAll();
  }

  static void _riverOrTurnStartedAction(
    GameReplayAction action,
    BuildContext context, {
    bool isRiver = false,
  }) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(
      action,
      context,
    );

    /* finally update the community cards */
    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    /* FIXME: HARD CODED FOR BOARD 0 */

    if (isRiver) {
      tableState.river(
        1,
        CardHelper.getCard(
          action.actionData['cards'][0],
        ),
      );
    } else {
      tableState.turn(
        1,
        CardHelper.getCard(
          action.actionData['cards'][0],
        ),
      );
    }

    tableState.notifyAll();
  }

  static void takeAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    log('takeAction : ${action.actionType}');

    assert(context != null);

    switch (action.actionType) {
      case GameReplayActionType.card_distribution:
        GameState gameState = Provider.of<GameState>(
          context,
          listen: false,
        );

        // TODO: FIND A GOOD PLACE TO UPDATE THE NO. OF CARDS

        final handInfo = gameState.getHandInfo(context);
        handInfo.update(noCards: 2);

        /* set the table status to NEW_HAND and thus shows the card shuffle animation */
        final tableState = gameState.getTableState(context);
        tableState.updateTableStatusSilent(AppConstants.NEW_HAND);
        tableState.notifyAll();

        // TODO: DO SOMETHING ABOUT THE DURATION
        await Future.delayed(const Duration(seconds: 2));

        return DealStartedService.handle(
          context: context,
          fromGameReplay: true,
        );

      case GameReplayActionType.pre_flop_started:
        return _preflopStartedAction(
          action,
          context,
        );

      case GameReplayActionType.player_action:
        return _playerAction(
          action,
          context,
        );

      case GameReplayActionType.flop_started:
        return _flopStartedAction(
          action,
          context,
        );

      case GameReplayActionType.river_started:
        return _riverOrTurnStartedAction(
          action,
          context,
          isRiver: true,
        );

      case GameReplayActionType.turn_started:
        return _riverOrTurnStartedAction(
          action,
          context,
          isRiver: false,
        );

      case GameReplayActionType.showdown:
        // TODO: Handle this case.
        break;

      case GameReplayActionType.declare_winner:
        // TODO: Handle this case.
        break;
    }
  }
}
