int maxLength = 1000;

/*
This class tracks logs for each game. This is used for debugging.
*/
class GameLog {
  List<String> logs = [];

  void log(String msg) {
    if (logs.length > maxLength) {
      for (int i = 0; i < 20; i++) {
        logs.removeAt(0);
      }
    }
    logs.add(msg);
  }

  List<String> getLogs() {
    return logs;
  }
}

class GameLogger {
  Map<String, GameLog> loggers = Map<String, GameLog>();

  void log(String gameCode, String msg) {
    GameLog logger;
    if (!loggers.containsKey(gameCode)) {
      loggers[gameCode] = GameLog();
    }
    logger = loggers[gameCode];
    logger.log(msg);
  }

  GameLog getLogger(String gameCode) {
    GameLog logger;
    if (!loggers.containsKey(gameCode)) {
      loggers[gameCode] = GameLog();
    }
    logger = loggers[gameCode];
    return logger;
  }
}

GameLogger loggers = GameLogger();

debugLog(String gameCode, String msg) {
  loggers.log(gameCode, msg);
}

GameLog getDebugLogger(String gameCode) {
  return loggers.getLogger(gameCode);
}
