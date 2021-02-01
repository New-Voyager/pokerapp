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
}
