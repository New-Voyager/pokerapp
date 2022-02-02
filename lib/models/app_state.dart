import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/flavor_config.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/services/app/player_service.dart';
import 'package:pokerapp/services/caching/cache.dart';

import 'club_model.dart';

class AppState extends ChangeNotifier {
  String _gameCode = '';
  int currentIndex = 0;
  bool mockScreens = false;
  bool newGame = false;
  bool gameEnded = false;
  Flavor _currentFlavor;
  PendingApprovalsState buyinApprovals = PendingApprovalsState();
  ClubsUpdateState clubUpdateState = ClubsUpdateState();

  CacheService cacheService = CacheService();

  Map<SeatPos, Offset> _chipPotViewPos = Map<SeatPos, Offset>();
  Map<String, dynamic> screenAttribs;
  // try {
  //   ScreenAttributes.buildList();
  //   Size size = Size(390.0, 865.0);
  //   attribs = ScreenAttributes.getScreenAttribs('iPhone Something', 1.0, size);
  //   log('attribs length: ${attribs.length}');
  // } catch(err) {
  //   log('Error: ${err.toString()}');
  // }
  bool isPosAvailableFor(Seat seat) {
    return _chipPotViewPos.containsKey(seat.seatPos);
  }

  void setPosForSeat(Seat seat, Offset pos) {
    _chipPotViewPos[seat.seatPos] = pos;
  }

  Offset getPosForSeat(Seat seat) {
    return _chipPotViewPos[seat.seatPos];
  }

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

  bool isClubManager(String clubCode) {
    for (final club in myClubs) {
      if (club.clubCode == clubCode) {
        return club.isManager;
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

  set currentFlavor(Flavor flavor) {
    _currentFlavor = flavor;
  }

  Flavor get currentFlavor {
    return _currentFlavor;
  }

  bool get isProd {
    if (_currentFlavor == Flavor.PROD) {
      return true;
    }
    return false;
  }

  void refreshPendingApprovals() {
    PlayerService.getPendingApprovals().then((v) {
      this.buyinApprovals.setPendingList(v);
    }).onError((error, stackTrace) {
      // ignore it
    });
  }

  Future<void> cacheData() async {
    final myClubs = await cacheService.getMyClubs();
    for (final club in myClubs) {
      await cacheService.getClubHomePageData(club.clubCode, update: true);
      await cacheService.getMembers(club.clubCode, update: true);
    }
  }
}
