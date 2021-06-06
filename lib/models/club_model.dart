import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/utils/formatter.dart';

class ClubModel {
  String clubName;
  String clubCode;
  String clubStatus;
  int memberCount;
  String imageID;
  bool isPrivate;
  bool isOwner;
  String hostName;
  String joinDate;
  bool isActive;
  String balance;
  bool hasJoined;
  bool incomingRequest;
  String invitationDate;
  bool outgoingRequest;
  String memberStatus;

  int pendingMemberCount;
  int hostUnreadMessageCount;
  int unreadMessageCount;
  int memberUnreadMessageCount;

  ClubModel({
    this.clubName,
    this.clubCode,
    this.clubStatus,
    this.memberCount,
    this.imageID,
    this.isPrivate,
    this.isOwner,
    this.balance,
    this.memberStatus,

    /* extra (for now) */
    this.joinDate,
    this.invitationDate,
  });

  // todo: at a later point, more fields can be added
  ClubModel.fromJson(LazyCacheMap jsonData) {
    /* this function converts the server response
    to app objects */

    this.clubName = jsonData['name'];
    this.clubCode = jsonData['clubCode'];
    this.clubStatus = jsonData['clubStatus'];
    this.memberCount = jsonData['memberCount'];
    this.imageID = jsonData['imageId'];
    this.isPrivate = jsonData['private'];
    this.isOwner = jsonData['isOwner'];
    this.memberStatus = jsonData['memberStatus'];
    this.hostName = jsonData['host'];
    if (jsonData['balance'] != null) {
      jsonData['balance'] = double.parse(jsonData['balance'].toString());
    }
    this.balance = DataFormatter.chipsFormat(jsonData['balance']);
    this.pendingMemberCount = jsonData['pendingMemberCount'];
    this.hostUnreadMessageCount = jsonData['hostUnreadMessageCount'];
    this.unreadMessageCount = jsonData['unreadMessageCount'];
    this.memberUnreadMessageCount = jsonData['memberUnreadMessageCount'];
  }
}
