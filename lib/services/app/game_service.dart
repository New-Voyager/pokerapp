import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/seat_change_model.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/models/waiting_list_model.dart';

class GameService {
  static String gameDetailQuery = """
      query completedGame(\$gameCode: String!) {
        completedGame(gameCode: \$gameCode) {
          gameType
          gameCode
          gameNum
          startedBy
          startedAt
          endedBy
          endedAt
          sessionTime
          handsPlayed
          runTime
          runTimeStr
          sessionTimeStr
          smallBlind
          bigBlind
          balance
          handsWon
          handsPlayed
          bigWin
          bigWinHand
          bigLoss
          bigLossHand
          preflopHands
          flopHands
          turnHands
          riverHands
          showdownHands
          balance
          handsDealt
          profit
          buyIn
          stackStat {
            handNum
            before
            after
          }
        }
        hhWinners: highHandWinners(gameCode: \$gameCode) {
            rank
            handNum
            playerUuid
            playerName
            gameCode
            highHand
            highHandCards
            playerCards
            boardCards
            handTime
            winner
        }
      }  
  """;
  static Future<GameHistoryDetailModel> getGameHistoryDetail(
      GameHistoryDetailModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(gameDetailQuery), variables: variables));

    if (result.hasException) return null;

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
  }

  static String gameResultTableQuery = """
      query game_result_table(\$gameCode: String!) {
        gameResultTable(gameCode: \$gameCode) {
          playerName
          sessionTime
          sessionTimeStr
          handsPlayed
          buyIn
          profit
          rakePaid
        }
      }
  """;

  static String highhandLogQuery = """
      query (\$gameCode: String!) {
          hhWinners: highHandsByGame(gameCode: \$gameCode) {
            playerUuid
            playerName
            playerCards
            boardCards
            highHand
            handTime
            handNum
            highHandCards
            winner
        }
     }
  """;

  static String liveGameQuery = """
  query {
      liveGames {
          status
          title
          gameCode
          gameType
          clubCode
          clubName
          waitlistCount
          playerStatus
          maxPlayers
          isTableFull
          smallBlind
          bigBlind
          buyInMin
          buyInMax
          tableCount
      } 
    }
  """;

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
    mutation (\$gameCode: String!) {
    confirmed: requestSeatChange(gameCode: \$gameCode)
    }
  """;

  static String addToWaitListQuery = """
    mutation addToWaitList(\$gameCode: String!) {
    confirmed: addToWaitingList(gameCode: \$gameCode)
  }
  """;

  static String removeFromWaitlistQuery = """
    mutation removeFromWaitlist(\$gameCode: String!) {
    confirmed: removeFromWaitingList(gameCode: \$gameCode)
  }
  """;

  static String waitlistQuery = """
   query waitlist(\$gameCode: String!) {
      waitingList(gameCode: \$gameCode) {
        playerUuid
        name
        waitingFrom
      }
    }
  """;
  static String changeWaitlistOrderQuery = """
   mutation(\$gameCode: String!, \$players: [String!]) {
    applyWaitlistOrder(gameCode: \$gameCode, playerUuid: \$players)
  }
  """;

  static Future<bool> changeWaitListOrderList(
      String gameCode, List<String> uuids) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "players": uuids,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(changeWaitlistOrderQuery),
        variables: variables,
      ),
    );
    if (result.hasException) return false;

    return result.data['applyWaitlistOrder'] ?? false;
  }

  static Future<bool> addToWaitList(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(addToWaitListQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return false;

    return result.data['confirmed'] ?? false;
  }

  static Future<bool> removeFromWaitlist(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(removeFromWaitlistQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return false;

    return result.data['confirmed'] ?? false;
  }

  static Future<List<WaitingListModel>> listOfWaitingPlayer(
      String gameCode) async {
    print("gameCode ${gameCode}");
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<WaitingListModel> waitingListPlayers = List<WaitingListModel>();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(documentNode: gql(waitlistQuery), variables: variables));
    print("result.data ${result.data} ${result.hasException}");
    if (result.hasException) return null;
    List players = result.data['waitingList'];
    waitingListPlayers = players.map((e) {
      WaitingListModel player = WaitingListModel.fromJson(e);
      return player;
    }).toList();
    return waitingListPlayers;
  }

  static Future<String> requestForSeatChange(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(requestForSeatChangeQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return "";

    return result.data['confirmed'] ?? "";
  }

  static Future<List<SeatChangeModel>> listOfSeatChange(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<SeatChangeModel> seatChangePlayers = new List<SeatChangeModel>();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(QueryOptions(
        documentNode: gql(listOfSeatChangeQuery), variables: variables));

    if (result.hasException) return null;
    List games = result.data['seatChangeRequests'];
    seatChangePlayers = games.map((e) {
      SeatChangeModel player = SeatChangeModel.fromJson(e);
      return player;
    }).toList();
    return seatChangePlayers;
  }

  static Future<List<GameModel>> getLiveGames() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<GameModel> allLiveGames = new List<GameModel>();

    QueryResult result =
        await _client.query(QueryOptions(documentNode: gql(liveGameQuery)));

    if (result.hasException) return null;

    List games = result.data['liveGames'];
    allLiveGames = games.map((e) {
      GameModel game = GameModel.fromJson(e);
      return game;
    }).toList();
    return allLiveGames;
  }

  static Future<TableRecord> getGameTableRecord(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(QueryOptions(
        documentNode: gql(gameResultTableQuery), variables: variables));

    if (result.hasException) return null;

    return TableRecord.fromJson(result.data['gameResultTable']);
  }

  static Future<List<HighHandWinner>> getHighHandLog(String gameCode) async {
    List<HighHandWinner> log = new List<HighHandWinner>();

    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(QueryOptions(
        documentNode: gql(highhandLogQuery), variables: variables));

    if (result.hasException) return null;

    List hhWinnersData = result.data['hhWinners'];
    log = hhWinnersData.map((e) {
      HighHandWinner winner = new HighHandWinner.fromJson(e);
      //winner.gameCode = gameCode;
      return winner;
    }).toList();
    return log;
  }
}
