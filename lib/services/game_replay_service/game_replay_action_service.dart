import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/business/card_distribution_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
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
  final BuildContext _context;
  bool _close = false;

  GameReplayActionService(this._context);

  void close() => _close = true;

  void _preflopStartedAction(GameReplayAction action) {
    if (_close) return;
    TableState tableState = _context.read<TableState>();

    tableState.updatePotChipsSilent(potChips: [action.startPot]);
    tableState.notifyAll();
  }

  void _playerToAct(GameReplayAction action) {
    if (_close) return;
    final gameState = GameState.getState(_context);

    if (_close) return;
    final player = gameState.fromSeat(_context, action.action.seatNo);

    if (_close) return;
    final seat = gameState.getSeat(_context, action.action.seatNo);

    assert(player != null && seat != null);

    player.highlight = true;
    seat.setActionTimer(action.action.actionTime);
    seat.notify();
  }

  void _playerAction(GameReplayAction replayAction) {
    /*
    "seatNo":7,
    "action":"SB",
    "amount":1,
    "timedOut":false,
    "stack":0
    */

    final ActionElement action = replayAction.action;

    if (_close) return;
    final gameState = GameState.getState(_context);

    if (_close) return;
    // reset highlight for other players
    gameState.resetActionHighlight(_context, -1);

    if (_close) return;
    Players players = _context.read<Players>();

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
      if (_close) return;
      final seat = gameState.getSeat(_context, action.seatNo);
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

    if (_close) return;
    final tableState = gameState.getTableState(_context);

    tableState.updatePotChipsSilent(
      potChips: tableState.potChips,
      potUpdatesChips: (tableState.potChipsUpdates ?? 0) + action.amount,
    );

    tableState.notifyAll();
    players.notifyAll();
  }

  Future<void> _stageUpdateUtilAction(GameReplayAction action) async {
    // show the move coin to pot animation, after that update the pot

    if (_close) return;
    final gameState = GameState.getState(_context);
    if (_close) return;
    final Players players = gameState.getPlayers(_context);

    if (_close) return;
    final TableState tableState = gameState.getTableState(_context);

    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();

    tableState.updatePotChipsSilent(
      potChips: action.pots,
      potUpdatesChips: null,
    );

    tableState.notifyAll();
    players.notifyAll();
  }

  void _flopStartedAction(GameReplayAction action) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(action);

    if (_close) return;

    /* finally update the community cards */
    final TableState tableState = _context.read<TableState>();

    tableState.addFlopCards(
      1,
      action.boardCards.map((c) => CardHelper.getCard(c)).toList(),
    );

    tableState.notifyAll();
  }

  void _riverOrTurnStartedAction(GameReplayAction action) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(action);

    if (_close) return;

    /* finally update the community cards */
    final TableState tableState = _context.read<TableState>();

    tableState.addTurnOrRiverCard(
      1,
      CardHelper.getCard(action.boardCard),
    );

    tableState.notifyAll();
  }

  void _showdownAction(GameReplayAction action) {
    if (_close) return;

    final GameState gameState = GameState.getState(_context);
    gameState.resetSeatActions();

    if (_close) return;
    final Players players = gameState.getPlayers(_context);

    /* clear players for showdown */
    players.clearForShowdown();

    if (_close) return;

    /* then, change the status of the footer to show the result */
    _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.Result;

    /* remove all highlight - silently */
    players.removeAllHighlightsSilent();

    /* remove all markers from players - silently */
    players.removeMarkersFromAllPlayerSilent();

    /* update the player cards: map of <seatNo, cards> */
    players.updateUserCardsSilent(action.playerCards);

    players.notifyAll();
  }

  Future<void> _runItTwiceAction(GameReplayAction action) =>
      HandActionService.handleRunItTwiceStatic(
        context: _context,
        board1Cards: action.boardCards,
        board2Cards: action.boardCards2,
      );

  Future<void> _runItTwiceWinner(GameReplayAction action) {
    // update pots before result
    HandActionService.updatePotBeforeResultStatic(
      isRunItTwice: true,
      runItTwiceResult: action.runItTwiceResult,
      potWinners: null,
      context: _context,
    );

    return HandActionService.handleResultStatic(
      fromReplay: true,
      isRunItTwice: true,
      runItTwiceResult: action.runItTwiceResult,
      boardCards: action.boardCards,
      boardCards2: action.boardCards2,
      potWinners: null,
      context: _context,
    );
  }

  Future<void> _potWinnerResult(GameReplayAction action) {
    final Map<String, dynamic> potWinners = {};

    for (final pw in action.potWinners.entries)
      potWinners[pw.key] = pw.value.toJson();

    // update pots before result
    HandActionService.updatePotBeforeResultStatic(
      isRunItTwice: false,
      runItTwiceResult: null,
      potWinners: potWinners,
      context: _context,
    );

    return HandActionService.handleResultStatic(
      fromReplay: true,
      isRunItTwice: false,
      runItTwiceResult: null,
      boardCards2: null,
      potWinners: potWinners,
      boardCards: action.boardCards,
      context: _context,
    );
  }

  /* this method sets no of cards & distributes the cards */
  Future<void> _distributeCards({GameReplayAction action}) async {
    if (_close) return;
    GameState gameState = GameState.getState(_context);

    if (_close) return;
    final players = gameState.getPlayers(_context);

    if (_close) return;
    final handInfo = gameState.getHandInfo(_context);
    handInfo.update(noCards: action.noCards);

    if (_close) return;

    /* set the table status to NEW_HAND and thus shows the card shuffle animation */
    final tableState = gameState.getTableState(_context);
    tableState.updateTableStatusSilent(AppConstants.NEW_HAND);
    tableState.notifyAll();

    /* wait for the card shuffling animation to finish :todo can be tweaked */
    await Future.delayed(const Duration(milliseconds: 800));

    /* finding the current Player */
    final playerID = gameState.currentPlayerId;
    final PlayerModel currPlayer =
        players.players.firstWhere((p) => p.playerId == playerID);
    currPlayer.cards = action.myCards;

    final noCards = action.noCards;
    final List<int> seatNos = action.seatNos;
    final int mySeatNo = seatNos.first; // fixme: we would need this

    /* distribute cards to the players */
    /* this for loop will distribute cards one by one to all the players */
    /* for distributing the ith card, go through all the players, and give them */
    for (int seatNo in seatNos) {
      int localSeatNo = ((seatNo - mySeatNo) % 9) + 1;

      if (_close) return;

      // start the animation
      _context.read<CardDistributionModel>().seatNo = localSeatNo;
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

  Future<void> takeAction(
    GameReplayAction action,
  ) async {
    switch (action.gameReplayActionType) {
      case GameReplayActionType.card_distribution:
        return _distributeCards(action: action);

      case GameReplayActionType.pre_flop_started:
        return _preflopStartedAction(action);

      case GameReplayActionType.player_action:
        return _playerAction(action);

      case GameReplayActionType.flop_started:
        return _flopStartedAction(action);

      case GameReplayActionType.river_started:
        return _riverOrTurnStartedAction(action);

      case GameReplayActionType.turn_started:
        return _riverOrTurnStartedAction(action);

      case GameReplayActionType.showdown:
        return _showdownAction(action);

      case GameReplayActionType.run_it_twice_board:
        return _runItTwiceAction(action);

      case GameReplayActionType.pot_winner:
        return _potWinnerResult(action);

      case GameReplayActionType.run_it_twice_winner:
        return _runItTwiceWinner(action);

      case GameReplayActionType.player_to_act:
        return _playerToAct(action);
    }
  }
}
