// To parse this JSON data, do
//
//     final clubStatsModel = clubStatsModelFromJson(jsonString);

import 'dart:convert';

ClubStatsModel clubStatsModelFromJson(String str) => ClubStatsModel.fromJson(json.decode(str));

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

    factory ClubStatsModel.fromJson(Map<String, dynamic> json) => ClubStatsModel(
        holdem: Map.from(json["holdem"]).map((k, v) => MapEntry<String, int>(k, v)),
        plo: Map.from(json["plo"]).map((k, v) => MapEntry<String, int>(k, v)),
        fivecardPlo: Map.from(json["fivecard_plo"]).map((k, v) => MapEntry<String, int>(k, v)),
    );

    Map<String, dynamic> toJson() => {
        "holdem": Map.from(holdem).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "plo": Map.from(plo).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "fivecard_plo": Map.from(fivecardPlo).map((k, v) => MapEntry<String, dynamic>(k, v)),
    };
}
