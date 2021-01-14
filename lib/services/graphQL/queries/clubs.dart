class Clubs {
  static String myClubs() => """
  query {
      myClubs {
        name
        clubCode
        clubStatus
        memberStatus
        balance
        memberCount
        imageId
        isOwner
        private
        host
      }
    }""";
}
