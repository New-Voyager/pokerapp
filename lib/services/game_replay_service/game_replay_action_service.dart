import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/services/audio/audio_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/game_play/action_services/result_handler_v2_json.dart';
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
    final seat = gameState.getSeat(action.action.seatNo);
    if (seat == null) return;

    final player = seat.player;

    if (_close) return;

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

    final seat = gameState.getSeat(action.seatNo);
    assert(seat != null);

    if (action.action == HandActions.FOLD) {
      AudioService.playFold();
      seat.player.playerFolded = true;
    } else {
      if (_close) return;
      seat.player.action.setAction(action);
      seat.player.stack = action.stack;
    }
    seat.notify();

    if (_close) return;

    // playing audio for action
    if (action.action == HandActions.CHECK) {
      AudioService.playCheck();
    } else {
      AudioService.playBet();
    }

    final tableState = gameState.tableState;

    tableState.updatePotChipsSilent(
      potChips: tableState.potChips,
      // potUpdatesChips: (tableState.potChipsUpdates ?? 0) + action.amount,
    );

    tableState.notifyAll();

    // reset highlight for other players
    if (_close) return;
    gameState.resetActionHighlight(-1);
  }

  Future<void> _stageUpdateUtilAction(GameReplayAction action) async {
    // show the move coin to pot animation, after that update the pot

    if (_close) return;
    final gameState = GameState.getState(_context);
    if (_close) return;

    if (_close) return;
    final TableState tableState = gameState.tableState;

    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();

    tableState.updatePotChipsSilent(
      potChips: action.pots,
      potUpdatesChips: null,
    );

    tableState.notifyAll();
    gameState.notifyAllSeats();
  }

  void _flopStartedAction(GameReplayAction action) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(action);

    if (_close) return;

    /* finally update the community cards */
    final TableState tableState = _context.read<TableState>();
    final gameState = GameState.getState(_context);

    gameState.handState = HandState.FLOP;

    gameState.communityCardState.addFlopCards(
      board1: action.boardCards,
      board2: action.boardCards2,
    );
  }

  void _riverOrTurnStartedAction(GameReplayAction action) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(action);

    if (_close) return;

    /* finally update the community cards */
    final TableState tableState = _context.read<TableState>();
    final GameState gameState = GameState.getState(_context);

    if (gameState.handState == HandState.FLOP) {
      gameState.handState = HandState.TURN;
    } else {
      gameState.handState = HandState.RIVER;
    }

    if (gameState.handState == HandState.TURN) {
      gameState.communityCardState.addTurnCard(
        board1Card: action.boardCard,
        board2Card: action.boardCard2,
      );
    } else {
      gameState.communityCardState.addRiverCard(
        board1Card: action.boardCard,
        board2Card: action.boardCard2,
      );
    }
  }

  void _showdownAction(GameReplayAction action) {
    if (_close) return;

    final GameState gameState = GameState.getState(_context);
    gameState.showdown = true;
    gameState.resetSeatActions();
    for (final player in gameState.playersInGame) {
      player.winner = false;
      player.highlightCards = [];
      player.highlight = false;
    }
    if (_close) return;

    /* then, change the status of the footer to show the result */
    gameState.handState = HandState.RESULT;

    /* update the player cards: map of <seatNo, cards> */
    for (final seatNo in action.playerCards.keys) {
      final seat = gameState.getSeat(seatNo);
      seat.player.cards = action.playerCards[seatNo];
    }
    gameState.notifyAllSeats();
  }

  Future<void> _runItTwiceAction(GameReplayAction action) =>
      HandActionProtoService.handleRunItTwiceStatic(
        context: _context,
        board1Cards: action.boardCards,
        board2Cards: action.boardCards2,
      );

  Future<void> _runItTwiceWinner(GameReplayAction action) {
    final GameState gameState = GameState.getState(_context);
    ResultHandlerV2Json resultHandler = ResultHandlerV2Json(
      replay: true,
      gameState: gameState,
      context: _context,
      handResult: action.result,
      audioPlayer: new AudioPlayer(),
    );

    return resultHandler.show();
  }

  Future<void> _potWinnerResult(GameReplayAction action) {
    ResultHandlerV2Json resultHandler = ResultHandlerV2Json(
      replay: true,
      gameState: GameState.getState(_context),
      context: _context,
      handResult: action.result,
      audioPlayer: new AudioPlayer(),
    );

    return resultHandler.show();
  }

  /* this method sets no of cards & distributes the cards */
  Future<void> _distributeCards({GameReplayAction action}) async {
    if (_close) return;
    GameState gameState = GameState.getState(_context);
    AudioService.playDeal();

    if (_close) return;
    return HandActionProtoService.cardDistribution(gameState, action.noCards);
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
