import 'package:flutter/material.dart';

class NewGameSettingsServices extends ChangeNotifier {
  final List<String> _gameTypes = [
    "No Limit Heldom",
    "PLO",
    "PLO(Hi-Lo)",
    "5 Card PLO",
    "5 Card PLO(Hi-Lo)",
    "ROE(NLH, PLO)",
    "ROE(NLH, PLO, PLO Hi-Lo)",
    "ROE(PLO, PLO Hi-Lo)",
    "ROE(5 Card PLO, 5 Card PLO Hi-Lo)"
  ];

  String _currentGameType = "No Limit Heldom";
  int _currentGameIndex = 0;
  int _smallBlind = 1;
  int _bigBlind = 2;
  int _straddle = 4;
  int _ante = 0;

  String get currentGameType => _currentGameType;
  int get currentGameIndex => _currentGameIndex;
  int get smallBlind => _smallBlind;
  int get bigBlind => _bigBlind;
  int get straddle => _straddle;
  int get ante => _ante;

  List<String> get gameTypes => _gameTypes;

  updateGameType(int index) {
    _currentGameIndex = index;
    _currentGameType = _gameTypes[index];
    notifyListeners();
  }

  updateSmallBlind(int smallBlind) {
    _smallBlind = smallBlind;
    notifyListeners();
  }

  updateBigBlind(int bigBlind) {
    _bigBlind = bigBlind;
    notifyListeners();
  }

  updateStraddle(int straddle) {
    _straddle = straddle;
    notifyListeners();
  }

  updateAnte(int ante) {
    _ante = ante;
    notifyListeners();
  }
}
