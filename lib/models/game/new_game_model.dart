import 'package:pokerapp/enums/approval_type.dart';
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
  static const List<int> BOMB_POT_INTERVALS = [15, 30, 45, 60];
  static const List<int> BOMB_POT_BET_SIZE = [2, 3, 4, 5, 10];
  static const List<int> BREAK_WAIT_TIMES = [3, 5, 10, 15, 30];
  static const List<String> BOMB_POT_GAME_TYPES = [
    'NLH',
    'PLO',
    'Hi-Lo',
    '5 Card PLO',
    '5 Card\nHi-Lo',
    '6 Card PLO',
    '6 Card\nHi-Lo'
  ];
  static const List<String> BUYIN_LIMIT_CHOICES = [
    'No Limit',
    'Credit Limit'
        'Host Approval'
  ];

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
  bool buyInApproval = false;
  double rakePercentage = 0;
  double rakeCap = 0;
  int buyInMin = 30;
  int buyInMax = 100;
  int actionTime = 30;
  bool locationCheck = false;
  bool ipCheck = false;
  bool runItTwice = true;
  bool seatChangeAllowed = true;
  bool waitList = true;
  bool botGame = false;
  bool highHandTracked = false;
  int buyInWaitTime = 120;
  Rewards rewards;
  bool muckLosingHand = false;
  bool showPlayerBuyin = false;
  bool audioConference = false;
  bool allowRabbitHunt = true;
  bool showHandRank = true;
  bool useAgora = false;
  bool breakAllowed = true;
  bool showResultOption = true;
  bool showResult = true;
  bool showCheckFold = true;
  int breakTime = 5;
  bool allowFunAnimations = true;
  ChipUnit chipUnit = ChipUnit.DOLLAR;
  BuyInApprovalLimit buyInApprovalLimit = BuyInApprovalLimit.BUYIN_NO_LIMIT;
  bool dealerChoiceOrbit = true;
  bool demoGame = false;

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
  GameType bombPotGameType = GameType.UNKNOWN;
  int bombPotHandInterval = 11;
  BombPotIntervalType bombPotIntervalType = BombPotIntervalType.TIME_INTERVAL;

  List<GameType> roeGames = [];
  List<GameType> dealerChoiceGames = [];

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
    this.showPlayerBuyin,
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
    this.showResult,
    this.highHandTracked,
    this.buyInWaitTime,
    this.allowFunAnimations,
    this.chipUnit,
    this.buyInApprovalLimit = BuyInApprovalLimit.BUYIN_NO_LIMIT,
    this.dealerChoiceOrbit,
    this.demoGame = false,
  });

  NewGameModel.withDefault(String clubCode) {
    this.clubCode = clubCode;
  }

  NewGameModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    this.gameType = GameTypeSerialization.fromJson(json["gameType"]);
    if (json['chipUnit'] == null) {
      chipUnit = ChipUnit.DOLLAR;
    } else {
      chipUnit = ChipUnitSerialization.fromJson(json['chipUnit']);
    }
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
    buyInMin = json['buyInMin'].toInt();
    buyInMax = json['buyInMax'].toInt();
    actionTime = json['actionTime'];
    botGame = json['botGame'];
    muckLosingHand = json['muckLosingHand'];
    showPlayerBuyin = json['showPlayerBuyin'];
    runItTwice = json['runItTwiceAllowed'];
    roeGames = json['roeGames']
            ?.map<GameType>((e) => GameTypeSerialization.fromJson(e))
            ?.toList() ??
        [];
    dealerChoiceGames = json['dealerChoiceGames']
            ?.map<GameType>((e) => GameTypeSerialization.fromJson(e))
            ?.toList() ??
        [];
    audioConference = json['audioConfEnabled'];
    allowRabbitHunt = json['allowRabbitHunt'];
    showHandRank = json['showHandRank'];
    useAgora = json['useAgora'];
    bombPotEnabled = json['bombPotEnabled'] ?? false;
    bombPotBet = json['bombPotBet'] ?? 5;
    doubleBoardBombPot = json['doubleBoardBombPot'] ?? false;
    bombPotInterval = json['bombPotInterval'] ?? 30;
    bombPotHandInterval = json['bombPotHandInterval'] ?? 11;
    bombPotIntervalType =
        BombPotIntervalTypeSerialization.fromJson(json['bombPotIntervalType']);
    bombPotGameType = GameType.UNKNOWN;
    if (json['bombPotGameType'] != null) {
      bombPotGameType = GameTypeSerialization.fromJson(json['bombPotGameType']);
    }

    seatChangeAllowed = json['seatChangeAllowed'] ?? false;
    breakTime = json['breakLength'] ?? 5;
    breakAllowed = json['breakAllowed'] ?? true;
    ipCheck = json['ipCheck'] ?? false;
    locationCheck = json['gpsCheck'] ?? false;
    waitList = json['waitList'] ?? false;
    buttonStraddle = json['buttonStraddleAllowed'] ?? false;
    buttonStraddleBet = json['buttonStraddleBet'] ?? 2;
    showResult = json['showResult'] ?? true;
    highHandTracked = json['highHandTracked'] ?? false;
    buyInWaitTime = json['buyInWaitTime'] ?? 60;
    allowFunAnimations = json['funAnimations'] ?? true;
    ante = json['ante'] ?? 0.0;
    if (json['buyInLimit'] == null) {
      buyInApprovalLimit = BuyInApprovalLimit.BUYIN_NO_LIMIT;
    } else {
      buyInApprovalLimit =
          BuyInApprovalLimitSerialization.fromJson(json['buyInLimit']);
    }
    dealerChoiceOrbit = json['dealerChoiceOrbit'];
  }

  Map<String, dynamic> toJson() {
    //this.smallBlind = (this.bigBlind ~/ 2).toDouble();
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['gameType'] = this.gameType.toJson();
    data['chipUnit'] = this.chipUnit.toJson();
    data['smallBlind'] = this.smallBlind;
    data['bigBlind'] = this.bigBlind;
    data['ante'] = this.ante;
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

    // multiple min/max with bigblind
    data['buyInMin'] = this.buyInMin * this.bigBlind;
    data['buyInMax'] = this.buyInMax * this.bigBlind;

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
    if (this.bombPotGameType == GameType.UNKNOWN) {
      this.bombPotGameType = this.gameType;
    }
    if (this.bombPotGameType == GameType.DEALER_CHOICE) {
      this.bombPotGameType = this.dealerChoiceGames[0];
    } else if (this.bombPotGameType == GameType.ROE) {
      this.bombPotGameType = this.roeGames[0];
    }
    data['bombPotGameType'] = this.bombPotGameType.toJson();
    data['bombPotHandInterval'] = this.bombPotHandInterval;
    data['bombPotIntervalType'] = this.bombPotIntervalType.toJson();

    data['seatChangeAllowed'] = this.seatChangeAllowed ?? false;
    data['breakAllowed'] = this.breakAllowed ?? true;
    data['showResult'] = this.showResult ?? true;
    data['funAnimations'] = this.allowFunAnimations ?? true;
    data['highHandTracked'] = this.highHandTracked ?? false;
    data['buyInLimit'] = this.buyInApprovalLimit.toJson();
    data['buyInTimeout'] = this.buyInWaitTime;
    data['waitlistAllowed'] = this.waitList;
    data['dealerChoiceOrbit'] = this.dealerChoiceOrbit;
    //data['allowFunAnimations'] = this.allowFunAnimations;

    if (this.breakTime == null) {
      data['breakLength'] = 5;
    } else {
      data['breakLength'] = this.breakTime;
    }
    data['gpsCheck'] = this.locationCheck ?? false;
    data['ipCheck'] = this.ipCheck ?? false;

    if (this.gameType == GameType.ROE) {
      data['roeGames'] = this.roeGames.map((e) => e.toJson()).toList();
    }

    if (this.gameType == GameType.DEALER_CHOICE) {
      data['dealerChoiceGames'] =
          this.dealerChoiceGames.map((e) => e.toJson()).toList();
    }

    if (this.rewards != null && this.rewards.id != 0) {
      data['rewardIds'] = [this.rewards.id];
    }

    data['demoGame'] = demoGame ?? false;
    return data;
  }

  factory NewGameModel.demoGame() {
    final newGameModel = NewGameModel.withDefault("");

    newGameModel.smallBlind = 1;
    newGameModel.bigBlind = 2;
    newGameModel.chipUnit = ChipUnit.DOLLAR;
    newGameModel.gameLength = 60;
    newGameModel.buyInMin = 100;
    newGameModel.buyInMax = 500;
    newGameModel.gameType = GameType.HOLDEM;
    newGameModel.minPlayers = 2;
    newGameModel.maxPlayers = 6;
    newGameModel.demoGame = true;
    newGameModel.actionTime = 15;
    newGameModel.rakePercentage = 0;
    newGameModel.rakeCap = 0;

    return newGameModel;
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
