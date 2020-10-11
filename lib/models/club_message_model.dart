import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/services/app/auth_service.dart';

enum MessageType {
  TEXT,
  HAND,
  GIPHY,
}

class ClubMessageModel {
  int id;
  String clubCode;
  MessageType messageType;
  String text;
  int gameNum;
  int handNum;
  String giphyLink;

  String playerTags;

  ClubMessageModel({
    this.clubCode,
    this.messageType,
    this.text,
    this.gameNum,
    this.handNum,
    this.giphyLink,
    this.playerTags,
  });

  ClubMessageModel.fromJson(LazyCacheMap jsonData) {
    /* this function converts the server response
    to app objects */

    this.id = jsonData['id'];

    switch (jsonData['messageType'] as String) {
      case 'TEXT':
        this.messageType = MessageType.TEXT;
        break;
      case 'HAND':
        this.messageType = MessageType.HAND;
        break;
      case 'GIPHY':
        this.messageType = MessageType.GIPHY;
        break;
      default:
        this.messageType = MessageType.TEXT;
    }

    this.clubCode = jsonData['clubCode'];
    this.text = jsonData['text'];
    this.gameNum = jsonData['gameNum'];
    this.handNum = jsonData['handNum'];
    this.giphyLink = jsonData['giphyLink'];
    this.playerTags = jsonData['playerTags'];
  }

  // MUTATIONS

  Future<String> mutationSendClubMessage() async {
    // TODO: THE PLAYER TAGS SHOULD CONTAIN PLAYER ID ALONG WITH PLAYER NAME
    this.playerTags = await AuthService.getJWT();

    assert(this.clubCode != null);
    assert(this.messageType != null);
    assert(this.playerTags != null);

    String messageType = '';

    switch (this.messageType) {
      case MessageType.TEXT:
        messageType = 'TEXT';
        break;
      case MessageType.HAND:
        messageType = 'HAND';
        break;
      case MessageType.GIPHY:
        messageType = 'GIPHY';
        break;
    }

    return """mutation{
    sendClubMessage(clubCode: "${this.clubCode}", message: {
      messageType: $messageType,
      ${this.text == null ? '' : 'text: "${this.text}"'}
      ${this.gameNum == null ? '' : 'gameNum: "${this.gameNum}"'}
      ${this.handNum == null ? '' : 'handNum: "${this.handNum}"'}
      ${this.giphyLink == null ? '' : 'giphyLink: "${this.giphyLink}"'}
      playerTags: "${this.playerTags}",
    })
  }""";
  }

  // QUERIES

  static String queryClubMessages(String clubCode,
          {int prev, int next, int count}) =>
      """query{
    clubMessages(clubCode:"$clubCode", pageOptions: {prev:$prev, next:$next, count: $count}){
      id
      messageType
      clubCode
      text
      gameNum
      handNum
      giphyLink
      playerTags
    }
  }""";

  @override
  String toString() {
    return this.text ?? 'Message';
  }
}
