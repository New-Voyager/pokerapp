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
  void _takeAction(GameReplayAction gameReplayAction) =>
      GameReplayActionService.takeAction(
        gameReplayAction,
        _context,
      );

  Timer _buildTimer() => Timer.periodic(
        AppConstants.replayPauseDuration,
        (_) {
          GameReplayAction nextAction = _getNextAction();

          /* if next Action is null, then there are no more actions to replay */
          if (nextAction == null)
            _timer.cancel();
          else
            _takeAction(nextAction);
        },
      );

  /* this method initializes the controller, i.e puts data into the provider models
    & other initial setups are done here*/
  void initController(BuildContext context) {
    this._context = context;

    isPlaying.listen((bool _isPlaying) {
      if (_isPlaying) {
        _timer = _buildTimer();
      } else {
        _timer.cancel();
      }
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
