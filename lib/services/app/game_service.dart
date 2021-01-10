import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/table_record.dart';

class GameService {
  static String gameDetailQuery = """
      query completedGame(\$gameCode: String!) {
        completedGame(gameCode: \$gameCode) {
          gameType
          gameCode
          gameNum
          startedBy
          startedAt
          endedBy
          endedAt
          sessionTime
          handsPlayed
          runTime
          runTimeStr
          sessionTimeStr
          smallBlind
          bigBlind
          balance
          handsWon
          handsPlayed
          bigWin
          bigWinHand
          bigLoss
          bigLossHand
          preflopHands
          flopHands
          turnHands
          riverHands
          showdownHands
          balance
          handsDealt
          profit
          buyIn
          stackStat {
            handNum
            before
            after
          }
        }
        highHandsByGame(gameCode: \$gameCode) {
            rank
            handNum
            boardCards
            playerCards
            highHand
            highHandCards
            handTime
        }
      }  
  """;
  static Future<GameHistoryDetailModel> getGameHistoryDetail(
      GameHistoryDetailModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(gameDetailQuery), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }

  static String gameResultTableQuery = """
      query game_result_table(\$gameCode: String!) {
        gameResultTable(gameCode: \$gameCode) {
          playerName
          sessionTime
          sessionTimeStr
          handsPlayed
          buyIn
          profit
          rakePaid
        }
      }
  """;
  static Future<TableRecord> getGameTableRecord(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(gameResultTableQuery), variables: variables));

    if (result.hasException) return null;

    return TableRecord.fromJson(result.data['gameResultTable']);
  }
}
