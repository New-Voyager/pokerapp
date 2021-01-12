import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../main.dart';

class RewardService {
  static String createRewardMutation = """
    mutation createReward(\$clubCode: String!, \$input: RewardInput!) {
  	id: createReward(clubCode:\$clubCode, input: \$input) 
    }
  """;

  static Future<bool> createReward() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> input = {
      "name": "NLH High Hand",
      "schedule": "ENTIRE_GAME",
      "amount": 200,
      "type": "HIGH_HAND"
    };
    Map<String, dynamic> variables = {
      "clubCode": "C-YPMXAK",
      "input": input,
    };
    QueryResult result = await _client.mutate(MutationOptions(
        documentNode: gql(createRewardMutation), variables: variables));
    if (result.hasException) return false;
    log(result.data.toString());
    return true;
  }

  static String getRewardsQuery = """
    query rewards(\$clubCode: String!) {
      rewards(clubCode: \$clubCode) {
        id
        type
        amount
        schedule
        startHour
      }
    }
    """;

  static Future<List<String>> getRewards(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": "C-YPMXAK"};
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(getRewardsQuery), variables: variables));

    if (result.hasException) return [];

    final jsonResponse = result.data['rewards'];

    log(jsonResponse.toString());
    return ["testing"];
  }
}
