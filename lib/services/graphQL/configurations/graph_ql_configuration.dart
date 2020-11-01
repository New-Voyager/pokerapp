import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/resources/app_apis.dart';
import 'package:pokerapp/services/app/auth_service.dart';

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    uri: AppApis.graphQLBaseUrl,
  );

  static AuthLink authLink = AuthLink(
    getToken: () async => 'jwt ${await AuthService.getJwt()}',
  );

  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: authLink.concat(httpLink),
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ),
  );

  GraphQLClient clientToQuery({bool noAuthLink = false}) {
    return GraphQLClient(
      link: noAuthLink ? httpLink : authLink.concat(httpLink),
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    );
  }
}
