import 'package:cryptography/cryptography.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/game_player_settings.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:uuid/uuid.dart';

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
  DateTime startedAt;
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
  double tipsPercentage = null;
  double tipsCap = null;
  String sfuUrl = '';

  String livekitUrl = '';
  String livekitToken = '';

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

  bool demoGame;
  bool tournament = false;

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

    if (data['rakeCap'] != null) {
      this.tipsCap = double.parse(data['rakeCap'].toString());
    }

    if (data['rakeCap'] != null) {
      this.tipsPercentage = double.parse(data['rakePercentage'].toString());
    }

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

    this.sfuUrl = data['sfuUrl'];
    this.livekitUrl = data['livekitUrl'];
    this.livekitToken = data['livekitToken'];

    if (data['allPlayers'] != null) {
      for (final playerData in data['allPlayers']) {
        final gamePlayer = GamePlayer(
            playerData['id'], playerData['name'], playerData['uuid']);
        this.allPlayers[gamePlayer.id] = gamePlayer;
      }
    }

    this.demoGame = data['demoGame'] ?? false;
  }

  GameInfoModel.fromTournamentGameInfoJson(var data, {int maxPlayers}) {
    this.gameID = data['gameID'] ?? 0;
    this.gameCode = data['gameCode'];
    this.clubCode = data['clubCode'];
    this.actionTime = data['actionTime'];
    this.maxPlayers = maxPlayers ?? data['maxPlayersInTable'];
    this.title = data['title'];
    this.gameType = data['gameType'];
    this.chipUnit = ChipUnit.DOLLAR;
    if (data['chipUnit'] == 'CENT') {
      this.chipUnit = ChipUnit.CENT;
    }
    this.smallBlind = double.parse(data['smallBlind'].toString());
    this.bigBlind = double.parse(data['bigBlind'].toString());
    if (data['ante'] != null) {
      this.ante = double.parse(data['ante'].toString());
    } else {
      data['ante'] = 0.0;
    }
    this.status = data['status'];
    this.tableStatus = data['tableStatus'];
    this.utgStraddleAllowed = data['utgStraddleAllowed'] ?? false;
    this.buttonStraddleAllowed = data['buttonStraddleAllowed'] ?? false;
    this.availableSeats = [];
    this.playersInSeats = data['players']
        .map<PlayerModel>((e) => PlayerModel.fromTournamentJson(e))
        .toList();

    this.gameToken = data['gameToken'];
    this.playerGameStatus = data['playerGameStatus'];
    this.playerRunItTwice = data['playerRunItTwiceConfig'] ?? false;
    this.playerMuckLosingHand = data['playerMuckLosingHandConfig'] ?? false;
    this.botGame = data['botGame'];
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

    // Nats Server channels
    this.gameToPlayerChannel = data['gameToPlayerChannel'];
    this.playerToHandChannel = data['playerToHandChannel'];
    this.handToPlayerTextChannel = data['handToPlayerTextChannel'];
    this.handToAllChannel = data['handToAllChannel'];
    this.handToPlayerChannel = data['handToPlayerChannel'];
    this.gameChatChannel = data['gameChatChannel'];
    this.clientAliveChannel = data['clientAliveChannel'];

    this.audioConfEnabled = data['audioConfEnabled'] ?? false;
    this.janusUrl = data['janusUrl'];
    this.janusRoomId = data['janusRoomId'];
    this.janusRoomPin = data['janusRoomPin'];
    this.janusToken = data['janusToken'];
    this.janusSecret = data['janusSecret'];

    this.useAgora = data['useAgora'];
    this.agoraAppId = data['agoraAppId'];
    this.agoraToken = data['agoraToken'];

    this.sfuUrl = data['sfuUrl'];
    this.livekitUrl = data['livekitUrl'];
    this.livekitToken = data['livekitToken'];
    this.demoGame = data['demoGame'] ?? false;
    this.tournament = true;
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

      rakeCap
      rakePercentage

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

      sfuUrl

      livekitUrl
      livekitToken
      demoGame
    }
  } """;

  // tournament game info
  static String tournamentGameInfoQuery(String gameCode) =>
      """query tournamentGameInfo {
        getTournamentGameInfo(gameCode:"$gameCode") {
              gameID
              actionTime
              maxPlayersInTable
              title
              chipUnit
              smallBlind
              bigBlind
              ante
              status
              tableStatus
              level
              gameType
              nextLevel
              gameCode
              nextLevelTimeInSecs
              gameChatChannel
              gameToPlayerChannel
              playerToHandChannel
              handToPlayerChannel
              handToAllChannel
              clientAliveChannel
              players {
                playerId
                playerUuid
                playerName
                stack
                seatNo
                status
              }
              handToPlayerTextChannel
    }
  }
  """;
}

class ClubInfo {
  bool trackMemberCredit = false;
  bool canUpdateCredits = false;
  bool isOwner = false;
  bool isManager = false;

  ClubInfo();

  factory ClubInfo.fromJson(dynamic json) {
    final clubInfo = ClubInfo();
    clubInfo.isOwner = json['isOwner'] ?? false;
    clubInfo.isManager = json['isManager'] ?? false;
    clubInfo.trackMemberCredit = json['trackMemberCredit'] ?? false;
    if (json['managerRole'] != null) {
      clubInfo.canUpdateCredits =
          json['managerRole']['trackMemberCredit'] ?? false;
    }
    return clubInfo;
  }

  static String getQuery() {
    return """
        query club(\$clubCode: String!){
          clubInfo(clubCode:\$clubCode) {
            trackMemberCredit
            isOwner
            isManager
            managerRole {
              canUpdateCredits
            }
          }
        }
    """;
  }
}

class GameInfoAll {
  GameInfoModel gameInfo;
  ClubInfo clubInfo;
  GamePlayerSettings gamePlayerSettings;
  PlayerInfo playerInfo;
  MyPlayerNotes playerNotes;
  GameSettings gameSettings;
  SecretKey encryptionKey;

  static String queryAll({@required gameCode, String clubCode}) {
    String header = "";
    if (clubCode != null) {
      header = """
        query gameInfoAll(\$clubCode: String!, \$gameCode: String!) {
      """;
    } else {
      header = """
        query gameInfoAll(\$gameCode: String!) {
      """;
    }
    String query = header;
    query += gameInfoQuery();
    if (clubCode != null) {
      query += clubInfoQuery();
    }
    query += gamePlayerSettingsQuery();
    query += getGameSettingsQuery();
    query += gamePlayerSettingsQuery();
    query += playerNotesQuery();
    query += encryptionKeyQuery();
    query += myInfoQuery();
    query += "}";
    return query;
  }

  static GameInfoAll build(dynamic data) {
    final gameInfo = GameInfoModel.fromJson(data['gameInfo']);
    ClubInfo clubInfo;
    if (data['clubInfo'] != null) {
      clubInfo = ClubInfo.fromJson(data['clubInfo']);
    }
    final gamePlayerSettings =
        GamePlayerSettings.fromJson(data['myGameSettings']);
    final playerInfo = PlayerInfo.fromJson(data);
    final playerNotes = MyPlayerNotes.fromJson(data['notes']);
    final gameSettings = GameSettings.fromJson(data['gameSettings']);

    List<int> bytes = Uuid.parse(data['encryptionKey']);
    var key = SecretKey(bytes);

    return GameInfoAll()
      ..gameInfo = gameInfo
      ..clubInfo = clubInfo
      ..gamePlayerSettings = gamePlayerSettings
      ..playerInfo = playerInfo
      ..gameSettings = gameSettings
      ..playerNotes = playerNotes
      ..encryptionKey = key;
  }

  static String clubInfoQuery() {
    return '''
          clubInfo(clubCode:\$clubCode) {
            trackMemberCredit
            isOwner
            isManager
            managerRole {
              canUpdateCredits
            }
          }
      ''';
  }

  static String gameInfoQuery() {
    return '''
          gameInfo(gameCode:\$gameCode) {
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

            rakeCap
            rakePercentage

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

            sfuUrl

            livekitUrl
            livekitToken
            demoGame
          }
    ''';
  }

  static String gamePlayerSettingsQuery() {
    return '''
          myGameSettings:myGameSettings(gameCode:\$gameCode){
            autoStraddle
            straddle
            buttonStraddle
            bombPotEnabled
            muckLosingHand
            runItTwiceEnabled
            autoReload
            reloadThreshold
            reloadTo
          }
    ''';
  }

  static String getGameSettingsQuery() {
    return '''
      gameSettings: gameSettings(gameCode :\$gameCode){
        audioConfEnabled
        buyInApproval
        buyInLimit
        runItTwiceAllowed
        allowRabbitHunt
        showHandRank
        doubleBoardEveryHand
        bombPotEnabled
        bombPotBet
        doubleBoardBombPot
        bombPotInterval
        bombPotIntervalInSecs
        bombPotEveryHand
        seatChangeAllowed
        seatChangeTimeout
        waitlistAllowed
        seatChangeTimeout
        waitlistAllowed
        breakAllowed
        breakLength
        ipCheck
        gpsCheck
        roeGames
        dealerChoiceGames
        resultPauseTime
        funAnimations
        chat
        showResult
      }
    ''';
  }

  static String myInfoQuery() {
    return '''
        myInfo: myInfo{
          id
          uuid
          name
          channel
        }
        role: playerRole(gameCode: \$gameCode)  {
          isHost
          isOwner
          isManager
      }''';
  }

  static String playerNotesQuery() {
    return '''
       notes:   playersWithNotes(gameCode:\$gameCode) {
          notes
          playerId
          playerUuid
        }
    ''';
  }

  static String encryptionKeyQuery() {
    return '''
      encryptionKey
    ''';
  }
}
