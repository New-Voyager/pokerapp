class HostMessageSummaryModel {
  int memberID;
  String memberName;
  String lastMessageText;
  String lastMessageTime;
  int newMessageCount;

  HostMessageSummaryModel(
      {this.memberID,
      this.memberName,
      this.lastMessageText,
      this.lastMessageTime,
      this.newMessageCount});

  HostMessageSummaryModel.fromJson(Map<String, dynamic> json) {
    memberID = json['memberID'];
    memberName = json['memberName'];
    lastMessageText = json['lastMessageText'];
    lastMessageTime = json['lastMessageTime'];
    newMessageCount = json['newMessageCount'];
  }
}
