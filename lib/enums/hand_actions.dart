enum HandActions {
  SB,
  BB,
  CALL,
  CHECK,
  BET,
  RAISE,
  FOLD,
  STRADDLE,
  UNKNOWN,
}

String handActionsToString(HandActions action) {
  return action.toString().split(".").last;
}
