import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';

class HandLogModel {
  String gameId;
  int handNumber;
  Duration handDuration;
  List<dynamic> communityCards = new List<dynamic>();
  List<dynamic> yourcards = new List<dynamic>();
  GameStages gameWonAt;
  List<PotWinnerDetailsModel> potWinners = new List<PotWinnerDetailsModel>();
  HandStageModel preFlopActions, flopActions, turnActions, riverActions;
  String unknownString = "u/k";
  int unknownInt = 0;

  HandLogModel();

  HandLogModel.fromJson(var jsonData) {
    gameId = jsonData["gameId"] == null ? unknownString : jsonData["gameId"];

    handNumber = jsonData["handNum"] == null ? 0 : jsonData["handNum"];

    var startTime = jsonData["handLog"]["handStartedAt"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            int.parse(jsonData["handLog"]["handStartedAt"]));
    var endTime = jsonData["handLog"]["handEndedAt"] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            int.parse(jsonData["handLog"]["handEndedAt"]));
    handDuration = ((startTime != null && endTime != null)
        ? startTime.difference(endTime)
        : new Duration(seconds: 0));

    communityCards = jsonData["boardCards"] ?? jsonData["boardCards"];
    yourcards =
        jsonData["players"]["2"]["cards"] ?? jsonData["players"]["2"]["cards"];

    switch (jsonData["handLog"]["wonAt"]) {
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

    var potDetailsJson =
        jsonData["handLog"]["potWinners"] ?? jsonData["handLog"]["potWinners"];
    var playersJson = jsonData["players"] ?? jsonData["players"];
    potWinners = potDetailsJson
        .map<PotWinnerDetailsModel>((potDetails) =>
            PotWinnerDetailsModel.fromJson(potDetails, playersJson))
        .toList();

    var preFlopJson = jsonData["handLog"]["preflopActions"] ??
        jsonData["handLog"]["preflopActions"];
    preFlopActions = HandStageModel.fromJson(
        "PRE FLOP", preFlopJson, new List<int>(), playersJson);

    var flopJson = jsonData["handLog"]["flopActions"] ??
        jsonData["handLog"]["flopActions"];
    var flopCards = jsonData["flopCards"] ?? jsonData["flopCards"];
    flopActions = HandStageModel.fromJson(
        "FLOP", flopJson, flopCards.cast<int>().toList(), playersJson);

    var turnJson = jsonData["handLog"]["turnActions"] ??
        jsonData["handLog"]["turnActions"];
    var turnCards = jsonData["turnCards"] ?? jsonData["turnCards"];
    turnActions = HandStageModel.fromJson(
        "TURN", turnJson, turnCards.cast<int>().toList(), playersJson);

    var riverJson = jsonData["handLog"]["riverActions"] ??
        jsonData["handLog"]["riverActions"];
    var riverCards = jsonData["riverCards"] ?? jsonData["riverCards"];
    riverActions = HandStageModel.fromJson(
        "RIVER", riverJson, riverCards.cast<int>().toList(), playersJson);
  }
}

class PotWinnerDetailsModel {
  int potNumber;
  int totalPotAmount;
  List<WinnerDetailsModel> hiWinners = new List<WinnerDetailsModel>();
  List<WinnerDetailsModel> loWinners = new List<WinnerDetailsModel>();

  PotWinnerDetailsModel.fromJson(var jsonData, playersJson) {
    potNumber = jsonData["potNumber"] != null ? jsonData["potNumber"] : 0;
    totalPotAmount = jsonData["totalPotAmount"] ?? jsonData["totalPotAmount"];

    var hiWinnersJson = jsonData["hiWinners"] ?? jsonData["hiWinners"];

    if (hiWinnersJson != null) {
      hiWinners = hiWinnersJson
          .map<WinnerDetailsModel>((hiWinnerJson) =>
              WinnerDetailsModel.fromJson(hiWinnerJson, playersJson))
          .toList();
    }

    var loWinnersJson = jsonData["lowWinners"] ?? jsonData["lowWinners"];
    if (loWinnersJson != null) {
      loWinners = loWinnersJson
          .map<WinnerDetailsModel>((loWinnerJson) =>
              WinnerDetailsModel.fromJson(loWinnerJson, playersJson))
          .toList();
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

  HandStageModel.fromJson(
      String sName, var jsonData, List<int> cardsList, var playersData) {
    stageName = sName;
    stageCards = cardsList;
    potAmount = jsonData["pot"] == null ? 0 : jsonData["pot"];
    var actionsJson = jsonData["actions"] ?? jsonData["actions"];
    if (actionsJson != null) {
      stageActions = actionsJson
          .map<ActionModel>(
              (actionsJson) => ActionModel.fromJson(actionsJson, playersData))
          .toList();
    }
  }
}

class ActionModel {
  int seatNum;
  String name;
  HandActions action;
  int amount;
  bool timedOut;
  int stack;

  ActionModel.fromJson(var jsonData, var playersData) {
    seatNum = jsonData["seatNo"] == null ? 0 : jsonData["seatNo"];
    name = playersData[seatNum.toString()]["name"];

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
