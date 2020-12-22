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

  String get currentGameType => _currentGameType;
  int get currentGameIndex => _currentGameIndex;

  List<String> get gameTypes => _gameTypes;

  updateGameType(int index) {
    _currentGameIndex = index;
    _currentGameType = _gameTypes[index];
    notifyListeners();
  }
}
