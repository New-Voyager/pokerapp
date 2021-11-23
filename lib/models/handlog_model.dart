import 'dart:convert';

import 'package:pokerapp/enums/game_stages.dart';
import 'package:pokerapp/enums/hand_actions.dart';

class BoardPlayerRank {
  int boardNo;
  int seatNo;
  int hiRank;
  List<int> hiCards;
  bool lowFound;
  int loRank;
  List<int> loCards;

  BoardPlayerRank();
  factory BoardPlayerRank.fromJson(dynamic json) {
    BoardPlayerRank ret = BoardPlayerRank();
    ret.boardNo = json['boardNo'];
    ret.seatNo = json['seatNo'];
    ret.hiRank = json['hiRank'];
    ret.hiCards = json['hiCards'].cast<int>();
    ret.lowFound = json['lowFound'] ?? false;
    ret.loCards = json['loCards'].cast<int>();
    if (ret.loCards == null) {
      ret.loCards = [];
    }
    return ret;
  }
}

class ResultBoard {
  int boardNo;
  List<int> cards;
  Map<int, BoardPlayerRank> playerBoardRank;
  ResultBoard();
  factory ResultBoard.fromJson(dynamic json) {
    ResultBoard resultBoard = ResultBoard();
    resultBoard.boardNo = json['boardNo'];
    resultBoard.cards = json['cards'].cast<int>();
    resultBoard.playerBoardRank = Map<int, BoardPlayerRank>();
    if (json['playerRank'] != null) {
      for (String seatNoStr in json['playerRank'].keys) {
        final seatNo = int.parse(seatNoStr);
        final rank = json['playerRank'][seatNoStr];
        resultBoard.playerBoardRank[seatNo] = BoardPlayerRank.fromJson(rank);
      }
    }
    return resultBoard;
  }
}

class ResultWinner {
  int seatNo;
  double amount;

  ResultWinner();
  factory ResultWinner.fromJson(dynamic json) {
    ResultWinner winner = ResultWinner();
    winner.seatNo = json['seatNo'];
    winner.amount = double.parse(json['seatNo'].toString());
    return winner;
  }
}

class PlayerBalance {
  double before = 0;
  double after = 0;

  PlayerBalance();
  factory PlayerBalance.fromJson(dynamic json) {
    PlayerBalance ret = PlayerBalance();
    if (json['before'] != null) {
      ret.before = double.parse(json['before'].toString());
    }
    if (json['after'] != null) {
      ret.after = double.parse(json['after'].toString());
    }
    return ret;
  }
}

class ResultPlayerInfo {
  int id;
  List<int> cards;
  String playedUntil;
  PlayerBalance balance;
  double received;
  String name;

  ResultPlayerInfo();

  factory ResultPlayerInfo.fromJson(dynamic json) {
    ResultPlayerInfo ret = ResultPlayerInfo();
    ret.id = int.parse(json['id'].toString());
    ret.cards = json['cards'].cast<int>();
    ret.playedUntil = json['playedUntil'];
    ret.received = 0;
    if (json['received'] == null) {
      ret.received = double.parse(json['received'].toString());
    }
    ret.name = json['name'];
    ret.balance = PlayerBalance.fromJson(json['balance']);
    return ret;
  }
}

class ResultBoardWinner {
  int boardNo;
  double amount;
  Map<int, ResultWinner> hiWinners;
  Map<int, ResultWinner> lowWinners;
  String hiRankText;
  ResultBoardWinner();

  factory ResultBoardWinner.fromJson(dynamic json) {
    ResultBoardWinner ret = ResultBoardWinner();
    ret.boardNo = json['boardNo'];
    ret.amount = double.parse(json['amount'].toString());
    ret.hiRankText = '';
    if (json['hiRankText'] != null) {
      ret.hiRankText = json['hiRankText'];
    }
    ret.lowWinners = Map<int, ResultWinner>();
    ret.hiWinners = Map<int, ResultWinner>();
    if (json['hiWinners'] != null) {
      for (final seatNoStr in json['hiWinners'].keys) {
        final winnerJson = json['hiWinners'][seatNoStr];
        final seatNo = int.parse(seatNoStr);
        ret.hiWinners[seatNo] = ResultWinner.fromJson(winnerJson);
      }
    }
    if (json['lowWinners'] != null) {
      for (final seatNoStr in json['lowWinners'].keys) {
        final winnerJson = json['lowWinners'][seatNoStr];
        final seatNo = int.parse(seatNoStr);
        ret.lowWinners[seatNo] = ResultWinner.fromJson(winnerJson);
      }
    }

    return ret;
  }
}

