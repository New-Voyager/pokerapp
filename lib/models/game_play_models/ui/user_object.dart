import 'package:flutter/foundation.dart';

class UserObject {
  bool isMe;
  int seatPosition;
  String name;
  int stack;
  String avatarUrl;

  UserObject({
    @required this.seatPosition,
    @required this.name,
    @required this.stack,
    this.isMe,
    this.avatarUrl,
  });

  @override
  String toString() => this.name;
}
