class LobbyGameModel {
/*
{
  "title": "NLH 1/2",
  "gameCode": "lgsyzgen",
  "gameID": 14,
  "status": "ACTIVE",
  "gameType": "HOLDEM",
  "smallBlind": 0.01,
  "bigBlind": 0.02,
  "buyInMin": 100,
  "buyInMax": 600,
  "activePlayers": 0,
  "maxPlayers": 9
} 
*/

  String title;
  String gameCode;
  int gameID;
  String status;
  String gameType;
  double smallBlind;
  double bigBlind;
  int buyInMin;
  int buyInMax;
  int activePlayers;
  int maxPlayers;

  LobbyGameModel({
    this.title,
    this.gameCode,
    this.gameID,
    this.status,
    this.gameType,
    this.smallBlind,
    this.bigBlind,
    this.buyInMin,
    this.buyInMax,
    this.activePlayers,
    this.maxPlayers,
  });
  LobbyGameModel.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    gameCode = json['gameCode']?.toString();
    gameID = json['gameID']?.toInt();
    status = json['status']?.toString();
    gameType = json['gameType']?.toString();
    smallBlind = json['smallBlind']?.toDouble();
    bigBlind = json['bigBlind']?.toDouble();
    buyInMin = json['buyInMin']?.toInt();
    buyInMax = json['buyInMax']?.toInt();
    activePlayers = json['activePlayers']?.toInt();
    maxPlayers = json['maxPlayers']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['gameCode'] = gameCode;
    data['gameID'] = gameID;
    data['status'] = status;
    data['gameType'] = gameType;
    data['smallBlind'] = smallBlind;
    data['bigBlind'] = bigBlind;
    data['buyInMin'] = buyInMin;
    data['buyInMax'] = buyInMax;
    data['activePlayers'] = activePlayers;
    data['maxPlayers'] = maxPlayers;
    return data;
  }
}
