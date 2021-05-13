import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/models/host_message_summary_model.dart';
import 'package:pokerapp/models/messages_from_member.dart';
import 'package:pokerapp/services/graphQL/mutations/clubs.dart';
import 'package:pokerapp/services/graphQL/queries/clubs.dart';

import 'package:flutter/services.dart' show rootBundle;

class ClubsService {
  static String sendPlayerMessageQuery = """
  mutation sendPlayer(\$clubCode: String!, \$player: String!, \$text: String!) {
    sendMessageToMember(clubCode: \$clubCode, playerId:\$player, text: \$text) {
      memberId
      messageTime
      messageType
    }
  }
  """;

  static String playerToHostQuery = """
    mutation playerToHost(\$clubCode: String!, \$text: String!){
    sendMessageToHost(clubCode:\$clubCode, text: \$text) {
        messageTime
        messageType
      }
  }
  """;

  static String memberMessagesQuery = """
  query memberMessages(\$clubCode:String!, \$player: String!) {
    messagesFromMember(clubCode:\$clubCode, playerId: \$player) {
      id
      memberId
      memberName
      messageType
      text
      messageTime
      playerId
    }
  }
  """;

  static String hostmessagesQuery = """
  query hostmessages(\$clubCode:String!) {
    messagesFromHost(clubCode:\$clubCode) {
      id
      memberId
      memberName
      messageType
      text
      messageTime
      playerId
    }
  }
  """;

  static String hostMessageSummaryQuery = """
  query hostMessageSummary(\$clubCode: String!) {
    hostMessageSummary (clubCode: \$clubCode){
      memberId
      memberName
      lastMessageText
      lastMessageTime
      newMessageCount
      playerId
    }
  }
  """;

  static String markMemberReadQuery = """
    mutation markMemberRead(\$clubCode: String!, \$player: String!) {
      markMemberMsgRead(clubCode: \$clubCode, playerId: \$player)
    }
  """;

  static String markreadHostQuery = """
  mutation markread(\$clubCode: String!) {
    markHostMsgRead(clubCode: \$clubCode)
  }
  """;

  static Future<bool> markMemberRead({String player, String clubCode}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables;
    QueryResult result;
    if (player != null) {
      variables = {
        "clubCode": clubCode,
        "player": player,
      };
      result = await _client.mutate(
        MutationOptions(
          documentNode: gql(markMemberReadQuery),
          variables: variables,
        ),
      );
    } else {
      variables = {
        "clubCode": clubCode,
      };
      result = await _client.mutate(
        MutationOptions(
          documentNode: gql(markreadHostQuery),
          variables: variables,
        ),
      );
    }

    if (result.hasException) return false;

    return player != null
        ? result.data['markMemberMsgRead'] ?? false
        : result.data['markHostMsgRead'] ?? false;
  }

  static Future<List<HostMessageSummaryModel>> hostMessageSummary(
      {String clubCode}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<HostMessageSummaryModel> allMemberMessages = [];
    Map<String, dynamic> variables = {"clubCode": clubCode};

    QueryResult result;
    result = await _client.query(QueryOptions(
        documentNode: gql(hostMessageSummaryQuery), variables: variables));

    print("result.data ${result.data} ${result.hasException}");
    if (result.hasException) return [];
    result.data['hostMessageSummary'].forEach((e) {
      print("playerId ${e['playerId']}");
      allMemberMessages.add(HostMessageSummaryModel.fromJson(e));
    });

    return allMemberMessages;
  }

  static Future<List<MessagesFromMember>> memberMessages(
      {String clubCode, String player}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<MessagesFromMember> messages = [];
    print("clubCode $clubCode player $player");
    if (player != null) {
      Map<String, dynamic> variables = {"clubCode": clubCode, "player": player};
      QueryResult result;
      result = await _client.query(QueryOptions(
          documentNode: gql(memberMessagesQuery), variables: variables));

      print("result.data ${result.data} ${result.hasException}");
      if (result.hasException) return [];
      result.data['messagesFromMember'].forEach((e) {
        messages.add(MessagesFromMember.fromJson(e));
      });
    } else {
      Map<String, dynamic> variables = {"clubCode": clubCode};
      QueryResult result;
      result = await _client.query(QueryOptions(
          documentNode: gql(hostmessagesQuery), variables: variables));
      print("result.data ${result.data} ${result.hasException}");
      if (result.hasException) return [];
      result.data['messagesFromHost'].forEach((e) {
        messages.add(MessagesFromMember.fromJson(e));
      });
    }

    return messages;
  }

  static Future sendMessage(String text, String player, String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables;
    if (player != null) {
      variables = {
        "clubCode": clubCode,
        "player": player,
        "text": text,
      };
    } else {
      variables = {
        "clubCode": clubCode,
        "text": text,
      };
    }

    QueryResult result;
    if (player != null) {
      result = await _client.mutate(
        MutationOptions(
          documentNode: gql(sendPlayerMessageQuery),
          variables: variables,
        ),
      );
    } else {
      result = await _client.mutate(
        MutationOptions(
          documentNode: gql(playerToHostQuery),
          variables: variables,
        ),
      );
    }
    if (result.hasException) return false;
  }

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

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return false;

    return result.data['updateClub'] ?? false;
  }

  static Future<bool> createClub(String name, String description) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = Club.createClub(name, description);

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query)),
    );

    print(result.exception);

    if (result.hasException) return false;

    String clubID = result.data['createClub'];

    return clubID.isNotEmpty;
  }

  static Future<List<ClubModel>> getMyClubs() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(Clubs.myClubs()),
      ),
    );

    if (result.hasException) return [];

    var jsonResponse = result.data['myClubs'];

    return jsonResponse
        .map<ClubModel>((var clubItem) => ClubModel.fromJson(clubItem))
        .toList();
  }

  static Future<ClubHomePageModel> getClubHomePageData(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      'clubCode': clubCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(ClubHomePageModel.query),
        variables: variables,
      ),
    );

    log('query result: ${result.exception}');

    if (result.hasException) return null;

    String weeklyData =
        await rootBundle.loadString("assets/sample-data/weekly-data.json");
    ClubWeeklyActivityModel weeklyActivity =
        ClubWeeklyActivityModel.fromJson(json.decode(weeklyData));

    return ClubHomePageModel.fromGQLResponse(
        clubCode, result.data, weeklyActivity);
  }
}
