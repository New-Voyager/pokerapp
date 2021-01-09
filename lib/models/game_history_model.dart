import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokerapp/utils/formatter.dart';

class GameHistoryModel {
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

  String get GameType {
    if (gameTypeStr == 'HOLDEM') {
      return 'No Limit Holdem';
    }
    return gameTypeStr;
  }

  String get StartedAt => DataFormatter.dateFormat(this.startedAt);

  String get Blinds => '$smallBlind/$bigBlind';

  String get ShortGameType {
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

class HandData {
  String round;
  double percent;
  HandData(this.round, this.percent);
}

class HighHandWinner {
  String gameCode;
  String playerUuid;
  int handNum;
  int rank;
  String player;
  List<int> playerCards = new List<int>();
  List<int> boardCards = new List<int>();
  List<int> hhCards = new List<int>();
  DateTime handTime;
  String highHandCards;

  HighHandWinner.fromJson(dynamic data) {
    gameCode = data['gameCode'];
    handNum = data['handNum'];
    rank = data['rank'];
    player = data['playerName'];
    playerUuid = data['playerUuid'];
    List<dynamic> cards = json.decode(data['playerCards']);
    for (dynamic card in cards) {
      playerCards.add(int.parse(card.toString()));
    }
    cards = json.decode(data['boardCards']);
    for (dynamic card in cards) {
      boardCards.add(int.parse(card.toString()));
    }
    cards = json.decode(data['highHand']);
    for (dynamic card in cards) {
      hhCards.add(int.parse(card.toString()));
    }
    handTime = DateTime.parse(data['handTime'].toString());
  }
}

class GameHistoryDetailModel extends ChangeNotifier {
  final String gameCode;
  final bool isOwner;
  List<PlayerStack> stack = new List<PlayerStack>();
  int preflopHands;
  int flopHands;
  int turnHands;
  int riverHands;
  int showdownHands;
  int handsPlayed;
  bool hhTracked = true;
  String gameType;
  int gameHands;
  String runTimeStr;
  String sessionTimeStr;
  int sessionTime;
  DateTime endedAt;
  double balance;
  double buyIn;
  double profit;

  List<HandData> handsData = new List<HandData>();
  List<HighHandWinner> hhWinners = new List<HighHandWinner>();
  dynamic jsonData;

  GameHistoryDetailModel(this.gameCode, this.isOwner);

  void load() async {
    final gameData = jsonData['completedGame'];
    final List playerStack = jsonData['completedGame']['stackStat'];

    stack = playerStack
        .map((e) => new PlayerStack(int.parse(e["handNum"].toString()),
            double.parse(e["after"].toString())))
        .toList();
    stack.sort((a, b) => a.handNum.compareTo(b.handNum));

    preflopHands = int.parse(gameData['preflopHands'].toString());
    flopHands = int.parse(gameData['flopHands'].toString());
    turnHands = int.parse(gameData['turnHands'].toString());
    riverHands = int.parse(gameData['riverHands'].toString());
    showdownHands = int.parse(gameData['showdownHands'].toString());
    handsPlayed = int.parse(gameData['handsPlayed'].toString());

    // build hands stats
    handsData
        .add(new HandData('Pre-flop', (preflopHands / handsPlayed) * 100.0));
    handsData.add(new HandData('Flop', (flopHands / handsPlayed) * 100.0));
    handsData.add(new HandData('Turn', (turnHands / handsPlayed) * 100.0));
    handsData.add(new HandData('River', (riverHands / handsPlayed) * 100.0));
    handsData
        .add(new HandData('Showdown', (showdownHands / handsPlayed) * 100.0));
    if (hhTracked) {
      List<dynamic> winners = gameData['hhWinners'];
      if (winners != null) {
        for (dynamic winner in winners) {
          hhWinners.add(HighHandWinner.fromJson(winner));
        }
      }
    }
    gameType = gameData['gameType'];
    gameHands = int.parse(gameData['handsDealt'].toString());
    runTimeStr = gameData['runTimeStr'].toString();
    sessionTime = int.parse(gameData['sessionTime'].toString());
    int runTimeSec = (int.parse(gameData['runTime'].toString()) / 1000).round();
    if (runTimeSec < 60) {
      runTimeSec = 60;
    }
    runTimeStr = DataFormatter.timeFormat(runTimeSec);
    sessionTimeStr = DataFormatter.timeFormat(sessionTime);

    endedAt = DateTime.parse(gameData['endedAt'].toString());
    balance = double.parse(gameData['balance'].toString());
    profit = double.parse(gameData['profit'].toString());
    buyIn = double.parse(gameData['buyIn'].toString());
  }

  String get gameHandsText {
    return '$gameHands hands dealt in $runTimeStr';
  }

  String get playerHandsText =>
      'You played $handsPlayed hands in $sessionTimeStr';

  String get balanceText => DataFormatter.chipsFormat(balance);

  String get buyInText => DataFormatter.chipsFormat(buyIn);

  String get profitText => DataFormatter.chipsFormat(profit);

  String get gameTypeStr {
    if (gameType == 'HOLDEM') {
      return 'No Limit Holdem';
    }
    return gameType;
  }

  String get handsPlayedStr {
    return handsPlayed.toString();
  }

  String get endedAtStr => DataFormatter.dateFormat(this.endedAt);

  static GameHistoryDetailModel copyWith(GameHistoryDetailModel copy) {
    String gameDetail = json.encode(copy.jsonData);
    GameHistoryDetailModel ret = new GameHistoryDetailModel(copy.gameCode, copy.isOwner);
    ret.jsonData = json.decode(gameDetail);
    ret.load();
    return ret;
  }
}
