// To parse this JSON data, do
//
//     final clubStatsModel = clubStatsModelFromJson(jsonString);

import 'dart:convert';

ClubStatsModel clubStatsModelFromJson(String str) =>
    ClubStatsModel.fromJson(json.decode(str));

String clubStatsModelToJson(ClubStatsModel data) => json.encode(data.toJson());

class ClubStatsModel {
  ClubStatsModel({
    this.holdem,
    this.plo,
    this.fivecardPlo,
  });

  Map<String, int> holdem;
  Map<String, int> plo;
  Map<String, int> fivecardPlo;

  factory ClubStatsModel.fromJson(Map<String, dynamic> json) {
    final holdem = Map<String, int>();
    for (final key in json["holdem"].keys) {
      if (key == '__typename') {
        continue;
      }
      holdem[key] = json["holdem"][key];
    }

    final plo = Map<String, int>();
    for (final key in json["plo"].keys) {
      if (key == '__typename') {
        continue;
      }
      plo[key] = json["plo"][key];
    }

    final fivecardPlo = Map<String, int>();
    for (final key in json["fivecard_plo"].keys) {
      if (key == '__typename') {
        continue;
      }
      fivecardPlo[key] = json["fivecard_plo"][key];
    }

    return ClubStatsModel(
      holdem: holdem,
      plo: plo,
      fivecardPlo: fivecardPlo,
    );
  }

  Map<String, dynamic> toJson() => {
        "holdem":
            Map.from(holdem).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "plo": Map.from(plo).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "fivecard_plo": Map.from(fivecardPlo)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
