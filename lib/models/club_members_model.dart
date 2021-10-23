import 'package:flutter/material.dart';
import 'package:pokerapp/enums/club_member_status.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  double _balance;
  String imageUrl;
  double _totalBuyIns;
  double _totalWinnings;
  double _rake;
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

  double get balance => this._balance ?? 0;
  double get totalWinnings => this._totalWinnings ?? 0;
  double get totalBuyIns => this._totalBuyIns ?? 0;
  double get rake => this._rake ?? 0;
  String get rakeStr => DataFormatter.chipsFormat(this._rake);
  String get balanceStr => DataFormatter.chipsFormat(this._balance);
  String get totalWinningsStr => DataFormatter.chipsFormat(this._totalWinnings);
  String get totalBuyinStr => DataFormatter.chipsFormat(this._totalBuyIns);

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
    data._balance = copyValue._balance;
    data._rake = copyValue._rake;
    data._contactInfo = copyValue._contactInfo;
    data._notes = copyValue._notes;
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
    this._balance = double.parse(jsonData['balance'].toString());
    this._rake = 0;
    if (jsonData['rakePaid'] != null) {
      this._rake = double.parse(jsonData['rakePaid'].toString());
    }

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
