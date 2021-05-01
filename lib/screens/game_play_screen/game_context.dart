import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';

/**
 * Each game has a context object.
 */
class GameContext {
  GameState gameState;
  HandActionService handActionService;
  GameComService gameComService;

  void dispose() {
    handActionService.close();
    gameComService?.dispose();
  }
}
