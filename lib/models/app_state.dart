import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  int currentIndex = 0;
  bool mockScreens = false;

  setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
