import 'dart:math';

class MockClubData {
  String clubName;
  String hostName;
  String memberCount;
  String joinDate;
  bool isActive;
  String balance;
  bool hasJoined;
  bool incomingRequest;
  String invitationDate;
  bool outgoingRequest;

  MockClubData({
    this.clubName,
    this.hostName,
    this.memberCount,
    this.joinDate,
    this.isActive,
    this.balance,
    this.hasJoined,
    this.incomingRequest,
    this.invitationDate,
    this.outgoingRequest,
  });

  static List<MockClubData> get(int numberOfClubs) {
    var r = Random();
    return List.generate(
      numberOfClubs,
      (_) => MockClubData(
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
        memberCount: r.nextInt(300).toString(),
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
