import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/rewards_model.dart';

class NewGameConstants {
  static const Map<GameType, String> SUPPORTED_GAMES = {
    GameType.HOLDEM: "No Limit Holdem",
    GameType.PLO: "PLO",
    GameType.PLO_HILO: "PLO(Hi-Lo)",
    GameType.FIVE_CARD_PLO: "5 Card PLO",
    GameType.FIVE_CARD_PLO_HILO: "5 Card PLO(Hi-Lo)",
    GameType.ROE: "Round Of Each",
    GameType.DEALER_CHOICE: "Dealer Choice",
  };

  static const List<int> ACTION_TIMES = [10, 15, 20, 30, 45, 60];
  static const List<int> BUYIN_WAIT_TIMES = [60, 90, 120, 240, 300];
  static const List<int> BOMB_POT_INTERVALS = [30, 45, 60, 90, 120];
  static const List<int> BOMB_POT_BET_SIZE = [2, 3, 4, 5, 10, 15, 20];
  static const List<int> BREAK_WAIT_TIMES = [3, 5, 10, 15, 30];

  // static const Map<int, String> ACTION_TIMES = {
  //   10: "10 Seconds",
  //   20: "20 Seconds",
  //   30: "30 Seconds",
  //   40: "45 Seconds",
  //   60: "1 minute",
  //   120: "2 minutes",
  //   300: "5 minutes",
  // };

  static const Map<GameType, int> MAX_PLAYERS = {
    GameType.HOLDEM: 9,
    GameType.PLO: 9,
    GameType.PLO_HILO: 9,
    GameType.FIVE_CARD_PLO: 8,
    GameType.FIVE_CARD_PLO_HILO: 8,
    GameType.ROE: 9,
    GameType.DEALER_CHOICE: 9
  };

  static const List<int> GAME_LENGTH = [1, 2, 4, 8, 12, 20];

  // static const Map<int, String> GAME_LENGTH = {
  //   -1: "Unlimited",
  //   60: "1 Hour",
  //   120: "2 Hours",
  //   240: "4 Hours",
  //   360: "6 Hours",
  //   480: "8 Hours",
  //   600: "10 Hours",
  //   900: "15 Hours",
  //   1440: "24 Hours",
  // };
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
  bool buttonStraddle = false;
  int buttonStraddleBet = 2; // 2 times big blind default
  int minPlayers = 2;
  int maxPlayers = 9;
  int gameLength = 60;
  int gameLengthInHrs = 1;
  bool buyInApproval = true;
  double rakePercentage = 0;
  double rakeCap = 0;
  int buyInMin = 30;
  int buyInMax = 100;
  int actionTime = 30;
  bool locationCheck = false;
  bool ipCheck = true;
  bool runItTwice = false;
  bool seatChangeAllowed = false;
  bool waitList = false;
  bool botGame = true;
  Rewards rewards;
  bool muckLosingHand = false;
  bool audioConference = true;
  bool allowRabbitHunt = true;
  bool showHandRank = false;
  bool useAgora = false;
  bool breakAllowed = true;
  int breakTime = 5;
  /*
    bombPotEnabled: Boolean
    bombPotBet: Int
    doubleBoardBombPot: Boolean
    bombPotInterval: Int        
    bombPotIntervalInSecs: Int  # for tests
  */
  bool bombPotEnabled = false;
  bool doubleBoardBombPot = false;
  int bombPotInterval = 30;
  int bombPotBet = 5; // in big blinds

  List<GameType> roeGames = [];
  List<GameType> dealerChoiceGames = [];

  int buyInWaitTime;

  NewGameModel({
    this.clubCode,
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
    this.seatChangeAllowed,
    this.runItTwice,
    this.ipCheck,
    this.locationCheck,
    this.waitList,
    this.botGame,
    this.muckLosingHand,
    this.roeGames,
    this.dealerChoiceGames,
    this.allowRabbitHunt,
    this.showHandRank,
    this.audioConference,
    this.useAgora,
    this.bombPotEnabled,
    this.bombPotBet,
    this.doubleBoardBombPot,
    this.bombPotInterval,
    this.breakAllowed,
    this.breakTime,
  });

