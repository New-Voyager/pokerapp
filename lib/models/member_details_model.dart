class MemberDetailsModel {
  String name;
  DateTime lastPlayedDate;
  String contactInfo;
  String balance;
  String autoApprovalLimit;
  String gamesPlayed;
  String totalBuyIn;
  String totalWinnings;
  String rakePaid;
  bool isClubManager;
  String notes;

  MemberDetailsModel(
      this.name,
      this.lastPlayedDate,
      this.contactInfo,
      this.balance,
      this.autoApprovalLimit,
      this.gamesPlayed,
      this.totalBuyIn,
      this.totalWinnings,
      this.rakePaid,
      this.isClubManager,
      this.notes);

  MemberDetailsModel.fromjson(jsonData) {
    this.name = jsonData["name"];
    this.lastPlayedDate = jsonData["lastPlayedDate"];
    this.contactInfo = jsonData["contactInfo"];
    this.balance = jsonData["balance"];
    this.autoApprovalLimit = jsonData["autoApprovalLimit"];
    this.gamesPlayed = jsonData["gamesPlayed"];
    this.totalBuyIn = jsonData["totalBuyIn"];
    this.totalWinnings = jsonData["totalWinnings"];
    this.rakePaid = jsonData["rakePaid"];
    this.isClubManager = jsonData["isClubManager"];
    this.notes = jsonData["notes"];
  }
}
