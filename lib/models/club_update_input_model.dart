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
    this.picUrl,
    this.trackMemberCredit,
  });

  String name;
  String description;
  bool showHighRankStats;
  bool trackMemberCredit;
  String picUrl;

  factory ClubUpdateInput.fromJson(Map<String, dynamic> json) =>
      ClubUpdateInput(
        name: json["name"],
        description: json["description"],
        showHighRankStats: json["showHighRankStats"],
        trackMemberCredit: json["trackMemberCredit"],
        picUrl: json["picUrl"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {};
    if (name != null) {
      ret['name'] = name;
    }
    if (description != null) {
      ret['description'] = description;
    }
    if (showHighRankStats != null) {
      ret['showHighRankStats'] = showHighRankStats;
    }
    if (picUrl != null) {
      ret['picUrl'] = picUrl;
    }
    if (trackMemberCredit != null) {
      ret['trackMemberCredit'] = trackMemberCredit;
    }
    return ret;
  }
}
