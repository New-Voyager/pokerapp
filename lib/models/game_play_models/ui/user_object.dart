import 'package:flutter/foundation.dart';

class UserObject {
  bool isMe;
  String name;
  int stack;
  String avatarUrl;
  int buyIn;

  int serverSeatPos;

  // this status is shown to all the players, by showing a little pop up below the user object
  String status;
  bool highlight;

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
