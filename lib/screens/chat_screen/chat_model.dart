class ChatModel {
  final int id;
  final int memberID;
  final String messageType;
  final String text;
  final DateTime messageTime;
  bool isGroupLatest;

  ChatModel({
    this.id,
    this.memberID,
    this.messageType,
    this.text,
    this.messageTime,
    this.isGroupLatest,
  });
}
