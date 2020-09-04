import 'dart:convert';
import 'dart:developer';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/enums/auth_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/services/graphQL/mutations/create_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _prefKey = 'auth_service_pref_key';

  /* private methods */

  static Future<bool> _save(AuthModel authModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(_prefKey, authModel.toJson());
  }

  static Future<bool> _remove() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(_prefKey);
  }

  static Future<AuthModel> _get() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = sharedPreferences.get(_prefKey);

    return jsonData == null ? null : AuthModel.fromJson(jsonDecode(jsonData));
  }

  /* methods exposed */

  /* method that returns back the uuid */
  static Future<String> getJWT() async => (await _get())?.uuid;

  /* method that deletes the stored user contents and logs out */
  static Future<bool> logout() async => _remove();

  // FIXME: DO WE NEED DIFFERENT METHODS FOR REGISTRATION AND LOGIN?
  // FIXME: FOR NOW, BOTH LOGIN AND REGISTRATION IS HANDLED BY THIS METHOD

  /* method that talks to the graphQL server to get back a user (or create a new) */
  static Future<bool> register(AuthModel authModel) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    // TODO REMOVE THIS WHEN THE SERVER CAN ALLOW PASSWORDS
    authModel.password = null;

    if (authModel.authType == AuthType.Email)
      authModel.deviceID = null;
    else {
      authModel.email = null;
      authModel.deviceID = await FlutterUdid.udid;
    }

    String _query = CreatePlayer.createPlayer(authModel);

    log(_query);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    print(result.exception);
    print(result.data);

    if (result.hasException) return false;

    authModel.uuid = (result.data as LazyCacheMap).data['createPlayer'];
    authModel.password = null; // the password need not to be saved locally

    return _save(authModel);
  }

//  static Future<bool> login(AuthModel authModel) async {
//    return false;
//  }
}
