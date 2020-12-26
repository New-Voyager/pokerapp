
import 'package:pokerapp/enums/game_type.dart';

class NewGameConstants {
  static const Map<GameType, String> SUPPORTED_GAMES = {
    GameType.HOLDEM: "No Limit Holdem",
    GameType.PLO: "PLO",
    GameType.PLO_HILO: "PLO(Hi-Lo)",
    GameType.FIVE_CARD_PLO: "5 Card PLO",
    GameType.FIVE_CARD_PLO_HILO: "5 Card PLO(Hi-Lo)",
  };

  static const Map<int, String> ACTION_TIMES = {
    10: "10 Seconds",
    20: "20 Seconds",
    30: "30 Seconds",
    40: "45 Seconds",
    60: "1 minute",
    120: "2 minutes",
    300: "5 minutes",
  };

  static const Map<GameType, int> MAX_PLAYERS = {
    GameType.HOLDEM: 9,
    GameType.PLO: 9,
    GameType.PLO_HILO: 9,
    GameType.FIVE_CARD_PLO: 8,
    GameType.FIVE_CARD_PLO_HILO: 8,
  };

  static const Map<int, String> GAME_LENGTH = {
    -1: "Unlimited",
    60: "1 Hour",
    120: "2 Hours",
    240: "4 Hours",
    360: "6 Hours",
    480: "8 Hours",
    600: "10 Hours",
    900: "15 Hours",
    1440: "24 Hours",
  };
}

class NewGameModel {
  String clubCode;
  String title = 'Test';
  GameType gameType = GameType.HOLDEM;
  double smallBlind = 1;
  double bigBlind = 2.0;
  double straddleBet = 4.0;
  double ante = 0.0;
  bool utgStraddleAllowed = false;
  int minPlayers = 2;
  int maxPlayers = 9;
  int gameLength = 60;
  bool buyInApproval = false;
  double rakePercentage = 0;
  int rakeCap = 0;
  int buyInMin = 30;
  int buyInMax = 100;
  int actionTime = 30;
  bool locationCheck = false;
  bool ipCheck = false;
  bool dontShowLosingHand = false;
  bool runItTwice = false;
  bool seatChangeAllowed = false;
  bool waitList = false;
  bool botGame = true;
  NewGameModel(
      {this.clubCode,
      this.title,
      this.gameType,
      this.smallBlind,
      this.bigBlind,
      this.utgStraddleAllowed,
      this.straddleBet,
      this.minPlayers,
      this.maxPlayers,
      this.gameLength,
      this.buyInApproval,
      this.rakePercentage,
      this.rakeCap,
      this.buyInMin,
      this.buyInMax,
      this.actionTime,
      this.dontShowLosingHand,
      this.seatChangeAllowed,
      this.runItTwice,
      this.ipCheck,
      this.locationCheck,
      this.waitList,
      this.botGame});

  NewGameModel.withDefault(String clubCode) {
    this.clubCode = clubCode;
  }

  NewGameModel.fromJson(Map<String, dynamic> json) {
    String gameTypeTmp = json["gameType"];
    title = json['title'];
    this.gameType = GameType.values.firstWhere((e) => e.toString() == 'GameType.' + gameTypeTmp);
    smallBlind = json['smallBlind'];
    bigBlind = json['bigBlind'];
    utgStraddleAllowed = json['utgStraddleAllowed'];
    straddleBet = json['straddleBet'];
    minPlayers = json['minPlayers'];
    maxPlayers = json['maxPlayers'];
    gameLength = json['gameLength'];
    buyInApproval = json['buyInApproval'];
    rakePercentage = json['rakePercentage'];
    rakeCap = json['rakeCap'];
    buyInMin = json['buyInMin'];
    buyInMax = json['buyInMax'];
    actionTime = json['actionTime'];
    botGame = json['botGame'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['gameType'] = this.gameType.toString().replaceFirst('GameType.', '');
    data['smallBlind'] = this.smallBlind;
    data['bigBlind'] = this.bigBlind;
    data['utgStraddleAllowed'] = this.utgStraddleAllowed;
    data['straddleBet'] = this.straddleBet;
    data['minPlayers'] = this.minPlayers;
    data['maxPlayers'] = this.maxPlayers;
    data['gameLength'] = this.gameLength;
    data['buyInApproval'] = this.buyInApproval;
    data['rakePercentage'] = this.rakePercentage;
    data['rakeCap'] = this.rakeCap;
    data['buyInMin'] = this.buyInMin;
    data['buyInMax'] = this.buyInMax;
    data['actionTime'] = this.actionTime;
    data['botGame'] = this.botGame;
    return data;
  }

  void setBlinds(Blinds blinds) {
    smallBlind = blinds.smallBlind;
    bigBlind = blinds.bigBlind;
    straddleBet = blinds.straddle;
    ante = blinds.ante;
  }
}


class Blinds {
  double smallBlind = 1.0;
  double bigBlind = 2.0;
  double straddle = 4.0;
  double ante = 0.0;

  Blinds({this.smallBlind, this.bigBlind, this.straddle, this.ante});
}
