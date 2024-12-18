// To parse this JSON data, do
//
//     final handStatsModel = handStatsModelFromJson(jsonString);

import 'dart:convert';

HandStatsModel handStatsModelFromJson(String str) =>
    HandStatsModel.fromJson(json.decode(str));

String handStatsModelToJson(HandStatsModel data) => json.encode(data.toJson());

class HandStatsModel {
  HandStatsModel({this.thisGame, this.alltime, this.playerIdToName});

  StatModel thisGame;
  StatModel alltime;
  Map<int, String> playerIdToName = Map<int, String>();

  Map<int /*playerId*/, HeadsupStat> headsupThisGame =
      Map<int /*playerId*/, HeadsupStat>();
  factory HandStatsModel.fromJson(Map<String, dynamic> json) {
    final playerIdToName = Map<int, String>();
    for (final player in json['gamePlayers']) {
      playerIdToName[player['id']] = player['name'];
    }
    final thisGame = StatModel.fromJson(json["playerGameStats"]);
    final allTime = StatModel.fromJson(json["playerHandStats"]);
    return HandStatsModel(
      thisGame: thisGame,
      alltime: allTime,
      playerIdToName: playerIdToName,
    );
  }

  Map<String, dynamic> toJson() => {
        "playerGameStats": thisGame.toJson(),
        "playerHandStats": alltime.toJson(),
      };

  loadData() {
    for (final stat in thisGame.headsupHandDetails) {
      final playerId = stat.otherPlayer;
      if (headsupThisGame[playerId] == null) {
        this.headsupThisGame[playerId] = HeadsupStat(playerId);
      }
      this.headsupThisGame[playerId].count++;
      if (stat.won ?? false) {
        this.headsupThisGame[playerId].won++;
      }
    }
  }
}

class HeadsupStat {
  int playerId;
  int won = 0;
  int count = 0;
  HeadsupStat(this.playerId);
}

class StatModel {
  StatModel({
    this.inPreflop,
    this.inFlop,
    this.inTurn,
    this.inRiver,
    this.wentToShowDown,
    this.wonAtShowDown,
    this.headsupHands,
    this.wonHeadsupHands,
    this.headsupHandSummary,
    this.preflopRaise,
    this.postflopRaise,
    this.threeBet,
    this.contBet,
    this.vpipCount,
    this.allInCount,
    this.totalHands,
    this.headsupHandDetails,
    this.totalGames,
  });

  int inPreflop;
  int inFlop;
  int inTurn;
  int inRiver;
  int wentToShowDown;
  int wonAtShowDown;
  int headsupHands;
  int wonHeadsupHands;
  Map<String, HeadsupHandSummary> headsupHandSummary;
  int preflopRaise;
  int postflopRaise;
  int threeBet;
  int contBet;
  int vpipCount;
  int allInCount;
  int totalHands;
  int totalGames;
  List<HeadsupHandDetail> headsupHandDetails;

  factory StatModel.fromJson(Map<String, dynamic> json) {
    List<HeadsupHandDetail> headsupDetails = [];
    if (json["headsupHandDetails"] != null) {
      for (final headsup in json["headsupHandDetails"]) {
        headsupDetails.add(HeadsupHandDetail.fromJson(headsup));
      }
    }

    final stats = StatModel(
      inPreflop: json["inPreflop"],
      inFlop: json["inFlop"],
      inTurn: json["inTurn"],
      inRiver: json["inRiver"],
      wentToShowDown: json["wentToShowDown"],
      wonAtShowDown: json["wonAtShowDown"],
      headsupHands: json["headsupHands"],
      wonHeadsupHands: json["wonHeadsupHands"],
      headsupHandSummary: json["headsupHandSummary"] == null
          ? null
          : Map.from(json["headsupHandSummary"]).map((k, v) =>
              MapEntry<String, HeadsupHandSummary>(
                  k, HeadsupHandSummary.fromJson(v))),
      preflopRaise: json["preflopRaise"],
      postflopRaise: json["postflopRaise"],
      threeBet: json["threeBet"],
      contBet: json["contBet"],
      vpipCount: json["vpipCount"],
      allInCount: json["allInCount"],
      totalHands: json["totalHands"],
      headsupHandDetails: headsupDetails,
      totalGames: json['totalGames'],
    );
    return stats;
  }

  Map<String, dynamic> toJson() => {
        "inPreflop": inPreflop,
        "inFlop": inFlop,
        "inTurn": inTurn,
        "inRiver": inRiver,
        "wentToShowDown": wentToShowDown,
        "wonAtShowDown": wonAtShowDown,
        "headsupHands": headsupHands,
        "wonHeadsupHands": wonHeadsupHands,
        "headsupHandSummary": headsupHandSummary == null
            ? null
            : Map.from(headsupHandSummary)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "preflopRaise": preflopRaise,
        "postflopRaise": postflopRaise,
        "threeBet": threeBet,
        "contBet": contBet,
        "vpipCount": vpipCount,
        "allInCount": allInCount,
        "totalHands": totalHands,
        "totalGames": totalGames,
        "headsupHandDetails": headsupHandDetails == null
            ? null
            : List<dynamic>.from(headsupHandDetails.map((x) => x.toJson())),
      };
}

class HeadsupHandDetail {
  HeadsupHandDetail({
    this.handNum,
    this.otherPlayer,
    this.won,
  });

  int handNum;
  int otherPlayer;
  bool won;

  factory HeadsupHandDetail.fromJson(Map<String, dynamic> json) {
    return HeadsupHandDetail(
      handNum: json["handNum"],
      otherPlayer: int.parse(json["otherPlayer"].toString()),
      won: json["won"],
    );
  }

  Map<String, dynamic> toJson() => {
        "handNum": handNum,
        "otherPlayer": otherPlayer,
        "won": won,
      };
}

class HeadsupHandSummary {
  HeadsupHandSummary({
    this.won,
    this.total,
  });

  int won;
  int total;

  factory HeadsupHandSummary.fromJson(Map<String, dynamic> json) =>
      HeadsupHandSummary(
        won: json["won"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "won": won,
        "total": total,
      };
}
