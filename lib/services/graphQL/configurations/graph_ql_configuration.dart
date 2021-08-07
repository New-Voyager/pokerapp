import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/resources/app_config.dart';

class GraphQLConfiguration {
  String apiURL;

  Future<void> init() async {
    String apiUrl = AppConfig.apiUrl;
    this.apiURL = '$apiUrl/graphql';
    print(apiURL);
  }

  HttpLink httpLink() {
    return HttpLink(uri: apiURL);
  }

  AuthLink authLink() {
    return AuthLink(getToken: () async {
      return 'jwt ${AppConfig.jwt}';
    });
  }

  // final ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(
  //     link: authLink.concat(httpLink),
  //     cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
  //   ),
  // );

  ValueNotifier<GraphQLClient> client() {
    return ValueNotifier(
      GraphQLClient(
        link: authLink().concat(httpLink()),
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      ),
    );
  }

  GraphQLClient clientToQuery({bool noAuthLink = false}) {
    return GraphQLClient(
      link: authLink().concat(httpLink()),
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    );
  }
}
