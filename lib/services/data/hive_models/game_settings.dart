class GameSettings {
  String gameCode;
  bool muckLosingHand = false;
  bool gameSound = true;
  bool audioConf = true;

  GameSettings(
      this.gameCode, this.muckLosingHand, this.gameSound, this.audioConf);

  @override
  String toString() {
    return "gameCode = ${this.gameCode}, muckLosingHand = ${this.muckLosingHand},"
        " gameSound = ${this.gameSound}, audioConf = ${this.audioConf}";
  }

  Map<String, dynamic> toJson() => {
        'gameCode': this.gameCode,
        'muckLosingHand': this.muckLosingHand,
        'gameSound': this.gameSound,
        'audioConf': this.audioConf
      };

  GameSettings.fromJson(Map<String, dynamic> json)
      : this.gameCode = json['gameCode'],
        this.muckLosingHand = json['muckLosingHand'],
        this.gameSound = json['gameSound'],
        this.audioConf = json['audioConf'];
}
