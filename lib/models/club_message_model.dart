import 'package:graphql_flutter/graphql_flutter.dart';

enum MessageType {
  TEXT,
  HAND,
  GIPHY,
}

class SharedHandMsg {
  /*
    sharedHand {
      handNum
      gameCode
      gameType
      sharedByPlayerId
      sharedByPlayerUuid
      sharedByPlayerName
      data
    }
    */
  final int handNum;
  final String gameCode;
  final String gameTypeStr;
  final int sharedByPlayerId;
  final String sharedByPlayerUuid;
  final String sharedByPlayerName;
  final dynamic data;

  SharedHandMsg(
    this.handNum,
    this.gameCode,
    this.gameTypeStr,
    this.sharedByPlayerId,
    this.sharedByPlayerUuid,
    this.sharedByPlayerName,
    this.data,
  );
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
  int messageTimeInEpoc;
  String sender;
  SharedHandMsg sharedHand;

  ClubMessageModel({
    this.clubCode,
    this.messageType,
    this.text,
    this.gameNum,
    this.handNum,
    this.giphyLink,
    this.playerTags,
  });

  ClubMessageModel.fromJson(dynamic jsonData) {
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
    this.messageTimeInEpoc = jsonData['messageTimeInEpoc'];
    this.sender = jsonData['sender'];

    if (this.messageType == MessageType.HAND) {
      dynamic sharedHand = jsonData['sharedHand'];
      this.sharedHand = SharedHandMsg(
        sharedHand['handNum'],
        sharedHand['gameCode'],
        sharedHand['gameType'],
        sharedHand['sharedByPlayerId'],
        sharedHand['sharedByPlayerUuid'],
        sharedHand['sharedByPlayerName'],
        sharedHand['data'],
      );
    }
  }

  // MUTATIONS

  Future<String> mutationSendClubMessage() async {
    assert(this.clubCode != null);
    assert(this.messageType != null);

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
      sender
      playerTags
      messageTimeInEpoc
      sharedHand {
        handNum
        gameCode
        gameType
        sharedByPlayerId
        sharedByPlayerUuid
        sharedByPlayerName
        data
      }
    }
  }""";

  static String queryClubMessages2 =
      """query (\$clubCode: String!, \$next: Int) {
    clubMessages(clubCode:\$clubCode, pageOptions: {next:\$next}){
      id
      messageType
      clubCode
      text
      gameNum
      handNum
      giphyLink
      sender
      playerTags
      messageTimeInEpoc
      sharedHand {
        handNum
        gameCode
        gameType
        sharedByPlayerId
        sharedByPlayerUuid
        sharedByPlayerName
        data
      }
    }
  }""";
  @override
  String toString() {
    return this.text ?? 'Message';
  }
}
