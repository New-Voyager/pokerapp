import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main_helper.dart';

class HelpService {
  static String requestFeatureQuery = """
    mutation requestFeature(\$feature :String!){
      ret:requestFeature(feature :\$feature)
    }
  """;

  static Future<bool> requestFeature({String feature}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"feature": feature};
    QueryResult result = await _client.query(
      QueryOptions(document: gql(requestFeatureQuery), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return false;
      }
    }

    return true;
  }

  static String reportBugQuery = """
      
    mutation reportBug(\$bug :String!){
      ret:reportBug(bug :\$bug)
    }
      """;

  static Future<bool> reportBug({String bug}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"bug": bug};
    QueryResult result = await _client.query(
      QueryOptions(document: gql(reportBugQuery), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return false;
      }
    }

    return true;
  }
}
