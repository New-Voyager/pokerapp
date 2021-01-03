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
        isOwner
        isManager
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
  bool isManager;
  bool isOwner;

  ClubHomePageModel(String clubCode, String clubName) {
    this.clubCode = clubCode;
    this.clubName = clubName;
    this.liveGames = new List<GameModel>();
    this.playerBalance = null;
  }

  // build data from the graphql response
  ClubHomePageModel.fromGQLResponse(String clubCode, var data) {
    var member = data['member'];

    this.clubName = member['name'];
    this.clubCode = clubCode;
    this.isManager = member['isManager'];
    this.isOwner = member['isOwner'];
    this.playerBalance = double.parse(member['myBalance'].toString());
    this.liveGames = data['liveGames']
        .map<GameModel>((game) => GameModel.fromJson(game))
        .toList();
  }
}
