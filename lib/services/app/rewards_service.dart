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

  static Future<bool> createReward(String name, String schedule, int amount,
      String type, String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> input = {
      "name": name,
      "schedule": schedule,
      "amount": amount,
      "type": type
    };
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "input": input,
    };
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(createRewardMutation), variables: variables));
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
        name
      }
    }
    """;

  static Future<List<Rewards>> getRewards(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": clubCode};
    QueryResult result = await _client.query(
        QueryOptions(document: gql(getRewardsQuery), variables: variables));

    if (result.hasException) return [];

    final List jsonResponse = result.data['rewards'];
    return jsonResponse
        .map<Rewards>((var reward) => Rewards.fromJson(reward))
        .toList();
  }
}
