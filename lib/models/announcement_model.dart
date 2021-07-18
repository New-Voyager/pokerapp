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
  });

  String text;
  DateTime createdAt;
  DateTime expiresAt;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        text: json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
        expiresAt: DateTime.parse(json["expiresAt"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "createdAt": createdAt.toIso8601String(),
        "expiresAt": expiresAt.toIso8601String(),
      };
}
