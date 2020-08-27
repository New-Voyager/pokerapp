import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/services/graphQL/queries/clubs.dart';

class ClubsService {
  static Future<List<ClubModel>> getMyClubs() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(Clubs.myClubs()),
      ),
    );

    var jsonResponse = result.data['myClubs'];

    return jsonResponse
        .map<ClubModel>((var clubItem) => ClubModel.fromJson(clubItem))
        .toList();
  }
}
