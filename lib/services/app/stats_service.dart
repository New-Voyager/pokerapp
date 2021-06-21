import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_stats_model.dart';

class StatsService {
  StatsService._();
  static final String getStatsForGameQuery = """

query (\$gameCode: String!) {
  playerHandStats {
    totalHands
    inPreflop
    inFlop
    inTurn
    inRiver
    wonAtShowDown
    wentToShowDown

		vpipCount
    preflopRaise
    postflopRaise
    threeBet
    contBet
    allInCount
    
    headsupHands
    wonHeadsupHands
    headsupHandSummary
    
    
  }
  
  playerGameStats(gameCode:\$gameCode) {
    
    totalHands
    inPreflop
    inFlop
    inTurn
    inRiver
    wonAtShowDown
    wentToShowDown

		vpipCount
    preflopRaise
    postflopRaise
    threeBet
    contBet
    allInCount
    
    headsupHands
    wonHeadsupHands
    headsupHandDetails
  }
}
  """;

  static Future<HandStatsModel> getStatsForAGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    String query = getStatsForGameQuery;
    QueryResult result = await _client
        .query(QueryOptions(documentNode: gql(query), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    // model.jsonData = result.data;
    // model.load();
    //final d = jsonEncode(result.data);
    // HandlogCacheService.saveToCache(gameCode, handNum, data, prefs);

    // log("-=-=-STAT raw DATA\n: ${result.data.data}");
    // log(
    //   "-=-=-STAT DATA\n $d",
    // );
    final handStats = HandStatsModel.fromJson(result.data.data);
    return handStats;
  }
}
