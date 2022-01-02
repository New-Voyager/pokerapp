import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game/game_player_settings.dart';
import 'package:pokerapp/models/game/game_settings.dart';

class GameSettingsService {
  static String updateGameSettingsQuery = """
mutation updateInputs(\$gameCode :String!,\$inputSettings: GameSettingsUpdateInput!){
  ret:updateGameSettings(gameCode :\$gameCode settings:\$inputSettings)
}
  """;

  static String getGameSettingsQuery = """
    query gameSettings(\$gameCode: String!) {
      ret:gameSettings(gameCode :\$gameCode){
        audioConfEnabled
        buyInApproval
        buyInLimit
        runItTwiceAllowed
        allowRabbitHunt
        showHandRank
        doubleBoardEveryHand
        bombPotEnabled
        bombPotBet
        doubleBoardBombPot
        bombPotInterval
        bombPotIntervalInSecs
        bombPotEveryHand
        seatChangeAllowed
        seatChangeTimeout
        waitlistAllowed
        seatChangeTimeout
        waitlistAllowed
        breakAllowed
        breakLength
        ipCheck
        gpsCheck
        roeGames
        dealerChoiceGames
        resultPauseTime
        funAnimations
        chat
        showResult
      }
    }
""";

  static String getGamePlayerSettingsQuery = """
query mySettings(\$gameCode:String!){
  ret:myGameSettings(gameCode:\$gameCode){
    autoStraddle
    straddle
    buttonStraddle
    bombPotEnabled
    muckLosingHand
    runItTwiceEnabled
  }
}
  """;

  static String updateGamePlayerSettingsQuery = """
  mutation updatePlayerInputs(\$gameCode :String!,\$settings: GamePlayerSettingsUpdateInput!){
    ret:updateGamePlayerSettings(gameCode :\$gameCode settings:\$settings)
  }
  """;

  static Future<GameSettings> getGameSettings(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"gameCode": gameCode};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getGameSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return null;
    }

    try {
      final GameSettings gameSettings =
          gameSettingsInputFromJson(jsonEncode(result.data['ret']));
      return gameSettings;
    } catch (e) {
      log("Exception : ${e.toString()}");
      return null;
    }
  }

  static Future<bool> updateGameSettings(
      String gameCode, GameSettings input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "inputSettings": input.toJson()
    };
    QueryResult result = await _client.query(QueryOptions(
        document: gql(updateGameSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return false;
    }

    if (result.data['ret'] ?? true) {
      return true;
    }
    return false;
  }

  static Future<bool> updateBombPot(String gameCode,
      {GameType gameType,
      bool enableBombPot,
      int bombPotBet,
      bool bombPotNextHand,
      bool bombPotEveryHand,
      bool doubleBoardBombPot}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "inputSettings": {}
    };
    Map<String, dynamic> settings = {};
    if (gameType != null) {
      settings["bombPotGameType"] = gameType.toJson();
    }

    if (enableBombPot != null) {
      settings["bombPotEnabled"] = enableBombPot;
    }

    if (bombPotBet != null) {
      settings["bombPotBet"] = bombPotBet;
    }

    if (bombPotNextHand != null) {
      settings["bombPotNextHand"] = bombPotNextHand;
    }

    if (bombPotEveryHand != null) {
      settings["bombPotEveryHand"] = bombPotEveryHand;
    }

    if (doubleBoardBombPot != null) {
      settings["doubleBoardBombPot"] = doubleBoardBombPot;
    }
    variables["inputSettings"] = settings;

    QueryResult result = await _client.query(QueryOptions(
        document: gql(updateGameSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return false;
    }

    if (result.data['ret'] ?? true) {
      return true;
    }
    return false;
  }

  static Future<GamePlayerSettings> getGamePlayerSettings(
      String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"gameCode": gameCode};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getGamePlayerSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return null;
    }

    try {
      final GamePlayerSettings playerSettings =
          gamePlayerSettingsInputFromJson(jsonEncode(result.data['ret']));
      return playerSettings;
    } catch (e) {
      log("Exception : ${e.toString()}");
      return null;
    }
  }

  /// Update game player settings for a game
  static Future<bool> updateGamePlayerSettings(
      String gameCode, GamePlayerSettings input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "settings": input.toJson()
    };
    QueryResult result = await _client.query(QueryOptions(
        document: gql(updateGamePlayerSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return false;
    }

    if (result.data['ret'] ?? true) {
      return true;
    }
    return false;
  }
}
