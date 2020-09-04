import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/services/graphQL/mutations/clubs.dart';
import 'package:pokerapp/services/graphQL/queries/clubs.dart';

class ClubsService {
  static Future<bool> deleteClub(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = Club.deleteClub(clubCode);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return false;

    return result.data['deleteClub'] ?? false;
  }

  static Future<bool> updateClub(
    String clubCode,
    String name,
    String description,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = Club.updateClub(clubCode, name, description);

    log(_query);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return false;

    return result.data['updateClub'] ?? false;
  }

  static Future<bool> createClub(String name, String description) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = Club.createClub(name, description);

    log(_query);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return false;

    String clubID = result.data['createClub'];

    log(clubID);

    return clubID.isNotEmpty;
  }

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
