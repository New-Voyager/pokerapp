import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';

class HandLogModel {
  String gameCode;
  int handNumber = -1;
  Duration handDuration;
  List<int> communityCards = new List<int>();
  List<int> yourcards = new List<int>();
  GameStages gameWonAt;
  List<PotWinnerDetailsModel> potWinners = new List<PotWinnerDetailsModel>();
  HandStageModel preFlopActions, flopActions, turnActions, riverActions;
  String unknownString = "u/k";
  int unknownInt = 0;
  var jsonData;
  Map<int, String> playerIDName = new Map();
  HandLogModel(this.gameCode, this.handNumber);
  int myPlayerId = 0;

  load() {
    var myInfo = jsonData["myInfo"];
    myPlayerId = int.parse(myInfo["id"].toString());
    var gamePlayers = jsonData["players"] as List;
    for (var player in gamePlayers) {
      int id = int.parse(player["id"].toString());
      String name = player["name"].toString();
      this.playerIDName[id] = name;
    }

    var data = jsonData["hand"]["data"];
    var startTime = data["handLog"]["handStartedAt"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            int.parse(data["handLog"]["handStartedAt"]));
    var endTime = data["handLog"]["handEndedAt"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            int.parse(data["handLog"]["handEndedAt"]));
    handDuration = ((startTime != null && endTime != null)
        ? startTime.difference(endTime)
        : new Duration(seconds: 0));

    dynamic cards;

    cards = data["boardCards"] ?? data["boardCards"];
    if (cards != null) {
      this.communityCards = cards.cast<int>().toList();
    }

    switch (data["handLog"]["wonAt"]) {
      case "PRE_FLOP":
        gameWonAt = GameStages.PREFLOP;
        break;
      case "FLOP":
        gameWonAt = GameStages.FLOP;
        break;
      case "RIVER":
        gameWonAt = GameStages.RIVER;
        break;
      case "TURN":
        gameWonAt = GameStages.TURN;
        break;
      case "SHOW_DOWN":
        gameWonAt = GameStages.SHOWDOWN;
        break;
      default:
        gameWonAt = GameStages.PREFLOP;
        break;
    }

    Map<String, dynamic> potDetailsJson =
        data["handLog"]["potWinners"] ?? data["handLog"]["potWinners"];
    Map<String, dynamic> playersJson =
        (data["players"] ?? data["players"]) as Map;
    for (var seatNo in playersJson.keys) {
      var player = playersJson[seatNo];
      int id = int.parse(player["id"].toString());
      if (id == myPlayerId) {
        yourcards = player["cards"].cast<int>().toList();
        break;
      }
    }

    // see whether the player was in this hand or not
    potWinners = new List<PotWinnerDetailsModel>();
    for (dynamic key in potDetailsJson.keys) {
      potWinners.add(PotWinnerDetailsModel.fromJson(
          key, potDetailsJson[key], playersJson));
    }

    if (data["handLog"]["preflopActions"] != null) {
      var preFlopJson = data["handLog"]["preflopActions"] ??
          data["handLog"]["preflopActions"];
      preFlopActions = HandStageModel.fromJson(this.playerIDName, "Pre-flop",
          preFlopJson, new List<int>(), playersJson);
    }

    if (data["handLog"]["flopActions"] != null) {
      var flopJson =
          data["handLog"]["flopActions"] ?? data["handLog"]["flopActions"];
      var flopCards = data["flop"] ?? data["flop"];
      flopActions = HandStageModel.fromJson(this.playerIDName, "Flop", flopJson,
          flopCards.cast<int>().toList(), playersJson);
    }

    if (data["handLog"]["turnActions"] != null) {
      var turnJson =
          data["handLog"]["turnActions"] ?? data["handLog"]["turnActions"];
      var turnCard = data["turn"] ?? data["turn"];
      List<int> turnCards = [turnCard];
      turnActions = HandStageModel.fromJson(
          this.playerIDName, "Turn", turnJson, turnCards, playersJson);
    }

    if (data["handLog"]["riverActions"] != null) {
      var riverJson = data["handLog"]["riverActions"] ??
          jsonData["handLog"]["riverActions"];
      var riverCard = data["river"] ?? data["river"];
      List<int> riverCards = [riverCard];
      riverActions = HandStageModel.fromJson(this.playerIDName, "River",
          riverJson, riverCards.cast<int>().toList(), playersJson);
    }
  }

