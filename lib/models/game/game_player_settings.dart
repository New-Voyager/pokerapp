// To parse this JSON data, do
//
//     final gamePlayerSettingsInput = gamePlayerSettingsInputFromJson(jsonString);

import 'dart:convert';

GamePlayerSettingsInput gamePlayerSettingsInputFromJson(String str) => GamePlayerSettingsInput.fromJson(json.decode(str));

String gamePlayerSettingsInputToJson(GamePlayerSettingsInput data) => json.encode(data.toJson());

class GamePlayerSettingsInput {
    GamePlayerSettingsInput({
        this.autoStraddle,
        this.straddle,
        this.buttonStraddle,
        this.bombPotEnabled,
        this.muckLosingHand,
        this.runItTwiceEnabled,
    });

    bool autoStraddle;
    bool straddle;
    bool buttonStraddle;
    bool bombPotEnabled;
    bool muckLosingHand;
    bool runItTwiceEnabled;

    factory GamePlayerSettingsInput.fromJson(Map<String, dynamic> json) => GamePlayerSettingsInput(
        autoStraddle: json["autoStraddle"],
        straddle: json["straddle"],
        buttonStraddle: json["buttonStraddle"],
        bombPotEnabled: json["bombPotEnabled"],
        muckLosingHand: json["muckLosingHand"],
        runItTwiceEnabled: json["runItTwiceEnabled"],
    );

    Map<String, dynamic> toJson() => {
        "autoStraddle": autoStraddle,
        "straddle": straddle,
        "buttonStraddle": buttonStraddle,
        "bombPotEnabled": bombPotEnabled,
        "muckLosingHand": muckLosingHand,
        "runItTwiceEnabled": runItTwiceEnabled,
    };
}
