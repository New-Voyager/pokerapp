class ClubInterior {
  static String clubMembers(String clubCode) => """
   query{
    clubMembers(clubCode: "$clubCode"){
      name
      joinedDate
      status
      lastGamePlayedDate
      imageId
      isOwner
      isManager
      playerId
    }
  }""";
}
