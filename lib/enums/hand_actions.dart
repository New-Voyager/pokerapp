enum HandActions {
  NONE,
  SB,
  BB,
  CALL,
  CHECK,
  BET,
  RAISE,
  FOLD,
  STRADDLE,
  ALLIN,
  BOMB_POT_BET,
  UNKNOWN,
}

String handActionsToString(HandActions action) {
  return action.toString().split(".").last;
}
