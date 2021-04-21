import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class GameService {
  static String leaveGameQuery = """
    mutation (\$gameCode: String!) {
      confirmed: leaveGame(gameCode: \$gameCode)
    }
    """;

  GameService._();

  /* this method confirms the seat change */
  static Future<bool> confirmSeatChange(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
        confirmSeatChange(gameCode: $gameCode)
      }""";

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['confirmSeatChange'];
  }

  /* The following method returns back the Game Info Model */
  static Future<GameInfoModel> getGameInfo(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = GameInfoModel.query(gameCode);

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;

    final jsonResponse = result.data['gameInfo'];
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(jsonResponse);
    debugPrint(prettyprint, wrapWidth: 4096);
    return GameInfoModel.fromJson(jsonResponse);
  }

  /* this method joins the game at a particular seat number */
  static Future<String> joinGame(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      joinGame(gameCode: "$gameCode", seatNo: $seatNo)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['joinGame'];
  }

  /* player switches to a open seat */
  static Future<String> switchSeat(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      switchSeat(gameCode: "$gameCode", seatNo: $seatNo)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['switchSeat'];
  }

  /* the following method facilitates buying chips */
  static Future<String> buyIn(String gameCode, int amount) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      buyIn(gameCode:"$gameCode", amount: $amount){
        approved
      }
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['approved'];
  }

  /* query current hand method is to get in between insight in a game */
  static void queryCurrentHand(String gameCode, Function(String) send) async {
    assert(send != null);

    String playerID = await AuthService.getPlayerID();

    String _query = """{
      "gameCode": "$gameCode",
      "messageType": "QUERY_CURRENT_HAND",
      "playerId": "$playerID"
    }""";

    send(_query);
  }

  static Future<String> configureClubGame(
      String clubCode, NewGameModel input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$clubCode: String!, \$gameInput: GameCreateInput!){
            configuredGame: configureGame(clubCode: \$clubCode, game: \$gameInput) {
              gameCode
            }
          }
          """;
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "gameInput": input.toJson(),
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
    Map game = (result.data as LazyCacheMap).data['configuredGame'];
    String gameCode = game["gameCode"];
    log('Created game: $gameCode');
    return gameCode;
  }

  static Future<String> startGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: startGame(gameCode: \$gameCode)
          }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
    Map game = (result.data as LazyCacheMap).data;
    String status = game["status"];
    log('Game code: $gameCode status: $status');
    return status;
  }

  static Future<String> pauseGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: pauseGame(gameCode: \$gameCode)
          }""";

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    Map game = (result.data as LazyCacheMap).data;
    String status = game["status"];
    log('Game code: $gameCode status: $status');

    return status;
  }

  static Future<String> resumeGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: resumeGame(gameCode: \$gameCode)
          }""";

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    Map game = (result.data as LazyCacheMap).data;
    String status = game["status"];
    log('Game code: $gameCode status: $status');

    return status;
  }

  /* this method ends the game */
  static Future<String> endGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation (\$gameCode: String!) {  
        endGame(gameCode: \$gameCode)
    }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation), variables: variables),
    );

    if (result.hasException) return null;

    // FIXME: We need to get the proper return value
    return "ended";
  }

  /* this method ends the game */
  static Future<String> leaveGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(leaveGameQuery), variables: variables),
    );

    if (result.hasException) return null;

    // FIXME: We need to get the proper return value
    return "ended";
  }

  /* returns token used for live audio */
  static Future<String> getLiveAudioToken(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
          query (\$gameCode: String!){
            token: liveAudioToken(gameCode: \$gameCode)
          }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return '';

    return result.data['token'].toString();
  }
}
