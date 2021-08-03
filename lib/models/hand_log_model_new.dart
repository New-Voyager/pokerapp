import 'dart:convert';
import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;
import 'package:pokerapp/proto/handmessage.pb.dart' as proto;

class HandLogModelNew {
  static HandLogModelNew handLogModelNewFromJson(
    String str, {
    bool serviceResult = false,
    authorizedToView = false,
    Map<int, String> playerIdsToNames,
    Map<int, List<int>> myCards,
  }) =>
      HandLogModelNew.fromJson(
        json.decode(str),
        serviceResult: serviceResult,
        authorizedToView: authorizedToView,
        playerIdsToNames: playerIdsToNames,
        myCards: myCards,
      );

  getMyCards() {
    List<int> cards = [];
    int myId = myInfo.id;
    // Need to use 'orElse', otherwise it will crash.
    final player = hand.playersInSeats
        .firstWhere((element) => element.id == myId, orElse: () => null);

    if (player != null) {
      cards = player.cards;
    }

    if (cards == null || cards.length == 0 && myCards != null) {
      cards = myCards[this.hand.handNum];
    }

    if (cards == null) {
      cards = [];
    }
    return cards;
  }

  HandLogModelNew({
    this.hand,
    this.myInfo,
    this.handData,
    this.authorized,
    this.playerIdsToNames,
    this.myCards,
  });

  String handData;
  Data hand;
  MyInfo myInfo;
  bool authorized;
  Map<int, String> playerIdsToNames;
  Map<int, List<int>> myCards;

  factory HandLogModelNew.fromJson(Map<String, dynamic> json,
      {bool serviceResult = false,
      authorizedToView = false,
      Map<int, String> playerIdsToNames,
      Map<int, List<int>> myCards}) {
    var hand = json["handResult"];
    if (hand == null) {
      if (json["hand"] == null) {
        // HACK here
        hand = json;
      } else {
        // HACK here
        hand = json['hand'];
      }
    }
    bool authorized = hand['authorized'] ?? authorizedToView;
    if (serviceResult) {
      hand = hand['data'];
    }
    //log("HandData : \n $hand");

    Data handLog;
    if (hand != null) {
      handLog = Data.fromJson(hand);
    }
    final handData = jsonEncode(hand);

    dynamic myInfo;
    if (json['myInfo'] != null) {
      myInfo = MyInfo.fromJson(json['myInfo']);
    } else {
      // dummy
      myInfo = MyInfo.fromJson(
          {"id": 1, "uuid": "cfe63ff3712c594f", "name": "asdf"});
    }

    return HandLogModelNew(
      hand: handLog,
      handData: handData,
      //playerIdToName: playerIdToName,
      myInfo: myInfo,
      authorized: authorized,
      playerIdsToNames: playerIdsToNames,
      myCards: myCards,
    );
  }

  Player getPlayerBySeatNo(int seatNo) {
    final player = this
        .hand
        .playersInSeats
        .firstWhere((element) => element.seatNo == seatNo);

    if (player != null && player.name == null && playerIdsToNames != null) {
      player.name = playerIdsToNames[player.id];
    }
    return player;
  }

  String getPlayerName(int id) {
    final player =
        this.hand.playersInSeats.firstWhere((element) => element.id == id);

    if (player != null && player.name == null && playerIdsToNames != null) {
      player.name = playerIdsToNames[player.id];
    }
    return player.name;
  }

  List<int> getPlayerIdsWithoutName() {
    List<int> ids = [];
    for (final player in this.hand.playersInSeats) {
      if (player.name == null) {
        ids.add(player.id);
      }
    }
    return ids;
  }
}

class Data {
  Data({
    this.gameId,
    this.gameCode,
    this.handNum,
    this.gameType,
    this.actionTime,
    this.noCards,
    this.maxPlayers,
    this.smallBlind,
    this.bigBlind,
    this.handLog,
    this.rewardTrackingIds,
    this.boardCards,
    this.boardCards2,
    this.flop,
    this.turn,
    this.river,
    this.playersInSeats,
    this.rakeCollected,
    this.highHand,
    //this.playerStats,
    this.handStats,
    this.runItTwice,
  });

