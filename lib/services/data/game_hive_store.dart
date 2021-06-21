import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'hive_models/game_settings.dart';

class GameHiveStore {
  Box _gameBox;

  GameHiveStore();

  GameSettings getGameSettings() {
    return GameSettings.fromJson(jsonDecode(_gameBox.get("gameSettings")));
  }

  putGameSettings(GameSettings gameSettings) {
    _gameBox.put("gameSettings", jsonEncode(gameSettings));
  }

  static const _DIAMONDS = 'diamonds';
  static const _DIAMONDS_UPDATE = 'diamonds_update';
  static const _IS_FIRST_JOIN = 'is_first_join';

  bool isFirstJoin() => _gameBox.get(
        _IS_FIRST_JOIN,
        defaultValue: true,
      ) as bool;

  Future<void> setIsFirstJoinDone() => _gameBox.put(_IS_FIRST_JOIN, false);

  DateTime _getLastDiamondUpdateTime() {
    final String lastUpdateTime = _gameBox.get(_DIAMONDS_UPDATE);

    // send back the earliest time possible
    if (lastUpdateTime == null) return DateTime.fromMicrosecondsSinceEpoch(0);

    return DateTime.parse(lastUpdateTime);
  }

  /* this function is made public, because, if I rejoin the game,
  I need to start the timer fresh */

  Future<void> updateLastDiamondUpdateTime() => _gameBox.put(
        _DIAMONDS_UPDATE,
        DateTime.now().toIso8601String(),
      );

  Future<void> _addDiamonds(int num) {
    return _gameBox.put(_DIAMONDS, getDiamonds() + num);
  }

  Future<void> addDiamonds({int num = 2}) async {
    // we do not allow diamonds more than maxDiamondNumber
    if (getDiamonds() >= AppConstants.maxDiamondNumber) return;

    // if game box is not init and not opened, do nothing
    if (!(_gameBox?.isOpen ?? false)) return;

    final DateTime now = DateTime.now();
    final DateTime lastUpdatedTime = _getLastDiamondUpdateTime();

    final Duration duration = now.difference(lastUpdatedTime);

    if (duration.compareTo(AppConstants.diamondUpdateDuration) == 1) {
      // if we have waited for AppConstants.diamondUpdateDuration duration, add diamonds

      // update the last diamond update time
      await updateLastDiamondUpdateTime();

      // update diamonds
      return _addDiamonds(num);
    }
  }

  int getDiamonds() => _gameBox.get(_DIAMONDS, defaultValue: 0) as int;

  Future<void> clearDiamonds() => _gameBox.put(_DIAMONDS, 0);

  Future<void> deductDiamonds({int num = 2}) => _addDiamonds(-num);

  Future<Box> open(String gameCode) async {
    _gameBox = await Hive.openBox(gameCode);
    return _gameBox;
  }

  bool isInitialized() {
    return _gameBox.isNotEmpty;
  }

  void close() {
    _gameBox?.close();
  }

  void deleteBox() {
    _gameBox.deleteFromDisk();
  }

  bool isBoxEmpty() {
    return _gameBox.isEmpty;
  }
}
