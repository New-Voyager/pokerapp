import 'package:flutter/foundation.dart';
import 'package:pokerapp/models/pending_approvals.dart';

import 'club_model.dart';

class AppState extends ChangeNotifier {
  String _gameCode = '';
  int currentIndex = 0;
  bool mockScreens = false;
  bool newGame = false;
  bool gameEnded = false;
  PendingApprovalsState buyinApprovals = PendingApprovalsState();
  ClubsUpdateState clubUpdateState = ClubsUpdateState();

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

  void removeGameCode() {
    setCurrentScreenGameCode('');
  }

  void setCurrentScreenGameCode(String gameCode) {
    _gameCode = gameCode;
  }

  String get currentScreenGameCode => _gameCode;

  setNewGame(bool value) {
    newGame = value;
    if (currentIndex == 0) {
      notifyListeners();
    }
  }

  setGameEnded(bool value) {
    gameEnded = value;
    if (currentIndex == 0) {
      notifyListeners();
    }
  }
}
