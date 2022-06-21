enum TournamentLevelType { STANDARD, TURBO, SUPER_TURBO }

extension TournamentLevelTypeSerialization on TournamentLevelType {
  String toJson() => this.toString().split(".").last;
  static TournamentLevelType fromJson(String s) =>
      TournamentLevelType.values.firstWhere((type) => type.toJson() == s);
}

class TournamentSettings {
  String name;
  DateTime startTime;
  double startingChips;
  int minPlayers;
  int maxPlayers;
  bool fillWithBots;
  int maxPlayersInTable;
  int botsCount;
  TournamentLevelType levelType;

  TournamentSettings();

  factory TournamentSettings.defaultSettings() {
    var settings = TournamentSettings();
    settings.name = 'Tournament Name';
    settings.startTime = DateTime.now();
    settings.startingChips = 1000.0;
    settings.minPlayers = 2;
    settings.maxPlayers = 6;
    settings.fillWithBots = true;
    settings.maxPlayersInTable = 6;
    settings.botsCount = 0;
    settings.levelType = TournamentLevelType.STANDARD;
    return settings;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "startTime": startTime.toIso8601String(),
      "startingChips": startingChips,
      "minPlayers": minPlayers,
      "maxPlayers": maxPlayers,
      "maxPlayersInTable": maxPlayersInTable,
      "levelType": levelType.toJson(),
      "fillWithBots": fillWithBots,
      "botsCount": botsCount,
    };
  }
}
