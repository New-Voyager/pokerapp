import 'package:flutter/foundation.dart';

import 'club_model.dart';

class AppState extends ChangeNotifier {
  int currentIndex = 0;
  bool mockScreens = false;
  bool newGame = false;
  bool gameEnded = false;

  List<ClubModel> myClubs = [];
  setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  bool isClubOwner(String clubCode) {
    for (final club in myClubs) {
      if (club.clubCode == clubCode) {
        return club.isOwner;
      }
    }
    return false;
  }

  setNewGame(bool value) {
    newGame = value;
    notifyListeners();
  }

  setGameEnded(bool value) {
    gameEnded = value;
    notifyListeners();
  }
}
