import 'package:flutter/material.dart';

class HeaderObject extends ChangeNotifier {
  String _gameCode;
  int _currentHandNum;

  HeaderObject({
    @required String gameCode,
  }) {
    this._gameCode = gameCode;
  }

  set currentHandNum(int newValue) {
    if (this._currentHandNum == newValue) return;

    this._currentHandNum = newValue;
    notifyListeners();
  }

  String get gameCode => _gameCode;
  int get currentHandNum => _currentHandNum;
}
