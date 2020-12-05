import 'package:flutter/material.dart';

class RemainingTime extends ChangeNotifier {
  int _remainingTime;

  int getRemainingTime() {
    int tmp = this._remainingTime;

    /* after fetching the value
     * we put the remainingTime to be null */

    this._remainingTime = null;
    return tmp;
  }

  set time(int time) {
    this._remainingTime = time;
    notifyListeners();
  }
}
