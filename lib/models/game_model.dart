import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/player_status.dart';

class GameModel {
  String clubCode;
  String clubName;
  String clubPicUrl;
  String gameCode;
  String title;
  GameType gameType;
  double buyInMin;
  double buyInMax;
  int elapsedTime;
  DateTime startedAt;
  GameStatus gameStatus;
  PlayerStatus playerStatus;

  int sessionTime;
  DateTime endedAt;
  int gameTime;
  double buyIn;
  double stack;
  int waitList;
  int seatsAvailable;
  double smallBlind;
  double bigBlind;
  int tableCount;
  bool isTableFull;
  int maxPlayers;

  GameModel.fromJson(var jsonData) {
    this.clubCode = jsonData['clubCode'];
    this.clubName = jsonData['clubName'];
    this.clubPicUrl = jsonData['clubPicUrl'] ?? '';
    this.gameCode = jsonData['gameCode'];

    this.title = jsonData['title'];
    this.smallBlind = jsonData["smallBlind"] == null
        ? null
        : double.parse(jsonData['smallBlind'].toString());
    this.bigBlind = jsonData["bigBlind"] == null
        ? null
        : double.parse(jsonData['bigBlind'].toString());
    this.waitList = jsonData["waitlistCount"] == null
        ? null
        : int.parse(jsonData['waitlistCount'].toString());
    this.tableCount = jsonData["tableCount"] == null
        ? 0
        : int.parse(jsonData['tableCount'].toString());
    this.isTableFull =
        jsonData["tableFull"] == null ? false : jsonData['tableFull'];
    this.maxPlayers = jsonData["maxPlayers"] == null
        ? 0
        : int.parse(jsonData['maxPlayers'].toString());
    this.seatsAvailable = this.maxPlayers - this.tableCount;

    GameType gameType;

    if (this.title == null) {
      this.title = gameTypeStr(gameType);
    }

    this.buyInMin = jsonData['buyInMin'] == null
        ? null
        : double.parse(jsonData['buyInMin'].toString());

    this.buyInMax = jsonData['buyInMax'] == null
        ? null
        : double.parse(jsonData['buyInMax'].toString());

    this.elapsedTime = jsonData['elapsedTime'] == null
        ? null
        : int.parse(jsonData['elapsedTime'].toString());

    this.startedAt = jsonData['startedAt'] == null
        ? null
        : DateTime.parse(jsonData['startedAt']);

    this.sessionTime = jsonData['sessionTime'] == null
        ? null
        : int.parse(jsonData['sessionTime'].toString());

    this.endedAt = jsonData['endedAt'] == null
        ? null
        : DateTime.parse(jsonData['endedAt']);

    this.gameTime = jsonData['gameTime'] == null
        ? null
        : int.parse(jsonData['gameTime'].toString());

    this.buyIn = jsonData['buyIn'] == null
        ? null
        : double.parse(jsonData['buyIn'].toString());

    this.stack = jsonData['stack'] == null
        ? null
        : double.parse(jsonData['stack'].toString());
  }

  static String get queryLiveGames => """query {
    liveGames {
      clubCode
      clubName
      gameCode
      title
      gameType
      buyInMin
      buyInMax
      elapsedTime
      startedAt
      status
      playerStatus
    } 
  }""";

  static String get queryPlayedGames => """query {
    pastGames {
      clubCode
      clubName
      gameCode
      smallBlind
      bigBlind
      title
      gameType
      sessionTime
      buyIn
      stack
      runTime
      startedAt
      endedAt
    }  
  }""";
}
