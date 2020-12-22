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

  List<String> _numberOfPlayers = ["2", "3", "4", "5", "6", "7", "8", "9"];

  String _currentGameType = "No Limit Heldom";
  int _currentGameIndex = 0;
  int _smallBlind = 1;
  int _bigBlind = 2;
  int _straddle = 4;
  int _ante = 0;
  int _minChips = 20;
  int _maxChips = 80;
  String _choosenMaxPlayer = "9";

  String get currentGameType => _currentGameType;
  int get currentGameIndex => _currentGameIndex;
  int get smallBlind => _smallBlind;
  int get bigBlind => _bigBlind;
  int get straddle => _straddle;
  int get ante => _ante;
  int get minChips => _minChips;
  int get maxChips => _maxChips;
  String get choosenMaxPlayer => _choosenMaxPlayer;

  List<String> get gameTypes => _gameTypes;
  List<String> get numberOfPlayers => _numberOfPlayers;

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

  updateMinChips(int min) {
    _minChips = min;
    _maxChips = min * 2;
    notifyListeners();
  }

  updateMaxChips(int max) {
    _maxChips = max;
    notifyListeners();
  }

  updateChooseMaxPlayer(int index) {
    _choosenMaxPlayer = _numberOfPlayers[index];
    notifyListeners();
  }
}
