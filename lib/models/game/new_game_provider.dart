import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/approval_type.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/rewards_model.dart';

class NewGameModelProvider extends ChangeNotifier {
  /* This object holds new game settings */
  NewGameModel settings;
  String clubCode;
  // List<String> actionTimes = [];
  List<String> gameTypes = [];
  // List<String> gameLengths = [];
  List<Rewards> rewards = [];
  List<GameType> roeSelectedGames = [];
  List<GameType> dealerSelectedGames = [];

  bool notify = false;
  bool cancelled = false;

  NewGameModelProvider(String clubCode) {
    settings = NewGameModel.withDefault(clubCode);
    settings.clubCode = clubCode;
    settings.chipUnit = ChipUnit.DOLLAR;
  }

  get selectedReward {
    if (settings.rewards == null) {
      return 0;
    }
    int index =
        rewards.indexWhere((element) => element.name == settings.rewards.name);
    if (index == -1) {
      return 0;
    }
    return index;
  }

  set selectedReward(int index) {
    if (index == -1) {
      settings.rewards = null;
      return;
    }

    settings.rewards = rewards[index];
    notifyListeners();
  }

  set setReward(Rewards rewards) {
    settings.rewards = rewards;
    notifyListeners();
  }

  set gameType(GameType type) {
    settings.gameType = type;
  }

  GameType get gameType {
    return settings.gameType;
  }

  set roeGames(List<GameType> games) {
    settings.roeGames = games;
  }

  set dealerChoiceGames(List<GameType> games) {
    settings.dealerChoiceGames = games;
  }

  int get gameLengthInMins => settings.gameLength;
  set gameLengthInMins(value) {
    settings.gameLength = value;
    notifyListeners();
  }

  bool get buyInApproval => settings.buyInApproval ?? false;
  set buyInApproval(value) {
    settings.buyInApproval = value;
    notifyListeners();
  }

  bool get buttonStraddle => settings.buttonStraddle ?? false;
  set buttonStraddle(value) {
    settings.buttonStraddle = value;
    notifyListeners();
  }

  int get buttonStraddleBetAmount => settings.buttonStraddleBet ?? false;
  set buttonStraddleBetAmount(value) {
    settings.buttonStraddleBet = value;
    notifyListeners();
  }

  bool get breakAllowed => settings.breakAllowed ?? false;
  set breakAllowed(value) {
    settings.breakAllowed = value;
    notifyListeners();
  }

  int get breakTime => settings.breakTime ?? 5;
  set breakTime(value) {
    settings.breakTime = value;
    notifyListeners();
  }

  bool get bombPotEnabled => settings.bombPotEnabled ?? false;
  set bombPotEnabled(value) {
    settings.bombPotEnabled = value;
    notifyListeners();
  }

  int get bombPotBet => settings.bombPotBet ?? 5;
  set bombPotBet(value) {
    settings.bombPotBet = value;
    notifyListeners();
  }

  bool get doubleBoardBombPot => settings.doubleBoardBombPot ?? false;
  set doubleBoardBombPot(value) {
    settings.doubleBoardBombPot = value;
    notifyListeners();
  }

  int get bombPotInterval => settings.bombPotInterval ?? false;
  set bombPotInterval(value) {
    settings.bombPotInterval = value;
    notifyListeners();
  }

  int get bombPotHandInterval => settings.bombPotHandInterval ?? 11;
  set bombPotHandInterval(value) {
    log('bombPotHandInterval: $bombPotHandInterval');
    settings.bombPotHandInterval = value;
    notifyListeners();
  }

  BombPotIntervalType get bombPotIntervalType =>
      settings.bombPotIntervalType ?? BombPotIntervalType.TIME_INTERVAL;
  set bombPotIntervalType(value) {
    settings.bombPotIntervalType = value;
    notifyListeners();
  }

  int get selectedBombPotGameType {
    if (settings.bombPotGameType == GameType.HOLDEM) {
      return 0;
    } else if (settings.bombPotGameType == GameType.PLO) {
      return 1;
    } else if (settings.bombPotGameType == GameType.PLO_HILO) {
      return 2;
    } else if (settings.bombPotGameType == GameType.FIVE_CARD_PLO) {
      return 3;
    } else if (settings.bombPotGameType == GameType.FIVE_CARD_PLO_HILO) {
      return 4;
    } else if (settings.bombPotGameType == GameType.SIX_CARD_PLO) {
      return 5;
    } else if (settings.bombPotGameType == GameType.SIX_CARD_PLO_HILO) {
      return 6;
    }
    return 0;
  }

  int get actionTime => settings.actionTime;
  set actionTime(int v) {
    settings.actionTime = v;
    notifyListeners();
  }

  double get smallBlind {
    return settings.smallBlind;
  }
  // set smallBlind(double value) {
  //   settings.smallBlind = value;
  //   notifyListeners();
  // }

