import 'package:flutter/cupertino.dart';
import 'package:pokerapp/enums/game_type.dart';

import 'player_model.dart';

class GamePlayer {
  int id;
  String name;
  String uuid;
  GamePlayer(this.id, this.name, this.uuid);
}

class GameInfoModel {
  int gameID;
  String gameCode;
  String clubCode; // optional
  int actionTime;
  double buyInMax;
  double buyInMin;
  int maxPlayers;
  String title;
  String gameType; // fixme: is it okay to use GameType or String?
  String tableStatus;
  String status;
  ChipUnit chipUnit;
  double smallBlind;
  double bigBlind;
  double ante;
  List<int> availableSeats;
  List<PlayerModel> playersInSeats;
  String gameToken;
  String playerGameStatus;
  bool isHost;
  bool playerMuckLosingHand;
  bool playerRunItTwice;
  bool utgStraddleAllowed;
  bool buttonStraddleAllowed;
  int buttonStraddleBet = 2;
  int sessionTime = 0;
  int runningTime = 0;
  int noHandsWon = 0;
  int noHandsPlayed = 0;
  bool allowRabbitHunt = false;
  bool showHandRank = false;
  bool botGame = false;
  bool waitlistAllowed = false;
  bool ipCheck = false;
  bool gpsCheck = false;
  bool highHandTracked = false;
  int handNum = 0;
  double buyin = null;
  double stack = null;
  String sfuUrl = 'http://67.205.136.63:7000';

  // nats channels
  String gameToPlayerChannel;
  String playerToHandChannel;
  String handToPlayerTextChannel;
  String handToAllChannel;
  String handToPlayerChannel;
  String gameChatChannel;
  String clientAliveChannel;

  // janus related settings
  bool audioConfEnabled;
  String janusUrl;
  String janusToken;
  String janusSecret;
  int janusRoomId;
  String janusRoomPin;

  bool useAgora;
  String agoraToken;
  String agoraAppId;

  // all players in the game
  Map<int, GamePlayer> allPlayers = Map<int, GamePlayer>();

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
    this.gameID = data['gameID'] ?? 0;
    this.gameCode = data['gameCode'];
    this.clubCode = data['clubCode'];
    this.actionTime = data['actionTime'];
    this.maxPlayers = maxPlayers ?? data['maxPlayers'];
    this.title = data['title'];
    this.gameType = data['gameType'];
    this.chipUnit = ChipUnit.DOLLAR;
    if (data['chipUnit'] == 'CENT') {
      this.chipUnit = ChipUnit.CENT;
    }
    this.buyInMin = double.parse(data['buyInMin'].toString());
    this.buyInMax = double.parse(data['buyInMax'].toString());
    this.smallBlind = double.parse(data['smallBlind'].toString());
    this.bigBlind = double.parse(data['bigBlind'].toString());
    if (data['ante'] != null) {
      this.ante = double.parse(data['ante'].toString());
    } else {
      data['ante'] = 0.0;
    }
    this.status = data['status'];
    this.tableStatus = data['tableStatus'];
    this.utgStraddleAllowed = data['utgStraddleAllowed'] ?? true;
    this.buttonStraddleAllowed = data['buttonStraddleAllowed'] ?? false;
    this.buttonStraddleBet = data['buttonStraddleBet'] ?? 2;
    this.availableSeats = data['seatInfo']['availableSeats']
        .map<int>((e) => int.parse(e.toString()))
        .toList();
    this.playersInSeats = data['seatInfo']['playersInSeats']
        .map<PlayerModel>((e) => PlayerModel.fromJson(e))
        .toList();

    this.gameToken = data['gameToken'];
    this.playerGameStatus = data['playerGameStatus'];
    this.playerRunItTwice = data['playerRunItTwiceConfig'] ?? false;
    this.playerMuckLosingHand = data['playerMuckLosingHandConfig'] ?? false;
    this.botGame = data['botGame'];
    this.highHandTracked = data['highHandTracked'] ?? false;

    this.sessionTime = data['sessionTime'] ?? 0;
    this.runningTime = data['runningTime'] ?? 0;
    this.noHandsWon = data['noHandsWon'] ?? 0;
    this.noHandsPlayed = data['noHandsPlayed'] ?? 0;
    this.allowRabbitHunt = data['allowRabbitHunt'] ?? true;
    this.showHandRank = data['showHandRank'] ?? false;
    this.waitlistAllowed = data['waitlistAllowed'] ?? false;
    this.ipCheck = data['ipCheck'] ?? false;
    this.gpsCheck = data['gpsCheck'] ?? false;
    this.handNum = data['handNum'] ?? 0;
    if (data['buyin'] != null) {
      this.buyin = double.parse(data['buyin'].toString());
    }

    if (data['stack'] != null) {
      this.stack = double.parse(data['stack'].toString());
    }

    this.isHost = true;
    if (data['isHost'] != null) {
      this.isHost = data['isHost'];
    }

    // Nats Server channels
    this.gameToPlayerChannel = data['gameToPlayerChannel'];
    this.playerToHandChannel = data['playerToHandChannel'];
    this.handToPlayerTextChannel = data['handToPlayerTextChannel'];
    this.handToAllChannel = data['handToAllChannel'];
    this.handToPlayerChannel = data['handToPlayerChannel'];
    this.gameChatChannel = data['gameChatChannel'];
    this.clientAliveChannel = data['clientAliveChannel'];

    this.audioConfEnabled = data['audioConfEnabled'];
    this.janusUrl = data['janusUrl'];
    this.janusRoomId = data['janusRoomId'];
    this.janusRoomPin = data['janusRoomPin'];
    this.janusToken = data['janusToken'];
    this.janusSecret = data['janusSecret'];

    this.useAgora = data['useAgora'];
    this.agoraAppId = data['agoraAppId'];
    this.agoraToken = data['agoraToken'];

    if (data['allPlayers'] != null) {
      for (final playerData in data['allPlayers']) {
        final gamePlayer = GamePlayer(
            playerData['id'], playerData['name'], playerData['uuid']);
        this.allPlayers[gamePlayer.id] = gamePlayer;
      }
    }
  }

  void gameEnded() {
    status = 'ENDED';
  }

  // graph ql queries
  static String query(String gameCode) => """query gameInfo {
    gameInfo(gameCode:"$gameCode") {
      gameID
      gameCode
      clubCode
      buyInMax
      maxPlayers
      title
      gameType
      buyInMin
      smallBlind
      bigBlind
      ante
      utgStraddleAllowed
      buttonStraddleAllowed
      buttonStraddleBet
      status
      tableStatus
      allowRabbitHunt
      showHandRank
      waitlistAllowed
      botGame
      highHandTracked
      ipCheck
      gpsCheck
      handNum
      chipUnit

      sessionTime
      runningTime
      noHandsWon
      noHandsPlayed
      buyin
      stack

      seatInfo {
        availableSeats
        playersInSeats {
          name
          seatNo
          playerId
          playerUuid
          stack
          buyIn
          status
          buyInExpTime
          breakExpTime
          breakStartedTime
        }
      }
      allPlayers {
        id
        uuid
        name
      }
      actionTime
      gameToken
      playerGameStatus
      gameToPlayerChannel
      playerToHandChannel
      handToAllChannel
      handToPlayerChannel
      handToPlayerTextChannel
      gameChatChannel
      clientAliveChannel
      playerRunItTwiceConfig
      playerMuckLosingHandConfig
      audioConfEnabled
      janusUrl
      janusToken
      janusSecret
      janusRoomId
      janusRoomPin

      useAgora
      agoraToken
      agoraAppId
    }
  } """;
}
