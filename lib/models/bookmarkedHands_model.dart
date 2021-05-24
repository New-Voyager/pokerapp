import 'dart:convert';
import 'dart:developer';

import 'package:pokerapp/models/hand_log_model_new.dart';

BookmarkedHandModel bookmarkedHandModelFromJson(String str) =>
    BookmarkedHandModel.fromJson(json.decode(str));

String bookmarkedHandModelToJson(BookmarkedHandModel data) =>
    json.encode(data.toJson());

class BookmarkedHandModel {
  BookmarkedHandModel({
    this.bookmarkedHands,
  });

  List<BookmarkedHand> bookmarkedHands;

  factory BookmarkedHandModel.fromJson(Map<String, dynamic> json) {
    //log("BOOK : ${json['bookmarkedHandsByGame'].map((x) => BookmarkedHand.fromJson(x))}");
    // TODO: it would be better to have same key for both bookmarkedHands and bookmarkedHandsByGame
    return BookmarkedHandModel(
      bookmarkedHands: json['bookmarkedHands'] == null
          ? List<BookmarkedHand>.from(json["bookmarkedHandsByGame"]
              .map((x) => BookmarkedHand.fromJson(x)))
          : List<BookmarkedHand>.from(
              json["bookmarkedHands"].map((x) => BookmarkedHand.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "bookmarkedHands":
            List<dynamic>.from(bookmarkedHands.map((x) => x.toJson())),
      };
}

class BookmarkedHand {
  BookmarkedHand({
    this.id,
    this.sharedBy,
    this.savedBy,
    this.sharedTo,
    this.gameCode,
    this.handNum,
    this.updatedAt,
    this.handlogData,
  });

  int id;
  PlayerInBookmarkModel sharedBy;
  PlayerInBookmarkModel savedBy;
  SharedToClubModel sharedTo;
  String gameCode;
  int handNum;
  DateTime updatedAt;
  HandLogModelNew handlogData;

  factory BookmarkedHand.fromJson(Map<String, dynamic> json) {
    return BookmarkedHand(
      id: json["id"],
      sharedBy: json["sharedBy"] == null
          ? null
          : PlayerInBookmarkModel.fromJson(json["sharedBy"]),
      savedBy: json["savedBy"] == null
          ? null
          : PlayerInBookmarkModel.fromJson(json["savedBy"]),
      sharedTo: json["sharedTo"] == null
          ? null
          : SharedToClubModel.fromJson(json["sharedTo"]),
      gameCode: json["gameCode"],
      handNum: json["handNum"],
      handlogData: HandLogModelNew.fromJson(json["data"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sharedBy": sharedBy == null ? null : sharedBy.toJson(),
        "savedBy": savedBy.toJson(),
        "sharedTo": sharedTo == null ? null : sharedTo.toJson(),
        "gameCode": gameCode,
        "handNum": handNum,
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class PlayerInBookmarkModel {
  PlayerInBookmarkModel({
    this.name,
    this.uuid,
    this.playerId,
    this.email,
    this.lastActiveTime,
  });

  String name;
  String uuid;
  String playerId;
  String email;
  DateTime lastActiveTime;

  factory PlayerInBookmarkModel.fromJson(Map<String, dynamic> json) {
    return PlayerInBookmarkModel(
      name: json["name"] ?? "Player",
      uuid: json["uuid"] == null ? null : json["uuid"],
      playerId: json["playerId"] == null ? null : json["playerId"],
      email: json["email"] == null ? null : json["email"],
      lastActiveTime: json["lastActiveTime"] == null
          ? null
          : DateTime.parse(json["lastActiveTime"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid": uuid == null ? null : uuid,
        "playerId": playerId == null ? null : playerId,
        "email": email == null ? null : email,
        "lastActiveTime":
            lastActiveTime == null ? null : lastActiveTime.toIso8601String(),
      };
}

class SharedToClubModel {
  SharedToClubModel({
    this.name,
    this.clubCode,
  });

  String name;
  String clubCode;

  factory SharedToClubModel.fromJson(Map<String, dynamic> json) =>
      SharedToClubModel(
        name: json["name"],
        clubCode: json["clubCode"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "clubCode": clubCode,
      };
}
