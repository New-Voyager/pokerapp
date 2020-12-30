import 'package:pokerapp/enums/club_member_status.dart';

class ClubMembersModel {
  String name;
  DateTime joinedDate;
  DateTime lastPlayedDate;
  ClubMemberStatus status;
  String lastGamePlayedDate;
  String imageId;
  bool isOwner;
  bool isManager;
  String playerId;
  String countryCode;
  String contactNumber;
  String balance;
  String imageUrl;
  String buyIn;
  String profit;
  String rake;

  ClubMembersModel(
      this.status,
      this.name,
      this.countryCode,
      this.contactNumber,
      this.buyIn,
      this.profit,
      this.rake,
      this.lastPlayedDate,
      this.balance,
      this.imageUrl);

  /*







   */

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
      case 'KICKEDOUT':
        return ClubMemberStatus.KICKEDOUT;
      default:
        return ClubMemberStatus.UNKNOWN;
    }
  }

  ClubMembersModel.fromJson(var jsonData) {
    this.name = jsonData['name'];
    this.joinedDate = DateTime.parse(jsonData['joinedDate']);
    this.status = _getPlayerStatus(jsonData['status']);
    this.lastGamePlayedDate = jsonData['lastGamePlayedDate'];
    this.imageId = jsonData['imageId'];
    this.isOwner = jsonData['isOwner'];
    this.isManager = jsonData['isManager'];
    this.playerId = jsonData['playerId'];
    this.countryCode = jsonData['countryCode'];
    this.contactNumber = jsonData['contactNumber'];
    this.balance = jsonData['balance'];
    this.imageUrl = jsonData['imageUrl'];
  }
}
