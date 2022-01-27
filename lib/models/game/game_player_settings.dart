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
    this.autoReload = false,
    this.reloadThreshold = 0,
    this.reloadTo = 0,
  });

  bool autoStraddle;
  bool buttonStraddle;
  bool bombPotEnabled;
  bool muckLosingHand;
  bool runItTwiceEnabled;
  int buttonStraddleBet;
  bool autoReload;
  double reloadThreshold;
  double reloadTo;

  factory GamePlayerSettings.fromJson(Map<String, dynamic> json) {
    final settings = GamePlayerSettings(
        autoStraddle: json["autoStraddle"],
        buttonStraddle: json["buttonStraddle"],
        bombPotEnabled: json["bombPotEnabled"],
        muckLosingHand: json["muckLosingHand"],
        runItTwiceEnabled: json["runItTwiceEnabled"],
        buttonStraddleBet: json["buttonStraddleBet"] ?? 2,
        autoReload: json["autoReload"] ?? false);

    settings.reloadThreshold = 0.0;
    settings.reloadTo = 0.0;
    if (json["reloadThreshold"] != null) {
      settings.reloadThreshold =
          double.parse(json["reloadThreshold"].toString());
    }
    if (json["reloadTo"] != null) {
      settings.reloadTo = double.parse(json["reloadTo"].toString());
    }
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
