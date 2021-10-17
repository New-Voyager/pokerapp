import 'dart:convert';

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
  bool seatChangeAllowed;
  int seatChangeTimeout;
  bool waitlistAllowed;
  bool breakAllowed;
  int breakLength;
  int resultPauseTime;
  bool ipCheck;
  bool gpsCheck;
  bool showResult;
  List roeGames;
  List dealerChoiceGames;
  bool dealerChoiceOrbit;

  factory GameSettings.fromJson(Map<String, dynamic> json) {
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
      seatChangeAllowed: json["seatChangeAllowed"] ?? false,
      seatChangeTimeout: json["seatChangeTimeout"] ?? 10,
      waitlistAllowed: json["waitlistAllowed"] ?? false,
      breakAllowed: json["breakAllowed"] ?? false,
      breakLength: json["breakLength"] ?? 10,
      resultPauseTime: json["resultPauseTime"] ?? 5,
      ipCheck: json["ipCheck"] ?? false,
      gpsCheck: json["gpsCheck"] ?? false,
      showResult: json["showResult"] ?? false,
      roeGames: json["roeGames"] ?? [],
      dealerChoiceGames: json["dealerChoiceGames"] ?? [],
      dealerChoiceOrbit: json["dealerChoiceOrbit"] ?? true,
    );
    return gameSettings;
  }

  Map<String, dynamic> toJson() => {
        "buyInApproval": buyInApproval,
        "runItTwiceAllowed": runItTwiceAllowed,
        "allowRabbitHunt": allowRabbitHunt,
        "showHandRank": showHandRank,
        "funAnimations": funAnimations,
        "chat": chat,
        "doubleBoardEveryHand": doubleBoardEveryHand,
        "bombPotEnabled": bombPotEnabled,
        "bombPotBet": bombPotBet,
        "doubleBoardBombPot": doubleBoardBombPot,
        "bombPotInterval": bombPotInterval,
        // "bombPotIntervalInSecs": bombPotIntervalInSecs,
        "bombPotEveryHand": bombPotEveryHand,
        "seatChangeAllowed": seatChangeAllowed,
        "seatChangeTimeout": seatChangeTimeout,
        "waitlistAllowed": waitlistAllowed,
        "breakAllowed": breakAllowed,
        "breakLength": breakLength,
        "resultPauseTime": resultPauseTime,
        "ipCheck": ipCheck,
        "gpsCheck": gpsCheck,
        "showResult": showResult,
        "roeGames": roeGames,
        "dealerChoiceGames": dealerChoiceGames,
        "dealerChoiceOrbit": dealerChoiceOrbit,
      };
}
