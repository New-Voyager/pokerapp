class Club {
  static String createClub(String name, String description) => """
    mutation {
      createClub(club: {
        name: "$name"
        description: "$description"
      })
    }
  """;

  static String updateClub(String clubCode, String name, String description) =>
      """
    mutation {
      updateClub(clubCode: "$clubCode", club: {
        name: "$name",
        description: "$description",
      })
  }
  """;

  static String deleteClub(String clubCode) => """
    mutation{
      deleteClub(clubCode: "$clubCode")
    }
  """;
}
