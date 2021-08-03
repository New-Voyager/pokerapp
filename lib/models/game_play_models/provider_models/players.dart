import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/app/auth_service.dart';

import 'seat.dart';

/*
* This class is made, to handle every player updates, and for every update,
* notify the underlying widgets for changes,
* so, there might b many methods, which handles different updates
* */

class Players extends ChangeNotifier {
  List<PlayerModel> _players;

  Players({
    @required List<PlayerModel> players,
  }) {
    this._players = players;
    notifyAll();
  }

  void update(List<PlayerModel> players) {
    this._players = players;
    notifyAll();
  }

  List<PlayerModel> get players => _players;

  void notifyAll() {
    // search and mark the current player (isMe field)
    String myUUID = AuthService.getUuid();
    int idx = this._players.indexWhere((p) => p.playerUuid == myUUID);

    // the current user is a player, thus update it and notify the listeners
    if (idx != -1) this._players[idx].isMe = true;
    notifyListeners();
  }

  void clear({bool notify = false}) {
    // remove all highlight winners
    this.removeWinnerHighlightSilent();

    // before marking the small, big blind or the dealer, remove any marking from the old hand
    this.removeMarkersFromAllPlayerSilent();

    // remove all the folder players
    this.removeAllFoldedPlayersSilent();

    /* reset the noCardsVisible of each player and remove my cards too */
    this.removeCardsFromAllSilent();

    /* reset the reverse pot chips animation */
    // this.resetMoveCoinsFromPotSilent();

    /* reset allin flag */
    // this.removeAllAllinPlayersSilent();

    if (notify) {
      this.notifyAll();
    }
  }

  void clearForShowdown({bool notify = false}) {
    // remove all highlight winners
    this.removeWinnerHighlightSilent();

    // before marking the small, big blind or the dealer, remove any marking from the old hand
    this.removeMarkersFromAllPlayerSilent();
  }

  void refreshWithPlayerInSeat(List<PlayerInSeat> playersInSeat,
      {bool notify = true}) {
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
    if (notify) {
      notifyAll();
    }
  }

  void updatePlayerFoldedStatusSilent(int idx, bool folded) {
    _players[idx].animatingFold = true;
    _players[idx].playerFolded = true;
    _players[idx].playerFolded = folded;
  }

  void removeAllFoldedPlayersSilent() {
    for (int i = 0; i < _players.length; i++) _players[i].playerFolded = null;
  }

  // void removeAllAllinPlayersSilent() {
  //   for (int i = 0; i < _players.length; i++) _players[i].allIn = false;
  // }

  void removeMarkersFromAllPlayerSilent() {
    for (int i = 0; i < _players.length; i++)
      _players[i].playerType = TablePosition.None;
  }

  bool addNewPlayerSilent(PlayerModel playerModel) {
    bool found = false;
    for (final player in _players) {
      if (player.playerUuid == playerModel.playerUuid) {
        found = true;
      }
    }
    if (!found) {
      _players.add(playerModel);
    }
    return found;
  }

  void updateExistingPlayerSilent(int idx, PlayerModel newPlayerModel) {
    _players[idx] = newPlayerModel;
  }

  void updatePlayerTypeSilent(int idx, TablePosition playerType,
      {int coinAmount}) {
    _players[idx].playerType = playerType;
    // if (coinAmount != null) {
    //   _players[idx].coinAmount = coinAmount;
    // }
  }

  // void updateTestBet(int coinAmount) {
  //   for (int i = 0; i < _players.length; i++)
  //     _players[i].coinAmount = coinAmount;
  // }

  void updateStackReloadStateSilent(int playerID, StackReloadState sts) {
    int idx = _players.indexWhere((p) => p.playerId == playerID);
    if (idx != -1) {
      _players[idx].stackReloadState = sts;
      if (sts != null) _players[idx].stack = sts.newStack;
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

  void unHighlightCardsSilentForAll() {
    for (int i = 0; i < _players.length; i++) {
      _players[i].highlightCards = [];
    }
  }

  void highlightCardsSilent({int seatNo, List<int> cards}) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    _players[idx].highlightCards = cards;
  }

  void updateStatusSilent(int idx, String status) {
    _players[idx].status = status;
  }

  // TODO: WE DONT NEED THIS METHOD
  void updateStackBulkSilent(var stackData) {
    Map<int, int> stacks = Map<int, int>();

    stackData.forEach((key, value) =>
        stacks[int.parse(key.toString())] = int.parse(value.toString()));

    // stacks contains, <seatNo, stack> mapping
    stacks.forEach((seatNo, stack) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      // log('player seat no: $seatNo index: $idx');
      _players[idx].stack = stack;
    });
  }

  void addStackWithValueSilent(int seatNo, int newStack) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx == -1) {
      return;
    }
    _players[idx].stack += newStack;
  }

  void updateStackWithValueSilent(int seatNo, int newStack) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx == -1) {
      return;
    }
    _players[idx].stack = newStack;
  }

  void updateUserCardsSilent(Map<int, List<int>> data) {
    log('updating: $data');
    /* seat-no, list of cards */
    data.forEach((seatNo, cards) {
      int idx = _players.indexWhere((p) => p.seatNo == seatNo);
      if (idx != -1) _players[idx].cards = cards;
    });
  }

  void updateCardSilent(int seatNo, List<int> cards) {
    log('updating $seatNo seat\'s cards to $cards');
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx == -1) {
      return;
    }
    _players[idx].cards = cards;
  }

  void updateVisibleCardNumberSilent(int seatNo, int n) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx == -1) {
      return;
    }
    _players[idx].noOfCardsVisible = n;
  }

  void visibleCardNumbersForAllSilent(int n) {
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].status == AppConstants.PLAYING) {
        _players[i].noOfCardsVisible = n;
      } else {
        _players[i].noOfCardsVisible = 0;
      }
    }
  }

  PlayerModel getPlayerBySeat(int seatNo) => _players.firstWhere(
        (p) => p.seatNo == seatNo,
        orElse: null,
      );

  void removeCardsFromAllSilent() {
    for (int i = 0; i < _players.length; i++) _players[i].noOfCardsVisible = 0;
    for (int i = 0; i < _players.length; i++) _players[i].cards = null;
  }

  void removePlayerSilent(int seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx != -1) {
      _players.removeAt(idx);
    }
  }

  PlayerModel get me {
    PlayerModel tmp = this._players.firstWhere(
          (u) => u.isMe,
          orElse: () => null,
        );
    return tmp;
  }

  int get count {
    return this._players.length;
  }

  // bool get showBuyinPrompt {
  //   if (this.me != null && this.me.stack == 0) {
  //     return true;
  //   }
  //   return false;
  // }

  PlayerModel fromSeat(int seatNo) {
    int idx = _players.indexWhere((p) => p.seatNo == seatNo);
    if (idx == -1) {
      return null;
    }
    return _players[idx];
  }

  void updatePlayersSilent(List<PlayerModel> players) {
    this._players = players;
    notifyAll();
  }
}

// /**
//  * The states that affect the current player.
//  */
class MyState extends ChangeNotifier {
  int _seatNo = 0;
  PlayerStatus _status = PlayerStatus.NOT_PLAYING;
  GameStatus _gameStatus = GameStatus.UNKNOWN;

  set seatNo(int v) {
    this._seatNo = v;
  }

  set gameStatus(GameStatus gameStatus) => this._gameStatus = gameStatus;

  get gameStatus => this._gameStatus;

  int get seatNo => this._seatNo;

  set status(PlayerStatus status) => this._status = status;

  get status => this._status;

  void notify() {
    notifyListeners();
  }
}
