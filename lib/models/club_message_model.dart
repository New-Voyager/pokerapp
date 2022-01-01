import 'dart:convert';

enum MessageType {
  TEXT,
  HAND,
  GIPHY,
  JOIN_CLUB,
  LEAVE_CLUB,
  KICKED_OUT,
  NEW_GAME,
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
  //int messageTimeInEpoc;
  DateTime messageTime;
  String sender;
  String playerName;
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
      case 'JOIN_CLUB':
        this.messageType = MessageType.JOIN_CLUB;
        break;
      case 'LEAVE_CLUB':
        this.messageType = MessageType.LEAVE_CLUB;
        break;
      case 'KICKED_OUT':
        this.messageType = MessageType.KICKED_OUT;
        break;
      case 'NEW_GAME':
        this.messageType = MessageType.NEW_GAME;
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
    //this.messageTimeInEpoc = jsonData['messageTimeInEpoc'];
    try {
      this.messageTime = DateTime.parse(jsonData['messageTime'] as String);
    } catch (err) {
      this.messageTime = DateTime.now();
    }
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
    } else if (this.messageType == MessageType.JOIN_CLUB ||
        this.messageType == MessageType.LEAVE_CLUB ||
        this.messageType == MessageType.KICKED_OUT) {
      dynamic clubMsg = jsonDecode(this.text);
      this.playerName = clubMsg['name'];
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
      messageTime
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
      messageTime
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
