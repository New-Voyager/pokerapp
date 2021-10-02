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
  // int serverSeatPos;
  // bool _openSeat;
  int _localSeatPos;
  int _serverSeatPos;
  PlayerModel _player;
  SeatPos _uiPos;
  SeatPosAttribs _attribs;

  // UI attributes
  // Offset _screenPos;

  // action timer
  ActionTimer _actionTimer;
  int actionCount = 0;
  bool _showTimer;

  /* fields to mark sb, bb, dealer */
  bool sb;
  bool dealer;
  bool bb;

  Seat(int localSeatPos, SeatPos uiPos, SeatPosAttribs attribs) {
    this._serverSeatPos = -1;
    this._localSeatPos = localSeatPos;
    this._uiPos = uiPos;
    this._attribs = attribs;
    this._player = null;
    this._actionTimer = ActionTimer();
    this._showTimer = false;
    this.dealer = false;
    this.sb = false;
    this.bb = false;
  }

  SeatPosAttribs get attribs => this._attribs;

  int get localSeatPos => this._localSeatPos;
  int get serverSeatPos => this._serverSeatPos;

  // server seat position is set only in the PlayersOnTableView class
  // this member is used only in seat change process and tapping on open seat
  // for all ui related functionalities attribs and seatPos member variables
  // should be used.
  set serverSeatPos(int pos) => this._serverSeatPos = pos;

  SeatPos get seatPos => this._uiPos;
  set seatPos(SeatPos uiPos) => this._uiPos = uiPos;

  @override
  String toString() {
    if (player != null) {
      return 'Seat: ${_player.seatNo} Player: ${_player.name} Stack: ${_player.stack}';
    }
    return 'Seat: ${_uiPos.toString()} Open';
  }

  bool get isOpen {
    return this._player == null;
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
  }

  set buyInExpired(bool v) {
    this._player.buyInExpired = v;
    this.notify();
  }

  GlobalKey get key => this._attribs.key;

  // get screenPos => this._screenPos;
  // set screenPos(Offset pos) => this._screenPos = pos;

  get parentRelativePos => this._attribs.parentRelativePos;
  set parentRelativePos(Offset pos) => this._attribs.parentRelativePos = pos;

  get size => this._attribs.size;
  set size(Size size) => this.attribs.size = size;

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

  GlobalKey get betWidgetUIKey => this._attribs.betWidgetUiKey;
  set betWidgetUIKey(GlobalKey key) => this._attribs.betWidgetUiKey = key;

  Offset get potViewPos => this._attribs.potPos;
  set potViewPos(Offset pos) => this._attribs.potPos = pos;

  Offset get betWidgetPos => this._attribs.betWidgetPos;
  set betWidgetPos(Offset offset) => this._attribs.betWidgetPos = offset;

  void setProgressTime(int progressTime) {
    _actionTimer.setProgressTime(progressTime);
  }
}

class ActionTimer extends ChangeNotifier {
  int _totalTime = 0;
  //int _remainingTime = 0;
  int _progressTime = 0;

  void setTime(int totalTime, int remainingTime) {
    this._totalTime = totalTime;
    this._progressTime = totalTime - remainingTime;
    notifyListeners();
  }

  void setProgressTime(int progressTime) {
    this._progressTime = progressTime;
  }

  int getProgressTime() {
    return this._progressTime;
  }

  int getTotalTime() {
    return this._totalTime;
  }
}
