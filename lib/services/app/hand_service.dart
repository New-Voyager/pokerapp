import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';

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

  static Future<void> getAllHands(HandHistoryListModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    print(allHands);
    QueryResult result = await _client
        .query(QueryOptions(documentNode: gql(allHands), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }

  static Future<HandLogModelNew> getHandLog(
      String gameCode, int handNum) async {
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
    QueryResult result = await _client
        .query(QueryOptions(documentNode: gql(query), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    // model.jsonData = result.data;
    // model.load();
    final data = jsonEncode(result.data);
    log("DATA\n: $data");
    final handLog =
        HandLogModelNew.handLogModelNewFromJson(data, serviceResult: true);
    return handLog;
  }

  static Future<bool> saveStarredHand(String gameCode, String handNum) async {
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

  static Future<bool> shareHand(
      String gameCode, int handNum, String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "handNum": handNum,
      "clubCode": clubCode,
    };

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

    QueryResult result = await _client.mutate(
        MutationOptions(documentNode: gql(bookmarkHand), variables: variables));
    if (result.hasException) {
      print(result.exception);
      return false;
    }
    return true;
  }
}
