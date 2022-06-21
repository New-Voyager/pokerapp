import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/data/game_log_store.dart';

class TournamentService {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];
  bool closed = false;
  AppTextScreen _appScreenText = getAppTextScreen("tournamentService");

  TournamentService(this._context, this._gameState);

  void close() {
    closed = true;
    clear();
  }

  void clear() {
    _messages.clear();
  }

  loop() async {
    while (!closed) {
      if (_messages.length > 0) {
        // don't process table message in the middle of the hand
        dynamic message = _messages[0];

        log(':GameUpdateService: ${jsonEncode(message)}');

        dynamic m = _messages.removeAt(0);
        bool done = false;
        //String messageType = m['messageType'];
        //debugPrint('$messageType start');
        while (!done && !closed) {
          if (m != null) {
            handleMessage(m).whenComplete(() {
              // debugPrint('$messageType end');
              done = true;
            });
          }
          m = null;
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  handle(String message) async {
    assert(_gameState != null);
    assert(_context != null);
    assert(message != null && message.isNotEmpty);

    var data = jsonDecode(message);
    _messages.add(data);
  }

  Future<void> handleMessage(dynamic data) async {
    // if the service is closed, don't process incoming messages
    if (closed || _gameState.uiClosing) return;

    String type = data['type']; // new format used by API server

    if (type != null) {
      // delegate further actions to sub services as per messageType
      switch (type) {
        case AppConstants.TOURNAMENT_PLAYER_MOVED_TABLE:
          handlePlayerMovedTable(data);
          break;
      }
    }
  }

  void handlePlayerMovedTable(dynamic data) {
    /*
    const message = {
      type: 'TOURNAMENT_PLAYER_MOVED_TABLE',
      tournamentId: tournamentId,
      playerId: playerId,
      currentTableNo: currentTableNo,
      playerUuid: playerUuid,
      newTableNo: newTableNo,
      playerName: playerName,
      stack: stack,
      seatNo: seatNo,
    };*/
    if (!_gameState.isTournament) {
      return;
    }

    int tournamentId = data['tournamentId'];
    int playerId = data['playerId'];
    int oldTable = data['currentTableNo'];
    String playerUuid = data['playerUuid'];
    int newTableNo = data['newTableNo'];
    String playerName = data['playerName'];
    double stack = double.parse(data['stack'].toString());
    int seatNo = data['seatNo'];

    if (tournamentId != _gameState.tournamentId) {
      if (oldTable != _gameState.tournamentTableNo &&
          newTableNo != _gameState.tournamentTableNo) {
        return;
      }
      return;
    }

    if (oldTable == _gameState.tournamentTableNo) {
      // this player left the table
      log('Tournament: player left the table');
    }

    if (newTableNo == _gameState.tournamentTableNo) {
      // this player joined the table
      log('Tournament: player joined the table');
    }
    return;
  }
}
