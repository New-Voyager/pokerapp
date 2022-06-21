import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/tournament/tournament_settings.dart';

enum TournamentStatus {
  UNKNOWN,
  SCHEDULED,
  ABOUT_TO_START,
  RUNNING,
  ENDED,
  CANCELLED,
}

extension TournamentStatusSerialization on TournamentStatus {
  String toJson() => this.toString().split(".").last;
  static TournamentStatus fromJson(String s) =>
      TournamentStatus.values.firstWhere((type) => type.toJson() == s);
}

enum TournamentPlayingStatus {
  REGISTERED,
  JOINED,
  PLAYING,
  BUSTED_OUT,
  SITTING_OUT,
}

extension TournamentPlayingStatusSerialization on TournamentPlayingStatus {
  String toJson() => this.toString().split(".").last;
  static TournamentPlayingStatus fromJson(String s) =>
      TournamentPlayingStatus.values.firstWhere((type) => type.toJson() == s);
}

class Tournament {
  String name;
  GameType gameType;
  int minPlayers;
  int maxPlayers;
  int maxPlayersInTable;
  List<TournamentPlayer> registeredPlayers;
  List<TournamentPlayer> tournamentPlayers;
  List<TournamentTable> tables;
  TournamentStatus status;
  Tournament({
    this.name,
    this.gameType,
    this.maxPlayers,
    this.registeredPlayers,
    this.status,
    this.tournamentPlayers,
    this.tables,
    this.minPlayers,
    this.maxPlayersInTable,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    Tournament ret = Tournament();
    ret.name = json['name'];
    ret.gameType = GameType.HOLDEM; //GameType.values[json['gameType']];
    ret.maxPlayers = json['maxPlayers'];
    ret.minPlayers = json['minPlayers'];
    ret.maxPlayersInTable = json['maxPlayersInTable'];
    ret.registeredPlayers = (json['registeredPlayers'] as List)
        .map((player) => TournamentPlayer.fromJson(player))
        .toList();
    ret.tables = (json['tables'] as List)
        .map((table) => TournamentTable.fromJson(table))
        .toList();

    ret.status = TournamentStatusSerialization.fromJson(json['status']);
    return ret;
  }
}

/*

type TournamentListItem {
  name: String!
  startTime: DateTime
  startingChips: Float
  minPlayers: Int
  maxPlayers: Int
  maxPlayersInTable: Int
  levelType: TournamentLevelType
  fillWithBots: Boolean
}*/
class TournamentListItem {
  int tournamentId;
  String name;
  DateTime startTime;
  double startingChips;
  int minPlayers;
  int maxPlayers;
  int maxPlayersInTable;
  TournamentLevelType levelType;
  bool fillWithBots;
  TournamentStatus status;
  int registeredPlayersCount;
  int botsCount;
  int activePlayersCount;
  String createdBy;

  TournamentListItem({
    @required this.tournamentId,
    @required this.name,
    @required this.startTime,
    @required this.startingChips,
    @required this.minPlayers,
    @required this.maxPlayers,
    @required this.maxPlayersInTable,
    @required this.levelType,
    @required this.fillWithBots,
    @required this.status,
    @required this.registeredPlayersCount,
    @required this.botsCount,
    @required this.activePlayersCount,
    @required this.createdBy,
  });

  factory TournamentListItem.fromJson(Map<String, dynamic> json) {
    var levelType = TournamentLevelType.STANDARD;
    if (json['levelType'] != null) {
      levelType = TournamentLevelTypeSerialization.fromJson(json['levelType']);
    }
    return TournamentListItem(
      tournamentId: json['tournamentId'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      startingChips: double.parse(json['startingChips'].toString()),
      minPlayers: json['minPlayers'],
      maxPlayers: json['maxPlayers'],
      maxPlayersInTable: json['maxPlayersInTable'],
      levelType: levelType,
      fillWithBots: json['fillWithBots'],
      status: TournamentStatusSerialization.fromJson(json['status']),
      registeredPlayersCount: json['registeredPlayersCount'],
      botsCount: json['botsCount'],
      activePlayersCount: json['activePlayersCount'],
      createdBy: json['createdBy'],
    );
  }
}

/*
query ti($tournamentId:Int!, $tableNo:Int!) {
          ti: getTournamentTableInfo(tournamentId: $tournamentId, tableNo:$tableNo) {
            

          }
        }*/
class TournamentPlayer {
  int playerId;
  String playerUuid;
  String playerName;
  double stack;
  int seatNo;
  int tableNo;
  TournamentPlayingStatus status;