  String gameId;
  String gameCode;
  int handNum;
  String gameType;
  int actionTime;
  int noCards;
  HandLog handLog;
  List<dynamic> rewardTrackingIds;
  List<int> boardCards;
  List<int> boardCards2;
  int maxPlayers;
  double smallBlind;
  double bigBlind;
  List<int> flop;
  int turn;
  int river;
  List<Player> playersInSeats;
  int rakeCollected;
  dynamic highHand;
  //Map<String, PlayerStat> playerStats;
  HandStats handStats;
  bool runItTwice;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        gameId: json["gameId"],
        gameCode: json["gameCode"],
        handNum: json["handNum"],
        gameType: json["gameType"],
        actionTime: json["actionTime"],
        noCards: json['noCards'],
        maxPlayers: json['maxPlayers'] ?? 9,
        smallBlind: double.parse((json['smallBlind'] ?? 1).toString()),
        bigBlind: double.parse((json['bigBlind'] ?? 2).toString()),
        handLog: HandLog.fromJson(json["handLog"]),
        rewardTrackingIds:
            List<dynamic>.from(json["rewardTrackingIds"].map((x) => x)),
        boardCards: List<int>.from(json["boardCards"].map((x) => x)),
        boardCards2: List<int>.from(json["boardCards2"].map((x) => x)),
        flop: List<int>.from(json["flop"].map((x) => x)),
        turn: json["turn"],
        river: json["river"],
        playersInSeats: Map.from(json["players"])
            .map((k, v) {
              final seatNo = int.parse(k.toString());
              return MapEntry<int, Player>(seatNo, Player.fromJson(seatNo, v));
            })
            .values
            .toList(),
        rakeCollected: json["rakeCollected"],
        highHand: json["highHand"],
        // playerStats: Map.from(json["playerStats"]).map(
        //     (k, v) => MapEntry<String, PlayerStat>(k, PlayerStat.fromJson(v))),
        handStats: HandStats.fromJson(json["handStats"]),
        runItTwice: json["runItTwice"],
      );

  Map<String, dynamic> toJson() => {
        "gameId": gameId,
        "gameCode": gameCode,
        "handNum": handNum,
        "gameType": gameType,
        "actionTime": actionTime,
        "handLog": handLog.toJson(),
        "rewardTrackingIds":
            List<dynamic>.from(rewardTrackingIds.map((x) => x)),
        "boardCards": List<dynamic>.from(boardCards.map((x) => x)),
        "boardCards2": List<dynamic>.from(boardCards2.map((x) => x)),
        "flop": List<dynamic>.from(flop.map((x) => x)),
        "turn": turn,
        "river": river,
        "players": playersInSeats,
        "rakeCollected": rakeCollected,
        "highHand": highHand,
        //"playerStats": Map.from(playerStats)
        //    .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "handStats": handStats.toJson(),
        "runItTwice": runItTwice,
      };
}

class HandLog {
  HandLog({
    this.preflopActions,
    this.flopActions,
    this.turnActions,
    this.riverActions,
    this.potWinners,
    this.wonAt,
    this.showDown,
    this.handStartedAt,
    this.handEndedAt,
    this.runItTwice,
    this.runItTwiceResult,
  });

  GameActions preflopActions;
  GameActions flopActions;
  GameActions turnActions;
  GameActions riverActions;
  Map<String, PotWinner> potWinners;
  GameStages wonAt;
  dynamic showDown;
  int handStartedAt;
  int handEndedAt;
  bool runItTwice;
  dynamic runItTwiceResult;
  List<SeatPot> seatPotsInShowdown;

  factory HandLog.fromJson(Map<String, dynamic> json) {
    final handLog = HandLog(
      preflopActions: GameActions.fromJson(json["preflopActions"]),
      flopActions: GameActions.fromJson(json["flopActions"]),
      turnActions: GameActions.fromJson(json["turnActions"]),
      riverActions: GameActions.fromJson(json["riverActions"]),
      potWinners: Map.from(json["potWinners"])
          .map((k, v) => MapEntry<String, PotWinner>(k, PotWinner.fromJson(v))),
      wonAt: stagesEnumValues.map[json["wonAt"]],
      showDown: json["showDown"],
      handStartedAt: int.parse(json["handStartedAt"].toString()),
      handEndedAt: int.parse(json["handEndedAt"].toString()),
      runItTwice: json["runItTwice"],
      runItTwiceResult: json["runItTwiceResult"],
    );
    final seatPotsJson = json["seatsPotsShowdown"];
    List<SeatPot> seatPots = [];
    if (seatPotsJson.length > 0) {
      for (final seatPot in seatPotsJson) {
        seatPots.add(SeatPot.fromJson(seatPot));
      }
    }
    handLog.seatPotsInShowdown = seatPots;
    return handLog;
  }

