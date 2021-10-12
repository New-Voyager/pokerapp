import 'dart:convert';

ClubUpdateInput playerUpdateInputFromJson(String str) =>
    ClubUpdateInput.fromJson(json.decode(str));

String playerUpdateInputToJson(ClubUpdateInput data) =>
    json.encode(data.toJson());

class ClubUpdateInput {
  ClubUpdateInput({
    this.name,
    this.description,
    this.showHighRankStats,
  });

  String name;
  String description;
  bool showHighRankStats;

  factory ClubUpdateInput.fromJson(Map<String, dynamic> json) =>
      ClubUpdateInput(
        name: json["name"],
        description: json["description"],
        showHighRankStats: json["showHighRankStats"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "showHighRankStats": showHighRankStats,
      };
}
