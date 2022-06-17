enum GameStatus {
  UNKNOWN,
  CONFIGURED,
  WAITING,
  NOTENOUGH_PLAYERS,
  RUNNING,
  ENDED,
}


extension GameStatusSerialization on GameStatus {
  String toJson() => this.toString().split(".").last;
  static GameStatus fromJson(String s) =>
      GameStatus.values.firstWhere((type) => type.toJson() == s);
}
