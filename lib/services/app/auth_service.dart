import 'dart:convert';
import 'dart:developer';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/enums/auth_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_apis.dart';
import 'package:pokerapp/services/graphQL/mutations/create_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _prefKey = 'auth_service_pref_key';

  /* private methods */

  static Future<bool> _save(AuthModel authModel) async {
    log(authModel.toJson());

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(_prefKey, authModel.toJson());
  }

  static Future<bool> _remove() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(_prefKey);
  }

  static Future<AuthModel> get() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = sharedPreferences.get(_prefKey);

    return jsonData == null ? null : AuthModel.fromJson(jsonDecode(jsonData));
  }

  /* methods exposed */

  /* method that returns back the uuid */
  static Future<String> getUuid() async => (await get())?.uuid;

  static Future<String> getJwt() async => (await get())?.jwt;

  /* method that deletes the stored user contents and logs out */
  static Future<bool> logout() async => _remove();

  /* method that talks to the graphQL server to get back a user (or create a new) */
  static Future<bool> register(AuthModel authModel) async {
    GraphQLClient _client =
        graphQLConfiguration.clientToQuery(noAuthLink: true);

    if (authModel.authType == AuthType.Email)
      authModel.deviceID = null;
    else if (authModel.authType == AuthType.Guest) {
      authModel.email = null;
      authModel.deviceID = await FlutterUdid.udid;
    } else {
      return false;
    }

    log(authModel.toJson());

    String _query = CreatePlayer.createPlayer(authModel);

    log(_query);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    print(result.exception);
    print(result.data);

    if (result.hasException) return false;

    authModel.uuid = (result.data as LazyCacheMap).data['createPlayer'];

    /* after account is created, login with the login API */

    Map<String, dynamic> res = await login(authModel);

    return res['status'];
  }

  static Future<Map<String, dynamic>> login(AuthModel authModel) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    String body;

    if (authModel.authType == null || authModel.authType == AuthType.Email) {
      /* in case if authType is null or Email */

      if (authModel.email == null || authModel.email.isEmpty)
        return {
          'status': false,
          'message': "Email can't be empty",
        };
      if (authModel.password == null || authModel.password.isEmpty)
        return {
          'status': false,
          'message': "Password can't be empty",
        };

      body = jsonEncode({
        'email': authModel.email,
        'password': authModel.password,
      });
    } else if (authModel.authType == AuthType.Guest) {
      /* only if the authType is Guest */
      body = jsonEncode({
        'device-id': authModel.deviceID,
        'uuid': authModel.uuid,
      });
    } else if (authModel.authType == AuthType.Name) {
      // FIXME: THIS IS A TEMP AND DEBUG REQUIREMENT
      body = jsonEncode({
        'name': authModel.name,
      });
    }

    assert(body != null);

    http.Response response = await http.post(
      '${AppApis.baseUrlWithDefaultPort}/auth/login',
      headers: header,
      body: body,
    );

    String resBody = response.body;

    if (response.statusCode != 200)
      return {
        'status': false,
        'message': jsonDecode(resBody)['errors'][0],
      };

    String jwt = jsonDecode(resBody)['jwt'];

    authModel.jwt = jwt;
    authModel.password = null;

    /* IF THE PLAYER UUID IS UNKNOWN, USE THE MY INFO API TO FETCH IT */
    if (authModel.uuid == null) {
      await _save(authModel); // this is done to save the JWT first
      authModel.uuid = await fetchUUID();
    }

    return {
      'status': await _save(authModel),
    };
  }

  static Future<String> fetchUUID() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query{
      myInfo{
        uuid
      }
    }
    """;

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    log(result.exception.toString());

    return result.hasException ? null : result.data['myInfo']['uuid'];
  }
}
