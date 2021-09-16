import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/screens/main_screens/games_page_view/enums.dart';

/* TODO: EFFICIENCY - ONE CALL TO THE GRAPHQL API IS SUFFICIENT */

class UserGamesService {
  static Future<List<GameModel>> _fetchGames(
      LiveOrPlayedGames liveOrPlayedGames) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(
          liveOrPlayedGames == LiveOrPlayedGames.LiveGames
              ? GameModel.queryLiveGames
              : GameModel.queryPlayedGames,
        ),
      ),
    );

    if (result.hasException) return [];

    var jsonResponse = result.data[
        liveOrPlayedGames == LiveOrPlayedGames.LiveGames
            ? 'liveGames'
            : 'pastGames'];

    return jsonResponse
        .map<GameModel>((var gameItem) => GameModel.fromJson(gameItem))
        .toList();
  }

  /* live games service */
  static Future<List<GameModel>> fetchLiveGames() =>
      _fetchGames(LiveOrPlayedGames.LiveGames);

  /* played games service */
  static Future<List<GameModel>> fetchPlayedGames() =>
      _fetchGames(LiveOrPlayedGames.PlayedGames);
}
