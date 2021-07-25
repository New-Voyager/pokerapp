// To parse this JSON data, do
//
//     final playerUpdateInput = playerUpdateInputFromJson(jsonString);

import 'dart:convert';

PlayerUpdateInput playerUpdateInputFromJson(String str) =>
    PlayerUpdateInput.fromJson(json.decode(str));

String playerUpdateInputToJson(PlayerUpdateInput data) =>
    json.encode(data.toJson());

class PlayerUpdateInput {
  PlayerUpdateInput({
    this.name,
    this.displayName,
    this.email,
  });

  String name;
  String displayName;
  String email;

  factory PlayerUpdateInput.fromJson(Map<String, dynamic> json) =>
      PlayerUpdateInput(
        name: json["name"],
        displayName: json["displayName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "displayName": displayName,
        "email": email,
      };
}
