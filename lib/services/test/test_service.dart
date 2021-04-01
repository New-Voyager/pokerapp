import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/player_info.dart';

class TestService {
  static var _isTesting = false;
  static var _showResult = false;
  static PlayerInfo _currentPlayer;
  static GameInfoModel _gameInfo;
  static dynamic _result;

  TestService._();

  static bool get isTesting {
    return _isTesting;
  }

  static PlayerInfo get currentPlayer {
    return _currentPlayer;
  }

  static GameInfoModel get gameInfo {
    return _gameInfo;
  }

  static dynamic get handResult {
    return _result;
  }
  
  static bool get showResult {
    return _showResult;
  }
  
  static Future<void> load() async {
    if (_isTesting) {
      final gameData = await rootBundle.loadString('assets/sample-data/gameinfo.json');
      final jsonData = jsonDecode(gameData);
      if (jsonData["currentPlayer"] != null) {
        _currentPlayer = PlayerInfo.fromJson(jsonData["currentPlayer"]);
      }
      if (jsonData["gameInfo"] != null) {
        _gameInfo = GameInfoModel.fromJson(jsonData["gameInfo"]);
      }
      final resultData = await rootBundle.loadString('assets/sample-data/result.json');
      _result = jsonDecode(resultData);
    }
  }
}
