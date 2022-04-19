import 'dart:convert';

/*
  newGames: Boolean
  clubChat: Boolean
  creditUpdates: Boolean
  hostMessages: Boolean
  clubAnnouncements: Boolean
  */
class ClubNotifications {
  ClubNotifications({
    this.clubChat,
    this.creditUpdates,
    this.clubAnnouncements,
    this.newGames,
  });

  bool clubChat;
  bool creditUpdates;
  bool clubAnnouncements;
  bool newGames;

  factory ClubNotifications.defaultObject() {
    return ClubNotifications(
      clubChat: true,
      creditUpdates: true,
      clubAnnouncements: true,
      newGames: true,
    );
  }

  factory ClubNotifications.fromJson(Map<String, dynamic> json) =>
      ClubNotifications(
        clubChat: json["clubChat"],
        creditUpdates: json["creditUpdates"],
        clubAnnouncements: json["clubAnnouncements"],
        newGames: json["newGames"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {};
    if (clubChat != null) {
      ret['clubChat'] = clubChat;
    }
    if (creditUpdates != null) {
      ret['creditUpdates'] = creditUpdates;
    }
    if (clubAnnouncements != null) {
      ret['clubAnnouncements'] = clubAnnouncements;
    }
    if (newGames != null) {
      ret['newGames'] = newGames;
    }
    return ret;
  }
}
