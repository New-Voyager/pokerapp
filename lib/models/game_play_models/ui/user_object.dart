import 'package:flutter/foundation.dart';

class UserObject {
  bool isMe;
  String name;
  int stack;
  String avatarUrl;

  int serverSeatPos;

  UserObject({
    @required this.serverSeatPos,
    @required this.name,
    @required this.stack,
    this.isMe,
    this.avatarUrl,
  });

  @override
  String toString() => this.name;
}
