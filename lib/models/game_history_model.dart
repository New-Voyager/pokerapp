import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokerapp/enums/game_type.dart';
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

  // New Fields from game record
  // gameType
  String clubCode;
  String clubName;
  String endedBy;
  double stack;
  double buyIn;

  GameHistoryModel.fromJson(var jsonData) {
    clubCode = jsonData['clubCode'];
    clubName = jsonData['clubName'];
    endedBy = jsonData['endedBy'];
    if (jsonData['stack'] != null) {
      stack = double.parse(jsonData['stack'].toString());
    }

    if (jsonData['buyIn'] != null) {
      buyIn = double.parse(jsonData['buyIn'].toString());
    }
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
    if (handsPlayed >= 1) {
      sessionTime = int.parse(jsonData["sessionTime"].toString());
      if (jsonData["sessionTimeStr"] != null) {
        sessionTimeStr = jsonData["sessionTimeStr"].toString();
      }
    } else {
      sessionTimeStr = "You didn't play this game";
    }

    smallBlind = double.parse(jsonData["smallBlind"].toString());
    bigBlind = double.parse(jsonData["bigBlind"].toString());

    if (jsonData["startedAt"] != null) {
      startedAt = DateTime.parse(jsonData["startedAt"].toString()).toLocal();
    }
    if (jsonData["gameNum"] != null) {
      gameNum = int.parse(jsonData["gameNum"].toString());
    }
  }

  // String get GameType {
  //   if (gameTypeStr == 'HOLDEM') {
  //     return 'No Limit Holdem';
  //   }
  //   return gameTypeStr;
  // }

  String get StartedAt => DataFormatter.dateFormat(this.startedAt);

  String get Blinds => '$smallBlind/$bigBlind';

  // String get ShortGameType {
  //   if (gameTypeStr == 'HOLDEM') {
  //     return 'NLH';
  //   } else if (gameTypeStr.contains('5 Card PLO')) {
  //     return '5PLO';
  //   }
  //   return gameTypeStr;
  // }
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
  List<int> playerCards = [];
  List<int> boardCards = [];
  List<int> hhCards = [];
  DateTime handTime;
  String highHandCards;
  bool winner;

  HighHandWinner();

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
    winner = false;
    if (data['winner'].toString() == 'true') {
      winner = true;
    }
  }
}

class GameHistoryDetailModel extends ChangeNotifier {
  final String gameCode;
  bool isOwner;
  List<PlayerStack> stack = [];
  int preflopHands;
  int flopHands;
  int turnHands;
  int riverHands;
  int showdownHands;
  int handsPlayed = 0;
  bool hhTracked = false;
  String gameType;
  int gameHands;
  String runTimeStr;
  String sessionTimeStr;
  int sessionTime;
  DateTime endedAt;
  double balance;
  double buyIn;
  double profit;
  bool playedGame = false;
  double smallBlind;
  double bigBlind;
  String startedBy;
  String endedBy;
  bool isHost;
  bool isManager;
  String handDataLink = '';
  bool dataAggregated = false;
  bool showGameResult = true;
  ChipUnit chipUnit = ChipUnit.DOLLAR;

  List<HandData> handsData = [];
  List<HighHandWinner> hhWinners = [];
  dynamic jsonData;

  GameHistoryDetailModel(this.gameCode, this.isOwner);

