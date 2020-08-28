import 'package:pokerapp/models/auth_model.dart';

class Club {
  static String createClub(String name, String description) => """
  mutation {
  createClub(club: {
    name: "$name"
    description: "$description"
  })
  }
  """;
}
