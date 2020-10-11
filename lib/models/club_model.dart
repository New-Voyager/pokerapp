import 'package:graphql_flutter/graphql_flutter.dart';

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

  ClubModel({
    this.clubName,
    this.clubCode,
    this.clubStatus,
    this.memberCount,
    this.imageID,
    this.isPrivate,
    this.isOwner,

    /* extra (for now) */
    this.hostName,
    this.joinDate,
    this.isActive,
    this.balance,
    this.hasJoined,
    this.incomingRequest,
    this.invitationDate,
    this.outgoingRequest,
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
  }
}
