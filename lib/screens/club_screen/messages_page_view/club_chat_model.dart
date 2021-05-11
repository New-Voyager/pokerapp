import '../../../models/club_message_model.dart';

class ClubChatModel {
  final int id;
  final String clubCode;
  final MessageType messageType;
  final String text;
  final int gameNum;
  final int handNum;
  final String giphyLink;
  final String playerTags;
  final int messageTimeInEpoc;
  final String sender;
  final SharedHandMsg sharedHand;

  bool isGroupLatest;
  bool isGroupFirst;

  ClubChatModel({
    this.id,
    this.messageTimeInEpoc,
    this.clubCode,
    this.messageType,
    this.text,
    this.gameNum,
    this.handNum,
    this.giphyLink,
    this.playerTags,
    this.isGroupLatest,
    this.isGroupFirst,
    this.sender,
    this.sharedHand,
  });
}
