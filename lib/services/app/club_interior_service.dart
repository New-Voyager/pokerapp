import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/services/graphQL/queries/club_interior.dart';

class ClubInteriorService {
  static Future<List<ClubMembersModel>> getMembers(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = ClubInterior.clubMembers(clubCode);

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return [];

    final jsonResponse = result.data['clubMembers'];

    return jsonResponse
        .map<ClubMembersModel>(
            (var memberItem) => ClubMembersModel.fromJson(memberItem))
        .toList();
  }
}
