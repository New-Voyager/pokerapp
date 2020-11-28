import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';

class JoinGameService {
  JoinGameService._();

  static Future<String> joinGame(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      joinGame(gameCode: "$gameCode", seatNo: $seatNo)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    // TODO: need an enum for the PlayerGameStatus or a String would suffice?
    return result.data['joinGame'];
  }
}
