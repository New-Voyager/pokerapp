import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/resources/app_apis.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfiguration {
  String apiURL;

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String apiUrl = sharedPreferences.getString(AppConstants.API_SERVER_URL);
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
