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

class Tournament {
  String name;
  GameType gameType;
  int maxPlayers;
  int registeredPlayers;
  bool testWithBots;
  TournamentStatus status;
  Tournament({
    @required this.name,
    @required this.gameType,
    @required this.maxPlayers,
    this.registeredPlayers = 0,
    @required this.testWithBots,
    @required this.status,
  });

  Tournament.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gameType = GameType.HOLDEM; //GameType.values[json['gameType']];
    maxPlayers = json['maxPlayers'];
    registeredPlayers = json['registeredPlayers'];
    testWithBots = json['testWithBots'];
    status = TournamentStatusSerialization.fromJson(json['status']);
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
  PlayerStatus status;

  TournamentPlayer({
    @required this.playerId,
    @required this.playerUuid,
    @required this.playerName,
    @required this.stack,
    @required this.seatNo,
    @required this.status,
  });

  factory TournamentPlayer.fromJson(Map<String, dynamic> json) {
    return TournamentPlayer(
      playerId: json['playerId'],
      playerUuid: json['playerUuid'],
      playerName: json['playerName'],
      stack: double.parse(json['stack'].toString()),
      seatNo: json['seatNo'],
      status: PlayerStatusSerialization.fromJson(json['status']),
    );
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
