import 'package:flutter/foundation.dart';

class UserObject {
  int seatPosition;
  String name;
  int chips;
  String avatarUrl;

  UserObject({
    @required this.seatPosition,
    @required this.name,
    @required this.chips,
    this.avatarUrl,
  });

  @override
  String toString() => this.name;
}