  NewGameModel.withDefault(String clubCode) {
    this.clubCode = clubCode;
  }

  NewGameModel.fromJson(Map<String, dynamic> json) {
    String gameTypeTmp = json["gameType"];
    title = json['title'];
    this.gameType = GameType.values
        .firstWhere((e) => e.toString() == 'GameType.' + gameTypeTmp);
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
    muckLosingHand = json['muckLosingHand'];
    runItTwice = json['runItTwiceAllowed'];
    roeGames = json['roeGames'];
    dealerChoiceGames = json['dealerChoiceGames'];
    audioConference = json['audioConfEnabled'];
    allowRabbitHunt = json['allowRabbitHunt'];
    showHandRank = json['showHandRank'];
    useAgora = json['useAgora'];
    bombPotEnabled = json['bombPotEnabled'] ?? false;
    bombPotBet = json['bombPotBet'] ?? 5;
    doubleBoardBombPot = json['doubleBoardBombPot'] ?? false;
    bombPotInterval = json['bombPotInterval'] ?? 30;
    seatChangeAllowed = json['seatChangeAllowed'] ?? false;
    breakTime = json['breakLength'] ?? 5;
    breakAllowed = json['breakAllowed'] ?? true;
    ipCheck = json['ipCheck'] ?? false;
    locationCheck = json['gpsCheck'] ?? false;
    buttonStraddle = json['buttonStraddleAllowed'] ?? false;
    buttonStraddleBet = json['buttonStraddleBet'] ?? 2;
  }

  Map<String, dynamic> toJson() {
    this.smallBlind = (this.bigBlind / 2).toInt().toDouble();
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['gameType'] = this.gameType.toString().replaceFirst('GameType.', '');
    data['smallBlind'] = this.smallBlind;
    data['bigBlind'] = this.bigBlind;
    data['utgStraddleAllowed'] = this.utgStraddleAllowed;
    data['buttonStraddleAllowed'] = this.buttonStraddle;
    data['buttonStraddleBet'] = this.buttonStraddleBet;
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
    data['runItTwiceAllowed'] = this.runItTwice;
    data['muckLosingHand'] = this.muckLosingHand;
    data['audioConfEnabled'] = this.audioConference;
    data['allowRabbitHunt'] = this.allowRabbitHunt;
    data['showHandRank'] = this.showHandRank;
    data['useAgora'] = this.useAgora;
    data['bombPotEnabled'] = this.bombPotEnabled;
    data['bombPotBet'] = this.bombPotBet;
    data['doubleBoardBombPot'] = this.doubleBoardBombPot;
    data['bombPotInterval'] = this.bombPotInterval;
    data['seatChangeAllowed'] = this.seatChangeAllowed ?? false;
    data['breakAllowed'] = this.breakAllowed ?? true;
    if (this.breakTime == null) {
      data['breakLength'] = 5;
    } else {
      data['breakLength'] = this.breakTime;
    }
    data['gpsCheck'] = this.locationCheck ?? false;
    data['ipCheck'] = this.ipCheck ?? false;

    if (this.gameType == GameType.ROE) {
      data['roeGames'] = this
          .roeGames
          .map((e) => e.toString().replaceAll('GameType.', ''))
          .toList();
    }

    if (this.gameType == GameType.DEALER_CHOICE) {
      data['dealerChoiceGames'] = this
          .dealerChoiceGames
          .map((e) => e.toString().replaceAll('GameType.', ''))
          .toList();
    }

    if (this.rewards != null && this.rewards.id != 0) {
      data['rewardIds'] = [this.rewards.id];
    }
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
  double smallBlind = 1;
  double bigBlind = 2;
  double straddle = 4;
  double ante = 0;

  Blinds({this.smallBlind, this.bigBlind, this.straddle, this.ante});
}
