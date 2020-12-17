import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/services/app/auth_service.dart';

/*
* This class is made, to handle every player updates, and for every update,
* notify the underlying widgets for changes,
* so, there might b many methods, which handles different updates
* */

class Players extends ChangeNotifier {
  List<PlayerModel> _players;

  Players({
    @required players,
  }) {
    this._players = players;
    _notify();
  }

  List<PlayerModel> get players => _players;

  void _notify() async {
    // search and mark the current player (isMe field)
    String myUUID = await AuthService.getUuid();
    int idx = this._players.indexWhere((p) => p.playerUuid == myUUID);

    // the current user is a player, thus update it and notify the listeners
    if (idx != -1) this._players[idx].isMe = true;
    notifyListeners();
  }

  void removeMarkersFromAllPlayer() {
    for (int i = 0; i < _players.length; i++)
      _players[i].playerType = PlayerType.None;
  }

  void addNewPlayer(PlayerModel playerModel) {
    _players.add(playerModel);
    _notify();
  }

  void updateExistingPlayer(int idx, PlayerModel newPlayerModel) {
    _players[idx] = newPlayerModel;
    _notify();
  }

  void updatePlayerType(int idx, PlayerType playerType) {
    _players[idx].playerType = playerType;
    _notify();
  }

  void updatePlayerTypeInSilent(int idx, PlayerType playerType) {
    _players[idx].playerType = playerType;
  }

  void updateHighlight(int idx, bool highlight) {
    _players[idx].highlight = highlight;
    _notify();
  }

  void updateStatus(int idx, String status) {
    _players[idx].status = status;
    _notify();
  }

  void updateStack(Map<int, int> stacks) {
    // stacks contains, <seatNo, stack> mapping

    stacks.forEach((seatNo, stack) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      _players[idx].stack = stack;
    });
    _notify();
  }

  void subtractStack(int idx, int amountToSubtract) {
    _players[idx].stack -= amountToSubtract;
    _notify();
  }

  // todo: how to identify a player that needs to be removed?
  void removePlayer(int idx) {}
}
