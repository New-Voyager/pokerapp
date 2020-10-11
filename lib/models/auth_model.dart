import 'dart:convert';

import 'package:pokerapp/enums/auth_type.dart';

class AuthModel {
  String uuid;
  String name;
  String email;
  String deviceID;
  String password;
  AuthType authType;

  AuthModel({
    this.uuid,
    this.name,
    this.email,
    this.deviceID,
    this.password,
    this.authType,
  });

  AuthModel.fromJson(var jsonData) {
    this.uuid = jsonData['uuid'].toString();
    this.name = jsonData['name'].toString();
    this.email = jsonData['email'].toString();
    this.deviceID = jsonData['deviceID'].toString();
    this.password = jsonData['password'].toString();
    this.authType = jsonData['authType'] != null
        ? AuthType.values[jsonData['authType']]
        : null;
  }

  String toJson() => jsonEncode({
        'uuid': this.uuid,
        'name': this.name,
        'email': this.email,
        'deviceID': this.deviceID,
        'password': this.password,
        'authType': this.authType?.index,
      });
}
