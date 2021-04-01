import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';

class HandResultState extends ChangeNotifier {
  int _handNum;
  bool _isAvailable;
  List<HiWinnersModel> _potWinners;

  HandResultState() {
    _isAvailable = false;
  }

  List<HiWinnersModel> updateWinners(var potWinners) {
    // todo: there could be multiple pots, but for now handle for single one

    _potWinners = potWinners['0']['hiWinners']
        .map<HiWinnersModel>(
            (var hiWinner) => HiWinnersModel.fromJson(hiWinner))
        .toList();

    _isAvailable = true;
    notifyListeners();

    return _potWinners;
  }

  void reset() {
    _isAvailable = false;
    notifyListeners();
  }

  void notifyAll() => notifyListeners();

  List<HiWinnersModel> get potWinners => _potWinners;
  bool get isAvailable => _isAvailable;
  int get handNum => _handNum;
}
