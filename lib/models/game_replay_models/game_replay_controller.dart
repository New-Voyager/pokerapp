import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_replay_service/game_replay_action_service.dart';

class GameReplayController {
  BuildContext _context;

  GameState _gameState;
  List<GameReplayAction> _actions;

  StreamController<bool> _isPlayingStreamController;
  bool _isPlaying;

  int _actionCounter;

  Timer _timer;

  GameReplayController({
    @required GameState gameState,
    @required List<GameReplayAction> actions,
  }) {
    this._gameState = gameState;
    this._actions = actions;

    this._isPlayingStreamController = StreamController<bool>.broadcast();
    this._isPlaying = false;

    this._actionCounter = -1;
  }

  /* private util methods */

  GameReplayAction _getNextAction() {
    _actionCounter += 1;
    if (_actionCounter < _actions.length) return _actions[_actionCounter];
    _actionCounter -= 1;
    return null;
  }

  /* this method takes in an replay action and executes it */
  Future<void> _takeAction(GameReplayAction action) =>
      GameReplayActionService.takeAction(action, _context);

  /* this method tries to estimate a delay for a particular action type
  * and default delay is 800 ms */
  int _estimateDelay(GameReplayAction action) {
    switch (action.gameReplayActionType) {
      case GameReplayActionType.card_distribution:
        return 0;

      case GameReplayActionType.pre_flop_started:
        return 0;

      case GameReplayActionType.player_action:
        if (action.action.actionTime == 0) return 800;
        return action.action.actionTime;

      case GameReplayActionType.flop_started:
        return 0;

      case GameReplayActionType.river_started:
        return 0;

      case GameReplayActionType.turn_started:
        return 0;

      case GameReplayActionType.showdown:
        return 0;

      case GameReplayActionType.run_it_twice_board:
        return 0;

      case GameReplayActionType.pot_winner:
        return 0;

      case GameReplayActionType.run_it_twice_winner:
        return 0;
    }

    return 0;
  }

  /* this method loads a GameReplayActionObject
  * 1. prepares to execute it
  * 2. wait for actionTime before execution
  * 3. executes it and waits until the execution finishes, then moves to the next action */
  /* and in case if the execution is interrupted, the load method ends and needs to be called
  * once again from the initController */
  void _load(final GameReplayAction action) async {
    /* if there is no action to play end it */
    if (action == null) return;

    final int waitForInMs = _estimateDelay(action);

    /* wait for the actionTime */
    await Future.delayed(Duration(milliseconds: waitForInMs));

    /* execute the action & wait for it to finish */
    await _takeAction(action);

    /* end function call if user paused */
    if (_isPlaying == false) return;

    /* if there is no interruption, load the next game action and continue */
    _load(_getNextAction());
  }

  /* this method initializes the controller, i.e puts data into the provider models
    & other initial setups are done here*/
  void initController(BuildContext context) {
    this._context = context;

    isPlaying.listen((bool _isPlaying) {
      if (_isPlaying) _load(_getNextAction());
    });
  }

  /* util methods */
  void dispose() {
    _isPlayingStreamController?.close();
    _timer?.cancel();
  }

  /* methods for controlling the game */
  void playOrPause() {
    /* toggle is playing */
    _isPlaying = !_isPlaying;
    _isPlayingStreamController.add(_isPlaying);
  }

  /* TODO: FOR THE BELOW 3 METHODS, THE BOARD CLEANUP IS NECESSARY
  *  FIXME: WITHOUT THE BOARD CLEANUP THE SKIP FORWARD AND BACKWARD WONT LOOK GOOD */

  void skipPrevious() {
    // _actionCounter -= 1;
  }

  void skipNext() {
    // _actionCounter += 1;
  }

  void repeat() {
    // _actionCounter = 0;
  }

  /* getters */
  Stream<bool> get isPlaying =>
      _isPlayingStreamController.stream.asBroadcastStream();

  GameState get gameState => _gameState;

  GameInfoModel get gameInfoModel => _gameState.gameInfo;

  String get playerUuid => _gameState.currentPlayer.uuid;
}
