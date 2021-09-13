import 'dart:convert';

GameSettingsInput gameSettingsInputFromJson(String str) =>
    GameSettingsInput.fromJson(json.decode(str));

String gameSettingsInputToJson(GameSettingsInput data) =>
    json.encode(data.toJson());

class GameSettingsInput {
  GameSettingsInput({
    this.buyInApproval,
    this.runItTwiceAllowed,
    this.allowRabbitHunt,
    this.showHandRank,
    this.doubleBoardEveryHand,
    this.bombPotEnabled,
    this.bombPotBet,
    this.doubleBoardBombPot,
    this.bombPotInterval,
    //this.bombPotIntervalInSecs,
    this.bombPotEveryHand,
    this.seatChangeAllowed,
    this.seatChangeTimeout,
    this.waitlistAllowed,
    this.breakAllowed,
    this.breakLength,
    this.pauseEachResultInSecs,
    this.ipCheck,
    this.gpsCheck,
    this.roeGames,
    this.dealerChoiceGames,
  });

  bool buyInApproval;
  bool runItTwiceAllowed;
  bool allowRabbitHunt;
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
  int pauseEachResultInSecs;
  bool ipCheck;
  bool gpsCheck;
  List roeGames;
  List dealerChoiceGames;

  factory GameSettingsInput.fromJson(Map<String, dynamic> json) =>
      GameSettingsInput(
        buyInApproval: json["buyInApproval"] ?? false,
        runItTwiceAllowed: json["runItTwiceAllowed"] ?? false,
        allowRabbitHunt: json["allowRabbitHunt"] ?? false,
        showHandRank: json["showHandRank"] ?? false,
        doubleBoardEveryHand: json["doubleBoardEveryHand"] ?? false,
        bombPotEnabled: json["bombPotEnabled"] ?? false,
        bombPotBet: json["bombPotBet"] ?? 1,
        doubleBoardBombPot: json["doubleBoardBombPot"] ?? false,
        bombPotInterval: json["bombPotInterval"] ?? 15,
       // bombPotIntervalInSecs: json["bombPotIntervalInSecs"] ?? 15,
        bombPotEveryHand: json["bombPotEveryHand"] ?? false,
        seatChangeAllowed: json["seatChangeAllowed"] ?? false,
        seatChangeTimeout: json["seatChangeTimeout"] ?? 10,
        waitlistAllowed: json["waitlistAllowed"] ?? false,
        breakAllowed: json["breakAllowed"] ?? false,
        breakLength: json["breakLength"] ?? 10,
        pauseEachResultInSecs: json["pauseEachResultInSecs"] ?? 5,
        ipCheck: json["ipCheck"] ?? false,
        gpsCheck: json["gpsCheck"] ?? false,
        roeGames: json["roeGames"] ?? [],
        dealerChoiceGames: json["dealerChoiceGames"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "buyInApproval": buyInApproval,
        "runItTwiceAllowed": runItTwiceAllowed,
        "allowRabbitHunt": allowRabbitHunt,
        "showHandRank": showHandRank,
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
        // "pauseEachResultInSecs": pauseEachResultInSecs,
        "ipCheck": ipCheck,
        "gpsCheck": gpsCheck,
        "roeGames": roeGames,
        "dealerChoiceGames": dealerChoiceGames,
      };
}
