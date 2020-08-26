import 'dart:convert';

class AuthModel {
  String name;
  String email;
  String deviceID;
  String password;

  AuthModel({
    this.name,
    this.email,
    this.deviceID,
    this.password,
  });
}
