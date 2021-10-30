import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/search_club_model.dart';

enum MemberListOptions {
  ALL,
  UNSETTLED,
  INACTIVE,
  MANAGERS,
}

class ClubInteriorService {
  static String membersQuery =
      """query (\$clubCode:String! \$filter: MemberFilterInput) {
        members: clubMembers(clubCode: \$clubCode filter: \$filter) {
          name
          playerId
          contactInfo
          status
          isOwner
          isManager
          joinedDate
          lastPlayedDate
          totalBuyins
          totalWinnings
          balance
          rakePaid
          contactInfo
          creditLimit
          autoBuyinApproval
          notes
          totalGames
        }
      }""";

  static String gameHistoryQuery = """
          query (\$clubCode: String!) {
            gameHistory: clubGames(clubCode: \$clubCode, completedGames: true) {
              gameType
              gameCode
              gameNum
              startedBy
              startedAt
              endedBy
              endedAt
              sessionTime
              sessionTimeStr
              handsPlayed
              runTime
              runTimeStr
              smallBlind
              bigBlind
              balance
            }
          }    
    """;

  static String updateClubMemberMutation = """
    mutation(\$clubCode: String!, \$playerUuid: String!, \$update: ClubMemberUpdateInput!) {
      update: updateClubMember(clubCode: \$clubCode, playerUuid: \$playerUuid, update: \$update)
    }
  """;

  static String searchClub = """
    query (\$clubCode: String!) {
        club: searchClub(clubCode: \$clubCode) {
          name
          ownerName
          status
      }
    }
  """;

  static String joinClubQuery = """
    mutation (\$clubCode: String!) {
        status: joinClub(clubCode: \$clubCode)
    }
  """;

  static String approveMember = """
  mutation (\$clubCode: String!, \$playerId: String!) {
    status: approveMember(clubCode: \$clubCode, playerUuid: \$playerId)
  }
  """;

  static String denyMember = """
  mutation (\$clubCode: String!, \$playerId: String!) {
    status: rejectMember(clubCode: \$clubCode, playerUuid: \$playerId)
  }
  """;

  static Future<List<ClubMemberModel>> getMembers(String clubCode) async {
    return getClubMembers(clubCode, MemberListOptions.ALL);
  }

  static Future<SearchClub> searchClubHelper(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": clubCode};
    QueryResult result = await _client
        .query(QueryOptions(document: gql(searchClub), variables: variables));
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final jsonResponse = result.data['club'];

    if (jsonResponse == null) {
      return null;
    }
    return SearchClub.fromJson(jsonResponse);
  }

  static Future<List<ClubMemberModel>> getMembersHelper(
      String clubCode, Map<String, dynamic> filter) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": clubCode, "filter": filter};
    QueryResult result = await _client
        .query(QueryOptions(document: gql(membersQuery), variables: variables));

    if (result.hasException) return [];

    final jsonResponse = result.data['members'];

    return jsonResponse
        .map<ClubMemberModel>(
            (var memberItem) => ClubMemberModel.fromJson(memberItem))
        .toList();
  }

  static Future<ClubMemberModel> getClubMemberDetail(
      String clubCode, String playerId) async {
    Map<String, dynamic> filter = {"playerId": playerId};
    final members = await getMembersHelper(clubCode, filter);
    if (members.length == 0) {
      return null;
    }
    members[0].clubCode = clubCode;
    return members[0];
  }

  static Future<List<ClubMemberModel>> getClubMembers(
      String clubCode, MemberListOptions options) async {
    Map<String, dynamic> filter;
    if (options == MemberListOptions.ALL) {
      filter = {"all": true};
    }

    if (options == MemberListOptions.INACTIVE) {
      filter = {"inactive": true};
    }

    if (options == MemberListOptions.MANAGERS) {
      filter = {"managers": true};
    }

    if (options == MemberListOptions.UNSETTLED) {
      filter = {"unsettled": true};
    }

    return getMembersHelper(clubCode, filter);
  }

  static Future<bool> updateClubMember(ClubMemberModel data) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    int creditLimit = 0;
    if (data.creditLimit != '0' && data.creditLimit != '') {
      creditLimit = int.parse(data.creditLimit.toString());
    }
    Map<String, dynamic> update = {
      "contactInfo": data.contactInfo,
      "notes": data.notes,
      "creditLimit": creditLimit,
      "autoBuyinApproval": data.autoBuyInApproval,
    };
    Map<String, dynamic> variables = {
      "clubCode": data.clubCode,
      "playerUuid": data.playerId,
      "update": update,
    };
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(updateClubMemberMutation), variables: variables));
    if (result.hasException) return false;
    return true;
  }

  static Future<List<GameHistoryModel>> getGameHistory(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(gameHistoryQuery), variables: variables));

    if (result.hasException) return [];

    final jsonResponse = result.data['gameHistory'];

    return jsonResponse
        .map<GameHistoryModel>((var item) => GameHistoryModel.fromJson(item))
        .toList();
  }

  static Future<String> joinClub(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": clubCode};
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(joinClubQuery), variables: variables));
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final jsonResponse = result.data['status'].toString();
    return jsonResponse;
  }

  static Future<String> approveClubMember(
      String clubCode, String playerID) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "playerId": playerID
    };
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(approveMember), variables: variables));
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    final jsonResponse = result.data['status'].toString();
    return jsonResponse;
  }

  static Future<String> denyClubMember(String clubCode, String playerID) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "playerId": playerID
    };
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(denyMember), variables: variables));
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    final jsonResponse = result.data['status'].toString();
    return jsonResponse;
  }
}
