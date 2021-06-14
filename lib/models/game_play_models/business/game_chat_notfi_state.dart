import 'package:flutter/widgets.dart';

class GameChatNotifState extends ChangeNotifier {
  bool get hasUnreadMessages => _count != 0;
  int get count => _count;

  int _count = 0;

  void readAll() {
    _count = 0;
    notifyListeners();
  }

  void addUnread() {
    _count += 1;
    notifyListeners();
  }
}
