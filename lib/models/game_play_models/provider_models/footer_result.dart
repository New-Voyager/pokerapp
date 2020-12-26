import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';

class FooterResult extends ChangeNotifier {
  bool _isEmpty;
  List<HiWinnersModel> _potWinners;

  FooterResult() {
    _isEmpty = true;
  }

  List<HiWinnersModel> updateWinners(var potWinners) {
    // todo: there could be multiple pots, but for now handle for single one

    _potWinners = potWinners['0']['hiWinners']
        .map<HiWinnersModel>(
            (var hiWinner) => HiWinnersModel.fromJson(hiWinner))
        .toList();

    _isEmpty = false;
    notifyListeners();

    return _potWinners;
  }

  void reset() {
    _isEmpty = true;
    notifyListeners();
  }

  List<HiWinnersModel> get potWinners => _potWinners;
  bool get isEmpty => _isEmpty;
}
