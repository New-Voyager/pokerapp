import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/models/rewards_model.dart';

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

  static Future<List<Rewards>> getRewards(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": clubCode};
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(getRewardsQuery), variables: variables));

    if (result.hasException) return [];

    final List jsonResponse = result.data['rewards'];

    // log(jsonEncode(jsonResponse).toString());
    // List<Rewards> rewards = [];
    // jsonResponse.forEach((element) {
    //   rewards.add(Rewards.fromJson(element));
    // });
    // log(rewards.toString());
    // return RewardsModel.fromJson(jsonEncode(jsonResponse));
    return jsonResponse
        .map<Rewards>((var reward) => Rewards.fromJson(reward))
        .toList();
  }
}