  void load() async {
    final gameData = jsonData['completedGame'];

    this.smallBlind = double.parse(gameData['smallBlind'].toString());
    this.bigBlind = double.parse(gameData['bigBlind'].toString());
    this.startedBy = gameData['startedBy'] ?? '';
    this.endedBy = gameData['endedBy'] ?? '';
    this.hhTracked = gameData['highHandTracked'] ?? false;

    if (gameData['handsPlayed'] == null) {
      this.playedGame = false;
    } else {
      handsPlayed = int.parse(gameData['handsPlayed'].toString());
      if (handsPlayed > 0) {
        this.playedGame = true;
      }
    }
    dataAggregated = gameData['dataAggregated'] ?? false;

    if (this.playedGame) {
      final List playerStack = jsonData['completedGame']['stackStat'];
      stack = playerStack
          .map((e) => new PlayerStack(int.parse(e["handNum"].toString()),
              double.parse(e["after"].toString())))
          .toList();
      stack.sort((a, b) => a.handNum.compareTo(b.handNum));

      handsPlayed = int.parse(gameData['handsPlayed'].toString());
      if (dataAggregated) {
        preflopHands = int.parse((gameData['preflopHands'] ?? 0).toString());
        flopHands = int.parse((gameData['flopHands'] ?? 0).toString());
        turnHands = int.parse((gameData['turnHands'] ?? 0).toString());
        riverHands = int.parse((gameData['riverHands'] ?? 0).toString());
        showdownHands = int.parse((gameData['showdownHands'] ?? 0).toString());
        // build hands stats
        handsData.add(
            new HandData('Pre-flop', (preflopHands / handsPlayed) * 100.0));
        handsData.add(new HandData('Flop', (flopHands / handsPlayed) * 100.0));
        handsData.add(new HandData('Turn', (turnHands / handsPlayed) * 100.0));
        handsData
            .add(new HandData('River', (riverHands / handsPlayed) * 100.0));
        handsData.add(
            new HandData('Showdown', (showdownHands / handsPlayed) * 100.0));
      }
    }

    if (this.hhTracked) {
      List<dynamic> winners = jsonData['hhWinners'];
      if (winners != null) {
        for (dynamic winner in winners) {
          hhWinners.add(HighHandWinner.fromJson(winner));
        }
      }
    }
    gameType = gameData['gameType'];
    gameHands = int.parse(gameData['handsDealt'].toString());
    // runTimeStr = gameData['runTimeStr'].toString();
    int runTimeSec = (int.parse(gameData['runTime'].toString()) / 1000).round();
    if (runTimeSec < 60) {
      runTimeSec = 60;
    }
    runTimeStr = DataFormatter.timeFormat(runTimeSec);
    endedAt =
        (DateTime.parse((gameData['endedAt'] ?? DateTime.now()).toString()))
            .toLocal();
    if (this.playedGame) {
      sessionTime = int.parse(gameData['sessionTime'].toString());
      sessionTimeStr = DataFormatter.timeFormat(sessionTime);
      balance = double.parse((gameData['balance'] ?? '0').toString());
      profit = double.parse((gameData['profit'] ?? '0').toString());
      buyIn = double.parse((gameData['buyIn'] ?? '0').toString());
    }
    if (gameData['chipUnit'] == 'DOLLAR') {
      chipUnit = ChipUnit.DOLLAR;
    } else {
      chipUnit = ChipUnit.CENT;
    }
    isOwner = gameData['isOwner'];
    isHost = gameData['isHost'];
    isManager = gameData['isManager'];
    handDataLink = gameData['handDataLink'];

    if (jsonData['showGameResult'] != null) {
      showGameResult = jsonData['showGameResult'];
    }
  }

  String get gameHandsText {
    return '$gameHands hands dealt in $runTimeStr';
  }

  String get playerHandsText {
    if (!this.playedGame) {
      return "You didn't play this game";
    }
    return 'You played $handsPlayed hands in $sessionTimeStr';
  }

  String get balanceText => DataFormatter.chipsFormat(balance);

  String get buyInText => DataFormatter.chipsFormat(buyIn);

  String get profitText => DataFormatter.chipsFormat(profit);

  String get gameTypeStr {
    // if (gameType == 'HOLDEM') {
    //   return 'No Limit Holdem';
    // }
    return gameType;
  }

  String get handsPlayedStr {
    return handsPlayed.toString();
  }

  String get endedAtStr => DataFormatter.dateFormat(this.endedAt);

  static GameHistoryDetailModel copyWith(GameHistoryDetailModel copy) {
    String gameDetail = json.encode(copy.jsonData);
    GameHistoryDetailModel ret =
        new GameHistoryDetailModel(copy.gameCode, copy.isOwner);
    ret.jsonData = json.decode(gameDetail);
    ret.load();
    return ret;
  }
}
