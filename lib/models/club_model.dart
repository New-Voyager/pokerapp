import 'dart:math';

class ClubModel {
  String clubName;
  String clubCode;
  String clubStatus;
  int memberCount;
  String imageID;
  bool isPrivate;

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
  ClubModel.fromJson(var jsonData) {
    /* this function converts the server resonse
    to app objcts, make sure the field names are correct */

    this.clubName = jsonData['name'];
    this.clubCode = jsonData['clubCode'];
    this.clubStatus = jsonData['clubStatus'];
    this.memberCount = jsonData['memberCount'];
    this.imageID = jsonData['imageId'];
    this.isPrivate = jsonData['private'];
  }

  static List<ClubModel> get(int numberOfClubs) {
    var r = Random();
    return List.generate(
      numberOfClubs,
      (_) => ClubModel(
        clubName: ([
          'Manchester Bus Station',
          'Club Haverhill',
          'Club Hyderabad',
          'BU Warren Towers',
          'Club Boston',
        ]..shuffle())
            .first,
        hostName: ([
          'Martinez',
          'Manny',
          'Yolo',
          'Bobby',
          'Aditya',
        ]..shuffle())
            .first,
        memberCount: r.nextInt(300),
        joinDate: '08/07/2020',
        isActive: r.nextInt(3) == 0 ? true : false,
        balance: (r.nextInt(700) * (r.nextInt(3) == 0 ? -1 : 1)).toString(),
        hasJoined: r.nextInt(3) == 0 ? true : false,
        incomingRequest: r.nextInt(3) == 0 ? true : false,
        invitationDate: '05/08/2020',
        outgoingRequest: r.nextInt(3) == 0 ? true : false,
      ),
    );
  }
}
