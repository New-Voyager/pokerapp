import 'package:flutter/widgets.dart';

class GameChatNotifState extends ChangeNotifier {
  bool _showBubble = true;
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
