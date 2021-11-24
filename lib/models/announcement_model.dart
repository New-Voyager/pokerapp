// To parse this JSON data, do
//
//     final announcementModel = announcementModelFromJson(jsonString);

import 'dart:convert';

import 'dart:developer';

import 'package:intl/intl.dart';

AnnouncementModel announcementModelFromJson(String str) =>
    AnnouncementModel.fromJson(json.decode(str));

String announcementModelToJson(AnnouncementModel data) =>
    json.encode(data.toJson());

class AnnouncementModel {
  AnnouncementModel({
    this.text,
    this.createdAt,
    this.expiresAt,
    this.level,
    this.playerName,
  });

  String text;
  DateTime createdAt;
  DateTime expiresAt;
  String level;
  String playerName = 'admin';

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    log("$json");
    return AnnouncementModel(
      text: json["text"],
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      expiresAt: DateTime.parse(json["expiresAt"]).toLocal(),
      level: json["level"],
      playerName: json['playerName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "createdAt": createdAt.toIso8601String(),
        "expiresAt": expiresAt.toIso8601String(),
        "level": level,
        "playerName": playerName,
      };

  bool get isImportant {
    return level == 'IMPORTANT';
  }
}
