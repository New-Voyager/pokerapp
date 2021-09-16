import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';

class SeatChangeService {
  SeatChangeService._();

  /* host begins seat change process */
  static Future<bool> hostSeatChangeBegin(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation beginHostSeatChange(\$gameCode: String!) {
	          seatChange: beginHostSeatChange(gameCode: \$gameCode)
        }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    return result.data['seatChange'];
  }

  static Future<bool> hostSeatChangeEnd(String gameCode,
      {bool cancel = false}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation =
        """mutation seatChangeComplete(\$gameCode: String! \$cancel: Boolean) {
            seatChange: seatChangeComplete(gameCode: \$gameCode, cancelChanges: \$cancel)
          }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "cancel": cancel,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    return result.data['seatChange'];
  }

  static Future<bool> hostSeatChangeMove(
      String gameCode, int seat1, int seat2) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation =
        """mutation seatChangeSwapSeats(\$gameCode: String!, \$seatNo1: Int!, \$seatNo2: Int!) {
	          seatChange: seatChangeSwapSeats(gameCode: \$gameCode seatNo1: \$seatNo1 seatNo2: \$seatNo2)
        }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "seatNo1": seat1,
      "seatNo2": seat2
    };
    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    return result.data['seatChange'];
  }

  static Future<List<PlayerInSeat>> hostSeatChangeSeatPositions(
    String gameCode,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String query = """query (\$gameCode: String!) {
        seatPositions(gameCode: \$gameCode, seatChange: true) {
          stack
          seatNo
          name
          playerUuid
        }
      }
    """;
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(query), variables: variables),
    );

    if (result.hasException) {
      return null;
    }
    var players = result.data['seatPositions'];
    List<PlayerInSeat> playersInSeats = [];
    for (var player in players) {
      PlayerInSeat playerInSeat = PlayerInSeat.fromJson(player);
      playersInSeats.add(playerInSeat);
    }

    return playersInSeats;
  }
}