  Map<String, dynamic> toJson() => {
        "preflopActions": preflopActions.toJson(),
        "flopActions": flopActions.toJson(),
        "turnActions": turnActions.toJson(),
        "riverActions": riverActions.toJson(),
        "potWinners": Map.from(potWinners)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "wonAt": stagesEnumValues.reverse[wonAt],
        "showDown": showDown,
        "handStartedAt": handStartedAt,
        "handEndedAt": handEndedAt,
        "runItTwice": runItTwice,
        "runItTwiceResult": runItTwiceResult,
      };
}

class SeatPot {
  List<int> seats = [];
  double pot;
  SeatPot();

  factory SeatPot.fromJson(dynamic json) {
    SeatPot seatPot = SeatPot();

    seatPot.seats = [];
    for (final seat in json['seats']) {
      seatPot.seats.add(int.parse(seat.toString()));
    }
    seatPot.pot = double.parse(json['pot'].toString());
    return seatPot;
  }
}

class GameActions {
  GameActions({
    this.pots,
    this.potStart,
    this.actions,
    this.seatPots,
  });

  List<int> pots;
  List<ActionElement> actions;
  int potStart;
  List<SeatPot> seatPots;

  factory GameActions.fromJson(Map<String, dynamic> json) {
    final seatPotsJson = json["seatsPots"];
    List<SeatPot> seatPots = [];
    if (seatPotsJson.length > 0) {
      for (final seatPot in seatPotsJson) {
        seatPots.add(SeatPot.fromJson(seatPot));
      }
    }

    return GameActions(
      pots: json["pots"]?.map<int>((e) => int.parse(e.toString()))?.toList(),
      potStart: json["potStart"],
      actions: List<ActionElement>.from(
          json["actions"].map((x) => ActionElement.fromJson(x))),
      seatPots: seatPots,
    );
  }

  Map<String, dynamic> toJson() => {
        "pot": pots,
        "potStart": potStart,
        "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
      };
}

class ActionElement {
  ActionElement({
    this.seatNo,
    this.action,
    this.amount,
    this.timedOut,
    this.actionTime,
    this.stack,
  });

  int seatNo;
  HandActions action;
  int amount;
  bool timedOut;
  int actionTime;
  int stack;

  factory ActionElement.fromJson(Map<String, dynamic> json) => ActionElement(
        seatNo: json["seatNo"],
        action: actionEnumValues.map[json["action"]],
        amount: json["amount"],
        timedOut: json["timedOut"],
        actionTime: json["actionTime"],
        stack: json["stack"],
      );

  Map<String, dynamic> toJson() => {
        "seatNo": seatNo,
        "action": actionEnumValues.reverse[action],
        "amount": amount,
        "timedOut": timedOut,
        "actionTime": actionTime,
        "stack": stack,
      };
}

final actionEnumValues = EnumValues({
  "BB": HandActions.BB,
  "CALL": HandActions.CALL,
  "CHECK": HandActions.CHECK,
  "SB": HandActions.SB,
  "BET": HandActions.BET,
  "RAISE": HandActions.RAISE,
  "FOLD": HandActions.FOLD,
  "STRADDLE": HandActions.STRADDLE,
  "ALLIN": HandActions.ALLIN
});

final stagesEnumValues = StageEnumValues({
  "PRE_FLOP": GameStages.PREFLOP,
  "FLOP": GameStages.FLOP,
  "RIVER": GameStages.RIVER,
  "TURN": GameStages.TURN,
  "SHOW_DOWN": GameStages.SHOWDOWN
});

class PotWinner {
  PotWinner({this.hiWinners, this.lowWinners, this.amount, this.potNo});
  int potNo;
  int amount;
  List<WinnerPlayer> hiWinners;
  List<WinnerPlayer> lowWinners;

  factory PotWinner.fromJson(Map<String, dynamic> json) => PotWinner(
        hiWinners: List<WinnerPlayer>.from(
            json["hiWinners"].map((x) => WinnerPlayer.fromJson(x))),
        lowWinners: List<WinnerPlayer>.from(
            json["lowWinners"].map((x) => WinnerPlayer.fromJson(x))),
        amount: json['amount'],
        potNo: json['pot'],
      );

