import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/data/game_log_store.dart';

class HandToPlayerTextService {
  final GameState _gameState;
  final BuildContext _context;
  final List<dynamic> _messages = [];
  bool closed = false;

  HandToPlayerTextService(this._context, this._gameState);

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
        log(':HandToPlayerTextService: ${jsonEncode(message)}');
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

    String messageType = data['messageType'];
    if (messageType != null &&
        messageType.indexOf('PLAYER_CONNECTIVITY') == -1) {
      final jsonData = jsonEncode(data);
      debugPrint(jsonData);
      debugLog(_gameState.gameCode, jsonData);
    }
    if (messageType != null) {
      // delegate further actions to sub services as per messageType
      switch (messageType) {
        case AppConstants.DEALER_CHOICE:
          return handleDealerChoice(data);
      }
    }
  }

  // Json messages
  Future<void> handleDealerChoice(var data) async {
    if (closed) return;
    final TableState tableState = _gameState.tableState;
    // remove all the community cards
    tableState.clear();
    tableState.notifyAll();

    if (closed) return;
    _gameState.clear();

    if (closed) return;
    // _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    List<GameType> gameChoices = [];
    final dealerChoiceGames = data['dealerChoiceGames'];
    for (final type in dealerChoiceGames) {
      final gameType =
          GameType.values[type]; //.firstWhere((element) => element == type);
      gameChoices.add(gameType);
    }
    final timeout = int.parse(data['timeout'].toString());
    GameType type = await showGameSelectorDialog(
      listOfGameTypes: gameChoices,
      timeLimit: Duration(seconds: timeout),
    );
    log('selected game type: $type');
    if (type != GameType.UNKNOWN) {
      GameService.dealerChoice(_gameState.gameCode, type);
    }
  }
}
