class MessagesFromMember {
  int id;
  int memberID;
  String messageType;
  String text;
  String messageTime;
  String memberName;
  String playerId;
  String updatedBy;

  MessagesFromMember(
      {this.id, this.memberID, this.messageType, this.text, this.messageTime});

  MessagesFromMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberID = json['memberId'];
    messageType = json['messageType'];
    text = json['text'];
    messageTime = json['messageTime'];
    memberName = json['memberName'];
    playerId = json['playerId'];
    updatedBy = json['updatedBy'];
  }
}