  proto.PotWinners toProto() {
    final List<proto.HandWinner> hiWinners = [];
    final List<proto.HandWinner> lowWinners = [];

    for(final winner in this.hiWinners) {
      final hiWinner = proto.HandWinner(
        seatNo: winner.seatNo,
        amount: winner.amount.toDouble(),
        boardCards: winner.boardCards,
        playerCards: winner.playerCards,
        winningCards: winner.winningCards,
        winningCardsStr: winner.winningCardsStr,
        loCard: winner.loCard,
        rank: winner.rank,
        rankStr: winner.rankStr);
      hiWinners.add(hiWinner);
    }

    for(final winner in this.lowWinners) {
      final loWinner = proto.HandWinner(
        seatNo: winner.seatNo,
        amount: winner.amount.toDouble(),
        boardCards: winner.boardCards,
        playerCards: winner.playerCards,
        winningCards: winner.winningCards,
        winningCardsStr: winner.winningCardsStr,
        loCard: winner.loCard,
        rank: winner.rank,
        rankStr: winner.rankStr);
      lowWinners.add(loWinner);
    }
    final ret = proto.PotWinners(
      amount: this.amount.toDouble(),
      potNo: this.potNo,
      hiWinners: hiWinners,
      lowWinners: lowWinners,
    );
    return ret;
  }

  Map<String, dynamic> toJson() => {
        "hiWinners":
            List<Map<String, dynamic>>.from(hiWinners.map((x) => x.toJson())),
        "lowWinners":
            List<Map<String, dynamic>>.from(lowWinners.map((x) => x.toJson())),
        "amount": amount,
        "pot": potNo,
      };
}

class WinnerPlayer {
  WinnerPlayer({
    this.seatNo,
    this.loCard,
    this.amount,
    this.winningCards,
    this.winningCardsStr,
    this.rankStr,
    this.rank,
    this.playerCards,
    this.boardCards,
  });

  int seatNo;
  bool loCard;
  int amount;
  List<int> winningCards;
  String winningCardsStr;
  String rankStr;
  int rank;
  List<int> playerCards;
  List<int> boardCards;

