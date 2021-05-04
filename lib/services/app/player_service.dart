import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/enums/approval_type.dart';
import 'package:pokerapp/main.dart';
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
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
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
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

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
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    bool ret = result.data['ret'];
    return ret;
  }

  static Future<int> getPendingApprovalsCount() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query { approvals: pendingApprovals {name} }""";

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;

    var ret = result.data['approvals'] as List;
    return ret.length;
  }

  static Future<List<PendingApproval>> getPendingApprovals() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query { 
      approvals: pendingApprovals {
        name
        amount
        outstandingBalance
        gameCode
        clubCode
        clubName
        gameType
        playerUuid        
      } 
    }""";

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;

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

    print(_query);
    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    log("Result ${result.data['ret']}");

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

    print(_query);
    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    log("Result ${result.data}");

    return result.data['ret'];
  }
}
