import 'package:flutter/widgets.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';

class GameChatNotifState extends ChangeNotifier {
  bool _showBubble = false;
  int _count = 0;

  bool get hasUnreadMessages => _count != 0;
  int get count => _count;
  bool get showBubble => _showBubble;

  void readAll() {
    _count = 0;
    notifyListeners();
  }

  void addUnread() {
    _count += 1;
    _showBubble = true;
    notifyListeners();
  }

  void notifyNewMessage() {
    _showBubble = true;
    notifyListeners();
  }

  void hideBubble() {
    _showBubble = false;
    notifyListeners();
  }
}

class GameChatBubbleNotifyState extends ChangeNotifier {
  List<ChatMessage> bubbleMessages = [];
  void addBubbleMessge(ChatMessage message) {
    bubbleMessages.add(message);
    notifyListeners();
  }

  List<ChatMessage> getMessages() {
    List<ChatMessage> retMessages = bubbleMessages;
    bubbleMessages = [];
    return retMessages;
  }
}
