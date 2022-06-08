import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';

class TournamentTextService {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];
  bool closed = false;

  TournamentTextService(this._context, this._gameState);

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

        //String messageType = message['messageType'];
        log(':TournamentTextService: ${jsonEncode(message)}');
        dynamic m = _messages.removeAt(0);
        bool done = false;
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

    String messageType = data['type'];
    if (messageType != null &&
        messageType.indexOf('PLAYER_CONNECTIVITY') == -1) {
      final jsonData = jsonEncode(data);
      debugPrint(jsonData);
    }
    if (messageType != null) {
      // delegate further actions to sub services as per messageType
      switch (messageType) {
        case 'LEVEL_CHANGED':
          return handleLevelChange(data);
      }
    }
  }

  void handleLevelChange(var data) {
    /*
      message.nextLevel = nextLevel.level;
      message.nextSb = nextLevel.sb;
      message.nextBb = nextLevel.bb;
      message.nextAnte = nextLevel.ante;
      message.nextLevelTime = levelTime;    
    */
    if (data['nextLevel'] != null) {
      _gameState.tournamentState.setNextLevel(data['nextLevel'], data['nextSb'],
          data['nextBb'], data['nextAnte'], data['nextLevelTime']);
    }
  }
}
