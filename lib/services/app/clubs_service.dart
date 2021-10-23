import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/exceptions/exceptions.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/club_update_input_model.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/models/host_message_summary_model.dart';
import 'package:pokerapp/models/messages_from_member.dart';

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

  static String myClubs = """
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
        pendingMemberCount
        hostUnreadMessageCount
        unreadMessageCount
        memberUnreadMessageCount
        liveGameCount
      }
    }""";

  static String createClubQuery = """
    mutation (\$name: String! \$description: String!){
      createClub(club: {
        name: \$name
        description: \$description
      })
    }
  """;

  // static String updateClubQuery = """
  //   mutation (\$clubCode: String! \$description: String, \$name: String!) {
  //     updateClub(clubCode: \$clubCode, club: {
  //       name: \$name,
  //       description: \$description,
  //     })
  // }
  // """;

  static String updateClubQuery = """
    mutation (\$clubCode: String!, \$club: ClubUpdateInput!) {
      updateClub(clubCode: \$clubCode, club: \$club)
  }
  """;

  static String deleteClubQuery = """
    mutation (\$clubCode: String!){
      deleteClub(clubCode: \$clubCode)
    }
  """;

  static String getAnnouncementsQuery = """
    query (\$clubCode :String!){
  clubAnnouncements(clubCode : \$clubCode){
    text
    createdAt
    expiresAt
  }
}
  """;

  static String createAnnouncmentQuery = """
   mutation (\$clubCode :String!,\$text :String!,\$expiresAt:DateTime!){
  ret:addClubAnnouncement(clubCode :\$clubCode,text:\$text,expiresAt:\$expiresAt)
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
          document: gql(markMemberReadQuery),
          variables: variables,
        ),
      );
    } else {
      variables = {
        "clubCode": clubCode,
      };
      result = await _client.mutate(
        MutationOptions(
          document: gql(markreadHostQuery),
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
        document: gql(hostMessageSummaryQuery), variables: variables));

    if (result.hasException) return [];
    result.data['hostMessageSummary'].forEach((e) {
      allMemberMessages.add(HostMessageSummaryModel.fromJson(e));
    });

    return allMemberMessages;
  }

  static Future<List<MessagesFromMember>> memberMessages(
      {String clubCode, String player}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<MessagesFromMember> messages = [];
    if (player != null) {
      Map<String, dynamic> variables = {"clubCode": clubCode, "player": player};
      QueryResult result;
      result = await _client.query(QueryOptions(
          document: gql(memberMessagesQuery), variables: variables));

      if (result.hasException) return [];
      result.data['messagesFromMember'].forEach((e) {
        messages.add(MessagesFromMember.fromJson(e));
      });
    } else {
      Map<String, dynamic> variables = {"clubCode": clubCode};
      QueryResult result;
      result = await _client.query(
          QueryOptions(document: gql(hostmessagesQuery), variables: variables));
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
          document: gql(sendPlayerMessageQuery),
          variables: variables,
        ),
      );
    } else {
      result = await _client.mutate(
        MutationOptions(
          document: gql(playerToHostQuery),
          variables: variables,
        ),
      );
    }
    if (result.hasException) return false;
  }

  static Future<bool> deleteClub(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = deleteClubQuery;
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) return false;

    return result.data['deleteClub'] ?? false;
  }

  // static Future<bool> updateClub(
  //   String clubCode,
  //   String name,
  //   String description,
  // ) async {
  //   GraphQLClient _client = graphQLConfiguration.clientToQuery();
  //   String _query = updateClubQuery;
  //   Map<String, dynamic> variables = {
  //     "name": name,
  //     "description": description,
  //     "clubCode": clubCode,
  //   };

  //   QueryResult result = await _client.mutate(
  //     MutationOptions(document: gql(_query), variables: variables),
  //   );

  //   if (result.hasException) return false;

  //   return result.data['updateClub'] ?? false;
  // }

  static Future<bool> updateClubInput(
      String clubCode, ClubUpdateInput input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "club": {
        "name": input.name,
        "description": input.description,
        "showHighRankStats": input.showHighRankStats
      }
    };

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(updateClubQuery), variables: variables),
    );

    if (result.hasException) return false;

    return result.data['updateClub'] ?? false;
  }

  static Future<String> createClub(String name, String description) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = createClubQuery;
    Map<String, dynamic> variables = {
      "name": name,
      "description": description,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        //throw result.exception.graphqlErrors[0];
        throw GQLException.withGQLErrror(result.exception.graphqlErrors);
      }
    }

    String clubCode = result.data['createClub'];

    return clubCode;
  }

  static Future<bool> createAnnouncement(
      String clubCode, String text, DateTime expiresAt) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "text": text,
      "expiresAt": expiresAt.toString()
    };

    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(createAnnouncmentQuery), variables: variables),
    );

    if (result.hasException) return false;

    log("Result of createNewQuery : ${result.data}");
    bool res = result.data['ret'];

    return res ?? false;
  }

  static Future<List<AnnouncementModel>> getAnnouncementsForAClub(
      String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"clubCode": clubCode};
    QueryResult result = await _client.query(
      QueryOptions(document: gql(getAnnouncementsQuery), variables: variables),
    );

    if (result.hasException) return [];

    var jsonResponse = result.data['clubAnnouncements'];

    return jsonResponse
        .map<AnnouncementModel>(
            (var announce) => AnnouncementModel.fromJson(announce))
        .toList();
  }

  static Future<List<ClubModel>> getMyClubs() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(myClubs),
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
    log('Getting club home page data');
    Map<String, dynamic> variables = {
      'clubCode': clubCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(ClubHomePageModel.query),
        variables: variables,
      ),
    );

    // log('query result: ${result.exception}');

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    String weeklyData =
        await rootBundle.loadString("assets/sample-data/weekly-data.json");
    ClubWeeklyActivityModel weeklyActivity =
        ClubWeeklyActivityModel.fromJson(json.decode(weeklyData));

    return ClubHomePageModel.fromGQLResponse(
        clubCode, result.data, weeklyActivity);
  }

  static leaveClub(String clubCode) async {
    final String query = """
      mutation leaveClub(\$clubCode : String!){
      ret : leaveClub(clubCode:\$clubCode)
    }
    """;
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      'clubCode': clubCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: variables,
      ),
    );

    // log('query result: ${result.exception}');

    if (result.hasException) {
      return false;
    }

    return result.data['ret'] ?? false;
  }

  static Future<int> getClubCoins(String clubCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    log('Getting club home page data');
    Map<String, dynamic> variables = {
      'clubCode': clubCode,
    };
    final String query = """
      query clubCoins(\$clubCode : String!){
        ret : clubCoins(clubCode:\$clubCode)
      }
    """;
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: variables,
      ),
    );

    // log('query result: ${result.exception}');

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    return result.data['ret'];
  }


  static Future<String> kickMember(
      String clubCode, String playerId) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "playerUuid": playerId,
    };
    final String query = """
      mutation kickMember(\$clubCode : String!, \$playerUuid: String!){
        ret: kickMember(clubCode:\$clubCode, playerUuid: \$playerUuid)
      }
    """;
    QueryResult result = await _client.mutate(
      MutationOptions(
          document: gql(query), variables: variables),
    );

    if (result.hasException) return '';

    String res = result.data['ret'];

    return res ?? false;
  }

}
