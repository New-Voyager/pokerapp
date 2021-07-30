import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  int currentIndex = 0;

  setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
