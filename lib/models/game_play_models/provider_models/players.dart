import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
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

  void updatePlayerFoldedStatus(int idx, bool folded) {
    _players[idx].playerFolded = folded;
    _notify();
  }

  void removeAllFoldedPlayers() {
    for (int i = 0; i < _players.length; i++) _players[i].playerFolded = null;
    _notify();
  }

  void removeMarkersFromAllPlayer() {
    for (int i = 0; i < _players.length; i++)
      _players[i].playerType = PlayerType.None;
    _notify();
  }

  void addNewPlayer(PlayerModel playerModel) {
    _players.add(playerModel);
    _notify();
  }

  void updateExistingPlayer(int idx, PlayerModel newPlayerModel) {
    _players[idx] = newPlayerModel;
    _notify();
  }

  void updatePlayerType(int idx, PlayerType playerType, {int coinAmount, bool notify}) {
    _players[idx].playerType = playerType;
    if (coinAmount != null) {
      _players[idx].coinAmount = coinAmount;
    }
    if (notify == null) {
      notify = true;
    }
    if (notify) {
      _notify();
    }
  }

  void updatePlayerTypeInSilent(int idx, PlayerType playerType) {
    _players[idx].playerType = playerType;
  }

  void highlightWinner(seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    log('\n\n\n\n\n\n winner index :$idx seatNo: $seatNo \n\n\n\n\n\n');
    if (idx != -1) _players[idx].winner = true;
    _notify();
  }

  void removeWinnerHighlight() {
    for (int i = 0; i < _players.length; i++) _players[i].winner = null;
    _notify();
  }

  void updateHighlight(int idx, bool highlight) {
    _players[idx].highlight = highlight;
    _notify();
  }

  void removeAllHighlights() {
    for (int i = 0; i < _players.length; i++) _players[i].highlight = false;
  }

  void highlightCards({int seatNo, List<int> cards}) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].highlightCards = cards;
    _notify();
  }

  void updateStatus(int idx, String status) {
    _players[idx].status = status;
    _notify();
  }

  void updateCoinAmount(int idx, int amount) {
    if (_players[idx].coinAmount == null)
      _players[idx].coinAmount = amount;
    else
      _players[idx].coinAmount = amount;
    _notify();
  }

  Future<void> moveCoinsToPot() async {
    /* move all the coins to the pot  */
    for (int i = 0; i < _players.length; i++) {
      _players[i].animatingCoinMovement = true;
    }
    _notify();

    // waiting for double the animation time
    await Future.delayed(AppConstants.animationDuration);

    for (int i = 0; i < _players.length; i++) {
      _players[i].animatingCoinMovement = false;
      _players[i].coinAmount = null;
    }
    _notify();
  }

  Future<void> removeAllPlayersStatus() async {
    for (int i = 0; i < _players.length; i++) {
      _players[i].status = null;
      _players[i].coinAmount = null;
    }
    _notify();
  }

  void updateStackSilent(var stackData) {
    Map<int, int> stacks = Map<int, int>();

    stackData.forEach((key, value) =>
        stacks[int.parse(key.toString())] = int.parse(value.toString()));

    // stacks contains, <seatNo, stack> mapping
    stacks.forEach((seatNo, stack) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      _players[idx].stack = stack;
    });
  }

  void updateStack(var stackData) {
    updateStackSilent(stackData);
    _notify();
  }

  void updateStackWithValue(int idx, int newStack) {
    _players[idx].stack = newStack;
    _notify();
  }

  void updateUserCards(Map<int, List<int>> data) {
    /* seat-no, list of cards */
    data.forEach((seatNo, cards) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      if (idx != -1) _players[idx].cards = cards;
    });

    _notify();
  }

  void updateCard(int seatNo, List<int> cards) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].cards = cards;

    _notify();
  }

  void updateVisibleCardNumber(int seatNo, int n) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].noOfCardsVisible = n;

    _notify();
  }

  void visibleCardNumbersForAll(int n) {
    for (int i = 0; i < _players.length; i++) _players[i].noOfCardsVisible = n;

    _notify();
  }

  void removeCardsFromAll() {
    for (int i = 0; i < _players.length; i++) _players[i].noOfCardsVisible = 0;
    for (int i = 0; i < _players.length; i++) _players[i].cards = null;
    _notify();
  }

  // todo: how to identify a player that needs to be removed?
  void removePlayer(int idx) {}
}