class ResultPotWinner {
  int potNo;
  double amount;
  List<int> seatsInPots;
  List<ResultBoardWinner> boardWinners;

  ResultPotWinner();

  factory ResultPotWinner.fromJson(dynamic json) {
    ResultPotWinner resultPotWinner = ResultPotWinner();
    resultPotWinner.potNo = json['potNo'];
    resultPotWinner.amount = double.parse(json['amount'].toString());
    resultPotWinner.seatsInPots = json['seatsInPots'].cast<int>();
    resultPotWinner.boardWinners = [];
    if (json['boardWinners'] != null) {
      for (final boardWinner in json['boardWinners']) {
        resultPotWinner.boardWinners
            .add(ResultBoardWinner.fromJson(boardWinner));
      }
    }
    return resultPotWinner;
  }
}

class HandResultNew {
  bool runItTwice;
  List<int> activeSeats;
  String wonAt;
  List<ResultBoard> boards;
  List<ResultPotWinner> potWinners;
  Map<int, ResultPlayerInfo> playerInfo;
  int pauseTimeInMs;

  HandResultNew();

  factory HandResultNew.fromJson(dynamic json) {
    HandResultNew ret = HandResultNew();
    ret.runItTwice = json['runItTwice'];
    ret.pauseTimeInMs = json['pauseTimeSecs'] as int;
    ret.activeSeats = json['activeSeats'].cast<int>();
    ret.wonAt = json['wonAt'].toString();
    ret.boards = [];
    if (json['boards'] != null) {
      for (final board in json['boards']) {
        ret.boards.add(ResultBoard.fromJson(board));
      }
    }

    if (json['potWinners'] != null) {
      ret.potWinners = [];
      for (final potWinner in json['potWinners']) {
        ret.potWinners.add(ResultPotWinner.fromJson(potWinner));
      }
    }

    ret.playerInfo = Map<int, ResultPlayerInfo>();
    if (json['playerInfo'] != null) {
      for (final seatNoStr in json['playerInfo'].keys) {
        final player = json['playerInfo'][seatNoStr];
        final seatNo = int.parse(seatNoStr);
        ret.playerInfo[seatNo] = ResultPlayerInfo.fromJson(player);
      }
    }
    return ret;
  }
}

class HandResultData {
  String gameId;
  String gameCode;
  int handNum;
  String gameType;
  int actionTime;
  int noCards;
  int maxPlayers;
  double smallBlind;
  double bigBlind;
  bool runItTwice;
  HandResultNew result;
  int myPlayerId = 0;

  GameActions preflopActions;
  GameActions flopActions;
  GameActions turnActions;
  GameActions riverActions;

  HandResultData();

  GameStages wonAt() {
    return getGameStage(result.wonAt);
  }

  List<int> getMyCards() {
    if (myPlayerId == 0) {
      return [];
    }
    for (final seatNo in result.playerInfo.keys) {
      final playerInfo = result.playerInfo[seatNo];
      if (playerInfo.id == myPlayerId) {
        return playerInfo.cards;
      }
    }
    return [];
  }

  ResultPlayerInfo getPlayerBySeatNo(int seatNo) {
    if (!result.playerInfo.containsKey(seatNo)) {
      return null;
    }
    return result.playerInfo[seatNo];
  }

  List<int> getBoardCards() {
    if (result.boards.length == 0) {
      return [];
    }
    return result.boards[0].cards;
  }

  ResultBoard getBoard(int boardNo) {
    for (final board in result.boards) {
      if (board.boardNo == boardNo) {
        return board;
      }
    }
    return null;
  }

  List<int> getBoard1() {
    return result.boards[0].cards;
  }

  List<int> getBoard2() {
    if (result.boards.length >= 2) {
      return result.boards[1].cards;
    }
    return [];
  }

