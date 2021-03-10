import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/player_info.dart';

class PlayerService {
  PlayerService._();

  static Future<PlayerInfo> getMyInfo() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query{
      myInfo{
        id
        uuid
        name
      }
    }
    """;

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;
    return PlayerInfo.fromJson(result.data['myInfo']);
  }


  static Future<Map<int, PlayerInfo>> getPlayerInfoFromIds(List<int> ids)  async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {"ids": ids};

    String _query = """query (\$ids: [Int!]{
      players: idsToPlayerInfo(ids: \$ids) {
        id
        uuid
        name
      }
    }
    """;

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;

    var playerInfo = new Map<int, PlayerInfo>();
    for (var player in result.data['players']) {
      int id = int.parse(player['id'].toString());
      playerInfo[id] = PlayerInfo.fromJson(player);
    }

    return playerInfo;
  }  
}