enum GameStages {
  PREFLOP,
  FLOP,
  TURN,
  RIVER,
  SHOWDOWN,
}

GameStages getGameStage(String stage) {
  stage = stage.toUpperCase();
  if (stage == 'PREFLOP') {
    return GameStages.PREFLOP;
  } else if (stage == 'FLOP') {
    return GameStages.FLOP;
  } else if (stage == 'TURN') {
    return GameStages.TURN;
  } else if (stage == 'RIVER') {
    return GameStages.RIVER;
  } else if (stage == 'SHOWDOWN' || stage == 'SHOW_DOWN') {
    return GameStages.SHOWDOWN;
  }
  return GameStages.PREFLOP;
}
