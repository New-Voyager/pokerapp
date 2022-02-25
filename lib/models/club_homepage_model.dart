import 'package:flutter/cupertino.dart';
import 'package:pokerapp/models/club_weekly_activity_model.dart';
import 'package:pokerapp/models/newmodels/game_model_new.dart';

class ManagerRole {
  bool approveMembers = true;
  bool seeTips = true;
  bool makeAnnouncement = true;
  bool sendPrivateMessage = true;
  bool hostGames = true;
  bool approveBuyin = true;
  bool viewMemberActivities = true;
  bool canUpdateCredits = true;

  dynamic toJson() {
    return {
      "approveMembers": approveMembers,
      "seeTips": seeTips,
      "makeAnnouncement": makeAnnouncement,
      "sendPrivateMessage": sendPrivateMessage,
      "hostGames": hostGames,
      "approveBuyin": approveBuyin,
      "viewMemberActivities": viewMemberActivities,
      "canUpdateCredits": canUpdateCredits,
    };
  }
}

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
        isAgent
        canViewAgentReport
        pendingMemberCount
        hostUnreadMessageCount
        unreadMessageCount
        memberUnreadMessageCount
        description
        picUrl
        showHighRankStats
        trackMemberCredit
        availableCredit
        showGameResult
        managerRole {
          approveMembers
          seeTips
          makeAnnouncement
          sendPrivateMessage
          hostGames
          approveBuyin
          viewMemberActivities
          canUpdateCredits
        }        
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
        startedAt
        status
      }  
    }""";

  String clubName;
  String clubCode;
  double playerBalance;
  List<GameModel> liveGames;
  bool isManager;
  bool isOwner;
  bool isAgent;
  bool canViewAgentReport;
  ClubWeeklyActivityModel weeklyActivity;
  int pendingMemberCount;
  int hostUnreadMessageCount;
  int unreadMessageCount;
  int memberUnreadMessageCount;
  String description;
  String picUrl;
  bool showHighRankStats;
  bool trackMemberCredit;
  bool showGameResult;
  double availableCredit;
  bool refreshCredits = false;
  int clubCoins; // filled for club owner and manager
  ManagerRole role = ManagerRole();
  ClubHomePageModel(String clubCode, String clubName) {
    this.clubCode = clubCode;
    this.clubName = clubName;
    this.liveGames = [];
    this.playerBalance = null;
    this.availableCredit = null;
  }

  // build data from the graphql response
  ClubHomePageModel.fromGQLResponse(String clubCode, var data, var activity) {
    var member = data['member'];
    this.clubName = member['name'];
    this.clubCode = clubCode;
    this.isManager = member['isManager'];
    this.isOwner = member['isOwner'];
    this.isAgent = member['isAgent'] ?? false;
    this.canViewAgentReport = member['canViewAgentReport'] ?? false;
    this.playerBalance = double.parse(member['myBalance'].toString());
    this.liveGames = data['liveGames']
        .map<GameModel>((game) => GameModel.fromJson(game))
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
    this.showGameResult = member['showGameResult'] ?? true;
    if (member['availableCredit'] != null) {
      this.availableCredit = double.parse(member['availableCredit'].toString());
    }
    if (data['member']['managerRole'] != null) {
      dynamic role = data['member']['managerRole'];
      this.role.approveBuyin = role['approveBuyin'];
      this.role.seeTips = role['seeTips'];
      this.role.makeAnnouncement = role['makeAnnouncement'];
      this.role.sendPrivateMessage = role['sendPrivateMessage'];
      this.role.hostGames = role['hostGames'];
      this.role.approveMembers = role['approveMembers'];
      this.role.viewMemberActivities = role['viewMemberActivities'];
      this.role.canUpdateCredits = role['canUpdateCredits'];
    }
  }
}
