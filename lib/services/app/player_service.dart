import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/player_info.dart';

class PlayerService {
  PlayerService._();

  static Future<PlayerInfo> getMyInfo(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables;

    String _query = """query {
      myInfo{
        id
        uuid
        name
        channel
      }
    }""";

    if (gameCode != null) {
      _query = """query (\$gameCode: String!){
        myInfo{
          id
          uuid
          name
          channel
        }
        role: playerRole (gameCode: \$gameCode) {
          isHost
          isOwner
          isManager
        }
      }
      """;
      variables = {
        "gameCode": gameCode,
      };
    }

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    debugPrint(jsonEncode(result.data));
    return PlayerInfo.fromJson(result.data);
  }

  static Future<Map<int, PlayerInfo>> getPlayerInfoFromIds(
      List<int> ids) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"ids": ids};

    String _query = """query (\$ids: [Int!]{
      players: idsToPlayersInfo(ids: \$ids) {
        id
        uuid
        name
      }
    }
    """;

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    var playerInfo = new Map<int, PlayerInfo>();
    for (var player in result.data['players']) {
      int id = int.parse(player['id'].toString());
      playerInfo[id] = PlayerInfo.fromJson(player);
    }

    return playerInfo;
  }

  static Future<bool> updateFirebaseToken(String token) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"token": token};

    String _query = """mutation firebaseToken(\$token: String!) {
             ret: updateFirebaseToken(token: \$token)
          }""";

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    bool ret = result.data['ret'];
    return ret;
  }

  static Future<int> getPendingApprovalsCount() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query { approvals: pendingApprovals {name} }""";

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query)),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    var ret = result.data['approvals'] as List;
    return ret.length;
  }

  static Future<List<PendingApproval>> getPendingApprovals() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query { 
      approvals: pendingApprovals {
        name
        amount
        gameCode
        clubCode
        clubName
        gameType
        playerUuid
        approvalType        
      } 
    }""";

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query)),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    if (result.data == null) {
      return null;
    }

    if (result.data['approvals'] == null) {
      return null;
    }

    var resp = result.data['approvals'] as List;
    List<PendingApproval> ret = [];
    for (var item in resp) {
      var approval = PendingApproval.fromJson(item);
      ret.add(approval);
    }
    return ret;
  }

  static Future<bool> approveBuyInRequest(
      String gameCode, String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    mutation approveRequest(\$gameCode: String!, \$playerId: String!) {
      ret: approveRequest(gameCode: \$gameCode, playerUuid: \$playerId, type: BUYIN_REQUEST, status:APPROVED)
    }
  """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "playerId": playerUuid
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    log("Result ${result.data['ret']}");

    return result.data['ret'];
  }

  static Future<bool> approveReloadRequest(
      String gameCode, String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    mutation approveRequest(\$gameCode: String!, \$playerId: String!) {
      ret: approveRequest(gameCode: \$gameCode, playerUuid: \$playerId, type: RELOAD_REQUEST, status:APPROVED)
    }
  """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "playerId": playerUuid
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    return result.data['ret'];
  }

  static Future<bool> declineBuyInRequest(
      String gameCode, String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    mutation denyRequest(\$gameCode: String!, \$playerId: String!) {
      ret : approveRequest(gameCode: \$gameCode, playerUuid: \$playerId, type: BUYIN_REQUEST, status:DENIED)
    }
  """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "playerId": playerUuid
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    log("Result ${result.data}");

    return result.data['ret'];
  }

  static Future<bool> declineReloadRequest(
      String gameCode, String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    mutation denyRequest(\$gameCode: String!, \$playerId: String!) {
      ret : approveRequest(gameCode: \$gameCode, playerUuid: \$playerId, type: RELOAD_REQUEST, status:DENIED)
    }
  """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "playerId": playerUuid
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    log("Result ${result.data}");

    return result.data['ret'];
  }

  static Future<bool> kickPlayer(String gameCode, String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    mutation (\$gameCode: String!, \$playerId: String!) {
      ret : kickOut(gameCode: \$gameCode, playerUuid: \$playerId)
    }
  """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "playerId": playerUuid
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    log("kickPlayer Result ${result.data}");

    return result.data['ret'];
  }

  static Future<bool> sitOutPlayer(String gameCode, String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    mutation (\$gameCode: String!, \$playerId: String!) {
      ret : sitOut(gameCode: \$gameCode, playerUuid: \$playerId)
    }
  """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "playerId": playerUuid
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    log("sitOut Result ${result.data}");

    return result.data['ret'];
  }

  static Future<void> updateLocation(LocationData position) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "location": {"lat": position.latitude, "long": position.longitude}
    };
    String _query = """
      mutation location(\$location:LocationInput!){
        ret:updateLocation(location:\$location)
      }
    """;
    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
  }

  static Future<MyPlayerNotes> getPlayerNotes(List<int> playerIds) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    query notesForPlayers(\$playerIds:[Int!]) {
        notes: notesForPlayers(playerIds:\$playerIds) {
          notes
          playerId
          playerUuid
        }
      }
    """;
    Map<String, dynamic> variables = {"playerIds": playerIds};
    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    var resp = result.data['notes'] as List;
    final playerNotes = MyPlayerNotes.fromJson(resp);
    return playerNotes;
  }
}
