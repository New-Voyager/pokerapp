import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_stats_model.dart';
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

  static final String clubStatsQuery = """

query clubStats(\$clubCode: String!) {
  holdem: clubStats(gameType: HOLDEM, clubCode: \$clubCode) {
    straightAFlush
    straightKFlush
    straightQFlush
    straightJFlush
    straightTFlush
    straight9Flush
    straight8Flush
    straight7Flush
    straight6Flush
    straight5Flush

    fourAAAA
    fourKKKK
    fourQQQQ
    fourJJJJ
    fourTTTT
    four9999
    four8888
    four7777
    four6666
    four5555
    four4444
    four3333
    four2222

    totalHands
  }
  plo: clubStats(gameType: PLO, clubCode: \$clubCode) {
    straightAFlush
    straightKFlush
    straightQFlush
    straightJFlush
    straightTFlush
    straight9Flush
    straight8Flush
    straight7Flush
    straight6Flush
    straight5Flush

    fourAAAA
    fourKKKK
    fourQQQQ
    fourJJJJ
    fourTTTT
    four9999
    four8888
    four7777
    four6666
    four5555
    four4444
    four3333
    four2222

    totalHands

  }
    fivecard_plo: clubStats(gameType: FIVE_CARD_PLO, clubCode: \$clubCode) {
    straightAFlush
    straightKFlush
    straightQFlush
    straightJFlush
    straightTFlush
    straight9Flush
    straight8Flush
    straight7Flush
    straight6Flush
    straight5Flush

    fourAAAA
    fourKKKK
    fourQQQQ
    fourJJJJ
    fourTTTT
    four9999
    four8888
    four7777
    four6666
    four5555
    four4444
    four3333
    four2222

    totalHands
  }
}

  """;

  static Future<HandStatsModel> getStatsForAGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(QueryOptions(
        documentNode: gql(getStatsForGameQuery), variables: variables));

    if (result.hasException) return null;

    final handStats = HandStatsModel.fromJson(result.data.data);
    return handStats;
  }

  static Future<ClubStatsModel> getClubStats(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(clubStatsQuery), variables: variables));

    if (result.hasException) return null;

    final clubStats = ClubStatsModel.fromJson(result.data.data);
    return clubStats;
  }
}
