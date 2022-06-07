import 'dart:io';

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
    return HttpLink(apiURL, defaultHeaders: {
      HttpHeaders.acceptHeader: '*',
      HttpHeaders.accessControlAllowOriginHeader: '*',
    });
  }

  AuthLink authLink() {
    return AuthLink(getToken: () async {
      return 'jwt ${AppConfig.jwt}';
    });
  }

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
