import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';
import 'package:pokerapp/resources/app_constants.dart';
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
    notifyAll();
  }

  List<PlayerModel> get players => _players;

  void notifyAll() async {
    // search and mark the current player (isMe field)
    String myUUID = await AuthService.getUuid();
    int idx = this._players.indexWhere((p) => p.playerUuid == myUUID);

    // the current user is a player, thus update it and notify the listeners
    if (idx != -1) this._players[idx].isMe = true;
    notifyListeners();
  }

  void refreshWithPlayerInSeat(List<PlayerInSeat> playersInSeat) {
    assert(playersInSeat != null);

    _players.clear();

    playersInSeat.forEach((playerInSeatModel) {
      _players.add(PlayerModel(
        name: playerInSeatModel.name,
        seatNo: playerInSeatModel.seatNo,
        playerUuid: playerInSeatModel.playerId,
        stack: playerInSeatModel.stack.toInt(),
      ));
    });

    notifyAll();
  }

  void updatePlayerFoldedStatusSilent(int idx, bool folded) {
    _players[idx].animatingFold = true;
    _players[idx].playerFolded = true;
    _players[idx].playerFolded = folded;
  }

  void removeAllFoldedPlayersSilent() {
    for (int i = 0; i < _players.length; i++) _players[i].playerFolded = null;
  }

  void removeMarkersFromAllPlayerSilent() {
    for (int i = 0; i < _players.length; i++)
      _players[i].playerType = TablePosition.None;
  }

  void addNewPlayerSilent(PlayerModel playerModel) {
    _players.add(playerModel);
  }

  void updateExistingPlayerSilent(int idx, PlayerModel newPlayerModel) {
    _players[idx] = newPlayerModel;
  }

  void updatePlayerTypeSilent(int idx, TablePosition playerType,
      {int coinAmount}) {
    _players[idx].playerType = playerType;
    if (coinAmount != null) {
      _players[idx].coinAmount = coinAmount;
    }
  }

  void fireworkWinnerSilent(int seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx != -1) _players[idx].showFirework = true;
  }

  void removeFireworkSilent(int seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx != -1) _players[idx].showFirework = null;
  }

  void highlightWinnerSilent(int seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx != -1) _players[idx].winner = true;
  }

  void removeWinnerHighlightSilent() {
    for (int i = 0; i < _players.length; i++) _players[i].winner = null;
  }

  void updateHighlightSilent(int idx, bool highlight) {
    _players[idx].highlight = highlight;
  }

  void removeAllHighlightsSilent() {
    for (int i = 0; i < _players.length; i++) _players[i].highlight = false;
  }

  void highlightCardsSilent({int seatNo, List<int> cards}) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].highlightCards = cards;
  }

  void updateStatusSilent(int idx, String status) {
    _players[idx].status = status;
  }

  void updateCoinAmountSilent(int idx, int amount) {
    _players[idx].coinAmount = amount;
  }

  Future<void> resetMoveCoinsFromPotSilent() async {
    for (int idx = 0; idx < players.length; idx++) {
      _players[idx].animatingCoinMovement = false;
      _players[idx].animatingCoinMovementReverse = false;
      _players[idx].coinAmount = null;
    }
  }

  Future<void> moveCoinsFromPotSilent(int idx, int amount) async {
    /* move all the coins to the pot  */
    _players[idx].animatingCoinMovement = true;
    _players[idx].animatingCoinMovementReverse = true;
    _players[idx].coinAmount = amount;
  }

  Future<void> moveCoinsToPot() async {
    /* move all the coins to the pot  */
    for (int i = 0; i < _players.length; i++) {
      _players[i].animatingCoinMovement = true;
    }
    notifyListeners();

    // waiting for double the animation time
    await Future.delayed(AppConstants.animationDuration);

    for (int i = 0; i < _players.length; i++) {
      _players[i].animatingCoinMovement = false;
      _players[i].coinAmount = null;
    }
    notifyListeners();
  }

  Future<void> removeAllPlayersStatusSilent() async {
    for (int i = 0; i < _players.length; i++) {
      _players[i].status = null;
      _players[i].coinAmount = null;
    }
  }

  void updateStackBulkSilent(var stackData) {
    Map<int, int> stacks = Map<int, int>();

    stackData.forEach((key, value) =>
        stacks[int.parse(key.toString())] = int.parse(value.toString()));

    // stacks contains, <seatNo, stack> mapping
    stacks.forEach((seatNo, stack) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      _players[idx].stack = stack;
    });
  }

  void updateStackWithValueSilent(int idx, int newStack) {
    _players[idx].stack = newStack;
  }

  void updateUserCardsSilent(Map<int, List<int>> data) {
    /* seat-no, list of cards */
    data.forEach((seatNo, cards) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      if (idx != -1) _players[idx].cards = cards;
    });
  }

  void updateCardSilent(int seatNo, List<int> cards) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].cards = cards;
  }

  void updateVisibleCardNumberSilent(int seatNo, int n) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].noOfCardsVisible = n;
  }

  void visibleCardNumbersForAllSilent(int n) {
    for (int i = 0; i < _players.length; i++) _players[i].noOfCardsVisible = n;
  }

  void removeCardsFromAllSilent() {
    for (int i = 0; i < _players.length; i++) _players[i].noOfCardsVisible = 0;
    for (int i = 0; i < _players.length; i++) _players[i].cards = null;
  }

  void removePlayerSilent(int seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players.removeAt(idx);
  }

  PlayerModel get me {
    PlayerModel tmp = this._players.firstWhere(
          (u) => u.isMe,
          orElse: () => null,
        );
    return tmp;
  }
}
