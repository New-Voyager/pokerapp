import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/app_coin.dart';

class RedeemPromotionResult {
  bool success;
  int availableCoins;
  String error;
}

class AppCoinService {
  AppCoinService._();

  static Future<bool> purchaseProduct(
      String storeType, int coinsPurchased, String receiptData) async {
    String query = '''
      mutation (\$storeType: StoreType! \$coinsPurchased:Int \$data: String!) {
        verify: appCoinPurchase(storeType: \$storeType coinsPurchased: \$coinsPurchased receipt: \$data) {
          valid
          duplicate
        }
      }''';
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "storeType": storeType,
      "data": receiptData,
      "coinsPurchased": coinsPurchased,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(query),
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
        document: gql(query),
      ),
    );
    if (result.hasException) return 0;
    return result.data['coins'] ?? 0;
  }

  static Future<List<IapAppCoinProduct>> availableProducts() async {
    String query = '''
      query getAvailableProducts {
        products: availableIapProducts {
          productId
          coins
        }
      }   
    ''';

    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    if (result.hasException) return [];
    final productsJson = result.data['products'];
    List<IapAppCoinProduct> products = [];
    for (final productJson in productsJson) {
      products.add(IapAppCoinProduct.fromJson(productJson));
    }
    return products;
  }

  static Future<RedeemPromotionResult> redeemCode(String code) async {
    String query = '''
      mutation (\$code: String!)  {
        redeemPromotionCode(code: \$code) {
          success
          availableCoins
          error
        }
      }   
    ''';

    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"code": code};
    final result = await _client.mutate(MutationOptions(
      document: gql(query),
      variables: variables,
    ));
    if (result.hasException) return null;
    final redeem = result.data['redeemPromotionCode'];
    RedeemPromotionResult resp = RedeemPromotionResult();
    resp.availableCoins = redeem['availableCoins'] as int;
    resp.error = redeem['error'] as String;
    resp.success = redeem['success'];
    return resp;
  }

  static Future<bool> buyDiamonds(int diamonds, int coinsUsed) async {
    String query = '''
      mutation (\$diamonds: Int!, \$coinsUsed: Int!)  {
        status: buyDiamonds(diamonds: \$diamonds, coinsUsed: \$coinsUsed)
      }   
    ''';

    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "diamonds": diamonds,
      "coinsUsed": coinsUsed,
    };
    final result = await _client.mutate(MutationOptions(
      document: gql(query),
      variables: variables,
    ));
    if (result.hasException) return null;
    final ret = result.data['status'];
    return ret;
  }
}
