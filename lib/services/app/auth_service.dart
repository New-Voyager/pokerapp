import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pokerapp/models/auth_model.dart';
import 'package:pokerapp/resources/app_config.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();

  static final String _prefKey = 'auth_service_pref_key';
  static String playerUuid;
  static AuthModel _user;

  static String createPlayerQuery = """
  mutation (\$name: String!, \$email: String, \$deviceID: String, \$password: String) {
    createPlayer(player: {
      name: \$name
      email: \$email
      deviceId: \$deviceID
      password: \$password
    })
  }""";

  /* private methods */

  static save(AuthModel currentUser) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(AppConstants.DEVICE_ID, currentUser.deviceID);
    sharedPreferences.setString(
        AppConstants.DEVICE_SECRET, currentUser.deviceSecret);
    _user = currentUser;
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

  static Future<AuthModel> get() async {
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
    String body =
        jsonEncode({"device-id": deviceId, "device-secret": deviceSecret});

    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.post(
      '$apiServerUrl/auth/new-login',
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

    Map<String, String> payload = {
      "device-id": deviceId,
      "screen-name": screenName,
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
      '$apiServerUrl/auth/signup',
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

  /// This function signs up a new player to the system
  /// Returns a device secret (used for login) and jwt
  static Future<Map<String, dynamic>> sendRecoveryCode(
      String recoveryEmail) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    Map<String, String> payload = {
      "email": recoveryEmail,
    };

    String body = jsonEncode(payload);
    String apiServerUrl = AppConfig.apiUrl;

    final response = await http.post(
      '$apiServerUrl/auth/recovery-code',
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
    return {
      'status': true,
    };
  }

  /// This function signs up a new player to the system
  /// Returns a device secret (used for login) and jwt
  static Future<Map<String, dynamic>> loginUsingRecoveryCode(
      String deviceId, String recoveryEmail, String code) async {
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
      '$apiServerUrl/auth/login-recovery-code',
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
    };
  }
}
