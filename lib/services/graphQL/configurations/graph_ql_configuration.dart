import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main-web.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/utils/platform.dart';

class GraphQLConfiguration {
  String apiURL;

  Future<void> init({String apiUrl}) async {
    if (apiUrl == null) {
      apiUrl = AppConfig.apiUrl;
    }
    this.apiURL = '${apiUrl}/graphql';
  }

  HttpLink httpLink() {
    return HttpLink(apiURL);
  }

  AuthLink authLink() {
    if (PlatformUtils.isWeb) {
      // TODO: temporary code
      return AuthLink(getToken: () async {
        return 'Bearer $kWebPlayerUuid';
      });
    } else {
      return AuthLink(getToken: () async {
        return 'jwt ${AppConfig.jwt}';
      });
    }
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