  // HandLogModel.fromJson(var jsonData) {
  //   //gameId = jsonData["gameId"] == null ? unknownString : jsonData["gameId"];
  //
  //   //handNumber = jsonData["handNum"] == null ? 0 : jsonData["handNum"];
  //
  // }
}

class PotWinnerDetailsModel {
  int potNumber;
  int totalPotAmount;
  List<WinnerDetailsModel> hiWinners = new List<WinnerDetailsModel>();
  List<WinnerDetailsModel> loWinners = new List<WinnerDetailsModel>();

  PotWinnerDetailsModel.fromJson(String potKey, var potWinner, playersJson) {
    potNumber = int.parse(potKey);
    totalPotAmount = 0;
    var hiWinnersJson = potWinner["hiWinners"] ?? potWinner["hiWinners"];

    if (hiWinnersJson != null) {
      hiWinners = hiWinnersJson
          .map<WinnerDetailsModel>((hiWinnerJson) =>
              WinnerDetailsModel.fromJson(hiWinnerJson, playersJson))
          .toList();
    }

    var loWinnersJson = potWinner["lowWinners"] ?? potWinner["lowWinners"];
    if (loWinnersJson != null) {
      loWinners = loWinnersJson
          .map<WinnerDetailsModel>((loWinnerJson) =>
              WinnerDetailsModel.fromJson(loWinnerJson, playersJson))
          .toList();
    }
  }

  String get potNumberStr {
    if (potNumber == 0) {
      return 'Main Pot';
    } else {
      return 'Side Pot ${potNumber}';
    }
  }
}

class WinnerDetailsModel {
  int seatNum;
  String name;
  int amount;
  List<dynamic> winningCards = new List<dynamic>();

  WinnerDetailsModel.fromJson(var jsonData, var allPlayersJson) {
    seatNum = jsonData["seatNo"] == null ? 0 : jsonData["seatNo"];
    name = allPlayersJson[seatNum.toString()]["name"] != null
        ? allPlayersJson[seatNum.toString()]["name"]
        : "";
    amount = jsonData["amount"] == null ? 0 : jsonData["amount"];
    winningCards = jsonData["winningCards"] ?? jsonData["winningCards"];
  }
}

class HandStageModel {
  String stageName;
  int potAmount;
  List<int> stageCards = new List<int>();
  List<ActionModel> stageActions = new List<ActionModel>();

  HandStageModel.fromJson(Map<int, String> playerIdName, String sName,
      var jsonData, List<int> cardsList, var playersData) {
    stageName = sName;
    stageCards = cardsList;
    potAmount = jsonData["pot"] == null ? 0 : jsonData["pot"];
    var actionsJson = jsonData["actions"] ?? jsonData["actions"];
    if (actionsJson != null) {
      stageActions = actionsJson
          .map<ActionModel>((actionsJson) =>
              ActionModel.fromJson(playerIdName, actionsJson, playersData))
          .toList();
    }
  }
}

class ActionModel {
  int seatNum;
  int id;
  String name;
  HandActions action;
  int amount;
  bool timedOut;
  int stack;

  ActionModel.fromJson(
      Map<int, String> playerIdName, var jsonData, var playersData) {
    seatNum = jsonData["seatNo"] == null ? 0 : jsonData["seatNo"];
    id = int.parse(playersData[seatNum.toString()]["id"]);
    name = playerIdName[id];

    switch (jsonData["action"]) {
      case "SB":
        action = HandActions.SB;
        break;
      case "BB":
        action = HandActions.BB;
        break;
      case "CALL":
        action = HandActions.CALL;
        break;
      case "CHECK":
        action = HandActions.CHECK;
        break;
      case "BET":
        action = HandActions.BET;
        break;
      case "RAISE":
        action = HandActions.RAISE;
        break;
      case "FOLD":
        action = HandActions.FOLD;
        break;
      case "STRADDLE":
        action = HandActions.STRADDLE;
        break;
      default:
        action = HandActions.UNKNOWN;
        break;
    }

    amount = jsonData["amount"] == null ? 0 : jsonData["amount"];
    timedOut = jsonData["timedOut"] == null ? true : jsonData["timedOut"];
    stack = jsonData["stack"] == null ? 0 : jsonData["stack"];
  }
}
