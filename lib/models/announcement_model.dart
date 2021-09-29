// To parse this JSON data, do
//
//     final announcementModel = announcementModelFromJson(jsonString);

import 'dart:convert';

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
  });

  String text;
  DateTime createdAt;
  DateTime expiresAt;
  String level;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        text: json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
        expiresAt: DateTime.parse(json["expiresAt"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "createdAt": createdAt.toIso8601String(),
        "expiresAt": expiresAt.toIso8601String(),
        "level": level,
      };
}
