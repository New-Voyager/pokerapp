import 'package:pokerapp/models/game_replay_models/game_replay_controller.dart';

class GameReplayService {
  GameReplayService._();

  static GameReplayController buildController(dynamic data) {
    return GameReplayController();
  }
}
