import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/resources/app_config.dart';

class GraphQLConfiguration {
  String apiURL;

  Future<void> init({String apiUrl}) async {
    if (apiUrl == null) {
      apiURL = AppConfig.apiUrl;
    }
    this.apiURL = '$apiUrl/graphql';
  }

  HttpLink httpLink() {
    return HttpLink(apiURL);
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
        cache: GraphQLCache(),
      ),
    );
  }

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      link: authLink().concat(httpLink()),
      cache: GraphQLCache(),
    );
  }
}
