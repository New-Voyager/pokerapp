import 'package:flutter/material.dart';

class SeatChangeStatus {
  bool isDropAble;
  bool isDragging;
  SeatChangeStatus({this.isDragging = false, this.isDropAble = false});
}

class HostSeatChange extends ChangeNotifier {
  /* This object holds states related to host seat change functionality */
  bool _seatChangeInProgress;
  bool _animateSeatChange;
  int fromSeatNo;
  int toSeatNo;
  String _playerName;
  double _stack;
  bool _fromOpenSeat;
  bool _toOpenSeat;
  List<SeatChangeStatus> allSeatChangeStatus =
      List.generate(10, (_) => SeatChangeStatus());
  void notifyAll() => notifyListeners();

  void updateSeatChangeInProgress(bool seatChangeInProgress) {
    if (this._seatChangeInProgress == seatChangeInProgress) return;
    this._seatChangeInProgress = seatChangeInProgress;
  }

  void updateAnimateSeatChange(bool animateSeatChange) {
    if (this._animateSeatChange == animateSeatChange) return;
    this._animateSeatChange = animateSeatChange;
  }

  void updateSeatChangePlayer(
      int fromSeat, int toSeat, String playerName, double stack) {
    this.fromSeatNo = fromSeat;
    this.toSeatNo = toSeat;
    this._playerName = playerName;
    this._stack = stack;
  }

  bool get seatChangeInProgress {
    return this._seatChangeInProgress;
  }

  onSeatDragStart(int seatNo) {
    print("seatNo $seatNo");
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

  onSeatdrop(int from, int to) {
    fromSeatNo = from;
    toSeatNo = to;
    notifyAll();
    fromSeatNo = null;
    toSeatNo = null;
  }
}
