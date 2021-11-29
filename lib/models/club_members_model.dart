import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClubMemberModel extends ChangeNotifier {
  bool creditTracking = false;
  String clubCode;
  String name;
  DateTime joinedDate;
  String lastPlayedDate;
  ClubMemberStatus status;
  String imageId;
  bool isOwner;
  bool isManager;
  String playerId;
  double availableCredit;
  String _contactInfo;
  double _balance;
  String imageUrl;
  double _totalBuyIns;
  double _totalWinnings;
  double _rake;
  int _tipsBack;
  bool autoBuyInApproval;
  int _creditLimit;
  String _notes;
  int _totalGames;
  bool edited = false;

  ClubMemberModel();

  ClubMemberStatus _getPlayerStatus(String status) {
    switch (status) {
      case 'UNKNOWN':
        return ClubMemberStatus.UNKNOWN;
      case 'INVITED':
        return ClubMemberStatus.INVITED;
      case 'PENDING':
        return ClubMemberStatus.PENDING;
      case 'DENIED':
        return ClubMemberStatus.DENIED;
      case 'ACTIVE':
        return ClubMemberStatus.ACTIVE;
      case 'LEFT':
        return ClubMemberStatus.LEFT;
      case 'KICKEDOUT':
        return ClubMemberStatus.KICKEDOUT;
      default:
        return ClubMemberStatus.UNKNOWN;
    }
  }

  int get creditLimit => this._creditLimit ?? 0;
  set creditLimit(int val) {
    this._creditLimit = val;
    this.edited = true;
    notifyListeners();
  }

  String get notes => this._notes;
  set notes(String val) {
    this._notes = val;
    this.edited = true;
    notifyListeners();
  }

  String get contactInfo => this._contactInfo;
  set contactInfo(String value) {
    this._contactInfo = value;
    this.edited = true;
    notifyListeners();
  }

  int get totalGames => this._totalGames ?? 0;

  double get totalWinnings => this._totalWinnings ?? 0;
  double get totalBuyIns => this._totalBuyIns ?? 0;
  double get rake => this._rake ?? 0;
  int get tipsBack => this._tipsBack ?? 0;
  String get rakeStr => DataFormatter.chipsFormat(this._rake);
  String get balanceStr => DataFormatter.chipsFormat(this._balance);
  String get totalWinningsStr => DataFormatter.chipsFormat(this._totalWinnings);
  String get totalBuyinStr => DataFormatter.chipsFormat(this._totalBuyIns);
  set tipsBack(int v) => _tipsBack = v;
  static ClubMemberModel copyWith(ClubMemberModel copyValue) {
    final data = new ClubMemberModel();
    data.name = copyValue.name;
    data.clubCode = copyValue.clubCode;
    data.playerId = copyValue.playerId;
    data.joinedDate = copyValue.joinedDate;
    data.status = copyValue.status;
    data.lastPlayedDate = copyValue.lastPlayedDate;
    data._creditLimit = copyValue._creditLimit;
    data._totalGames = copyValue._totalGames;
    data._totalWinnings = copyValue._totalWinnings;
    data._totalBuyIns = copyValue._totalBuyIns;
    data.autoBuyInApproval = copyValue.autoBuyInApproval;
    data.isOwner = copyValue.isOwner;
    data.isManager = copyValue.isManager;
    data._rake = copyValue._rake;
    data._contactInfo = copyValue._contactInfo;
    data._notes = copyValue._notes;
    data._tipsBack = copyValue._tipsBack;
    return data;
  }

  ClubMemberModel.fromJson(var jsonData) {
    this.name = jsonData['name'];
    this.joinedDate = DateTime.parse(jsonData['joinedDate']);
    this.status = _getPlayerStatus(jsonData['status']);
    this.lastPlayedDate = "";
    this._creditLimit = 0;
    this._totalGames = 0;
    this._totalWinnings = 0;
    this._totalBuyIns = 0;
    this.autoBuyInApproval = false;

    if (jsonData['lastPlayedDate'] != null) {
      // last played date is GMT
      DateTime lastPlayedDate = DateTime.tryParse(jsonData['lastPlayedDate']);
      if (lastPlayedDate != null) {
        lastPlayedDate = lastPlayedDate.toLocal();
        final diff = DateTime.now().difference(lastPlayedDate);
        final ago = new DateTime.now().subtract(diff);
        this.lastPlayedDate = timeago.format(ago);
      }
      //convertDate(jsonData["lastPlayedDate"]);
    }

    this.imageId = jsonData['imageId'];
    this.isOwner = jsonData['isOwner'];
    this.isManager = jsonData['isManager'];
    this.playerId = jsonData['playerId'];
    this.contactInfo = jsonData['contactInfo'];
    this._rake = 0;
    if (jsonData['rakePaid'] != null) {
      this._rake = double.parse(jsonData['rakePaid'].toString());
    }
    this._tipsBack = int.parse((jsonData['tipsBack'] ?? 0).toString());
    this.imageUrl = jsonData['imageUrl'];

    if (jsonData['totalGames'] != null) {
      this._totalGames = int.parse(jsonData['totalGames'].toString());
    }

    if (jsonData['totalBuyins'] != null) {
      this._totalBuyIns = double.parse(jsonData['totalBuyins'].toString());
    }

    if (jsonData['totalWinnings'] != null) {
      this._totalWinnings = double.parse(jsonData['totalWinnings'].toString());
    }

    this.autoBuyInApproval = false;
    if (jsonData['autoBuyinApproval'] != null) {
      if (jsonData['autoBuyinApproval'].toString() == 'true') {
        this.autoBuyInApproval = true;
      }
    }

    if (jsonData['creditLimit'] != null) {
      this._creditLimit = int.parse(jsonData['creditLimit'].toString());
    }

    if (jsonData['notes'] != null) {
      this._notes = jsonData['notes'].toString();
    }
    this.availableCredit =
        double.parse((jsonData['availableCredit'] ?? '0').toString());
    this.edited = false;
  }

  void convertDate(String date) {
    DateTime playedDate = DateTime.parse(date);
    if (playedDate != null) {
      DateTime now = DateTime.now();
      Duration diff = now.difference(playedDate);
      if (diff.inDays == 0) {
        this.lastPlayedDate = 'Today';
      } else if (diff.inDays == 1) {
        this.lastPlayedDate = 'Yesterday';
      } else if (diff.inDays < 7) {
        this.lastPlayedDate = '${diff.inDays} days ago';
      } else if (diff.inDays < 30) {
        int weeks = diff.inDays ~/ 7;
        if (diff.inDays % 7 > 0) {
          weeks += 1;
        }
        String weekStr = "weeks";
        if (weeks == 1) {
          weekStr = "week";
        }
        this.lastPlayedDate = '$weeks $weekStr ago';
      } else if (diff.inDays < 365) {
        int months = diff.inDays ~/ 30;
        if (diff.inDays % 30 > 0) {
          months += 1;
        }
        String monthStr = "months";
        if (months == 1) {
          monthStr = "month";
        }
        this.lastPlayedDate = '$months $monthStr ago';
      } else {
        int years = diff.inDays ~/ 365;
        String yearStr = "years";
        if (years == 1) {
          yearStr = "year";
        }
        this.lastPlayedDate = '$years $yearStr ago';
      }
    }
  }
}

