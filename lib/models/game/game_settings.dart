import 'dart:convert';

import 'package:pokerapp/enums/game_type.dart';

GameSettings gameSettingsInputFromJson(String str) =>
    GameSettings.fromJson(json.decode(str));

String gameSettingsInputToJson(GameSettings data) => json.encode(data.toJson());

class GameSettings {
  GameSettings({
    this.buyInApproval,
    this.runItTwiceAllowed,
    this.allowRabbitHunt,
    this.showHandRank,
    this.funAnimations,
    this.chat,
    this.doubleBoardEveryHand,
    this.bombPotEnabled,
    this.bombPotBet,
    this.doubleBoardBombPot,
    this.bombPotInterval,
    this.bombPotEveryHand,
    this.bombPotNextHand,
    this.seatChangeAllowed,
    this.seatChangeTimeout,
    this.waitlistAllowed,
    this.breakAllowed,
    this.breakLength,
    this.resultPauseTime,
    this.ipCheck,
    this.gpsCheck,
    this.showResult,
    this.roeGames,
    this.dealerChoiceGames,
    this.dealerChoiceOrbit,
    this.gameType,
    this.actionTime,
  });

  bool buyInApproval;
  bool runItTwiceAllowed;
  bool allowRabbitHunt;
  bool funAnimations;
  bool chat;
  bool showHandRank;
  bool doubleBoardEveryHand;
  bool bombPotEnabled;
  int bombPotBet;
  bool doubleBoardBombPot;
  int bombPotInterval;
  int bombPotIntervalInSecs;
  bool bombPotEveryHand;
  bool bombPotNextHand;
  bool seatChangeAllowed;
  int seatChangeTimeout;
  bool waitlistAllowed;
  bool breakAllowed;
  int breakLength;
  int resultPauseTime;
  bool ipCheck;
  bool gpsCheck;
  bool showResult;
  List<GameType> roeGames;
  List<GameType> dealerChoiceGames;
  bool dealerChoiceOrbit;
  int actionTime;
  GameType gameType;
  double rakeCap;
  double rakePercentage;

