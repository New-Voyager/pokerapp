import 'package:flutter/material.dart';
import 'package:pokerapp/models/player_info.dart';

class GameContextObject extends ChangeNotifier {
  String _gameCode;
  int _gameId;
  int _currentHandNum;
  PlayerInfo _currentPlayer;
  bool _gameEnded = false;

  GameContextObject({
    @required String gameCode,
    @required PlayerInfo player,
  }) {
    this._gameCode = gameCode;
    this._currentPlayer = player;
    this._gameId = 0;
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
    if (_currentPlayer.role.isHost || _currentPlayer.role.isManager || _currentPlayer.role.isOwner) {
      return true;
    }
    return false;
  }
}
