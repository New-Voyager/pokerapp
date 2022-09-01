import 'package:pokerapp/models/ui/app_text.dart';

enum GameType {
  UNKNOWN,
  HOLDEM,
  PLO,
  PLO_HILO,
  FIVE_CARD_PLO,
  FIVE_CARD_PLO_HILO,
  SIX_CARD_PLO,
  SIX_CARD_PLO_HILO,
  ROE,
  DEALER_CHOICE,
}

extension GameTypeSerialization on GameType {
  String toJson() => this.toString().split(".").last;
  static GameType fromJson(String s) =>
      GameType.values.firstWhere((gameType) => gameType.toJson() == s);
}

String gameTypeStr(GameType type) {
  AppTextScreen appTextScreen = getAppTextScreen("gameType");
  switch (type) {
    case GameType.HOLDEM:
      return appTextScreen['NOLIMITHOLDEM'];
    case GameType.PLO:
      return appTextScreen['PLO'];
    case GameType.PLO_HILO:
      return appTextScreen['PLOHILO'];
    case GameType.FIVE_CARD_PLO:
      return appTextScreen['FIVECARDPLO'];
    case GameType.FIVE_CARD_PLO_HILO:
      return appTextScreen['FIVECARDPLOHILO'];
    case GameType.SIX_CARD_PLO:
      return appTextScreen['SIXCARDPLO'];
    case GameType.SIX_CARD_PLO_HILO:
      return appTextScreen['SIXCARDPLOHILO'];
    case GameType.ROE:
      return appTextScreen['ROE'];
    case GameType.DEALER_CHOICE:
      return appTextScreen['DEALERCHOICE'];
    default:
      return appTextScreen["UNKNOWN"];
  }
}

String gameTypeStr2(GameType type) {
  switch (type) {
    case GameType.HOLDEM:
      return 'No Limit Holdem';
    case GameType.PLO:
      return 'Pot Limit Omaha';
    case GameType.PLO_HILO:
      return 'Pot Limit Omaha Hi-Lo';
    case GameType.FIVE_CARD_PLO:
      return '5 Card PLO';
    case GameType.FIVE_CARD_PLO_HILO:
      return '5 Card PLO Hi-Lo';
    case GameType.SIX_CARD_PLO:
      return '6 Card PLO';
    case GameType.SIX_CARD_PLO_HILO:
      return '6 Card PLO Hi-Lo';
    case GameType.ROE:
      return 'Round of Each';
    case GameType.DEALER_CHOICE:
      return 'Dealer Choice';
    default:
      return 'Unknown';
  }
}

String gameTypeShortStr2(GameType type) {
  AppTextScreen appTextScreen = getAppTextScreen("gameTypeShort");

  switch (type) {
    case GameType.HOLDEM:
      return appTextScreen["NLH"];
    case GameType.PLO:
      return appTextScreen["PLO"];
    case GameType.PLO_HILO:
      return appTextScreen["PLOHILO"];
    case GameType.FIVE_CARD_PLO:
      return appTextScreen["5CARDPLO"];
    case GameType.FIVE_CARD_PLO_HILO:
      return appTextScreen["5CARDPLOHILO"];
    case GameType.SIX_CARD_PLO:
      return appTextScreen["6CARDPLO"];
    case GameType.SIX_CARD_PLO_HILO:
      return appTextScreen["6CARDPLOHILO"];
    case GameType.ROE:
      return appTextScreen["ROUNDOFEACH"];
    case GameType.DEALER_CHOICE:
      return appTextScreen["DEALERCHOICE"];
    default:
      return appTextScreen["UNKNOWN"];
  }
}

String gameTypeShortStr(GameType type) {
  switch (type) {
    case GameType.HOLDEM:
      return "NLH";
    case GameType.PLO:
      return "PLO";
    case GameType.PLO_HILO:
      return "Hi-Lo";
    case GameType.FIVE_CARD_PLO:
      return "5 Card PLO";
    case GameType.FIVE_CARD_PLO_HILO:
      return "5 Card Hi-Lo";
    case GameType.SIX_CARD_PLO:
      return "6 Card PLO";
    case GameType.SIX_CARD_PLO_HILO:
      return "6 Card Hi-Lo";
    case GameType.ROE:
      return "ROE";
    case GameType.DEALER_CHOICE:
      return "Dealer Choice";
    default:
      return "Unknown";
  }
}

GameType gameTypeFromStr(String gameTypeStr) {
  List<String> types = GameType.values.map((e) => e.toString()).toList();
  if (gameTypeStr.indexOf('GameType.') != -1) {
    gameTypeStr = gameTypeStr.replaceAll('GameType.', '');
  }
  int i = types.indexOf('GameType.' + gameTypeStr);
  if (i != -1) {
    return GameType.values
        .firstWhere((e) => e.toString() == 'GameType.' + gameTypeStr);
  } else {
    return GameType.UNKNOWN;
  }
}

List<GameType> roeGameChoices() {
  return [
    GameType.HOLDEM,
    GameType.PLO,
    GameType.PLO_HILO,
    GameType.FIVE_CARD_PLO,
    GameType.FIVE_CARD_PLO_HILO,
    GameType.SIX_CARD_PLO,
    GameType.SIX_CARD_PLO_HILO,
  ];
}

List<GameType> gameChoices() {
  return [
    GameType.HOLDEM,
    GameType.PLO,
    GameType.PLO_HILO,
    GameType.FIVE_CARD_PLO,
    GameType.FIVE_CARD_PLO_HILO,
    GameType.SIX_CARD_PLO,
    GameType.SIX_CARD_PLO_HILO,
    GameType.ROE,
    GameType.DEALER_CHOICE,
  ];
}

enum ChipUnit {
  DOLLAR,
  CENT,
}

extension ChipUnitSerialization on ChipUnit {
  String toJson() => this.toString().split(".").last;
  static ChipUnit fromJson(String s) =>
      ChipUnit.values.firstWhere((chipUnit) => chipUnit.toJson() == s);
}

enum BuyInApprovalLimit {
  BUYIN_NO_LIMIT,
  BUYIN_CREDIT_LIMIT,
  BUYIN_HOST_APPROVAL
}

extension BuyInApprovalLimitSerialization on BuyInApprovalLimit {
  String toJson() => this.toString().split(".").last;
  static BuyInApprovalLimit fromJson(String s) =>
      BuyInApprovalLimit.values.firstWhere((e) => e.toJson() == s);
}
