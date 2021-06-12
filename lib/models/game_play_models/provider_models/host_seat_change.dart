import 'package:flutter/material.dart';

class SeatChangeStatus {
  bool isDropAble;
  bool isDragging;
  SeatChangeStatus({this.isDragging = false, this.isDropAble = false});
}

class PlayerInSeat {
  int seatNo;
  String name;
  double stack;
  String playerId;
  bool openSeat;

  static PlayerInSeat fromJson(var data) {
    var ret = PlayerInSeat();
    ret.seatNo = int.parse(data["seatNo"].toString());
    ret.name = data["name"];
    ret.stack = double.parse(data["stack"].toString());
    ret.openSeat = data["openSeat"];
    ret.playerId = data["playerUuid"].toString();
    return ret;
  }
}

class SeatChangeNotifier extends ChangeNotifier {
  /* This object holds states related to host seat change functionality */
  bool _seatChangeInProgress = false;
  bool _animateSeatChange = false;
  int seatChangeHost = 0;
  int fromSeatNo = 0;
  int toSeatNo = 0;
  String _playerName;
  double _stack;
  bool _fromOpenSeat;
  bool _toOpenSeat;
  List<PlayerInSeat> playersInSeats = [];

  List<SeatChangeStatus> allSeatChangeStatus =
      List.generate(10, (_) => SeatChangeStatus());
  void notifyAll() => notifyListeners();

  SeatChangeNotifier({bool seatChangeInProgress, List<PlayerInSeat> players}) {
    this._seatChangeInProgress = seatChangeInProgress ?? false;
    this.playersInSeats = players;
  }

  void updateSeatChangeInProgress(bool seatChangeInProgress) {
    if (this._seatChangeInProgress == seatChangeInProgress) return;
    this._seatChangeInProgress = seatChangeInProgress;
    notifyAll();
  }

  void updateSeatChangeHost(int seatChangeHost) {
    if (this.seatChangeHost == seatChangeHost) return;
    this.seatChangeHost = seatChangeHost;
    notifyAll();
  }

  void updateAnimateSeatChange(bool animateSeatChange) {
    if (this._animateSeatChange == animateSeatChange) return;
    this._animateSeatChange = animateSeatChange;
  }

  void updateSeatChangePlayer(
    int fromSeat,
    int toSeat,
    String playerName,
    double stack,
  ) {
    this.fromSeatNo = fromSeat;
    this.toSeatNo = toSeat;
    this._playerName = playerName;
    this._stack = stack;
  }

  void updatePlayersInSeats(List<PlayerInSeat> playersInSeats) {
    this.playersInSeats = playersInSeats;
  }

  set animate(bool v) {
    this._animateSeatChange = v;
  }

  bool get animate {
    return this._animateSeatChange;
  }

  bool get seatChangeInProgress {
    return this._seatChangeInProgress;
  }

  onSeatDragStart(int seatNo) {
    // print("seatNo $seatNo");
    allSeatChangeStatus[seatNo].isDragging = true;
    for (int i = 0; i < allSeatChangeStatus.length; i++) {
      if (i != seatNo) {
        allSeatChangeStatus[i].isDropAble = true;
      }
    }
    notifyAll();
  }

  onSeatDragEnd() {
    for (int i = 0; i < allSeatChangeStatus.length; i++) {
      allSeatChangeStatus[i].isDropAble = false;
      allSeatChangeStatus[i].isDragging = false;
    }
    notifyAll();
  }

  onSeatDrop(int from, int to) {
    fromSeatNo = from;
    toSeatNo = to;
    notifyAll();
    fromSeatNo = null;
    toSeatNo = null;
  }
}
