import 'package:pokerapp/enums/club_member_status.dart';

class ClubMemberModel {
  String name;
  DateTime joinedDate;
  String lastPlayedDate;
  ClubMemberStatus status;
  String imageId;
  bool isOwner;
  bool isManager;
  String playerId;
  String contactInfo;
  String balance;
  String imageUrl;
  String buyIn;
  String profit;
  String rake;

  ClubMemberModel(
      this.status,
      this.name,
      this.contactInfo,
      this.buyIn,
      this.profit,
      this.rake,
      this.lastPlayedDate,
      this.balance,
      this.imageUrl,
      this.isOwner,
      this.isManager);

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

  ClubMemberModel.fromJson(var jsonData) {
    this.name = jsonData['name'];
    this.joinedDate = DateTime.parse(jsonData['joinedDate']);
    this.status = _getPlayerStatus(jsonData['status']);
    this.lastPlayedDate = "";

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
    this.imageUrl = jsonData['imageUrl'];
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
