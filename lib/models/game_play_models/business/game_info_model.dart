import 'dart:developer';

import 'package:flutter/cupertino.dart';
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
  bool isHost;

  // nats channels
  String gameToPlayerChannel;
  String playerToHandChannel;
  String handToAllChannel;
  String handToPlayerChannel;
  String gameChatChannel;

  /* this constructor is used in the replay hand section */
  GameInfoModel({
    @required this.maxPlayers,
    @required this.gameType,
    @required this.tableStatus,
    @required this.status,
    @required this.smallBlind,
    @required this.bigBlind,
    @required this.playersInSeats,
  });

  GameInfoModel.fromJson(var data, {int maxPlayers}) {
    this.gameCode = data['gameCode'];
    this.clubCode = data['clubCode'];
    this.buyInMax = data['buyInMax'];
    this.actionTime = data['actionTime'];
    this.maxPlayers = maxPlayers ?? data['maxPlayers'];
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
        .toList()
        .sublist(0, maxPlayers ?? data['maxPlayers'] as int);
    // FIXME: FOR DEBUG - sublist

    this.gameToken = data['gameToken'];
    this.playerGameStatus = data['playerGameStatus'];
    this.isHost = true;
    if (data['isHost'] != null) {
      this.isHost = data['isHost'];
    }

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
          buyInExpTime
          breakExpTime
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
