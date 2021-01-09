import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';

class ClubMemberModel extends ChangeNotifier {
  String clubCode;
  String name;
  DateTime joinedDate;
  String lastPlayedDate;
  ClubMemberStatus status;
  String imageId;
  bool isOwner;
  bool isManager;
  String playerId;
  String _contactInfo;
  String balance;
  String imageUrl;
  String totalBuyIns;
  String totalWinnings;
  String currentBalance;
  String rake;
  bool autoBuyInApproval;
  String _creditLimit;
  String _notes;
  String winnings;
  String totalGames;
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

  String get creditLimit => this._creditLimit;
  set creditLimit(String val) {
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

  static ClubMemberModel copyWith(ClubMemberModel copyValue) {
    final data = new ClubMemberModel();
    data.name = copyValue.name;
    data.clubCode = copyValue.clubCode;
    data.playerId = copyValue.playerId;
    data.joinedDate = copyValue.joinedDate;
    data.status = copyValue.status;
    data.lastPlayedDate = copyValue.lastPlayedDate;
    data._creditLimit = copyValue._creditLimit;
    data.totalGames = copyValue.totalGames;
    data.totalWinnings = copyValue.totalWinnings;
    data.totalBuyIns = copyValue.totalBuyIns;
    data.autoBuyInApproval = copyValue.autoBuyInApproval;
    data.isOwner = copyValue.isOwner;
    data.isManager = copyValue.isManager;
    data.currentBalance = copyValue.currentBalance;
    data.balance = copyValue.balance;
    data.rake = copyValue.rake;
    data._contactInfo = copyValue._contactInfo;
    data._notes = copyValue._notes;
    return data;
  }

  ClubMemberModel.fromJson(var jsonData) {
    this.name = jsonData['name'];
    this.joinedDate = DateTime.parse(jsonData['joinedDate']);
    this.status = _getPlayerStatus(jsonData['status']);
    this.lastPlayedDate = "";
    this._creditLimit = '';
    this.totalGames = '';
    this.totalWinnings = '';
    this.totalBuyIns  = '';
    this.autoBuyInApproval = false;

    if (jsonData['lastPlayedDate'] != null) {
      convertDate(jsonData["lastPlayedDate"]);
    }

    this.imageId = jsonData['imageId'];
    this.isOwner = jsonData['isOwner'];
    this.isManager = jsonData['isManager'];
    this.playerId = jsonData['playerId'];
    this.contactInfo = jsonData['contactInfo'];
    this.balance = jsonData['balance'].toString();
    if (this.balance == '0') {
      this.balance = '';
    }
    this.rake = '';
    if (jsonData['rakePaid'] != null) {
      this.rake = jsonData['rakePaid'].toString();
      if (this.rake == '0') {
        this.rake = null;
      }
    }
    this.imageUrl = jsonData['imageUrl'];


    if (jsonData['totalGames'] != null) {
      this.totalBuyIns = jsonData['totalGames'].toString();
    }

    if (jsonData['totalBuyins'] != null) {
      this.totalBuyIns = jsonData['totalBuyins'].toString();
    }

    if (jsonData['totalWinnings'] != null) {
      this.totalWinnings = jsonData['totalWinnings'].toString();
    }

    this.autoBuyInApproval = false;
    if (jsonData['autoBuyinApproval'] != null) {
      if (jsonData['autoBuyinApproval'].toString() == 'true') {
        this.autoBuyInApproval = true;
      }
    }

    if (jsonData['creditLimit'] != null) {
      this._creditLimit = jsonData['creditLimit'].toString();
    }

    if (jsonData['notes'] != null) {
      this._notes = jsonData['notes'].toString();
    }
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
        this.lastPlayedDate = '${diff.inDays} ago';
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
