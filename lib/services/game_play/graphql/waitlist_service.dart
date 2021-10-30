import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/waiting_list_model.dart';

class WaitlistService {
  static String addToWaitListQuery = """
    mutation addToWaitList(\$gameCode: String!) {
    confirmed: addToWaitingList(gameCode: \$gameCode)
  }
  """;

  static String removeFromWaitlistQuery = """
    mutation removeFromWaitlist(\$gameCode: String!) {
    confirmed: removeFromWaitingList(gameCode: \$gameCode)
  }
  """;

  static String waitlistQuery = """
   query waitlist(\$gameCode: String!) {
      waitingList(gameCode: \$gameCode) {
        playerUuid
        name
        waitingFrom
      }
    }
  """;
  static String changeWaitlistOrderQuery = """
   mutation(\$gameCode: String!, \$players: [String!]) {
    applyWaitlistOrder(gameCode: \$gameCode, playerUuid: \$players)
  }
  """;

  static Future<bool> changeWaitListOrderList(
      String gameCode, List<String> uuids) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "players": uuids,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(changeWaitlistOrderQuery),
        variables: variables,
      ),
    );
    if (result.hasException) return false;

    return result.data['applyWaitlistOrder'] ?? false;
  }

  static Future<bool> addToWaitList(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(addToWaitListQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return false;

    return result.data['confirmed'] ?? false;
  }

  static Future<bool> removeFromWaitlist(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(removeFromWaitlistQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return false;

    return result.data['confirmed'] ?? false;
  }

  static Future<List<WaitingListModel>> listOfWaitingPlayer(
      String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<WaitingListModel> waitingListPlayers = [];
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(waitlistQuery), variables: variables));
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    List players = result.data['waitingList'];
    waitingListPlayers = players.map((e) {
      WaitingListModel player = WaitingListModel.fromJson(e);
      return player;
    }).toList();
    return waitingListPlayers;
  }
}