  TournamentPlayer({
    this.playerId,
    this.playerUuid,
    this.playerName,
    this.stack,
    this.seatNo,
    this.status,
    this.tableNo,
  });

  factory TournamentPlayer.fromJson(Map<String, dynamic> json) {
    final ret = TournamentPlayer(
      playerId: json['playerId'],
      playerUuid: json['playerUuid'],
      playerName: json['playerName'],
    );
    if (json['status'] != null) {
      ret.status =
          TournamentPlayingStatusSerialization.fromJson(json['status']);
    }
    if (json['stack'] != null) {
      ret.stack = double.parse(json['stack'].toString());
    }
    if (json['seatNo'] != null) {
      ret.seatNo = json['seatNo'];
    }
    if (json['tableNo'] != null) {
      ret.tableNo = json['tableNo'];
    }
    return ret;
  }
}

class TournamentGameInfo {
  int gameID;
  int actionTime;
  int maxPlayersInTable;
  String title;
  ChipUnit chipUnit;
  double smallBlind;
  double bigBlind;
  double ante;
  GameStatus status;
  String tableStatus;
  int level;
  GameType gameType;
  int nextLevel;
  String gameCode;
  int nextLevelTimeInSecs;
  String gameChatChannel;
  String gameToPlayerChannel;
  String playerToHandChannel;
  String handToPlayerChannel;
  String handToAllChannel;
  String clientAliveChannel;
  String handToPlayerTextChannel;
  String tournamentChannel;
  bool playing;
  List<TournamentPlayer> players;

  TournamentGameInfo({
    @required this.gameID,
    @required this.actionTime,
    @required this.maxPlayersInTable,
    @required this.title,
    @required this.chipUnit,
    @required this.smallBlind,
    @required this.bigBlind,
    @required this.ante,
    @required this.status,
    @required this.tableStatus,
    @required this.level,
    @required this.gameType,
    @required this.nextLevel,
    @required this.gameCode,
    @required this.nextLevelTimeInSecs,
    @required this.gameChatChannel,
    @required this.gameToPlayerChannel,
    @required this.playerToHandChannel,
    @required this.handToPlayerChannel,
    @required this.handToAllChannel,
    @required this.clientAliveChannel,
    @required this.handToPlayerTextChannel,
    @required this.tournamentChannel,
    @required this.playing,
    @required this.players,
  });

  factory TournamentGameInfo.fromJson(Map<String, dynamic> json) {
    return TournamentGameInfo(
      gameID: json['gameID'],
      actionTime: json['actionTime'],
      maxPlayersInTable: json['maxPlayersInTable'],
      title: json['title'],
      chipUnit: ChipUnitSerialization.fromJson(json['chipUnit']),
      smallBlind: double.parse(json['smallBlind'].toString()),
      bigBlind: double.parse(json['bigBlind'].toString()),
      ante: double.parse(json['ante'].toString()),
      status: GameStatusSerialization.fromJson(json['status']),
      tableStatus: json['tableStatus'],
      level: json['level'],
      gameType: GameType.values[json['gameType']],
      nextLevel: json['nextLevel'],
      gameCode: json['gameCode'],
      nextLevelTimeInSecs: json['nextLevelTimeInSecs'],
      gameChatChannel: json['gameChatChannel'],
      gameToPlayerChannel: json['gameToPlayerChannel'],
      playerToHandChannel: json['playerToHandChannel'],
      handToPlayerChannel: json['handToPlayerChannel'],
      handToAllChannel: json['handToAllChannel'],
      clientAliveChannel: json['clientAliveChannel'],
      handToPlayerTextChannel: json['handToPlayerTextChannel'],
      tournamentChannel: json['tournamentChannel'],
      playing: json['playing'],
      players: (json['players'] as List)
          .map((e) => TournamentPlayer.fromJson(e))
          .toList(),
    );
  }
}

class TournamentTable {
  int tableNo;
  List<TournamentPlayer> players;
  TournamentTable({this.tableNo, this.players});

  factory TournamentTable.fromJson(dynamic json) {
    TournamentTable table = TournamentTable();
    table.tableNo = json['no'];
    table.players = (json['players'] as List)
        .map((e) => TournamentPlayer.fromJson(e))
        .toList();
    return table;
  }
}
