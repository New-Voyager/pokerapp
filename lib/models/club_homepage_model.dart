import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';

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
        description
        picUrl
        showHighRankStats
        trackMemberCredit        
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
  List<GameModelNew> liveGames;
  bool isManager;
  bool isOwner;
  ClubWeeklyActivityModel weeklyActivity;
  int pendingMemberCount;
  int hostUnreadMessageCount;
  int unreadMessageCount;
  int memberUnreadMessageCount;
  String description;
  String picUrl;
  bool showHighRankStats;
  bool trackMemberCredit;
  int clubCoins; // filled for club owner and manager
  ClubHomePageModel(String clubCode, String clubName) {
    this.clubCode = clubCode;
    this.clubName = clubName;
    this.liveGames = [];
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
        .map<GameModelNew>((game) => GameModelNew.fromJson(game))
        .toList();
    this.weeklyActivity = activity;
    this.pendingMemberCount = member['pendingMemberCount'] ?? 0;
    this.hostUnreadMessageCount = member['hostUnreadMessageCount'] ?? 0;
    this.unreadMessageCount = member['unreadMessageCount'] ?? 0;
    this.memberUnreadMessageCount = member['memberUnreadMessageCount'] ?? 0;
    this.description = member['description'] ?? "";
    this.picUrl = member['picUrl'] ?? "";
    this.showHighRankStats = member['showHighRankStats'] ?? false;
    this.trackMemberCredit = member['trackMemberCredit'] ?? false;
  }
}
