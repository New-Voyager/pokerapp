class Clubs {
  static String myClubs() => """
  query {
      myClubs {
        name
        clubCode
        clubStatus
        memberCount
        imageId
        isOwner
        private
      }
    }""";
}
