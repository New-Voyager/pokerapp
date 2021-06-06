import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';

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
        pendingMemberCount
        hostUnreadMessageCount
        unreadMessageCount
        memberUnreadMessageCount        
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
  ClubWeeklyActivityModel weeklyActivity;
  int pendingMemberCount;
  int hostUnreadMessageCount;
  int unreadMessageCount;
  int memberUnreadMessageCount;

  ClubHomePageModel(String clubCode, String clubName) {
    this.clubCode = clubCode;
    this.clubName = clubName;
    this.liveGames = new List<GameModel>();
    this.playerBalance = null;
  }

  // build data from the graphql response
  ClubHomePageModel.fromGQLResponse(String clubCode, var data, var activity) {
    var member = data['member'];
    this.clubName = member['name'];
    this.clubCode = clubCode;
    this.isManager = member['isManager'];
    this.isOwner = member['isOwner'];
    this.playerBalance = double.parse(member['myBalance'].toString());
    this.liveGames = data['liveGames']
        .map<GameModel>((game) => GameModel.fromJson(game))
        .toList();
    this.weeklyActivity = activity;
    this.pendingMemberCount = member['pendingMemberCount'] ?? 0;
    this.hostUnreadMessageCount = member['hostUnreadMessageCount'] ?? 0;
    this.unreadMessageCount = member['unreadMessageCount'] ?? 0;
    this.memberUnreadMessageCount = member['memberUnreadMessageCount'] ?? 0;
  }
}
