import 'package:flutter/foundation.dart';

class UserObject {
  String name;
  int chips;
  String avatarUrl;

  UserObject({
    @required this.name,
    @required this.chips,
    this.avatarUrl,
  });

  @override
  String toString() => this.name;
}
