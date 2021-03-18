import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/player_info.dart';

class PlayerService {
  PlayerService._();

  static Future<PlayerInfo> getMyInfo(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query (\$gameCode: String!){
      myInfo{
        id
        uuid
        name
      }
      role: playerRole (gameCode: \$gameCode) {
        isHost
        isOwner
        isManager
      }
    }
    """;

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
    return PlayerInfo.fromJson(result.data);
  }
}
