import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main-web.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/utils/platform.dart';

class GraphQLConfiguration {
  String apiURL;

  Future<void> init({String apiUrl}) async {
    if (apiUrl == null) {
      apiUrl = AppConfig.apiUrl;
      this.apiURL = '$apiUrl/graphql';
    } else {
      this.apiURL = '$apiUrl/graphql';
    }
  }

  HttpLink httpLink() {
    return HttpLink(apiURL);
  }

  AuthLink authLink() {
    return AuthLink(getToken: () async {
      return 'jwt ${AppConfig.jwt}';
    });
  }

  AuthLink authLinkWeb() {
    return AuthLink(getToken: () async {
      return 'Bearer 889a2eda-ffa0-4b35-9805-cc284145459a';
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

  ValueNotifier<GraphQLClient> webclient() {
    return ValueNotifier(
      GraphQLClient(
        link: authLinkWeb().concat(httpLink()),
        cache: GraphQLCache(),
      ),
    );
  }

  GraphQLClient clientToQuery() {
    if (PlatformUtils.isWeb) {
      return GraphQLClient(
        link: authLinkWeb().concat(httpLink()),
        cache: GraphQLCache(),
      );
    } else {
      return GraphQLClient(
        link: authLink().concat(httpLink()),
        cache: GraphQLCache(),
      );
    }
  }
}
