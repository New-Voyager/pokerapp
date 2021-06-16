import 'dart:convert';

import 'package:hive/hive.dart';
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
