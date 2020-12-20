import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/hi_winners_model.dart';

class FooterResult extends ChangeNotifier {
  List<HiWinnersModel> _potWinners;

  void updateWinners(var potWinners) {
    // todo: there could be multiple pots, but for now handle for single one

    _potWinners = potWinners['0']['hiWinners']
        .map<HiWinnersModel>(
            (var hiWinner) => HiWinnersModel.fromJson(hiWinner))
        .toList();

    notifyListeners();
  }

  List<HiWinnersModel> get potWinners => _potWinners;
}
