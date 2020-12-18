import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class GameService {
  GameService._();

  /* The following method returns back the Game Info Model */
  static Future<GameInfoModel> getGameInfo(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = GameInfoModel.query(gameCode);

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;

    final jsonResponse = result.data['gameInfo'];

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
}
