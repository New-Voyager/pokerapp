// To parse this JSON data, do
//
//     final gamePlayerSettingsInput = gamePlayerSettingsInputFromJson(jsonString);

import 'dart:convert';

GamePlayerSettings gamePlayerSettingsInputFromJson(String str) =>
    GamePlayerSettings.fromJson(json.decode(str));

String gamePlayerSettingsInputToJson(GamePlayerSettings data) =>
    json.encode(data.toJson());

class GamePlayerSettings {
  GamePlayerSettings({
    this.autoStraddle,
    this.buttonStraddle,
    this.buttonStraddleBet,
    this.bombPotEnabled,
    this.muckLosingHand = true,
    this.runItTwiceEnabled,
  });

  bool autoStraddle;
  bool buttonStraddle;
  bool bombPotEnabled;
  bool muckLosingHand;
  bool runItTwiceEnabled;
  int buttonStraddleBet;

  factory GamePlayerSettings.fromJson(Map<String, dynamic> json) {
    final settings = GamePlayerSettings(
      autoStraddle: json["autoStraddle"],
      buttonStraddle: json["buttonStraddle"],
      bombPotEnabled: json["bombPotEnabled"],
      muckLosingHand: json["muckLosingHand"],
      runItTwiceEnabled: json["runItTwiceEnabled"],
      buttonStraddleBet: json["buttonStraddleBet"] ?? 2,
    );
    if (settings.buttonStraddleBet == null) {
      settings.buttonStraddleBet = 2;
    }
    return settings;
  }

  Map<String, dynamic> toJson() => {
        "autoStraddle": autoStraddle,
        "buttonStraddle": buttonStraddle,
        "bombPotEnabled": bombPotEnabled,
        "muckLosingHand": muckLosingHand,
        "runItTwiceEnabled": runItTwiceEnabled,
        "buttonStraddleBet": buttonStraddleBet,
      };
}