  BuyInApprovalLimit buyInApprovalLimit = BuyInApprovalLimit.BUYIN_NO_LIMIT;

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    List<GameType> roeGames = [];
    if (json['roeGames'] != null) {
      for (var gameTypeStr in json["roeGames"]) {
        GameType gameType = GameTypeSerialization.fromJson(gameTypeStr);
        roeGames.add(gameType);
      }
    }
    List<GameType> dealerChoiceGames = [];
    if (json['dealerChoiceGames'] != null) {
      for (var gameTypeStr in json["dealerChoiceGames"]) {
        GameType gameType = GameTypeSerialization.fromJson(gameTypeStr);
        dealerChoiceGames.add(gameType);
      }
    }
    final gameSettings = GameSettings(
      buyInApproval: json["buyInApproval"] ?? false,
      runItTwiceAllowed: json["runItTwiceAllowed"] ?? false,
      allowRabbitHunt: json["allowRabbitHunt"] ?? false,
      showHandRank: json["showHandRank"] ?? false,
      funAnimations: json["funAnimations"] ?? true,
      chat: json["chat"] ?? true,
      doubleBoardEveryHand: json["doubleBoardEveryHand"] ?? false,
      bombPotEnabled: json["bombPotEnabled"] ?? false,
      bombPotBet: json["bombPotBet"] ?? 5,
      doubleBoardBombPot: json["doubleBoardBombPot"] ?? false,
      bombPotInterval: json["bombPotInterval"] ?? 15,
      // bombPotIntervalInSecs: json["bombPotIntervalInSecs"] ?? 15,
      bombPotEveryHand: json["bombPotEveryHand"] ?? false,
      bombPotNextHand: json["bombPotNextHand"] ?? false,
      seatChangeAllowed: json["seatChangeAllowed"] ?? false,
      seatChangeTimeout: json["seatChangeTimeout"] ?? 10,
      waitlistAllowed: json["waitlistAllowed"] ?? false,
      breakAllowed: json["breakAllowed"] ?? false,
      breakLength: json["breakLength"] ?? 10,
      resultPauseTime: json["resultPauseTime"] ?? 5,
      ipCheck: json["ipCheck"] ?? false,
      gpsCheck: json["gpsCheck"] ?? false,
      showResult: json["showResult"] ?? false,
      roeGames: roeGames,
      dealerChoiceGames: dealerChoiceGames,
      dealerChoiceOrbit: json["dealerChoiceOrbit"] ?? true,
    );
    if (json["buyInLimit"] != null) {
      gameSettings.buyInApprovalLimit =
          BuyInApprovalLimitSerialization.fromJson(json["buyInLimit"]);
    }
    return gameSettings;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {};
    if (buyInApproval != null) {
      ret["buyInApproval"] = buyInApproval;
    }
    if (runItTwiceAllowed != null) {
      ret["runItTwiceAllowed"] = runItTwiceAllowed;
    }
    if (allowRabbitHunt != null) {
      ret["allowRabbitHunt"] = allowRabbitHunt;
    }
    if (showHandRank != null) {
      ret["showHandRank"] = showHandRank;
    }
    if (funAnimations != null) {
      ret["funAnimations"] = funAnimations;
    }
    if (chat != null) {
      ret["chat"] = chat;
    }
    if (doubleBoardEveryHand != null) {
      ret["doubleBoardEveryHand"] = doubleBoardEveryHand;
    }
    if (bombPotEnabled != null) {
      ret["bombPotEnabled"] = bombPotEnabled;
    }
    if (bombPotBet != null) {
      ret["bombPotBet"] = bombPotBet;
    }
    if (bombPotEnabled != null) {
      ret["bombPotEnabled"] = bombPotEnabled;
    }
    if (doubleBoardBombPot != null) {
      ret["doubleBoardBombPot"] = doubleBoardBombPot;
    }
    if (bombPotInterval != null) {
      ret["bombPotInterval"] = bombPotInterval;
    }
    if (bombPotEveryHand != null) {
      ret["bombPotEveryHand"] = bombPotEveryHand;
    }
    if (bombPotEveryHand != null) {
      ret["bombPotInterval"] = bombPotInterval;
    }
    if (bombPotNextHand != null) {
      ret["bombPotNextHand"] = bombPotNextHand;
    }
    if (seatChangeAllowed != null) {
      ret["seatChangeAllowed"] = seatChangeAllowed;
    }
    if (bombPotNextHand != null) {
      ret["bombPotNextHand"] = bombPotNextHand;
    }
    if (seatChangeTimeout != null) {
      ret["seatChangeTimeout"] = seatChangeTimeout;
    }
    if (breakAllowed != null) {
      ret["breakAllowed"] = breakAllowed;
    }
    if (breakLength != null) {
      ret["breakLength"] = breakLength;
    }
    if (waitlistAllowed != null) {
      ret["waitlistAllowed"] = waitlistAllowed;
    }
    if (resultPauseTime != null) {
      ret["resultPauseTime"] = resultPauseTime;
    }
    if (ipCheck != null) {
      ret["ipCheck"] = ipCheck;
    }
    if (gpsCheck != null) {
      ret["gpsCheck"] = gpsCheck;
    }
    if (showResult != null) {
      ret["showResult"] = showResult;
    }
    if (roeGames != null) {
      List<String> games = [];
      for (GameType gameType in roeGames) {
        String gameTypeStr = gameType.toJson();
        games.add(gameTypeStr);
      }
      ret["roeGames"] = games;
    }
    if (dealerChoiceGames != null) {
      ret["dealerChoiceGames"] =
          dealerChoiceGames.map((x) => x.toJson()).toList();
    }
    if (dealerChoiceOrbit != null) {
      ret["dealerChoiceOrbit"] = dealerChoiceOrbit;
    }
    if (gameType != null) {
      ret['gameType'] = gameType.toJson();
    }
    if (actionTime != null) {
      ret['actionTime'] = actionTime;
    }
    if (rakeCap != null) {
      ret['rakeCap'] = rakeCap;
    }
    if (rakePercentage != null) {
      ret['rakePercentage'] = rakePercentage;
    }
    return ret;
  }
}
