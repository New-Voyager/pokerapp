import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/game_history_model.dart';

enum MemberListOptions {
  ALL,
  UNSETTLED,
  INACTIVE,
  MANAGERS,
}

class ClubInteriorService {

  static String membersQuery = """query (\$clubCode:String! \$filter: MemberFilterInput) {
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


    static Future<List<ClubMemberModel>> getMembers(String clubCode) async {
      return getClubMembers(clubCode, MemberListOptions.ALL);
    }

    static Future<List<ClubMemberModel>> getMembersHelper(String clubCode, Map<String, dynamic> filter) async {
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      Map<String, dynamic> variables = {
        "clubCode": clubCode,
        "filter": filter
      };
      QueryResult result = await _client.query(
          QueryOptions(documentNode: gql(membersQuery), variables: variables)
      );

      if (result.hasException) return [];

      final jsonResponse = result.data['members'];

      return jsonResponse
          .map<ClubMemberModel>(
              (var memberItem) => ClubMemberModel.fromJson(memberItem))
          .toList();
    }

    static Future<List<ClubMemberModel>> getClubMembers(String clubCode, MemberListOptions options) async {
      Map<String, dynamic> filter;
      if (options == MemberListOptions.ALL) {
        filter = {
          "all": true
        };
      }

      if (options == MemberListOptions.INACTIVE) {
        filter = {
          "inactive": true
        };
      }

      if (options == MemberListOptions.MANAGERS) {
        filter = {
          "managers": true
        };
      }

      if (options == MemberListOptions.UNSETTLED) {
        filter = {
          "unsettled": true
        };
      }

      return getMembersHelper(clubCode, filter);
    }

  static Future<List<GameHistoryModel>> getGameHistory(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(gameHistoryQuery), variables: variables)
    );

    if (result.hasException) return [];

    final jsonResponse = result.data['gameHistory'];

    return jsonResponse
        .map<GameHistoryModel>(
            (var item) => GameHistoryModel.fromJson(item))
        .toList();
  }

}
