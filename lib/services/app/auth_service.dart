import 'dart:developer';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/services/graphQL/mutations/create_player.dart';

class AuthService {
  static Future<bool> register(AuthModel authModel) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    // TODO REMOVE THIS WHEN THE SERVER CAN ALLOW PASSWORDS
    authModel.password = null;

    /* if email is not present, then fill the deviceID field */
    if (authModel.email == null || authModel.email.isEmpty)
      authModel.deviceID = await FlutterUdid.udid;

    String _query = CreatePlayer.createPlayer(authModel);

    log(_query);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    print(result.exception);
    print(result.data);

    if (result.hasException) return false;

    // todo save the UUID in the device
    print((result.data as LazyCacheMap).data);

    return true;
  }

  static Future<bool> login(AuthModel authModel) async {
    return false;
  }
}
