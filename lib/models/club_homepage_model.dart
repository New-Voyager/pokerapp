import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'game_model.dart';

class ClubHomePageModel extends ChangeNotifier {
  // GraphQL query to get data to populate club home page
  static String query = """
    query (\$clubCode: String!) {
      member: clubInfo (clubCode: \$clubCode) {
        name
        myBalance
        joinedAt
        gamesPlayed
        status
      }
      liveGames(clubCode: \$clubCode) {
        status
        title
        gameCode
        gameType
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
    }""";

  String clubName;
  String clubCode;
  double playerBalance;
  List<GameModel> liveGames;

  ClubHomePageModel(String clubCode, String clubName) {
    this.clubCode = clubCode;
    this.clubName = clubName;
    this.liveGames = new List<GameModel>();
    this.playerBalance = null;
  }

  // build data from the graphql response
  ClubHomePageModel.fromGQLResponse(String clubCode, LazyCacheMap data) {
    LazyCacheMap member = data['member'];
    playerBalance = double.parse(member['myBalance'].toString());
    clubName = member['name'].toString();
    List<Object> _liveGames = data['liveGames'];
    liveGames = new List<GameModel>();
    for (LazyCacheMap game in _liveGames) {
      GameModel liveGame = GameModel.fromJson(game);
      liveGames.add(liveGame);
    }
  }
}
