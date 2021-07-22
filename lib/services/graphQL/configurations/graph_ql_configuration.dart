import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/resources/app_apis.dart';
import 'package:pokerapp/resources/app_config.dart';

class GraphQLConfiguration {
  String apiURL;

  Future<void> init() async {
    String apiUrl = AppConfig.apiUrl;
    this.apiURL = '$apiUrl/graphql';
    print(apiURL);
  }

  static HttpLink httpLink = HttpLink(
    uri: AppApis.graphQLBaseUrl,
  );

  static AuthLink authLink = AuthLink(
    getToken: () async => 'jwt ${AppConfig.jwt}',
  );

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: authLink.concat(httpLink),
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ),
  );

  GraphQLClient clientToQuery({bool noAuthLink = false}) {
    final HttpLink hl = HttpLink(
      uri: apiURL,
    );

    return GraphQLClient(
      link: noAuthLink ? hl : authLink.concat(hl),
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    );
  }
}
