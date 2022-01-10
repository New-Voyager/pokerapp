import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/seat_change_model.dart';

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

  static String listOfSeatChangeQuery = """
  query (\$gameCode:String!) {
    seatChangeRequests(gameCode: \$gameCode) {
      name
      status
      seatNo
      seatChangeRequestedAt
      sessionTime
      playerUuid
    }
  }
  """;
  static String requestForSeatChangeQuery = """
    mutation (\$gameCode: String!, \$cancel: Boolean) {
    confirmed: requestSeatChange(gameCode: \$gameCode, cancel: \$cancel)
    }
  """;

  static String beginHostSeatChangeQuery = """
  mutation beginHostSeatChange(\$gameCode: String!) {
	seatChange: beginHostSeatChange(
		gameCode: \$gameCode)
  }  
  """;

  static Future<List<SeatChangeModel>> listOfSeatChange(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<SeatChangeModel> seatChangePlayers = [];
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(QueryOptions(
        document: gql(listOfSeatChangeQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    List games = result.data['seatChangeRequests'];
    seatChangePlayers = games.map((e) {
      SeatChangeModel player = SeatChangeModel.fromJson(e);
      return player;
    }).toList();
    return seatChangePlayers;
  }

  /* this method confirms the seat change */
  static Future<bool> confirmSeatChange(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation (\$gameCode: String! \$seatNo: Int!){
        confirmSeatChange(gameCode: \$gameCode, seatNo: \$seatNo)
      }""";
    Map<String, dynamic> variables = {"gameCode": gameCode, "seatNo": seatNo};
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(_mutation),
        variables: variables,
      ),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    return result.data['confirmSeatChange'];
  }

  /* this method declines the seat change */
  static Future<bool> declineSeatChange(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation (\$gameCode: String!){
        declineSeatChange(gameCode: \$gameCode)
      }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(_mutation),
        variables: variables,
      ),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    return result.data['declineSeatChange'];
  }

  static Future<bool> beginHostSeatChange(
    String gameCode,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(beginHostSeatChangeQuery),
        variables: variables,
      ),
    );
    if (result.hasException) return false;
    return result.data['addClubChatText'] ?? false;
  }

  static Future<String> requestForSeatChange(String gameCode,
      {bool cancel = false}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "cancel": false,
    };

    if (cancel ?? false) {
      variables['cancel'] = cancel;
    }
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(requestForSeatChangeQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return "";

    return result.data['confirmed'] ?? "";
  }

  /* player switches to a open seat */
  static Future<String> switchSeat(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      switchSeat(gameCode: "$gameCode", seatNo: $seatNo)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation)),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        throw result.exception;
      }
    }

    return result.data['switchSeat'];
  }
}
