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

String gameTypeStr(GameType type) {
  switch(type) {
    case GameType.HOLDEM:
      return "No Limit Holdem";
    case GameType.PLO:
      return "PLO";
    case GameType.PLO_HILO:
      return "PLO Hi-Lo";
    case GameType.FIVE_CARD_PLO:
      return "5 card PLO";
    case GameType.FIVE_CARD_PLO_HILO:
      return "5 card PLO Hi-Lo";
    case GameType.ROE:
      return "Round of Each";
    case GameType.DEALER_CHOICE:
      return "Dealer Choice";
    default:
      return "Unknown";
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