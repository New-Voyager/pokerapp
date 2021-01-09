import 'package:flutter/cupertino.dart';

class CardDistributionModel extends ChangeNotifier {
  int _distributeToSeatNo;

  set seatNo(int seatNo) {
    _distributeToSeatNo = seatNo;
    notifyListeners();
  }

  int get seatNo => _distributeToSeatNo;
}
