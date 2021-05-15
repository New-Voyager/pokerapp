import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
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

    tableState.updatePotChipsSilent(potChips: [action.startPot]);
    tableState.notifyAll();
  }

  static void _playerAction(
    GameReplayAction replayAction,
    BuildContext context,
  ) {
    /*
    "seatNo":7,
    "action":"SB",
    "amount":1,
    "timedOut":false,
    "stack":0
    */

    final ActionElement action = replayAction.action;

    final gameState = GameState.getState(context);
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere(
      (p) => p.seatNo == action.seatNo,
    );

    assert(idx != -1);

    if (action.action == HandActions.FOLD)
      players.updatePlayerFoldedStatusSilent(
        idx,
        true,
      );
    else {
      final seat = gameState.getSeat(context, action.seatNo);
      seat.player.action.setAction(action);

      players.updateStatusSilent(
        idx,
        handActionsToString(action.action),
      );

      players.updateStackWithValueSilent(
        action.seatNo,
        action.stack,
      );
    }

    final tableState = gameState.getTableState(context);

    tableState.updatePotChipsSilent(
      potChips: tableState.potChips,
      potUpdatesChips: (tableState.potChipsUpdates ?? 0) + action.amount,
    );

    tableState.notifyAll();
    players.notifyAll();
  }

  static Future<void> _stageUpdateUtilAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    // show the move coin to pot animation, after that update the pot

    final gameState = GameState.getState(context);
    final Players players = gameState.getPlayers(context);
    final TableState tableState = gameState.getTableState(context);

    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();

    tableState.updatePotChipsSilent(
      potChips: [action.startPot],
      potUpdatesChips: null,
    );

    tableState.notifyAll();
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

    tableState.addFlopCards(
      1,
      action.boardCards.map((c) => CardHelper.getCard(c)).toList(),
    );

    tableState.notifyAll();
  }

  static void _riverOrTurnStartedAction(
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

    tableState.addTurnOrRiverCard(
      1,
      CardHelper.getCard(action.boardCard),
    );

    tableState.notifyAll();
  }

  static void _showdownAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    final GameState gameState = GameState.getState(context);
    gameState.resetSeatActions();

    final Players players = gameState.getPlayers(context);

    /* clear players for showdown */
    players.clearForShowdown();

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    /* remove all highlight - silently */
    players.removeAllHighlightsSilent();

    /* remove all markers from players - silently */
    players.removeMarkersFromAllPlayerSilent();

    /* update the player cards: map of <seatNo, cards> */
    players.updateUserCardsSilent(action.playerCards);

    players.notifyAll();
  }

  static Future<void> _runItTwiceAction(
    GameReplayAction action,
    BuildContext context,
  ) =>
      HandActionService.handleRunItTwiceStatic(
        context: context,
        board1Cards: action.boardCards,
        board2Cards: action.boardCards2,
      );

  static Future<void> _runItTwiceWinner(
    GameReplayAction action,
    BuildContext context,
  ) =>
      HandActionService.handleResultStatic(
        fromReplay: true,
        isRunItTwice: true,
        runItTwiceResult: action.runItTwiceResult,
        boardCards: action.boardCards,
        boardCards2: action.boardCards2,
        winners: null,
        context: context,
      );

  static Future<void> _potWinnerAction(
    GameReplayAction action,
    BuildContext context,
  ) =>
      HandActionService.handleResultStatic(
        isRunItTwice: false,
        runItTwiceResult: null,
        boardCards2: null,
        winners:
            action.potWinners['0'].hiWinners.map((hw) => hw.toJson()).toList(),
        boardCards: action.boardCards,
        context: context,
      );

  /* this method sets no of cards & distributes the cards */
  static Future<void> _distributeCards({
    GameReplayAction action,
    BuildContext context,
  }) async {
    GameState gameState = GameState.getState(context);

    final players = gameState.getPlayers(context);

    final handInfo = gameState.getHandInfo(context);
    handInfo.update(noCards: action.noCards);

    /* set the table status to NEW_HAND and thus shows the card shuffle animation */
    final tableState = gameState.getTableState(context);
    tableState.updateTableStatusSilent(AppConstants.NEW_HAND);
    tableState.notifyAll();

    /* wait for the card shuffling animation to finish :todo can be tweaked */
    await Future.delayed(const Duration(milliseconds: 800));

    final noCards = action.noCards;
    final List<int> seatNos = action.seatNos;
    final int mySeatNo = seatNos.first; // fixme: we would need this

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    /* for distributing the ith card, go through all the players, and give them */
    for (int seatNo in seatNos) {
      int localSeatNo = ((seatNo - mySeatNo) % 9) + 1;

      // start the animation
      Provider.of<CardDistributionModel>(
        context,
        listen: false,
      ).seatNo = localSeatNo;
      // wait for the animation to finish
      await Future.delayed(AppConstants.cardDistributionAnimationDuration);

      //debugPrint('Setting cards for $seatNo');
      players.updateVisibleCardNumberSilent(seatNo, noCards);
      players.notifyAll();
    }

    /* remove the center card */
    tableState.updateTableStatusSilent(null);
    tableState.notifyAll();
  }

  static Future<void> takeAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    log('takeAction: actionType: ${action.gameReplayActionType}');

    assert(context != null);

    switch (action.gameReplayActionType) {
      case GameReplayActionType.card_distribution:
        return _distributeCards(context: context, action: action);

      case GameReplayActionType.pre_flop_started:
        return _preflopStartedAction(action, context);

      case GameReplayActionType.player_action:
        return _playerAction(action, context);

      case GameReplayActionType.flop_started:
        return _flopStartedAction(action, context);

      case GameReplayActionType.river_started:
        return _riverOrTurnStartedAction(action, context);

      case GameReplayActionType.turn_started:
        return _riverOrTurnStartedAction(action, context);

      case GameReplayActionType.showdown:
        return _showdownAction(action, context);

      case GameReplayActionType.run_it_twice_board:
        return _runItTwiceAction(action, context);

      case GameReplayActionType.pot_winner:
        return _potWinnerAction(action, context);

      case GameReplayActionType.run_it_twice_winner:
        return _runItTwiceWinner(action, context);
    }
  }
}
