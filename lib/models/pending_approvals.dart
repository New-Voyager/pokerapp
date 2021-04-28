import 'package:flutter/material.dart';

class PendingApprovalsState extends ChangeNotifier {
  int totalPending = 0;

  setTotalPending(int i) {
    totalPending = i;
    notify();
  }

  decreaseTotalPending() {
    totalPending--;
    notify();
  }

  incrementTotalPending() {
    totalPending++;
    notify();
  }

  notify() {
    notifyListeners();
  }
}

class PendingApproval {
  String name;
  double amount;
  double balance;
  String gameCode;
  String gameType;
  String clubCode;
  String clubName;
  String playerUuid;

  static PendingApproval fromJson(dynamic data) {
    PendingApproval ret = new PendingApproval();
    /*
      {
        "name": "guest",
        "amount": 100,
        "outstandingBalance": 0,
        "gameCode": "CG-3QC8TXJRNOADG3",
        "clubCode": "C-POTQK6M8PM9Y",
        "clubName": null,
        "gameType": "HOLDEM",
        "playerUuid": "456"
      }
      */
    ret.name = data['name'].toString();
    ret.amount = double.parse(data['amount'].toString());
    ret.balance = double.parse(data['outstandingBalance'].toString());
    ret.gameCode = data['gameCode'].toString();
    ret.clubCode = data['clubCode'].toString();
    ret.clubName = data['clubName'].toString();
    ret.gameType = data['gameType'].toString();
    ret.playerUuid = data['playerUuid'].toString();
    return ret;
  }
}
