import 'package:flutter/material.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';

import 'game_state.dart';

class GameContextObject extends ChangeNotifier {
  String _gameCode;
  int _gameId;
  int _currentHandNum;
  PlayerInfo _currentPlayer;
  bool _gameEnded = false;
  GameState gameState;
  HandActionService handActionService;
  GameComService gameComService;

  GameContextObject({
    @required String gameCode,
    @required PlayerInfo player,
    GameState gameState,
    HandActionService handActionService,
    GameComService gameComService,
  }) {
    this._gameCode = gameCode;
    this._currentPlayer = player;
    this._gameId = 0;
    this.gameComService = gameComService;
    this.gameState = gameState;
    this.handActionService = handActionService;
  }

  set currentHandNum(int newValue) {
    if (this._currentHandNum == newValue) return;

    this._currentHandNum = newValue;
    notifyListeners();
  }

  set gameEnded(bool ended) {
    if (ended == _gameEnded) return;
    this._gameEnded = ended;
    notifyListeners();
  }

  int get gameId => _gameId;
  String get gameCode => _gameCode;
  int get currentHandNum => _currentHandNum;
  bool get gameEnded => _gameEnded;
  String get playerUuid => _currentPlayer.uuid;
  int get playerId => _currentPlayer.id;

  bool isAdmin() {
    if (_currentPlayer?.role?.isHost == true ||
        _currentPlayer?.role?.isManager == true ||
        _currentPlayer?.role?.isOwner == true) return true;

    return false;
  }

  @override
  void dispose() {
    handActionService.close();
    gameComService.dispose();
    super.dispose();
  }
}
