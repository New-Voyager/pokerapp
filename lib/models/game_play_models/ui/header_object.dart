import 'package:flutter/material.dart';

class HeaderObject extends ChangeNotifier {
  String _gameCode;
  int _currentHandNum;
  int _playerId;
  String _playerUuid;

  bool _gameEnded = false;

  HeaderObject({
    @required String gameCode,
    @required int playerId,
    @required String playerUuid,
  }) {
    this._gameCode = gameCode;
    this._playerId = playerId;
    this._playerUuid = playerUuid;
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

  String get gameCode => _gameCode;
  int get currentHandNum => _currentHandNum;
  bool get gameEnded => _gameEnded;
  String get playerUuid => _playerUuid;
  int get playerId => _playerId;
}
