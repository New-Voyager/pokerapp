import 'package:flutter/material.dart';

class WaitlistState extends ChangeNotifier {
  String playerUuid;
  String name;
  DateTime expiryTime;
  bool waiting;
  int expSeconds;

  /* This object holds the game status, table status, pot chips, and community cards */
  void fromJson(var data) {
    // {
    //   "gameId": "61",
    //   "gameCode": "CG-YKEH5TZ7A5Z3WA7",
    //   "messageType": "TABLE_UPDATE",
    //   "tableUpdate": {
    //     "type": "WaitlistSeating",
    //     "waitlistPlayerName": "emma",
    //     "waitlistRemainingTime": 60,
    //     "waitlistPlayerId": "424",
    //     "waitlistPlayerUuid": "1852f882-860a-4511-8355-9062c3e4ca0d"
    //   }
    // }
    var tableUpdate = data['tableUpdate'];
    DateTime now = DateTime.now();
    expSeconds = int.parse(tableUpdate['waitlistRemainingTime'].toString());
    this.expiryTime = now.add(Duration(seconds: expSeconds));
    this.playerUuid = tableUpdate['waitlistPlayerUuid'].toString();
    this.name = tableUpdate['waitlistPlayerName'].toString();
    this.waiting = true;
  }

  void notify() {
    this.notifyListeners();
  }
}
