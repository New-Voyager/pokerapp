import 'dart:convert';

import 'package:pokerapp/enums/game_type.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class GameHistoryModel {
  GameType gameType;
  String gameTypeStr;
  String gameCode;
  double smallBlind;
  int gameNum;
  double bigBlind;
  String startedBy;
  DateTime startedAt;
  DateTime endedAt;
  int sessionTime;
  String sessionTimeStr;
  int runTime;
  String runTimeStr;
  double balance;
  int handsPlayed;
  final DateFormat formatter = DateFormat.yMd().add_jm(); // internationalize this

  GameHistoryModel.fromJson(var jsonData) {
    gameTypeStr = jsonData["gameType"];
    gameCode = jsonData["gameCode"];
    startedBy = jsonData["startedBy"];
    if (jsonData["endedAt"] != null) {
      endedAt = DateTime.parse(jsonData["endedAt"].toString());
    }
    runTimeStr = jsonData["runTimeStr"];
    if (runTimeStr == null) {
      runTimeStr = "";
    }
    runTime = jsonData["runTime"];
    if (jsonData["handsPlayed"] != null) {
      handsPlayed = int.parse(jsonData["handsPlayed"].toString());
    } else {
      handsPlayed = -1;
    }
    if (jsonData["balance"] != null) {
      balance = double.parse(jsonData["balance"].toString());
    }
    sessionTime = int.parse(jsonData["sessionTime"].toString());
    smallBlind = double.parse(jsonData["smallBlind"].toString());
    bigBlind = double.parse(jsonData["bigBlind"].toString());

    if (jsonData["startedAt"] != null) {
      startedAt = DateTime.parse(jsonData["startedAt"].toString());
    }
    if (jsonData["sessionTimeStr"] != null) {
      sessionTimeStr = jsonData["sessionTimeStr"].toString();
    }
    if (jsonData["gameNum"] != null) {
      gameNum = int.parse(jsonData["gameNum"].toString());
    }
  }

  String getGameTypeStr() {
    if (gameTypeStr == 'HOLDEM') {
      return 'No Limit Holdem';
    }
    return gameTypeStr;
  }

  String getStartedAt() {
    return formatter.format(this.startedAt);
  }

  String blinds() {
    return '$smallBlind/$bigBlind';
  }

  String getShortGameType() {
    if (gameTypeStr == 'HOLDEM') {
      return 'NLH';
    } else if (gameTypeStr.contains('5 Card PLO')) {
      return '5PLO';
    }
    return gameTypeStr;
  }
}

class PlayerStack {
  int handNum;
  double balance;
  PlayerStack(this.handNum, this.balance);
}

class GameHistoryDetailModel {
  List<PlayerStack> stack = new List<PlayerStack>();
  int flopHands;
  int turnHands;
  int riverHands;
  int showdownHands;
  int handsPlayed;

  static Future<GameHistoryDetailModel> fromJson() async  {
    String data = await rootBundle.loadString('assets/sample-data/completed-game.json');
    final jsonData = json.decode(data);
    print(jsonData);
    GameHistoryDetailModel ret = new GameHistoryDetailModel();
    final gameData = jsonData['data']['completedGame'];
    final List playerStack = jsonData['data']['completedGame']['stackStat'];

    ret.stack = playerStack.map((e) =>
        new PlayerStack(int.parse(e["handNum"].toString()),
            double.parse(e["after"].toString())))
        .toList();

    ret.flopHands = int.parse(gameData['flopHands'].toString());
    ret.turnHands = int.parse(gameData['turnHands'].toString());
    ret.riverHands = int.parse(gameData['riverHands'].toString());
    ret.showdownHands = int.parse(gameData['showdownHands'].toString());
    ret.handsPlayed = int.parse(gameData['handsPlayed'].toString());
    return ret;
  }
}