  factory WinnerPlayer.fromJson(Map<String, dynamic> json) => WinnerPlayer(
        seatNo: json["seatNo"],
        loCard: json["loCard"],
        amount: json["amount"],
        winningCards: List<int>.from(json["winningCards"].map((x) => x)),
        winningCardsStr: json["winningCardsStr"],
        rankStr: json["rankStr"],
        rank: json["rank"],
        playerCards: List<int>.from(json["playerCards"].map((x) => x)),
        boardCards: List<int>.from(json["boardCards"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "seatNo": seatNo,
        "loCard": loCard,
        "amount": amount,
        "winningCards": List<dynamic>.from(winningCards.map((x) => x)),
        "winningCardsStr": winningCardsStr,
        "rankStr": rankStr,
        "rank": rank,
        "playerCards": List<dynamic>.from(playerCards.map((x) => x)),
        "boardCards": List<dynamic>.from(boardCards.map((x) => x)),
      };
}

class HandStats {
  HandStats({
    this.endedAtPreflop,
    this.endedAtFlop,
    this.endedAtTurn,
    this.endedAtRiver,
    this.endedAtShowdown,
  });

  bool endedAtPreflop;
  bool endedAtFlop;
  bool endedAtTurn;
  bool endedAtRiver;
  bool endedAtShowdown;

  factory HandStats.fromJson(Map<String, dynamic> json) => HandStats(
        endedAtPreflop: json["endedAtPreflop"],
        endedAtFlop: json["endedAtFlop"],
        endedAtTurn: json["endedAtTurn"],
        endedAtRiver: json["endedAtRiver"],
        endedAtShowdown: json["endedAtShowdown"],
      );

  Map<String, dynamic> toJson() => {
        "endedAtPreflop": endedAtPreflop,
        "endedAtFlop": endedAtFlop,
        "endedAtTurn": endedAtTurn,
        "endedAtRiver": endedAtRiver,
        "endedAtShowdown": endedAtShowdown,
      };
}

class PlayerStat {
  PlayerStat({
    this.preflopRaise,
    this.postflopRaise,
    this.threeBet,
    this.cbet,
    this.vpip,
    this.allin,
    this.wentToShowdown,
    this.wonChipsAtShowdown,
    this.headsup,
    this.headsupPlayer,
    this.wonHeadsup,
    this.badbeat,
    this.inPreflop,
    this.inFlop,
    this.inTurn,
    this.inRiver,
  });

  bool preflopRaise;
  bool postflopRaise;
  bool threeBet;
  bool cbet;
  bool vpip;
  bool allin;
  bool wentToShowdown;
  bool wonChipsAtShowdown;
  bool headsup;
  String headsupPlayer;
  bool wonHeadsup;
  bool badbeat;
  bool inPreflop;
  bool inFlop;
  bool inTurn;
  bool inRiver;

  factory PlayerStat.fromJson(Map<String, dynamic> json) => PlayerStat(
        preflopRaise: json["preflopRaise"],
        postflopRaise: json["postflopRaise"],
        threeBet: json["threeBet"],
        cbet: json["cbet"],
        vpip: json["vpip"],
        allin: json["allin"],
        wentToShowdown: json["wentToShowdown"],
        wonChipsAtShowdown: json["wonChipsAtShowdown"],
        headsup: json["headsup"],
        headsupPlayer: json["headsupPlayer"],
        wonHeadsup: json["wonHeadsup"],
        badbeat: json["badbeat"],
        inPreflop: json["inPreflop"],
        inFlop: json["inFlop"],
        inTurn: json["inTurn"],
        inRiver: json["inRiver"],
      );

  Map<String, dynamic> toJson() => {
        "preflopRaise": preflopRaise,
        "postflopRaise": postflopRaise,
        "threeBet": threeBet,
        "cbet": cbet,
        "vpip": vpip,
        "allin": allin,
        "wentToShowdown": wentToShowdown,
        "wonChipsAtShowdown": wonChipsAtShowdown,
        "headsup": headsup,
        "headsupPlayer": headsupPlayer,
        "wonHeadsup": wonHeadsup,
        "badbeat": badbeat,
        "inPreflop": inPreflop,
        "inFlop": inFlop,
        "inTurn": inTurn,
        "inRiver": inRiver,
      };
}

class Player {
  Player({
    this.seatNo,
    this.id,
    this.name,
    this.cards,
    this.bestCards,
    this.rank,
    this.playedUntil,
    this.balance,
    this.hhCards,
    this.hhRank,
    this.received,
    this.rakePaid,
  });

  int seatNo;
  int id;
  List<int> cards;
  List<int> bestCards;
  int rank;
  String playedUntil;
  Balance balance;
  List<int> hhCards;
  int hhRank;
  int received;
  int rakePaid;
  String name;

  factory Player.fromJson(int seatNo, Map<String, dynamic> json) => Player(
        seatNo: seatNo,
        id: int.parse(json["id"].toString()),
        name: json["name"],
        cards: List<int>.from(json["cards"].map((x) => x)),
        bestCards: List<int>.from(json["bestCards"].map((x) => x)),
        rank: json["rank"],
        playedUntil: json["playedUntil"],
        balance: Balance.fromJson(json["balance"]),
        hhCards: List<int>.from(json["hhCards"].map((x) => x)),
        hhRank: json["hhRank"],
        received: json["received"],
        rakePaid: json["rakePaid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cards": List<dynamic>.from(cards.map((x) => x)),
        "bestCards": List<dynamic>.from(bestCards.map((x) => x)),
        "rank": rank,
        "playedUntil": playedUntil,
        "balance": balance.toJson(),
        "hhCards": List<dynamic>.from(hhCards.map((x) => x)),
        "hhRank": hhRank,
        "received": received,
        "rakePaid": rakePaid,
      };
}

class Balance {
  Balance({
    this.before,
    this.after,
  });

  int before;
  int after;

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        before: json["before"],
        after: json["after"],
      );

  Map<String, dynamic> toJson() => {
        "before": before,
        "after": after,
      };
}

class MyInfo {
  MyInfo({
    this.id,
    this.uuid,
    this.name,
  });

  int id;
  String uuid;
  String name;

  factory MyInfo.fromJson(Map<String, dynamic> json) => MyInfo(
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "name": name,
      };
}

class PlayerElement {
  PlayerElement({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory PlayerElement.fromJson(Map<String, dynamic> json) => PlayerElement(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class StageEnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  StageEnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
