import 'dart:convert';

GameSettingsInput gameSettingsInputFromJson(String str) => GameSettingsInput.fromJson(json.decode(str));

String gameSettingsInputToJson(GameSettingsInput data) => json.encode(data.toJson());

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
        this.bombPotIntervalInSecs,
        this.bombPotEveryHand,
        this.seatChangeAllowed,
        this.seatChangeTimeout,
        this.waitlistAllowed,
        this.breakAllowed,
        this.breakLength,
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
    dynamic bombPotIntervalInSecs;
    bool bombPotEveryHand;
    bool seatChangeAllowed;
    int seatChangeTimeout;
    bool waitlistAllowed;
    bool breakAllowed;
    int breakLength;
    bool ipCheck;
    bool gpsCheck;
    dynamic roeGames;
    dynamic dealerChoiceGames;

    factory GameSettingsInput.fromJson(Map<String, dynamic> json) => GameSettingsInput(
        buyInApproval: json["buyInApproval"],
        runItTwiceAllowed: json["runItTwiceAllowed"],
        allowRabbitHunt: json["allowRabbitHunt"],
        showHandRank: json["showHandRank"],
        doubleBoardEveryHand: json["doubleBoardEveryHand"],
        bombPotEnabled: json["bombPotEnabled"],
        bombPotBet: json["bombPotBet"],
        doubleBoardBombPot: json["doubleBoardBombPot"],
        bombPotInterval: json["bombPotInterval"],
        bombPotIntervalInSecs: json["bombPotIntervalInSecs"],
        bombPotEveryHand: json["bombPotEveryHand"],
        seatChangeAllowed: json["seatChangeAllowed"],
        seatChangeTimeout: json["seatChangeTimeout"],
        waitlistAllowed: json["waitlistAllowed"],
        breakAllowed: json["breakAllowed"],
        breakLength: json["breakLength"],
        ipCheck: json["ipCheck"],
        gpsCheck: json["gpsCheck"],
        roeGames: json["roeGames"],
        dealerChoiceGames: json["dealerChoiceGames"],
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
        "bombPotIntervalInSecs": bombPotIntervalInSecs,
        "bombPotEveryHand": bombPotEveryHand,
        "seatChangeAllowed": seatChangeAllowed,
        "seatChangeTimeout": seatChangeTimeout,
        "waitlistAllowed": waitlistAllowed,
        "breakAllowed": breakAllowed,
        "breakLength": breakLength,
        "ipCheck": ipCheck,
        "gpsCheck": gpsCheck,
        "roeGames": roeGames,
        "dealerChoiceGames": dealerChoiceGames,
    };
}
