import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/hand_log_model.dart';

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
          hand: specificHandHistory(gameCode: \$gameCode, handNum: \$handNum) {
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

  static void getAllHands(HandHistoryListModel model) async {
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

  static void getHandLog(HandLogModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
      "handNum": model.handNumber.toString()
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(handLogData), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }
}
