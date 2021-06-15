import 'dart:convert';

import 'package:hive/hive.dart';
import 'hive_models/game_settings.dart';

class GameHiveStore {
  static GameHiveStore _instance;

  GameHiveStore._();

  static GameHiveStore get getInstance => _instance ??= GameHiveStore._();
  Box _gameBox;

  GameSettings getGameSettings() {
    return GameSettings.fromJson(jsonDecode(_gameBox.get("gameSettings")));
  }

  putGameSettings(GameSettings gameSettings) {
    _gameBox.put("gameSettings", jsonEncode(gameSettings));
  }

  Future<Box> openBox(String gameCode) async {
    _gameBox = await Hive.openBox(gameCode);
    return _gameBox;
  }

  void deleteBox() {
    _gameBox.deleteFromDisk();
  }

  bool isBoxEmpty() {
    return _gameBox.isEmpty;
  }
}
