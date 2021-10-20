import 'package:synchronized/synchronized.dart';

// Every message sent by the player should have a unique message ID.
// The purpose of it is to associate server acknowledgement with the action
// message. The server will return the same message ID when it acknowledges
// the action message.
// The message ID should be >= 1. 0 is not valid.
class MessageId {
  static var lastMessageIds = new Map();
  static var lock = new Lock();

  static int get(String gameCode) {
    int ret;
    lock.synchronized(() {
      if (!lastMessageIds.containsKey(gameCode)) {
        lastMessageIds[gameCode] = 1;
      }
      ret = lastMessageIds[gameCode];
    });
    return ret;
  }

  static void set(String gameCode, int messageId) {
    lock.synchronized(() {
      lastMessageIds[gameCode] = messageId;
    });
  }

  static int incrementAndGet(String gameCode) {
    int ret;
    lock.synchronized(() {
      if (lastMessageIds.containsKey(gameCode)) {
        lastMessageIds[gameCode] = lastMessageIds[gameCode] + 1;
      } else {
        lastMessageIds[gameCode] = 1;
      }
      ret = lastMessageIds[gameCode];
    });
    return ret;
  }
}
