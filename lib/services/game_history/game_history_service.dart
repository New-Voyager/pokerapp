import 'package:hive/hive.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/game_history/model/game_history.dart';

class GameHistoryService {
  GameHistoryService._();

  static GameHistoryService _instance;

  static GameHistoryService get getInstance =>
      _instance ??= GameHistoryService._();

  static Box _gameHistoryBox =
      HiveDatasource.getInstance.getBox(BoxType.GAME_HISTORY_BOX);

  // method to clean up all expired caches
  Future<void> cleanupExpired() async {
    List<String> gameCodesExpired = [];

    for (final String gameCode in _gameHistoryBox.keys) {
      final gameHistory = GameHistory.fromJson(_gameHistoryBox.get(gameCode));
      // check if the game history cache is expired
      if (gameHistory.isExpired()){
        // remove all the relevant files
        await _cleanupDirs(gameHistory);

        // finally collect for removing from hive
        gameCodesExpired.add(gameCode)
      }
    }

    // remove all game keys from hive
    await _gameHistoryBox.deleteAll(gameCodesExpired);

  }

  Future<void> _cleanupDirs(GameHistory gameHistory) async {}
}
