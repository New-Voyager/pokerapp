import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';

class AppCoinService {
  AppCoinService._();

  static Future<bool> purchaseProduct(
      String storeType, String receiptData) async {
    String query = '''
      mutation (\$storeType: StoreType! \$data: String!) {
        verify: appCoinPurchase(storeType: \$storeType receipt: \$data) {
          valid
          duplicate
        }
      }''';
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "storeType": storeType,
      "data": receiptData,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(query),
        variables: variables,
      ),
    );
    if (result.hasException) return false;
    /*
        type IapReceipt {
          valid: Boolean!
          duplicate: Boolean
        }      
      */
    print("result $result");
    return result.data['verify']['valid'] ?? false;
  }

  static Future<int> availableCoins() async {
    String query = '''
      query coins {
        coins: availableAppCoins
      }    
    ''';

    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(query),
      ),
    );
    if (result.hasException) return 0;
    return result.data['coins'] ?? 0;
  }
}
