import 'package:pokerapp/models/ui/app_text.dart';

enum GameType {
  UNKNOWN,
  HOLDEM,
  PLO,
  PLO_HILO,
  FIVE_CARD_PLO,
  FIVE_CARD_PLO_HILO,
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
      return 'Pot Limit Omaha Hi/Lo';
    case GameType.FIVE_CARD_PLO:
      return '5 Card Pot Limit Omaha';
    case GameType.FIVE_CARD_PLO_HILO:
      return '5 Card Pot Limit Omaha Hi/Lo';
    case GameType.ROE:
      return 'Round of Each';
    case GameType.DEALER_CHOICE:
      return 'Dealer Choice';
    default:
      return 'Unknown';
  }
}

String gameTypeShortStr(GameType type) {
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
    case GameType.ROE:
      return appTextScreen["ROUNDOFEACH"];
    case GameType.DEALER_CHOICE:
      return appTextScreen["DEALERCHOICE"];
    default:
      return appTextScreen["UNKNOWN"];
  }
}

GameType gameTypeFromStr(String gameTypeStr) {
  List<String> types = GameType.values.map((e) => e.toString()).toList();
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
  ];
}

List<GameType> gameChoices() {
  return [
    GameType.HOLDEM,
    GameType.PLO,
    GameType.PLO_HILO,
    GameType.FIVE_CARD_PLO,
    GameType.FIVE_CARD_PLO_HILO,
    GameType.ROE,
    GameType.DEALER_CHOICE,
  ];
}
