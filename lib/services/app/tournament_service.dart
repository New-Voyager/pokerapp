import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/tournament/tournament.dart';
import 'package:pokerapp/models/tournament/tournament_settings.dart';

class TournamentService {
  TournamentService._();

  static Future<Tournament> getTournamentInfo(int tournamentId) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables;

    String _query = """query {
      query tournamentInfo($tournamentId: Int!) {
        tournamentInfo: getTournamentInfo(tournamentId: $tournamentId) {
          id
          tournamentChannel
          # minPlayers
          # startingChips
          # maxPlayers
          # maxPlayersInTable
        }
      }""";

    variables = {
      "tournamentId": tournamentId,
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    debugPrint(jsonEncode(result.data));
    return Tournament.fromJson(result.data);
  }

  static Future<int> scheduleTournament(TournamentSettings input) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """
          mutation (\$input: TournamentCreateInput!){
            ret: scheduleTournament(input: \$input)
          }""";
    Map<String, dynamic> variables = {"input": input.toJson()};

    QueryResult result = await _client.mutate(
      MutationOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    return int.parse(result.data['ret'].toString());
  }

  static Future<List<TournamentListItem>> getTournamentList() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    String _query = """
          query tournamentList {
              list: getActiveTournaments {
                tournamentId
                name
                startTime
                startingChips
                minPlayers
                maxPlayersInTable
                maxPlayers
                fillWithBots
                status
                registeredPlayersCount
                botsCount
                activePlayersCount
                createdBy                
              }
            }""";

    Map<String, dynamic> variables = {};

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    debugPrint(jsonEncode(result.data));
    dynamic list = result.data['list'];
    List<TournamentListItem> tournamentList = [];
    for (final item in list) {
      tournamentList.add(TournamentListItem.fromJson(item));
    }
    return tournamentList;
  }

  static Future<GameInfoModel> getTournamentTableInfo(
      int tournamentId, int tableNo) async {
    String query = '''
        query ti(\$tournamentId:Int!, \$tableNo:Int!) {
          ti: getTournamentTableInfo(tournamentId: \$tournamentId, tableNo:\$tableNo) {
            gameID
            actionTime
            maxPlayersInTable
            title
            chipUnit
            smallBlind
            bigBlind
            ante
            status
            tableStatus
            level
            gameType
            nextLevel
            gameCode
            nextLevelTimeInSecs
            gameChatChannel
            gameToPlayerChannel
            playerToHandChannel
            handToPlayerChannel
            handToAllChannel
            clientAliveChannel
            players {
              playerId
              playerUuid
              playerName
              stack
              seatNo
              status
            }
            handToPlayerTextChannel
            playing
          }
        }
      ''';

    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    Map<String, dynamic> variables;

    variables = {
      "tournamentId": tournamentId,
      "tableNo": tableNo,
    };

    QueryResult result = await _client.query(
      QueryOptions(document: gql(query), variables: variables),
    );

    if (result.hasException) {
      if (result.exception.graphqlErrors.length > 0) {
        return null;
      }
    }
    debugPrint(jsonEncode(result.data));
    final ret = GameInfoModel.fromTournamentGameInfoJson(result.data['ti']);
    return ret;
  }
}
