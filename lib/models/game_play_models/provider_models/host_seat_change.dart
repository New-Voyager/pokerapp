import 'package:flutter/material.dart';

class HostSeatChange extends ChangeNotifier {
  /* This object holds states related to host seat change functionality */
  bool _seatChangeInProgress;
  bool _animateSeatChange;
  int  _fromSeatNo;
  int _toSeatNo;
  String _playerName;
  double _stack;
  bool _fromOpenSeat;
  bool _toOpenSeat;

  void notifyAll() => notifyListeners();

  void updateSeatChangeInProgress(bool seatChangeInProgress) {
    if (this._seatChangeInProgress == seatChangeInProgress) return;
    this._seatChangeInProgress = seatChangeInProgress;
  }

  void updateAnimateSeatChange(bool animateSeatChange) {
    if (this._animateSeatChange == animateSeatChange) return;
    this._animateSeatChange = animateSeatChange;
  }

  void updateSeatChangePlayer(int fromSeat, int toSeat, String playerName, double stack) {
    this._fromSeatNo = fromSeat;
    this._toSeatNo = toSeat;
    this._playerName = playerName;
    this._stack = stack;
  }

  bool get seatChangeInProgress {
    return this._seatChangeInProgress;
  }
}
