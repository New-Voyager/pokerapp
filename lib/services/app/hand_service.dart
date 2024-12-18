import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/screens/game_screens/highhand_log/grouped_list_view.dart';

import 'auth_service.dart';

class HandService {
  static String allHands = """
        query (\$gameCode: String!) {
          allHands: allHandHistory(gameCode: \$gameCode) {
            handNum
            showDown
            winningRank
            winningCards
            wonAt
            totalPot    
            summary
            handTime
            timeEnded
            authorized
          }
          winningHands: myWinningHands(gameCode: \$gameCode) {
            handNum
            showDown
            winningRank
            winningCards
            wonAt
            totalPot    
            summary
            handTime
            authorized
          }          
          players: gamePlayers(gameCode: \$gameCode) {
              id
              name
            }
        }
  """;

  static String handLogData = """
        query (\$gameCode: String! \$handNum: Int!) {
          handResult: specificHandHistory(gameCode: \$gameCode, handNum: \$handNum) {
            data
            authorized
            totalPot
          }  
          players: gamePlayers(gameCode: \$gameCode) {
            id
            name
          }
          myInfo {
            id
            uuid
            name
          }
        }
    """;

  static String lastHandLogData = """
      query lasthand(\$gameCode: String!) {
        hand: lastHandHistory(gameCode: \$gameCode) {
          data
          authorized
          totalPot
        }
        players: gamePlayers(gameCode: \$gameCode) {
          id
          name
        }
        myInfo {
          id
          uuid
          name
        }
      }
  """;

  static String saveStarredHandMutation = """
    mutation(\$gameCode: String!, \$handNum: String!) {
      update: saveStarredHand(gameCode: \$gameCode, handNum: \$handNum)
    }
  """;

  static String shareHandMutation = """
    mutation(\$gameCode: String!, \$handNum: Int!, \$clubCode: String!) {
      update: shareHand(gameCode: \$gameCode, handNum: \$handNum, clubCode: \$clubCode)
    }
  """;

  static String bookmarkHand = """
   mutation(\$gameCode: String!, \$handNum: Int!) {
      update: bookmarkHand(gameCode: \$gameCode, handNum: \$handNum)
    }
  """;

  static String removeBookmarkedHand = """
   mutation(\$bookmarkId: Int!) {
      update: removeBookmark(bookmarkId: \$bookmarkId)
    }
  """;

  static String bookmarkedHands = """
    query bookMarkedHands {
    bookmarkedHands {
      id
      sharedBy{
        playerId
      }
      savedBy{
        name
      }
      sharedTo{
        name
      }
      gameCode
      handNum
      data
      updatedAt 
    }
  }
  """;
  static String bookmarkedHandsForGame = """
    query bookMarkedHandsForGame(\$gameCode : String!) {
    bookmarkedHandsByGame(gameCode: \$gameCode){
      id
      sharedBy{
        playerId
      }
      savedBy{
        name
      }
      sharedTo{
        name
      }
      gameCode
      handNum
      data
      updatedAt 
    }
  }
  """;

  static String debugHandLogQuery = """
    mutation debugHand(\$gameCode:String!, \$handNum:Int!) {
      debugHandLog(gameCode: \$gameCode, handNum: \$handNum)
    }
  """;

  static String searchHandsQuery = """
      query search(\$clubCode:String!, \$startDate:DateTime! \$endDate: DateTime!, \$gameTypes:[GameType!], \$minRank:Int!) {
        hands: searchHands(clubCode:\$clubCode, 
            startDate:\$startDate 
            endDate:\$endDate 
            gameTypes: \$gameTypes, 
            minRank: \$minRank) {
          rank
          handNum
          handTime
          gameCode
        }
      }
  """;

  static Future<void> getAllHands(HandHistoryListModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    QueryResult result = await _client
        .query(QueryOptions(document: gql(allHands), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }

  static Future<HandResultData> getHandLog(String gameCode, int handNum) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    log("Trying to get GameCode: $gameCode; handNum: $handNum");
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    String query = handLogData;
    if (handNum != -1) {
      variables["handNum"] = handNum;
    } else {
      query = lastHandLogData;
    }
    QueryResult result = await _client
        .query(QueryOptions(document: gql(query), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    final handResultData = result.data['handResult']['data'];
    dynamic handResultDataJson = handResultData;
    if (handResultData is String) {
      handResultDataJson = jsonDecode(handResultData);
    }
    final me = await AuthService.get();
    final handLog = HandResultData.fromJson(handResultDataJson);
    handLog.myPlayerId = me.playerId;
    return handLog;
  }

  static Future<bool> shareHand(
      String gameCode, int handNum, String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "handNum": handNum,
      "clubCode": clubCode
    };

    log("Variables : $variables");
    log("CODE IN GRAPHQL : $clubCode");

    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(shareHandMutation), variables: variables));
    if (result.hasException) {
      return false;
    }
    return true;
  }

  static Future<bool> bookMarkHand(String gameCode, int handNum) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "handNum": handNum,
    };

    log("Variables : $variables");
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(bookmarkHand), variables: variables));
    if (result.hasException) {
      return false;
    }
    return true;
  }

  static Future<bool> removeBookmark(int bookmarkId) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"bookmarkId": bookmarkId};

    log("Variables : $variables");
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(removeBookmarkedHand), variables: variables));

    if (result.hasException) {
      return false;
    }
    return true;
  }

  static getBookMarkedHands() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(QueryOptions(
      document: gql(bookmarkedHands),
    ));

    if (result.hasException) {
      return null;
    }
    return result.data;
  }

  static Future<dynamic> getBookmarkedHandsForGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.query(QueryOptions(
        document: gql(bookmarkedHandsForGame), variables: variables));

    if (result.hasException) {
      return null;
    }
    return result.data;
  }

  static Future<bool> debugHandLog(String gameCode, int handNum) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"gameCode": gameCode, "handNum": handNum};

    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(debugHandLogQuery), variables: variables));

    if (result.hasException) {
      return false;
    }
    return true;
  }

  static Future<dynamic> searchHands(String clubCode, DateTime startDate,
      DateTime endDate, List<GameType> gameTypes, int minRank) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    List<String> gameTypesStr =
        gameTypes.map((e) => e.toString().replaceAll('GameType.', '')).toList();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "gameTypes": gameTypesStr,
      "minRank": minRank,
    };

    QueryResult result = await _client.query(
        QueryOptions(document: gql(searchHandsQuery), variables: variables));

    if (result.hasException) {
      return null;
    }
    List<SearchHighHandResult> ret = [];
    for (final item in result.data['hands']) {
      ret.add(SearchHighHandResult.fromJson(item));
    }
    return ret;
  }
}
