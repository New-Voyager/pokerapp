import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';

/*
* This class is made, to handle every player updates, and for every update,
* notify the underlying widgets for changes,
* so, there might b many methods, which handles different updates
* todo: am i thinking it right?
* */

class Players with ChangeNotifier {
  List<PlayerModel> _players;

  Players({
    @required players,
  }) {
    this._players = players;
  }

  List<PlayerModel> get players => _players;

  // todo: need to implement this in an efficient way
  void update() {}
}
