import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';

enum TournamentStatus {
  REGISTERING,
  RUNNING,
  CANCELED,
  ENDED,
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
}
