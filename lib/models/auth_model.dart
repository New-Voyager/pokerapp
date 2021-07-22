import 'dart:convert';

class AuthModel {
  String uuid;
  String name;
  String email;
  String deviceID;
  String deviceSecret;
  String jwt;
  int playerId;

  AuthModel({
    this.uuid,
    this.name,
    this.email,
    this.deviceID,
    this.deviceSecret,
    this.playerId,
    this.jwt,
  });

  // AuthModel.fromJson(var jsonData) {
  //   this.uuid = jsonData['uuid']?.toString();
  //   this.name = jsonData['name']?.toString();
  //   this.email = jsonData['email']?.toString();
  //   this.deviceID = jsonData['deviceID']?.toString();
  //   this.deviceSecret = jsonData['deviceSecret']?.toString();
  //   this.jwt = jsonData['jwt']?.toString();
  // }

  // String toJson() => jsonEncode({
  //       'uuid': this.uuid,
  //       'name': this.name,
  //       'email': this.email,
  //       'deviceID': this.deviceID,
  //       'deviceSecret': this.deviceSecret,
  //       'jwt': this.jwt,
  //     });
}
