import 'package:flutter/material.dart';

class InstaRefreshService with ChangeNotifier {
  bool _shouldRefreshLiveGames = true;
  bool _shouldRefreshGameRecord = true;

  void setNeedToRefreshLiveGames() {
    _shouldRefreshLiveGames = true;
    notifyListeners();
  }

  void refreshLiveGamesDone() {
    _shouldRefreshLiveGames = false;
    notifyListeners();
  }

  void setNeedToRefreshGameRecord() {
    _shouldRefreshGameRecord = true;
    notifyListeners();
  }

  void refreshGameRecordDone() {
    _shouldRefreshGameRecord = false;
    notifyListeners();
  }

  bool get needToRefreshLiveGames => _shouldRefreshLiveGames;
  bool get needToRefreshGameRecord => _shouldRefreshGameRecord;
}
