import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';

class HandService {
  static String allHands = """
        query (\$gameCode: String!) {
          hands: allHandHistory(gameCode: \$gameCode) {
            handNum
            showDown
            winningRank
            winningCards
            wonAt
            totalPot    
            summary
            handTime
          }
        }
  """;
  static void getAllHands(HandHistoryListModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    QueryResult result = await _client
        .query(QueryOptions(documentNode: gql(allHands), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }
}
