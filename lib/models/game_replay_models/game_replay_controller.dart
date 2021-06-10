import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/services/game_replay_service/game_replay_action_service.dart';

class GameReplayController {
  int _playerActionTime;
  GameState _gameState;
  List<GameReplayAction> _actions;

  GameReplayActionService _actionService;

  StreamController<bool> _isPlayingStreamController;
  StreamController<bool> _isEnded;

  bool _isPlaying;
  bool _goNext;

  int _actionCounter;

  GameReplayController({
    @required GameState gameState,
    @required List<GameReplayAction> actions,
    @required int playerActionTime,
  }) {
    this._gameState = gameState;
    this._actions = actions;
    this._playerActionTime = playerActionTime;

    this._isPlayingStreamController = StreamController<bool>.broadcast();
    this._isEnded = StreamController<bool>.broadcast();
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

  Future<void> waitAndAlsoHandleInterrupt(int waitForInMs) async {
    // run a loop for every 100 ms and check for a interrupt,
    // if there is an interrupt, return,
    // else we continue for the specified time

    int checkDurationInMs = 100;

    int n = waitForInMs ~/ checkDurationInMs;

    // invoke a loop for n times
    for (int i = 0; i < n; i++) {
      // if we need to interrupt, return from this function will end the wait
      if (_goNext == true) {
        _goNext = false; // change the _goNext value
        return;
      }

      // else we wait
      await Future.delayed(Duration(milliseconds: checkDurationInMs));
    }
  }

  /* this method needs to highlight the next player to act, before we actually
  wait for that players actionTime */
  Future<void> _playerToAct(GameReplayAction action) async {
    if (action.gameReplayActionType == GameReplayActionType.player_action) {
      // call take action function, using a new action type : player_to_act
      // along with the seat No, thus we show the player to act highlight
      _takeAction(
        GameReplayAction(
          gameReplayActionType: GameReplayActionType.player_to_act,
          action: ActionElement(
            seatNo: action.action.seatNo,
            actionTime: _playerActionTime,
          ),
        ),
      );

      // after we highlight the player, need to wait for that particular duration
      // and also during wait, need to handle any interruptions,
      // so that incase of skip request, we can end the wait and continue

      // we need to show next action player
      final int waitForInMs = _estimateDelay(action);

      await waitAndAlsoHandleInterrupt(waitForInMs);
    }

    // if actionType is not playerActed, then we dont care about the delay
    // just return from this function
  }

  /* this method takes in an replay action and executes it */
  Future<void> _takeAction(GameReplayAction action) =>
      _actionService.takeAction(action);

  /* this method estimates a delay for a "player_action" action type
  * and default delay is 800 ms */
  int _estimateDelay(GameReplayAction action) {
    if (action.gameReplayActionType == GameReplayActionType.player_action) {
      if (action.action.actionTime == 0) return 800;
      return action.action.actionTime * 1000;
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
    if (action == null) {
      onEnd();
      return;
    }

    /* check for player action, and if true wait for actionTime duration */
    await _playerToAct(action);

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
    _actionService = GameReplayActionService(context);

    isPlaying.listen((bool _isPlaying) {
      if (_isPlaying) _load(_getNextAction());
    });

    /* play when the controller is initiated */
    playOrPause();
  }

  void onEnd() {
    if (_isPlaying) playOrPause();
    _isEnded.sink.add(true);
  }

  /* util methods */
  void dispose(BuildContext context) {
    /* if we were playing something, stop that and dispose */
    if (_isPlaying) playOrPause();

    _isPlayingStreamController?.close();
    _isEnded?.close();

    Navigator.pop(context);
  }

  /* methods for controlling the game */
  void playOrPause() {
    /* toggle is playing */
    _isPlaying = !_isPlaying;
    _isPlayingStreamController.add(_isPlaying);
  }

  void skipPrevious() {
    // _actionCounter -= 1;
  }

  void skipNext() => _goNext = true;

  void repeat() {
    // reset everything and start from beginning
  }

  /* getters */
  Stream<bool> get isPlaying =>
      _isPlayingStreamController.stream.asBroadcastStream();

  Stream<bool> get isEnded => _isEnded.stream.asBroadcastStream();

  GameState get gameState => _gameState;

  GameInfoModel get gameInfoModel => _gameState.gameInfo;

  String get playerUuid => _gameState.currentPlayer.uuid;
}
