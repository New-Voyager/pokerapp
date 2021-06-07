import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/services/app/handlog_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        query (\$gameCode: String! \$handNum: String!) {
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

  static Future<void> getAllHands(HandHistoryListModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    // print(allHands);
    QueryResult result = await _client
        .query(QueryOptions(documentNode: gql(allHands), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }

  static Future<HandLogModelNew> getHandLog(
      String gameCode, int handNum) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (!HandlogCacheService.needToFetch(gameCode, handNum, prefs)) {
    //   final data = HandlogCacheService.getFromCache(gameCode, handNum,prefs);
    //   final handLog =
    //       HandLogModelNew.handLogModelNewFromJson(data, serviceResult: true);
    //   return handLog;
    // }

    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    log("Trying to get GameCode: $gameCode; handNum: $handNum");
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    String query = handLogData;
    if (handNum != -1) {
      variables["handNum"] = handNum.toString();
    } else {
      query = lastHandLogData;
    }
    log("variables: $variables");
    QueryResult result = await _client
        .query(QueryOptions(documentNode: gql(query), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    // model.jsonData = result.data;
    // model.load();
    final data = jsonEncode(result.data);
    // HandlogCacheService.saveToCache(gameCode, handNum, data, prefs);

    // log("DATA\n: $data");
    final handLog =
        HandLogModelNew.handLogModelNewFromJson(data, serviceResult: true);
    return handLog;
  }

/*   static Future<bool> saveStarredHand(String gameCode, String handNum) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "handNum": handNum,
    };

    QueryResult result = await _client.mutate(MutationOptions(
        documentNode: gql(saveStarredHandMutation), variables: variables));
    if (result.hasException) {
      print(result.exception);
      return false;
    }
    return true;
  }
 */
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
        documentNode: gql(shareHandMutation), variables: variables));
    if (result.hasException) {
      print(result.exception);
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
        MutationOptions(documentNode: gql(bookmarkHand), variables: variables));
    //print("Bookmarking API : ${result.data.values}");

    if (result.hasException) {
      print("Exception in BookmarkHand: ${result.exception}");
      return false;
    }
    return true;
  }

  static Future<bool> removeBookmark(int bookmarkId) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"bookmarkId": bookmarkId};

    log("Variables : $variables");
    QueryResult result = await _client.mutate(MutationOptions(
        documentNode: gql(removeBookmarkedHand), variables: variables));
    //print("Bookmarking API : ${result.data.values}");

    if (result.hasException) {
      print("Exception in removing BookmarkHand: ${result.exception}");
      return false;
    }
    return true;
  }

  static getBookMarkedHands() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    // Map<String, dynamic> variables = {
    //   "gameCode": gameCode,
    //   "handNum": handNum,
    // };

    //  log("Variables : $variables");
    QueryResult result = await _client.mutate(MutationOptions(
      documentNode: gql(bookmarkedHands),
    ));
    //print("Bookmarking API : ${result.data.values}");
    log("results : ${result.data.keys}");
    log("results : ${result.data.values}");

    if (result.hasException) {
      print("Exception in BookmarkHand: ${result.exception}");
      return null;
    }
    return result.data;
  }

  static Future<dynamic> getBookmarkedHandsForGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      //   "handNum": handNum,
    };

    //  log("Variables : $variables");
    QueryResult result = await _client.mutate(MutationOptions(
        documentNode: gql(bookmarkedHandsForGame), variables: variables));
    // print("Bookmarking DFGSDFG API : ${result.data.values}");
    // print("Bookmarking DFGSDFG API : ${result.data.keys}");

    if (result.hasException) {
      print("Exception in BookmarkHand for game: ${result.exception}");
      return null;
    }
    return result.data;
  }
}
