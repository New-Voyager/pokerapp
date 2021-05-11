import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/seat_change_model.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/models/waiting_list_model.dart';
import 'package:pokerapp/services/gql_errors.dart';

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

  static String favouriteGiphiesWithClubCodeQuery = """
  query (\$clubCode: String) {
    chatTexts(clubCode: \$clubCode)
  }
  """;

  static String favouriteGiphiesQuery = """
  query {
    chatTexts
  }
  """;

  static String addfavouriteGiphieQuery = """
  mutation (\$text: String!) {
   addChatText(text: \$text)
  }
  """;
  static String beginHostSeatChangeQuery = """
  mutation beginHostSeatChange(\$gameCode: String!) {
	seatChange: beginHostSeatChange(
		gameCode: \$gameCode)
  }  
  """;

  static String updatePlayerGameConfig = """
    mutation muckLosingHand(\$gameCode:String! \$config:GameConfigChangeInput!) {
      ret: updateGameConfig(gameCode: \$gameCode, config: \$config)
    }
    """;

  static String leaveGameQuery = """
    mutation (\$gameCode: String!) {
      confirmed: leaveGame(gameCode: \$gameCode)
    }
    """;

  static Future<bool> beginHostSeatChange(
    String gameCode,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(beginHostSeatChangeQuery),
        variables: variables,
      ),
    );
    if (result.hasException) return false;
    print("result $result");
    return result.data['addClubChatText'] ?? false;
  }

  static Future<List<String>> favouriteGiphies({String gameCode}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<String> favouriteGiphies = List<String>();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result;
    if (gameCode != null) {
      result = await _client.query(QueryOptions(
          documentNode: gql(favouriteGiphiesWithClubCodeQuery),
          variables: variables));
    } else {
      result = await _client.query(QueryOptions(
        documentNode: gql(favouriteGiphiesQuery),
      ));
    }

    print("result.data ${result.data} ${result.hasException}");
    if (result.hasException) return [];
    for (int i = 0; i < result.data['chatTexts'].length; i++) {
      favouriteGiphies.add((result.data['chatTexts'][i] as String));
    }
    return favouriteGiphies;
  }

  static Future<bool> addFavoutireGiphy(
    String name,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "text": name,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(addfavouriteGiphieQuery),
        variables: variables,
      ),
    );
    if (result.hasException) return false;

    return result.data['addClubChatText'] ?? false;
  }

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

  static Future<bool> updateGameConfig(
    String gameCode, {
    bool muckLosingHand,
    bool runItTwicePrompt,
  }) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    Map<String, dynamic> config = {};
    if (muckLosingHand != null) {
      config["muckLosingHand"] = muckLosingHand;
    }

    if (runItTwicePrompt != null) {
      config["runItTwicePrompt"] = runItTwicePrompt;
    }
    variables["config"] = config;

    QueryResult result = await _client.mutate(
      MutationOptions(
        documentNode: gql(updatePlayerGameConfig),
        variables: variables,
      ),
    );
    if (result.hasException) return false;
    print("result $result");
    return result.data['ret'] ?? false;
  }

  /* this method confirms the seat change */
  static Future<bool> confirmSeatChange(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
        confirmSeatChange(gameCode: $gameCode)
      }""";

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['confirmSeatChange'];
  }

  /* The following method returns back the Game Info Model */
  static Future<GameInfoModel> getGameInfo(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = GameInfoModel.query(gameCode);

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query)),
    );

    if (result.hasException) return null;

    final jsonResponse = result.data['gameInfo'];
    // JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    // String prettyprint = encoder.convert(jsonResponse);
    // debugPrint(prettyprint, wrapWidth: 4096);
    return GameInfoModel.fromJson(jsonResponse);
  }

  /* this method joins the game at a particular seat number */
  static Future<String> joinGame(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      joinGame(gameCode: "$gameCode", seatNo: $seatNo)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) {
      throw GqlError.fromException(result.exception);
    }

    return result.data['joinGame'];
  }

  /* player switches to a open seat */
  static Future<String> switchSeat(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      switchSeat(gameCode: "$gameCode", seatNo: $seatNo)
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['switchSeat'];
  }

  /* the following method facilitates buying chips */
  static Future<String> buyIn(String gameCode, int amount) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      buyIn(gameCode:"$gameCode", amount: $amount){
        approved
      }
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation)),
    );

    if (result.hasException) return null;

    return result.data['approved'];
  }

  static Future<String> configureClubGame(
      String clubCode, NewGameModel input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$clubCode: String!, \$gameInput: GameCreateInput!){
            configuredGame: configureGame(clubCode: \$clubCode, game: \$gameInput) {
              gameCode
            }
          }
          """;
    Map<String, dynamic> variables = {
      "clubCode": clubCode,
      "gameInput": input.toJson(),
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
    Map game = (result.data as LazyCacheMap).data['configuredGame'];
    String gameCode = game["gameCode"];
    log('Created game: $gameCode');
    return gameCode;
  }

  static Future<String> startGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: startGame(gameCode: \$gameCode)
          }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;
    Map game = (result.data as LazyCacheMap).data;
    String status = game["status"];
    log('Game code: $gameCode status: $status');
    return status;
  }

  static Future<String> pauseGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: pauseGame(gameCode: \$gameCode)
          }""";

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    Map game = (result.data as LazyCacheMap).data;
    String status = game["status"];
    log('Game code: $gameCode status: $status');

    return status;
  }

  static Future<String> resumeGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: resumeGame(gameCode: \$gameCode)
          }""";

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return null;

    Map game = (result.data as LazyCacheMap).data;
    String status = game["status"];
    log('Game code: $gameCode status: $status');

    return status;
  }

  /* this method ends the game */
  static Future<String> endGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation (\$gameCode: String!) {  
        endGame(gameCode: \$gameCode)
    }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(_mutation), variables: variables),
    );

    if (result.hasException) return null;

    // FIXME: We need to get the proper return value
    return "ended";
  }

  /* this method ends the game */
  static Future<String> leaveGame(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(documentNode: gql(leaveGameQuery), variables: variables),
    );

    if (result.hasException) return null;

    // FIXME: We need to get the proper return value
    return "ended";
  }

  /* returns token used for live audio */
  static Future<String> getLiveAudioToken(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
          query (\$gameCode: String!){
            token: liveAudioToken(gameCode: \$gameCode)
          }""";
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.query(
      QueryOptions(documentNode: gql(_query), variables: variables),
    );

    if (result.hasException) return '';

    return result.data['token'].toString();
  }
}
