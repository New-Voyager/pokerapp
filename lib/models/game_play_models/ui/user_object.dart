import 'package:flutter/foundation.dart';

class UserObject {
  bool isMe;
  int seatPosition;
  String name;
  int chips;
  String avatarUrl;

  UserObject({
    @required this.seatPosition,
    @required this.name,
    @required this.chips,
    this.isMe,
    this.avatarUrl,
  });

  @override
  String toString() => this.name;
}
