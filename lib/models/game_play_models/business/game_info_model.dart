import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';

class GameInfoModel {
  String gameCode;
  String clubCode; // optional
  int actionTime;
  int buyInMax;
  int buyInMin;
  int maxPlayers;
  String title;
  String gameType; // fixme: is it okay to use GameType or String?
  String tableStatus;
  String status;
  int smallBlind;
  int bigBlind;
  List<int> availableSeats;
  List<PlayerModel> playersInSeats;
  String gameToken;
  String playerGameStatus;

  // nats channels
  String gameToPlayerChannel;
  String playerToHandChannel;
  String handToAllChannel;
  String handToPlayerChannel;
  String gameChatChannel;

  GameInfoModel.fromJson(var data) {
    this.gameCode = data['gameCode'];
    this.clubCode = data['clubCode'];
    this.buyInMax = data['buyInMax'];
    this.actionTime = data['actionTime'];
    this.maxPlayers = data['maxPlayers'];
    this.title = data['title'];
    this.gameType = data['gameType'];
    this.buyInMin = data['buyInMin'];
    this.smallBlind = data['smallBlind'];
    this.bigBlind = data['bigBlind'];
    this.status = data['status'];
    this.tableStatus = data['tableStatus'];
    this.availableSeats = data['seatInfo']['availableSeats']
        .map<int>((e) => int.parse(e.toString()))
        .toList();
    this.playersInSeats = data['seatInfo']['playersInSeats']
        .map<PlayerModel>((e) => PlayerModel.fromJson(e))
        .toList();
    this.gameToken = data['gameToken'];
    this.playerGameStatus = data['playerGameStatus'];

    // Nats Server channels
    this.gameToPlayerChannel = data['gameToPlayerChannel'];
    this.playerToHandChannel = data['playerToHandChannel'];
    this.handToAllChannel = data['handToAllChannel'];
    this.handToPlayerChannel = data['handToPlayerChannel'];
    this.gameChatChannel = data['gameChatChannel'];
  }

  void gameEnded() {
    status = 'ENDED';
  }

  // graph ql queries
  static String query(String gameCode) => """query gameInfo {
    gameInfo(gameCode:"$gameCode") {
      gameCode
      clubCode
      buyInMax
      maxPlayers
      title
      gameType
      buyInMin
      smallBlind
      bigBlind
      status
      tableStatus
      seatInfo {
        availableSeats
        playersInSeats {
          name
          seatNo
          playerUuid
          stack
          buyIn
          status
        }
      }
      actionTime
      gameToken
      playerGameStatus
      gameToPlayerChannel
      playerToHandChannel
      handToAllChannel
      handToPlayerChannel
      gameChatChannel
    }
  } """;
}
