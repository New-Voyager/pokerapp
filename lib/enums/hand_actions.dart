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
  POST_BLIND,
  UNKNOWN,
}

String handActionsToString(HandActions action) {
  return action.toString().split(".").last;
}
