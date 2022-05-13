import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pokerapp/build_info.dart';
import 'package:pokerapp/main_helper.dart';

import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/screen_attributes.dart';
import 'package:pokerapp/models/user_update_input.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();
  static AuthModel _user;
  static String updatUserDetailsQuery = """ 
      mutation updatePlayer(\$input :PlayerUpdateInput!){
        ret :updatePlayer(input:\$input)
      }
  """;

  static String getPlayerInfoQuery = """
     query myInfo(\$getPrivs : Boolean!){
      ret: myInfo(getPrivs : \$getPrivs){
          uuid
          id
          name
          email
          lastActiveTime
          channel
        }
        }
  """;

  /* private methods */

  /// For updating user details
  static Future<bool> updateUserDetails(PlayerUpdateInput input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"input": input.toJson()};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(updatUserDetailsQuery), variables: variables));

    if (result.hasException) {
      log(result.exception.toString());
      return false;
    }
    // ignoring the return value
    return true;
  }

  static Future<void> save(AuthModel currentUser) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString(AppConstants.DEVICE_ID, currentUser.deviceID);
    // sharedPreferences.setString(
    //     AppConstants.DEVICE_SECRET, currentUser.deviceSecret);
    _user = currentUser;
    return;
  }

  static _remove() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(AppConstants.DEVICE_ID);
    sharedPreferences.remove(AppConstants.DEVICE_SECRET);
  }

  static logout() async {
    _user = null;
    await _remove();
  }

  static AuthModel get() {
    return _user;
  }

  static void setUser(AuthModel user) async {
    _user = user;
  }

  /* methods exposed */

  /* get player ID from the JWT */
  static Future<String> getPlayerID() async {
    return _user.uuid;
  }

  /* method that returns back the uuid */
  static String getUuid() => _user.uuid;

  static getJwt() => _user.jwt;

  static Future<String> fetchUUID() async {
    return _user.uuid;
  }

  /// This function logs in the user with device id and device secret to generate JWT
  /// If the JWT expires, we need to generate a new JWT.
  /// When the user opens the app everytime, we will generate a new JWT.
  static Future<Map<String, dynamic>> newlogin(
      String deviceId, String deviceSecret) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    String body = jsonEncode({
      "device-id": deviceId,
      "device-secret": deviceSecret,
      "app-version": versionNumber,
    });

    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.post(
      Uri.parse('$apiServerUrl/auth/new-login'),
      headers: header,
      body: body,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode != 200) {
      return {
        'status': false,
        'error': respBody['errors'][0],
      };
    }
    respBody['status'] = true;
    return respBody;
  }

  /// This function signs up a new player to the system
  /// Returns a device secret (used for login) and jwt
  static Future<Map<String, dynamic>> signup(
      {@required String deviceId,
      @required String screenName,
      String recoveryEmail,
      String displayName}) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    final attribs = ScreenAttributes.getScreenAttribsObject(
        DeviceInfo.model, Screen.diagonalInches, Screen.size);

    Map<String, String> payload = {
      "device-id": deviceId,
      "screen-name": screenName,
      "device-model": DeviceInfo.model,
      "device-os": DeviceInfo.version,
      "attribs-used": attribs?.name,
      "physcial-dimension": Screen.physicalSize.toString(),
      "screen-dimension": Screen.size.toString(),
      "app-version": versionNumber,
    };
    if (recoveryEmail != null) {
      payload["email"] = recoveryEmail;
    }

    if (displayName != null) {
      payload["display-name"] = displayName;
    }
    String body = jsonEncode(payload);

    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.post(
      Uri.parse('$apiServerUrl/auth/signup'),
      headers: header,
      body: body,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode != 200) {
      return {
        'status': false,
        'error': respBody['errors'][0],
      };
    }

    String jwt = respBody['jwt'];
    String deviceSecret = respBody['device-secret'];
    return {'status': true, 'jwt': jwt, "deviceSecret": deviceSecret};
  }

  /// This function signs up bot player without device id
  static Future<Map<String, dynamic>> loginBot(String name) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    String apiServerUrl = AppConfig.apiUrl;
    final response = await http.post(
      Uri.parse('$apiServerUrl/auth/login-bot/${name}'),
      headers: header,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode != 200) {
      return {
        'status': false,
        'error': respBody['errors'][0],
      };
    }

    String jwt = respBody['jwt'];
    String deviceSecret = respBody['device-secret'];
    return {
      'status': true,
      'jwt': jwt,
      'deviceSecret': deviceSecret,
      'uuid': respBody['uuid'],
      'id': respBody['id'],
      'name': respBody['name'],
      'deviceId': respBody['uuid'],
    };
  }

  /// This function signs up bot player without device id
  static Future<Map<String, dynamic>> loginPlayer(int playerId) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    String apiServerUrl = AppConfig.apiUrl;
    final response = await http.post(
      Uri.parse('$apiServerUrl/auth/login-player/${playerId}'),
      headers: header,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode != 200) {
      return {
        'status': false,
        'error': respBody['errors'][0],
      };
    }

    String jwt = respBody['jwt'];
    String deviceSecret = respBody['device-secret'];
    return {
      'status': true,
      'jwt': jwt,
      'deviceSecret': deviceSecret,
      'uuid': respBody['uuid'],
      'id': respBody['id'],
      'name': respBody['name'],
      'deviceId': respBody['uuid'],
    };
  }

  /// This function signs up a new player to the system
  /// Returns a device secret (used for login) and jwt
  static Future<Map<String, dynamic>> sendRecoveryCode(
      {String recoveryEmail}) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    Map<String, String> payload = {
      "email": recoveryEmail,
    };

    String body = jsonEncode(payload);
    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.post(
      Uri.parse('$apiServerUrl/auth/recovery-code'),
      headers: header,
      body: body,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode != 200) {
      String message = 'Failed to send recovery code';
      if (respBody['error'] != null) {
        message = respBody['error'];
      }
      return {
        'status': false,
        'error': message,
      };
    }
    return {
      'status': true,
    };
  }

  /// This function signs up a new player to the system
  /// Returns a device secret (used for login) and jwt
  static Future<Map<String, dynamic>> loginUsingRecoveryCode(
      {String deviceId,
      @required String recoveryEmail,
      @required String code}) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    Map<String, String> payload = {
      "email": recoveryEmail,
      "code": code,
      "device-id": deviceId,
    };

    String body = jsonEncode(payload);
    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.post(
      Uri.parse('$apiServerUrl/auth/login-recovery-code'),
      headers: header,
      body: body,
    );

    String resBody = response.body;
    final respBody = jsonDecode(resBody);
    if (response.statusCode != 200) {
      String message = 'Failed to send recovery code';
      if (respBody['error']) {
        message = respBody['error'];
      }
      return {
        'status': false,
        'error': message,
      };
    }

    /*
      {
        "device-secret": "a34da203-b90b-4f6b-ae6c-13ef459af799",
        "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoic29tYTEiLCJ1dWlkIjoiYjMzYzE0MmQtODljNi00OGJhLWE0YjgtZDkzNTFiYjZmMWVjIiwiaWQiOjMsImlhdCI6MTYyNjk3MjA2MywiZXhwIjoxNjI3MjMxMjYzfQ.akTJsqHqVPKVd76FE_B6StLjjoNrEWEbx3NPptxdeRk"
      }
    */
    return {
      'status': true,
      'deviceSecret': respBody['device-secret'],
      'jwt': respBody['jwt'],
      'name': respBody['name'],
      'uuid': respBody['uuidd'],
      'id': respBody['id']
    };
  }

  static getPlayerInfo() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getPlayerInfoQuery), variables: {"getPrivs": true}));

    if (result.hasException) {
      log(result.exception.toString());
      return null;
    }
    if (result.data['ret'] == null) {
      return null;
    }
    var data = result.data['ret'];
    AuthModel auth = _user;
    auth.email = data['email'];
    auth.name = data['name'];
    auth.playerId = data['id'];
    auth.uuid = data['uuid'];
    return auth;
  }
}
