import 'dart:async';

import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';

class GameReplayController {
  StreamController<bool> _isPlayingStreamController;
  GameInfoModel _gameInfoModel;
  bool _isPlaying = false;

  GameReplayController() {
    _isPlayingStreamController = StreamController<bool>();
    _gameInfoModel = GameInfoModel(
      status: '',
      smallBlind: null,
      playersInSeats: [],
      bigBlind: null,
      gameType: '',
      tableStatus: '',
    );
  }

  /* private util methods */

  void _getNextAction() {}

  void _takeAction() {}

  /* util methods */
  void dispose() {
    _isPlayingStreamController.close();
  }

  /* methods for controlling the game */
  void playOrPause() {
    /* toggle is playing */
    _isPlaying = !_isPlaying;
    _isPlayingStreamController.add(_isPlaying);

    /* take necessary action */
  }

  void skipPrevious() {}

  void skipNext() {}

  void repeat() {}

  /* getters */
  Stream<bool> get isPlaying => _isPlayingStreamController.stream;

  GameInfoModel get gameInfoModel => _gameInfoModel;
}
