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
  int _blindStraddle = 4;
  int _ante = 0;
  int _minChips = 20;
  int _maxChips = 80;
  int _choosenMaxPlayer = 7;

  String get currentGameType => _currentGameType;
  int get currentGameIndex => _currentGameIndex;
  int get smallBlind => _smallBlind;
  int get bigBlind => _bigBlind;
  int get blindStraddle => _blindStraddle;
  int get ante => _ante;
  int get minChips => _minChips;
  int get maxChips => _maxChips;
  int get choosenMaxPlayer => _choosenMaxPlayer;

  List<String> get gameTypes => _gameTypes;
  List<String> get numberOfPlayers => _numberOfPlayers;

  // Starting Club Tips

  // Club Tips Variable
  int _percentage = 2;
  int _cap = 5;

  // Club Tips getter
  int get percentage => _percentage;
  int get cap => _cap;

  // Club Tips methods

  updatePercentage(int p) {
    _percentage = p;
    notifyListeners();
  }

  updateCap(int c) {
    _cap = c;
    notifyListeners();
  }

  // Ending Club Tips

  // Starting Straddle

  // Straddle variable
  bool _straddle = true;
  bool get straddle => _straddle;

  // Straddle methods
  updateStraddle(bool s) {
    _straddle = s;
    notifyListeners();
  }

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

  updateBlindStraddle(int s) {
    _blindStraddle = s;
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
    _choosenMaxPlayer = index;
    notifyListeners();
  }
}
