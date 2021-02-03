class MessagesFromMember {
  int id;
  int memberID;
  String messageType;
  String text;
  String messageTime;

  MessagesFromMember(
      {this.id, this.memberID, this.messageType, this.text, this.messageTime});

  MessagesFromMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberID = json['memberID'];
    messageType = json['messageType'];
    text = json['text'];
    messageTime = json['messageTime'];
  }
}
