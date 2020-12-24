import 'package:pokerapp/models/create_game_input.dart';

class CreateGame {
  static String createGame(String clubCode, String gameInput) => """
  mutation{
  configuredGame: configureGame(clubCode: $clubCode, game: $gameInput) {
    gameCode
  }
  }
  """;

  static String createGameInput(CreateGameInput createGameInput) => """
      { 
    "title": ${createGameInput.title},
    "gameType": ${createGameInput.gameType},
    "smallBlind":${createGameInput.smallBlind},
    "bigBlind":${createGameInput.bigBlind},
    "utgStraddleAllowed":${createGameInput.utgStraddleAllowed},
    "straddleBet":${createGameInput.straddleBet},
    "minPlayers":${createGameInput.minPlayers},
    "maxPlayers":${createGameInput.maxPlayers},
    "gameLength":${createGameInput.gameLength},
    "buyInApproval":${createGameInput.buyInApproval},
    "rakePercentage":${createGameInput.rakePercentage},
    "rakeCap":${createGameInput.rakeCap},
    "buyInMin":${createGameInput.buyInMin},
    "buyInMax":${createGameInput.buyInMax},
    "actionTime":${createGameInput.actionTime}
  }
  """;
}