/*
query ch($clubCode: String!, $playerUuid: String!) {
  creditHistory(clubCode:$clubCode, playerUuid:$playerUuid) {
    adminUuid
    adminName
    notes
    gameCode
    updateType
    updatedCredits
    amount
  	updateDate
  }
}
*/
class MemberCreditHistory {
  String adminUuid;
  String adminName;
  String notes;
  String gameCode;
  String updateType;
  double updatedCredits;
  double amount;
  DateTime updatedDate;

  MemberCreditHistory();

  factory MemberCreditHistory.fromJson(dynamic json) {
    MemberCreditHistory history = MemberCreditHistory();
    history.adminUuid = json['adminUuid'];
    history.adminName = json['adminName'];
    history.notes = json['notes'] ?? '';
    history.gameCode = json['gameCode'] ?? '';
    history.updateType = json['updateType'];
    history.updatedCredits =
        double.parse((json['updatedCredits'] ?? '0').toString());
    history.amount = double.parse((json['amount'] ?? '0').toString());
    history.updatedDate = DateTime.tryParse(json['updateDate'] ?? '');
    return history;
  }

  static List<MemberCreditHistory> getMockData() {
    String data = '''{
            "history": [
              {
                "adminUuid": "xyx",
                "adminName": "steve",
                "notes": "Fee back",
                "updateType": "DEDUCT",
                "amount": -35,
                "updatedCredits": 65,
                "updateDate": "2021-11-21T10:00:00Z"
              },
              {
                "adminUuid": "xyx",
                "adminName": "steve",
                "notes": "Recd from sean",
                "updateType": "DEDUCT",
                "amount": -400,
                "updatedCredits": 100,
                "updateDate": "2021-11-21T09:00:00Z"
              },
              {
                "adminUuid": "xyx",
                "adminName": "steve",
                "notes": "hh bonus",
                "updateType": "ADD",
                "amount": 100,
                "updatedCredits": 500,
                "updateDate": "2021-11-21T09:00:00Z"
              },
              {
                "notes": "Game: ABCDE",
                "updateType": "GAME_RESULT",
                "amount": 400,
                "updatedCredits": 400,
                "updateDate": "2021-11-20T09:00:00Z"
              },
              {
                "notes": "Game: ABCDE",
                "updateType": "BUYIN",
                "amount": -200,
                "updatedCredits": 0,
                "updateDate": "2021-11-20T08:00:00Z"
              },
              {
                "adminUuid": "xyx",
                "adminName": "steve",
                "notes": "Set Credit",
                "updateType": "CHANGE",
                "amount": 200,
                "updatedCredits": 200,
                "updateDate": "2021-11-20T07:00:00Z"
              }
            ]
        }''';
    final json = jsonDecode(data);
    List<MemberCreditHistory> ret = [];
    for (final item in json['history']) {
      ret.add(MemberCreditHistory.fromJson(item));
    }

    return ret;
  }
}
