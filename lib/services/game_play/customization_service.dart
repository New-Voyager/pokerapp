import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/player_info.dart' as pi;

class CustomizationService {
  pi.PlayerInfo _currentPlayer;
  GameInfoModel _gameInfo;
  CustomizationService();

  pi.PlayerInfo get currentPlayer {
    return _currentPlayer;
  }

  GameInfoModel get gameInfo => _gameInfo;

  Future<void> load() async {
    final gameData =
        await rootBundle.loadString('assets/sample-data/gameinfo.json');
    final jsonData = jsonDecode(gameData);
    if (jsonData["currentPlayer"] != null) {
      final data = jsonDecode('''  {
            "myInfo": {
              "id": 1,
              "uuid": "371e8c15-39cb-4bd9-a932-ced7a9dd6aac",
              "name": "tom"
            },
            "role": {
              "isHost": true,
              "isOwner": true,
              "isManager": false
            }
          }''');
      this._currentPlayer = pi.PlayerInfo.fromJson(data);

      // 2 4 6 8 9
      var maxPlayers = 6;
      if (jsonData["gameInfo"] != null) {
        // todo: debug remove: change the max Players in a game here
        this._gameInfo = GameInfoModel.fromJson(
          jsonData["gameInfo"],
          maxPlayers: maxPlayers,
        );
        _gameInfo.showHandRank = true;
      }

      List<PlayerModel> playerInSeats = [];
      for (final player in _gameInfo.playersInSeats) {
        if (player.seatNo <= maxPlayers) {
          playerInSeats.add(player);
        }

        if (player.playerId == this._currentPlayer.id) {
          player.isMe = true;
          player.cards = this.getHoleCards();
        }
      }

      _gameInfo.playersInSeats = playerInSeats;
    }
  }

  List<int> getHoleCards() {
    return [177, 168];
  }
}
