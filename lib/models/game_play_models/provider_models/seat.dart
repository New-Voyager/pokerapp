import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';

enum TablePosition {
  Dealer,
  SmallBlind,
  BigBlind,
  None,
}

/*
 * This class represents a seat on the poker table. A seat has a number (assigned by the server) and also
 * a locat seat number for display purposes. All the server APIs and messages use server seat number.
 * The local seating is relative to the current user playing the game. The current user is always in the 
 * bottom center seat.
 * 
 * This class has a property to indicate whether the seat is open. If a player is in the seat, then
 * the player property is non null.
 * 
 * In additon to these base attributes, it has attributes for various animations performed in the seat.
 * 
 * e.g. folding, betting, showing cards, highlighting winner, show highhand animation (fireworks) 
 */
class Seat extends ChangeNotifier {
  int localSeatPos;
  int serverSeatPos;
  bool _openSeat;
  PlayerModel _player;
  SeatBet _seatBet;
  SeatPos _uiPos;

  // UI attributes
  GlobalKey _key;
  Offset _screenPos;
  Size _size;

  // action timer
  ActionTimer _actionTimer;
  int actionCount = 0;
  bool _showTimer;

  Seat(int localSeatPos, int serverSeatPos, PlayerModel player) {
    this.localSeatPos = localSeatPos;
    this._openSeat = false;
    if (player == null) {
      this._openSeat = true;
    }
    this._player = player;
    this.serverSeatPos = serverSeatPos;
    this._seatBet = SeatBet();
    this._actionTimer = ActionTimer();
    this._showTimer = false;
  }

  SeatPos get uiSeatPos => this._uiPos;
  set uiSeatPos(SeatPos uiPos) => this._uiPos = uiPos;

  @override
  String toString() {
    if (player != null) {
      return 'Seat: $serverSeatPos Player: ${_player.name} Stack: ${_player.stack}';
    }
    return 'Seat: $serverSeatPos Open';
  }

  bool get isOpen {
    return _openSeat;
  }

  PlayerModel get player {
    return this._player;
  }

  bool get folded {
    if (this.player == null) {
      return false;
    }
    return this._player.playerFolded;
  }

  List<int> get cards {
    if (this.player == null) {
      return [];
    }
    return this._player.cards;
  }

  bool get isMe {
    if (this.player == null) {
      return false;
    }
    return this._player.isMe;
  }

  set player(PlayerModel v) {
    this._player = v;
    if (v != null) {
      this._openSeat = false;
    } else {
      this._openSeat = true;
    }
  }

  set buyInExpired(bool v) {
    this._player.buyInExpired = v;
    this.notify();
  }

  GlobalKey get key => this._key;
  set key(Key key) => this._key = key;

  get screenPos => this._screenPos;
  set screenPos(Offset pos) => this._screenPos = pos;

  get size => this._size;
  set size(Size size) => this._size = size;

  SeatBet get seatBet => this._seatBet;

  void notify() {
    this.notifyListeners();
  }

  void showTimer({bool show = false}) {
    this._showTimer = show;
  }

  void setActionTimer(int total, {int remainingTime = -1}) {
    if (remainingTime == -1) {
      remainingTime = total;
    }
    this._actionTimer.setTime(total, remainingTime);
  }

  ActionTimer get actionTimer {
    return this._actionTimer;
  }
}

class SeatBet extends ChangeNotifier {
  double _betAmount = 0.0;
  bool _show = false;
  bool _animate = false;
  Offset _potViewPos;
  Offset _betWidgetPos;
  GlobalKey _uiKey;

  void notify() {
    this.notifyListeners();
  }

  get betAmount => this._betAmount;
  set betAmount(double value) => this._betAmount = value;

  get animate => this._animate;
  set animate(bool v) => this._animate = v;

  get show => this._show;
  set show(bool v) => this._show = v;

  GlobalKey get uiKey => this._uiKey;
  set uiKey(GlobalKey key) => this._uiKey = key;

  Offset get potViewPos => this._potViewPos;
  set potViewPos(Offset pos) => this._potViewPos = pos;

  Offset get betWidgetPos => this._betWidgetPos;
  set betWidgetPos(Offset offset) => this._betWidgetPos = offset;
}

class ActionTimer extends ChangeNotifier {
  int _totalTime = 0;
  int _remainingTime = 0;

  void setTime(int totalTime, int remainingTime) {
    this._totalTime = totalTime;
    this._remainingTime = remainingTime;
    notifyListeners();
  }

  int getRemainingTime() {
    return this._remainingTime;
  }

  int getTotalTime() {
    return this._totalTime;
  }
}
