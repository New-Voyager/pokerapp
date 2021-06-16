import 'dart:convert';

class GameSettings {
  String gameCode;
  bool muckLosingHand = false;
  bool gameSound = true;
  bool audioConf = true;
  bool straddleOption = true;
  bool autoStraddle = false;
  GameSettings(
      this.gameCode, this.muckLosingHand, this.gameSound, this.audioConf);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() => {
        'gameCode': this.gameCode,
        'muckLosingHand': this.muckLosingHand,
        'gameSound': this.gameSound,
        'audioConf': this.audioConf,
        'straddleOption': this.straddleOption,
        'autoStraddle': this.autoStraddle,
      };

  GameSettings.fromJson(Map<String, dynamic> json)
      : this.gameCode = json['gameCode'],
        this.muckLosingHand = json['muckLosingHand'],
        this.gameSound = json['gameSound'],
        this.audioConf = json['audioConf'],
        this.autoStraddle = json['autoStraddle'],
        this.straddleOption = json['straddleOption'];
}
