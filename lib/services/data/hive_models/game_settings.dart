import 'dart:convert';

class GameSettings {
  bool muckLosingHand = false;
  bool gameSound = true;
  bool audioConf = true;

  GameSettings(this.muckLosingHand, this.gameSound, this.audioConf);

  @override
  String toString() {
    return "muckLosingHand = ${this.muckLosingHand},"
        " gameSound = ${this.gameSound}, audioConf = ${this.audioConf}";
  }

  Map<String, dynamic> toJson() => {
        'muckLosingHand': this.muckLosingHand,
        'gameSound': this.gameSound,
        'audioConf': this.audioConf
      };

  GameSettings.fromJson(Map<String, dynamic> json) :
    this.muckLosingHand = json['muckLosingHand'],
    this.gameSound = json['gameSound'],
    this.audioConf = json['audioConf'];

}
