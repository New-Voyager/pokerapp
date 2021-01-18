import 'package:synchronized/synchronized.dart';

// Every action message sent by the player should increment the lastMessageId.
// Game server processes the action only if it has a message ID greater than
// the previous messages. The message ID should start from 1 and increment.
// 0 is not a valid message ID.
class MessageId {
  static var lastMessageIds = new Map();
  static var lock = new Lock();

  static int getLastMessageId(String gameCode) {
    int ret = 0;
    lock.synchronized(() {
      if (lastMessageIds.containsKey(gameCode)) {
        ret = lastMessageIds[gameCode];
      } else {
        ret = 0;
      }
    });
    print('getMessageId gameCode: $gameCode, ret: $ret');
    return ret;
  }

  static void setLastMessageId(String gameCode, int messageId) {
    print('setMessageId gameCode: $gameCode, messageId: $messageId');
    lock.synchronized(() {
      lastMessageIds[gameCode] = messageId;
    });
  }

  static int incrementAndGetMessageId(String gameCode) {
    int ret = 1;
    lock.synchronized(() {
      if (lastMessageIds.containsKey(gameCode)) {
        lastMessageIds[gameCode] = lastMessageIds[gameCode] + 1;
      } else {
        lastMessageIds[gameCode] = 1;
      }
      ret = lastMessageIds[gameCode];
    });
    print('incrementAndGetMessageId gameCode: $gameCode, ret: $ret');
    return ret;
  }
}
