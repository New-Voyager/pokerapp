import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/highrank_stats_model.dart';
import 'package:pokerapp/models/hand_stats_model.dart';
import 'package:pokerapp/models/player_performance_model.dart';

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

  gamePlayers(gameCode: \$gameCode) {
    id
    uuid
    name
  }

}
  """;
  static final String getAllTimeStatsOnlyQuery = """

query {
  playerHandStats {
    totalHands
    totalGames
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
    totalGames
    totalPlayersInHand
    totalPlayersInShowdown    
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
    totalGames
    totalPlayersInHand
    totalPlayersInShowdown    
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
    totalGames
    totalPlayersInHand
    totalPlayersInShowdown    
  }
}

  """;

  static final String systemStatsQuery = """
query systemStats {
  holdem: systemStats(gameType: HOLDEM) {
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
    totalGames
    totalPlayersInHand
    totalPlayersInShowdown    
  }
  plo: systemStats(gameType: PLO) {
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
    totalGames
    totalPlayersInHand
    totalPlayersInShowdown    
  }
  fivecard_plo: systemStats(gameType: FIVE_CARD_PLO) {
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
    totalGames
    totalPlayersInHand
    totalPlayersInShowdown    
  }
}

  """;

  static final String playerRecentPerformanceQuery = """
    query recentPerformance{
      perf: playerRecentPerformance
    }  
  """;

  static Future<HandStatsModel> getStatsForAGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getStatsForGameQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final handStats = HandStatsModel.fromJson(result.data);
    return handStats;
  }

  static Future<HandStatsModel> getAlltimeStatsOnly() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client
        .query(QueryOptions(document: gql(getAllTimeStatsOnlyQuery)));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final handStats = StatModel.fromJson(result.data['playerHandStats']);
    return HandStatsModel(
      alltime: handStats,
    );
  }

  static Future<HighRankStatsModel> getClubStats(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(clubStatsQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final clubStats = HighRankStatsModel.fromJson(result.data);
    return clubStats;
  }

  static Future<HighRankStatsModel> getSystemStats() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result =
        await _client.query(QueryOptions(document: gql(systemStatsQuery)));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final systemStats = HighRankStatsModel.fromJson(result.data);
    return systemStats;
  }

  static Future<PlayerPerformanceList> getPlayerRecentPerformance() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client
        .query(QueryOptions(document: gql(playerRecentPerformanceQuery)));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final performance = PlayerPerformanceList.fromJson(result.data['perf']);
    return performance;
  }
}
