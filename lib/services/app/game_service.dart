import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/announcement_model.dart';
import 'package:pokerapp/models/game/game_player_settings.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game/new_game_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/seat_change_model.dart';
import 'package:pokerapp/models/table_record.dart';
import 'package:pokerapp/models/waiting_list_model.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/services/gql_errors.dart';
import 'package:pokerapp/services/tenor/src/model/tenor_result.dart';
import 'package:pokerapp/widgets/dialogs.dart';

class JoinGameResponse {
  String status;
  bool missedBlind;
}

class SitBackResponse {
  String status;
  bool missedBlind;
}

class GameService {
  static String gameDetailQuery = """
      query completedGame(\$gameCode: String!) {
        completedGame(gameCode: \$gameCode) {
          gameType
          gameCode
          gameNum
          smallBlind
          bigBlind
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
          handsPlayed
          handsDealt
          profit
          buyIn
          highHandTracked
          dataAggregated
          stackStat {
            handNum
            before
            after
          }
          isHost
          isManager
          isOwner

          preflopHands
          flopHands
          turnHands
          riverHands
          showdownHands
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

  static String updateGameSettingsQuery = """
mutation updateInputs(\$gameCode :String!,\$inputSettings: GameSettingsUpdateInput!){
  ret:updateGameSettings(gameCode :\$gameCode settings:\$inputSettings)
}
  """;

  static String getGameSettingsQuery = """
    query gameSettings(\$gameCode: String!) {
      ret:gameSettings(gameCode :\$gameCode){
        audioConfEnabled
        buyInApproval
        runItTwiceAllowed
        allowRabbitHunt
        showHandRank
        doubleBoardEveryHand
        bombPotEnabled
        bombPotBet
        doubleBoardBombPot
        bombPotInterval
        bombPotIntervalInSecs
        bombPotEveryHand
        seatChangeAllowed
        seatChangeTimeout
        waitlistAllowed
        seatChangeTimeout
        waitlistAllowed
        breakAllowed
        breakLength
        ipCheck
        gpsCheck
        roeGames
        dealerChoiceGames
        resultPauseTime
        funAnimations
        chat
      }
    }
""";

  static String getGamePlayerSettingsQuery = """
query mySettings(\$gameCode:String!){
  ret:myGameSettings(gameCode:\$gameCode){
    autoStraddle
    straddle
    buttonStraddle
    bombPotEnabled
    muckLosingHand
    runItTwiceEnabled
  }
}
  """;

  static String updateGamePlayerSettingsQuery = """
  mutation updatePlayerInputs(\$gameCode :String!,\$settings: GamePlayerSettingsUpdateInput!){
    ret:updateGamePlayerSettings(gameCode :\$gameCode settings:\$settings)
  }
  """;

  static String stackStat = """
      query stackStat(\$gameCode: String!) {
        ret: completedGame(gameCode: \$gameCode) {
          stackStat {
            handNum
            before
            after
          }
        }
      }  
  """;

  static String liveStackStat = """
      query stackStat (\$gameCode:String!){
        stackStat: playerStackStat(gameCode:\$gameCode) {
          handNum
          before
          after
        }
      } 
  """;

  static String getNotesForUserQuery = """ 
      query (\$playerUuid: String!){
       ret : notes(playerUuid: \$playerUuid)
      }
  """;

  static String addNotesForUserQuery = """
     mutation setNotes(\$playerUuid:String!,\$notes:String!){
        ret :setNotes(playerUuid:\$playerUuid, notes:\$notes)
      }
  """;

  static String postBlindQuery = """
    mutation postBlind(\$gameCode : String!){
      ret: postBlind(gameCode : \$gameCode)
    }
  """;

  static String systemAnnouncementsQuery = """
    query fetch{
      ret:systemAnnouncements{
        text
        createdAt
        expiresAt
        level
      }
    } 
  """;

  static Future<List<AnnouncementModel>> getSystemAnnouncements() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(systemAnnouncementsQuery),
      ),
    );

    List<AnnouncementModel> list = [];

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return list;
    }

    try {
      if (result.data['ret'] != null) {
        //log(result.data['ret'][0]);
        list = result.data['ret']
            .map<AnnouncementModel>(
                (var announce) => AnnouncementModel.fromJson(announce))
            .toList();
      }
      return list;
    } catch (e) {
      log("Exception : ${e.toString()}");
      return list;
    }
  }

  static Future<bool> setNotesForUser(String playerUuid, String notes) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"playerUuid": playerUuid, "notes": notes};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(addNotesForUserQuery), variables: variables));

    if (result.hasException) {
      log(result.exception.toString());
      return false;
    }
    // ignoring the return value
    return true;
  }

  static Future<String> getNotesForUser(String playerUuid) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"playerUuid": playerUuid};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getNotesForUserQuery), variables: variables));

    if (result.hasException) {
      log(result.exception.toString());
      return "";
    }
    /* Sample return data 
    {
      "data": {
        "ret": "Sample notes2"
      }
    } 
    */
    return result.data['ret'];
  }

  // Post Blinds
  static Future<bool> postBlinds(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"gameCode": gameCode};
    QueryResult result = await _client.query(
        QueryOptions(document: gql(postBlindQuery), variables: variables));

    if (result.hasException) {
      log(result.exception.toString());
      return false;
    }
    /* Sample return data 
    {
      "data": {
        "ret": "Sample notes2"
      }
    } 
    */
    return result.data['ret'];
  }

  static Future<GameSettings> getGameSettings(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"gameCode": gameCode};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getGameSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return null;
    }

    try {
      final GameSettings gameSettings =
          gameSettingsInputFromJson(jsonEncode(result.data['ret']));
      return gameSettings;
    } catch (e) {
      log("Exception : ${e.toString()}");
      return null;
    }
  }

  static Future<bool> updateGameSettings(
      String gameCode, GameSettings input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "inputSettings": input.toJson()
    };
    QueryResult result = await _client.query(QueryOptions(
        document: gql(updateGameSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return false;
    }

    if (result.data['ret'] ?? true) {
      return true;
    }
    return false;
  }

  static Future<GamePlayerSettings> getGamePlayerSettings(
      String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {"gameCode": gameCode};
    QueryResult result = await _client.query(QueryOptions(
        document: gql(getGamePlayerSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return null;
    }

    try {
      final GamePlayerSettings playerSettings =
          gamePlayerSettingsInputFromJson(jsonEncode(result.data['ret']));
      return playerSettings;
    } catch (e) {
      log("Exception : ${e.toString()}");
      return null;
    }
  }

  /// Update game player settings for a game
  static Future<bool> updateGamePlayerSettings(
      String gameCode, GamePlayerSettings input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "settings": input.toJson()
    };
    QueryResult result = await _client.query(QueryOptions(
        document: gql(updateGamePlayerSettingsQuery), variables: variables));

    if (result.hasException) {
      log("Exception : ${result.exception.toString()}");
      return false;
    }

    if (result.data['ret'] ?? true) {
      return true;
    }
    return false;
  }

  static Future<GameHistoryDetailModel> getGameHistoryDetail(
      GameHistoryDetailModel model) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": model.gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(gameDetailQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    // instantiate game history detail object
    model.jsonData = result.data;
    model.load();
    return model;
  }

  static Future<dynamic> getStackStat(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client
        .query(QueryOptions(document: gql(stackStat), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    // return stack stat
    return result.data['ret']['stackStat'];
  }

  static Future<dynamic> getLiveStackStat(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(liveStackStat), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    // return stack stat
    return result.data['stackStat'];
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

  static String downloadResultQuery = """
    query download(\$gameCode:String!) {
      result: downloadResult(gameCode:\$gameCode)  
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
    mutation (\$gameCode: String!, \$cancel: Boolean) {
    confirmed: requestSeatChange(gameCode: \$gameCode, cancel: \$cancel)
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
    mutation updatePlayerGameConfig(\$gameCode:String! \$config:GameConfigChangeInput!) {
      ret: updatePlayerGameConfig(gameCode: \$gameCode, config: \$config)
    }
    """;

  static String leaveGameQuery = """
    mutation (\$gameCode: String!) {
      confirmed: leaveGame(gameCode: \$gameCode)
    }
    """;

  static String dealerChoiceQuery = """
    mutation dealerChoice(\$gameCode: String!, \$gameType: GameType!) {
      ret: dealerChoice(
        gameCode: \$gameCode
        gameType: \$gameType
      )
    }
    """;

  static String liveGamesNewQuery = """
      query liveGames {
        liveGames {
          gameCode
          gameType
          clubName
          buyInMin
          buyInMax
          smallBlind
          bigBlind
          maxPlayers
          elapsedTime
          waitlistCount
          tableCount
          clubCode
        }
      }
    """;

  static String pastGamesQuery = """
      query {
        pastGames {
          clubCode
          clubName
          gameCode
          smallBlind
          bigBlind
          gameType
          startedBy
          startedAt
          endedAt
          endedBy
          runTime
          smallBlind
          bigBlind
          endedAt
          startedAt
          handsDealt
          handsPlayed
          sessionTime
          stack
          buyIn
          balance
        }
      }
    """;
  static String openSeatsQuery = """
      query openSeats(\$gameCode: String!) {
        seats: openSeats(gameCode: \$gameCode)
      }
    """;

  static Future<List<GameModelNew>> getLiveGamesNew() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    final List<GameModelNew> liveGames = [];

    QueryResult result =
        await _client.query(QueryOptions(document: gql(liveGamesNewQuery)));

    // print("result.data ${result.data} ${result.hasException}");
    if (result.hasException) {
      log("Exception In GraphQl Response: ${result.exception}");
    } else {
      try {
        result.data['liveGames'].forEach((item) {
          liveGames.add(GameModelNew.fromJson(item));
        });
      } catch (e) {
        log("Exception in converting to model: $e");
        return liveGames;
      }
    }
    //log("Returning liveGames Count: ${liveGames.length}");
    return liveGames;
  }

  static Future<List<GameHistoryModel>> getPastGames() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<GameHistoryModel> pastGames = [];

    QueryResult result =
        await _client.query(QueryOptions(document: gql(pastGamesQuery)));
    // print("result.data ${result.data} ${result.hasException}");
    if (result.hasException) {
      log("Exception In GraphQl Response: ${result.exception}");
      return pastGames;
    } else {
      debugPrint(jsonEncode(result.data['pastGames']));
      try {
        result.data['pastGames'].forEach((item) {
          pastGames.add(GameHistoryModel.fromJson(item));
        });
      } catch (e) {
        log("Exception in converting to model: $e");
        return pastGames;
      }
    }
    //log("Returning liveGames Count: ${liveGames.length}");
    return pastGames;
  }

  static Future<List<int>> getOpenSeats(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<int> openSeats = [];
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(openSeatsQuery), variables: variables));

    // print("result.data ${result.data} ${result.hasException}");
    if (result.hasException) {
      log("Exception In GraphQl Response: ${result.exception}");
    } else {
      try {
        for (final seat in result.data['seats']) {
          openSeats.add(int.parse(seat.toString()));
        }
      } catch (e) {
        log("Exception in converting to model: $e");
      }
    }
    return openSeats;
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
    print("result $result");
    return result.data['addClubChatText'] ?? false;
  }

  static Future<List<String>> _getPresetTextsFromServer() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<String> favouriteGiphies = [];

    QueryResult result;

    result = await _client.query(QueryOptions(
      document: gql(favouriteGiphiesQuery),
    ));

    if (result.hasException) return [];

    for (int i = 0; i < result.data['chatTexts'].length; i++)
      favouriteGiphies.add((result.data['chatTexts'][i] as String));

    return favouriteGiphies;
  }

  static const FAVOURITE_TEXTS = 'FAVOURITE_TEXTS';
  static const LOCAL_KEY = 'LOCAL:';

  static List<String> _getPresetTextsFromLocal() {
    final usBox = HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);

    final rawData = usBox.get(FAVOURITE_TEXTS);

    if (rawData == null) return [];

    final data = jsonDecode(rawData);

    List<String> o = [];
    for (final d in data) o.add(d.toString());

    return o;
  }

  static Future<void> _addPresetTextLocal(String text) async {
    final usBox = HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);

    text = LOCAL_KEY + text;

    return usBox.put(
      FAVOURITE_TEXTS,
      jsonEncode(_getPresetTextsFromLocal()..add(text)),
    );
  }

  static Future<void> _removePresetTextLocal(String toBeRemovedText) async {
    final usBox = HiveDatasource.getInstance.getBox(BoxType.USER_SETTINGS_BOX);

    List<String> existing = _getPresetTextsFromLocal();

    existing.remove(toBeRemovedText);

    return usBox.put(FAVOURITE_TEXTS, jsonEncode(existing));
  }

  static List<TenorResult> fetchFavouriteGifs() {
    final fgBox = HiveDatasource.getInstance.getBox(BoxType.FAV_GIF_BOX);

    List<TenorResult> trs = [];

    fgBox.values.forEach((data) => trs.add(TenorResult.fromJson(data)));

    return trs;
  }

  static Future<void> addFavouriteGif(TenorResult r) async {
    final fgBox = HiveDatasource.getInstance.getBox(BoxType.FAV_GIF_BOX);
    return fgBox.put(r.id, r.toJson());
  }

  static Future<void> removeFavouriteGif(TenorResult r) async {
    final fgBox = HiveDatasource.getInstance.getBox(BoxType.FAV_GIF_BOX);
    return fgBox.delete(r.id);
  }

  static bool isGifFavourite(TenorResult r) {
    final fgBox = HiveDatasource.getInstance.getBox(BoxType.FAV_GIF_BOX);
    return fgBox.containsKey(r.id);
  }

  static Future<List<String>> getPresetTexts() async {
    /* fetch initial presets from server */

    List<String> presetTextsFromServer = await _getPresetTextsFromServer();
    List<String> presetTextsFromLocal = _getPresetTextsFromLocal();

    return presetTextsFromServer + presetTextsFromLocal;
  }

  static Future<void> addPresetText(String text) => _addPresetTextLocal(text);

  static Future<void> removePresetText(String text) =>
      _removePresetTextLocal(text);

  static Future<bool> changeWaitListOrderList(
      String gameCode, List<String> uuids) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "players": uuids,
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(changeWaitlistOrderQuery),
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
        document: gql(addToWaitListQuery),
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
        document: gql(removeFromWaitlistQuery),
        variables: variables,
      ),
    );

    if (result.hasException) return false;

    return result.data['confirmed'] ?? false;
  }

  static Future<List<WaitingListModel>> listOfWaitingPlayer(
      String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<WaitingListModel> waitingListPlayers = [];
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(waitlistQuery), variables: variables));
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    List players = result.data['waitingList'];
    waitingListPlayers = players.map((e) {
      WaitingListModel player = WaitingListModel.fromJson(e);
      return player;
    }).toList();
    return waitingListPlayers;
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

  static Future<List<GameModel>> getLiveGames() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    List<GameModel> allLiveGames = [];

    QueryResult result =
        await _client.query(QueryOptions(document: gql(liveGameQuery)));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

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
        document: gql(gameResultTableQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    return TableRecord.fromJson(result.data['gameResultTable']);
  }

  static Future<String> downloadResult(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(downloadResultQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    return result.data['result'].toString();
  }

  static Future<List<HighHandWinner>> getHighHandLog(String gameCode) async {
    List<HighHandWinner> log = [];

    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    QueryResult result = await _client.query(
        QueryOptions(document: gql(highhandLogQuery), variables: variables));

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

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
        document: gql(updatePlayerGameConfig),
        variables: variables,
      ),
    );
    if (result.hasException) return false;
    print("result $result");
    return result.data['ret'] ?? false;
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

  /* The following method returns back the Game Info Model */
  static Future<GameInfoModel> getGameInfo(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = GameInfoModel.query(gameCode);

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query)),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final jsonResponse = result.data['gameInfo'];
    // JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    // String prettyprint = encoder.convert(jsonResponse);
    // debugPrint(prettyprint, wrapWidth: 4096);
    return GameInfoModel.fromJson(jsonResponse);
  }

  /* this method joins the game at a particular seat number */
  static Future<JoinGameResponse> joinGame(String gameCode, int seatNo) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      status: joinGame(gameCode: "$gameCode", seatNo: $seatNo) {
        status
        missedBlind
      }
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation)),
    );

    if (result.hasException) {
      throw GqlError.fromException(result.exception);
    }
    JoinGameResponse resp = JoinGameResponse();
    resp.status = result.data['status']['status'];
    resp.missedBlind = result.data['status']['missedBlind'];
    return resp;
  }

  static Future<PlayerModel> takeSeat(String gameCode, int seatNo,
      {LocationData location}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation =
        """mutation (\$gameCode: String! \$seatNo: Int! \$location: LocationInput) {
      takeSeat(gameCode: \$gameCode, seatNo: \$seatNo, location: \$location) {
        seatNo
        playerUuid
        playerId
        name
        buyIn
        stack
        status
        buyInExpTime
        breakStartedTime
        breakExpTime
        gameToken
        isBot
        missedBlind
      }
    }
    """;
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "seatNo": seatNo,
    };

    if (location != null) {
      variables["location"] = {
        "lat": location.latitude,
        "long": location.longitude
      };
    }

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation), variables: variables),
    );

    if (result.hasException) {
      throw GqlError.fromException(result.exception);
    }
    final seatPlayer = result.data['takeSeat'];
    PlayerModel player = PlayerModel.fromJson(seatPlayer);
    return player;
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
        return null;
      }
    }

    return result.data['switchSeat'];
  }

  /* the following method facilitates buying chips */
  static Future<bool> buyIn(String gameCode, int amount) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation{
      buyIn(gameCode:"$gameCode", amount: $amount){
        approved
      }
    }
    """;

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation)),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    final buyIn = result.data['buyIn'];
    return buyIn['approved'];
  }

  /* the following method facilitates buying chips */
  static Future<String> reload(String gameCode, int amount) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _mutation = """mutation (\$gameCode: String!, \$amount: Float!)  {
      reload(gameCode:\$gameCode, amount: \$amount){
        approved
      }
    }
    """;
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "amount": amount,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_mutation), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    return result.data['approved'];
  }

  static Future<String> configureClubGame(
    String clubCode,
    NewGameModel input,
  ) async {
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

    try {
      QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_query), variables: variables),
      );


      print(result.exception);
      if (result.hasException) {
        if (result.exception.graphqlErrors.length > 0) {
          return null;
        }
      }

      Map game = result.data['configuredGame'];
      String gameCode = game["gameCode"];
      log('Created game: $gameCode');
      return gameCode;
  } catch(err) {
    log('Error: ${err.toString()}');
    return null;
  }

  }

  static Future<String> configurePlayerGame(
    NewGameModel input,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameInput: GameCreateInput!){
            configuredGame: configureFriendsGame(game: \$gameInput) {
              gameCode
            }
          }
          """;
    Map<String, dynamic> variables = {
      "gameInput": input.toJson(),
    };

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    print(result.exception);
    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    Map game = result.data['configuredGame'];
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
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    Map game = result.data;
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
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    Map game = result.data;
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
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    Map game = result.data;
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
      MutationOptions(document: gql(_mutation), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

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
      MutationOptions(document: gql(leaveGameQuery), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

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
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) return '';

    return result.data['token'].toString();
  }

  static Future<bool> dealerChoice(
    String gameCode,
    GameType gameType,
  ) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables = {
      "gameCode": gameCode,
      "gameType": gameType.toString().replaceAll('GameType.', '')
    };
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(dealerChoiceQuery),
        variables: variables,
      ),
    );
    if (result.hasException) return false;
    print("result $result");
    return result.data['ret'] ?? false;
  }

  static Future<bool> takeBreak(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String!){
            status: takeBreak(gameCode: \$gameCode)
          }""";

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }

    Map game = (result.data as dynamic).data;
    bool status = game["status"];
    log('Take break Game code: $gameCode status: $status');

    return status;
  }

  static Future<SitBackResponse> sitBack(String gameCode,
      {LocationData location}) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          mutation (\$gameCode: String! \$location: LocationInput){
            status: sitBack(gameCode: \$gameCode location: \$location) {
              status
              missedBlind
            }
          }""";

    Map<String, dynamic> variables = {
      "gameCode": gameCode,
    };
    if (location != null) {
      variables["location"] = {
        "lat": location.latitude,
        "long": location.longitude
      };
    }

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        throw GqlError.fromException(result.exception);
      }
    }

    Map game = (result.data as dynamic).data;
    dynamic status = game["status"];
    log('Sit back Game code: $gameCode status: $status');
    SitBackResponse resp = SitBackResponse();
    resp.status = status['status'];
    resp.missedBlind = status['missedBlind'];
    return resp;
  }

  static Future<MyPlayerNotes> getPlayersWithNotes(String gameCode) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
    query notesForPlayers(\$gameCode:String!) {
        notes:   playersWithNotes(gameCode:\$gameCode) {
          notes
          playerId
          playerUuid
        }
      }
    """;
    Map<String, dynamic> variables = {"gameCode": gameCode};
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
