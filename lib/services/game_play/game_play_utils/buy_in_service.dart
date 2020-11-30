import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';

class BuyInService {
  BuyInService._();

  static Future<String> buyIn(String gameCode, int amount) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      buyIn(gameCode:"$gameCode", amount: $amount)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    // returns the buyIn status todo: need to do something with this guy
    return result.data['buyIn'];
  }
}