  BoardPlayerRank getPlayerRank(int boardNo, int seatNo) {
    for (final board in result.boards) {
      if (board.boardNo == boardNo) {
        final rank = board.playerBoardRank[seatNo];
        return rank;
      }
    }
    return null;
  }

  List<int> getBoard1ShownCards() {
    List<int> cards = result.boards[0].cards;
    final wonat = this.wonAt();
    if (wonat == GameStages.PREFLOP) {
      return cards;
    } else if (wonat == GameStages.FLOP) {
      return cards.sublist(0, 3);
    } else if (wonat == GameStages.TURN) {
      return cards.sublist(0, 4);
    } else if (wonat == GameStages.RIVER) {
      return cards.sublist(0, 5);
    } else if (wonat == GameStages.SHOWDOWN) {
      return cards.sublist(0, 5);
    }
    return [];
  }

  List<int> getBoard2ShownCards() {
    if (result.boards.length == 1) {
      return null;
    }
    List<int> cards = result.boards[1].cards;
    final wonat = this.wonAt();
    if (wonat == GameStages.PREFLOP) {
      return cards;
    } else if (wonat == GameStages.FLOP) {
      return cards.sublist(0, 3);
    } else if (wonat == GameStages.TURN) {
      return cards.sublist(0, 4);
    } else if (wonat == GameStages.RIVER) {
      return cards.sublist(0, 5);
    } else if (wonat == GameStages.SHOWDOWN) {
      return cards.sublist(0, 5);
    }
    return [];
  }

  int numOfBoards() {
    return result.boards.length;
  }

  factory HandResultData.fromJson(dynamic json) {
    HandResultData ret = HandResultData();
    if (json is String) {
      json = jsonDecode(json);
    }
    ret.gameId = json["gameId"].toString();
    ret.gameCode = json["gameCode"];
    ret.handNum = json["handNum"];
    ret.gameType = json["gameType"];
    ret.noCards = json['noCards'];
    ret.maxPlayers = json['maxPlayers'] ?? 9;
    ret.smallBlind = double.parse((json['smallBlind'] ?? 1).toString());
    ret.bigBlind = double.parse((json['bigBlind'] ?? 2).toString());

    final handLog = json["handLog"];
    ret.preflopActions = GameActions.fromJson(handLog["preflopActions"]);
    ret.flopActions = GameActions.fromJson(handLog["flopActions"]);
    ret.turnActions = GameActions.fromJson(handLog["turnActions"]);
    ret.riverActions = GameActions.fromJson(handLog["riverActions"]);

    ret.result = HandResultNew.fromJson(json['result']);
    ret.runItTwice = ret.result.runItTwice;

    return ret;
  }

  ResultPlayerInfo getPlayerBySeat(int seatNo) {
    return this.result.playerInfo[seatNo];
  }
}

class GameActions {
  GameActions({
    this.pots,
    this.potStart,
    this.actions,
    this.seatPots,
  });

  List<double> pots;
  List<ActionElement> actions;
  double potStart;
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
      pots: json["pots"]
          ?.map<double>((e) => double.parse(e.toString()))
          ?.toList(),
      potStart: double.parse(json["potStart"].toString()),
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
  double amount;
  bool timedOut;
  int actionTime;
  double stack;

  factory ActionElement.fromJson(Map<String, dynamic> json) {
    final action = json['action'];
    final actionValue = actionEnumValues.map[action];
    return ActionElement(
      seatNo: json["seatNo"],
      action: actionValue,
      amount: double.parse(json["amount"].toString()),
      timedOut: json["timedOut"],
      actionTime: json["actionTime"],
      stack: double.parse(json["stack"].toString()),
    );
  }

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
  "ALLIN": HandActions.ALLIN,
  "BOMB_POT_BET": HandActions.BOMB_POT_BET,
});

final stagesEnumValues = StageEnumValues({
  "PRE_FLOP": GameStages.PREFLOP,
  "FLOP": GameStages.FLOP,
  "RIVER": GameStages.RIVER,
  "TURN": GameStages.TURN,
  "SHOW_DOWN": GameStages.SHOWDOWN
});

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