  double get bigBlind => settings.bigBlind;
  set bigBlind(double value) {
    settings.bigBlind = value;
    if (settings.chipUnit == ChipUnit.CENT) {
      double sb = (settings.bigBlind / 2);
      settings.smallBlind = double.parse(sb.toStringAsFixed(2));
    } else {
      settings.smallBlind = (settings.bigBlind / 2).floor().toDouble();
    }
    settings.straddleBet = settings.bigBlind * 2;

    notifyListeners();
  }

  double get straddleBet => settings.straddleBet;
  set straddleBet(double value) {
    settings.straddleBet = value;
    notifyListeners();
  }

  double get ante => settings.ante;
  set ante(double value) {
    settings.ante = value;
    notifyListeners();
  }

  int get buyInMin => settings.buyInMin;
  int get buyInMax => settings.buyInMax;

  set buyInMin(int value) {
    settings.buyInMin = value;
    if (settings.buyInMax <= settings.buyInMin) {
      settings.buyInMax = value + 100;
    }
    notifyListeners();
  }

  void notifyListeners() {
    if (notify) {
      super.notifyListeners();
    }
  }

  set buyInMax(int value) {
    settings.buyInMax = value;
    notifyListeners();
  }

  double get rakePercentage => settings.rakePercentage;
  double get rakeCap => settings.rakeCap;

  set rakePercentage(double value) {
    settings.rakePercentage = value;
    notifyListeners();
  }

  set rakeCap(double value) {
    settings.rakeCap = value;
    notifyListeners();
  }

  get maxPlayers {
    return settings.maxPlayers;
  }

  set maxPlayers(int value) {
    settings.maxPlayers = value;
    notifyListeners();
  }

  get locationCheck => settings.locationCheck;
  set locationCheck(bool value) {
    settings.locationCheck = value;
    notifyListeners();
  }

  get ipCheck => settings.ipCheck;
  set ipCheck(bool value) {
    settings.ipCheck = value;
    notifyListeners();
  }

  get seatChangeAllowed => settings.seatChangeAllowed;
  set seatChangeAllowed(bool value) {
    settings.seatChangeAllowed = value;
    notifyListeners();
  }

  get allowFunAnimations => settings.allowFunAnimations;
  set allowFunAnimations(bool value) {
    settings.allowFunAnimations = value;
    notifyListeners();
  }

  get showPlayerBuyin => settings.showPlayerBuyin;
  set showPlayerBuyin(bool value) {
    settings.showPlayerBuyin = value;
    notifyListeners();
  }

  get runItTwice => settings.runItTwice;
  set runItTwice(bool value) {
    settings.runItTwice = value;
    notifyListeners();
  }

  get waitList => settings.waitList;
  set waitList(bool value) {
    settings.waitList = value;
    notifyListeners();
  }

  get straddleAllowed => settings.utgStraddleAllowed;
  set straddleAllowed(bool value) {
    settings.utgStraddleAllowed = value;
    notifyListeners();
  }

  get botGame => settings.botGame;
  set botGame(bool value) {
    settings.botGame = value;
    notifyListeners();
  }

  get muckLosingHand => settings.muckLosingHand;
  set muckLosingHand(bool value) {
    settings.muckLosingHand = value;
    notifyListeners();
  }

  get audioConference => settings.audioConference;
  set audioConference(bool value) {
    settings.audioConference = value;
    notifyListeners();
  }

  get useAgora => settings.useAgora;
  set useAgora(bool value) {
    settings.useAgora = value;
    settings.audioConference = value;
    notifyListeners();
  }

  get showHandRank => settings.showHandRank;
  set showHandRank(bool value) {
    settings.showHandRank = value;
    notifyListeners();
  }

  get showResult => settings.showResult;
  set showResult(bool value) {
    settings.showResult = value;
    notifyListeners();
  }

  get showResultOption => settings.showResultOption;

  get highHandTracked => settings.highHandTracked;
  set highHandTracked(bool value) {
    settings.highHandTracked = value;
    notifyListeners();
  }

  get allowRabbitHunt => settings.allowRabbitHunt;
  set allowRabbitHunt(bool value) {
    settings.allowRabbitHunt = value;
    notifyListeners();
  }

  get buyInWaitTime => settings.buyInWaitTime;
  set buyInWaitTime(int value) {
    settings.buyInWaitTime = value;
    // notifyListeners();
  }

  set chipUnit(ChipUnit chipUnit) {
    settings.chipUnit = chipUnit;
    notifyListeners();
  }

  get chipUnit {
    return settings.chipUnit;
  }

  set dealerChoiceOrbit(bool value) {
    settings.dealerChoiceOrbit = value;
    notifyListeners();
  }

  get dealerChoiceOrbit {
    return settings.dealerChoiceOrbit;
  }

  set buyInApprovalLimit(BuyInApprovalLimit buyInLimit) {
    settings.buyInApprovalLimit = buyInLimit;
    notifyListeners();
  }

  BuyInApprovalLimit get buyInApprovalLimit {
    return settings.buyInApprovalLimit;
  }
}
