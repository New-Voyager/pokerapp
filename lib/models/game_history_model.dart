import 'package:pokerapp/enums/game_type.dart';
import 'package:intl/intl.dart';
class GameHistoryModel {
  GameType gameType;
  String gameTypeStr;
  String gameCode;
  double smallBlind;
  double bigBlind;
  String startedBy;
  DateTime startedAt;
  DateTime endedAt;
  int sessionTime;
  String sessionTimeStr;
  int runTime;
  String runTimeStr;
  double balance;
  int handsPlayed;
  final DateFormat formatter = DateFormat.yMd().add_jm(); // internationalize this

  GameHistoryModel.fromJson(var jsonData) {
    gameTypeStr = jsonData["gameType"];
    gameCode = jsonData["gameCode"];
    startedBy = jsonData["startedBy"];
    if (jsonData["endedAt"] != null) {
      endedAt = DateTime.parse(jsonData["endedAt"].toString());
    }
    runTimeStr = jsonData["runTimeStr"];
    runTime = jsonData["runTime"];
    if (jsonData["handsPlayed"] != null) {
      handsPlayed = int.parse(jsonData["handsPlayed"].toString());
    } else {
      handsPlayed = -1;
    }
    if (jsonData["balance"] != null) {
      balance = double.parse(jsonData["balance"].toString());
    }
    sessionTime = int.parse(jsonData["sessionTime"].toString());
    smallBlind = double.parse(jsonData["smallBlind"].toString());
    bigBlind = double.parse(jsonData["bigBlind"].toString());

    if (jsonData["startedAt"] != null) {
      startedAt = DateTime.parse(jsonData["startedAt"].toString());
    }
    if (jsonData["sessionTimeStr"] != null) {
      sessionTimeStr = jsonData["sessionTimeStr"].toString();
    }
  }

  String getGameTypeStr() {
    if (gameTypeStr == 'HOLDEM') {
      return 'No Limit Holdem';
    }
    return gameTypeStr;
  }

  String getStartedAt() {
    return formatter.format(this.startedAt);
  }

  String blinds() {
    return '$smallBlind/$bigBlind';
  }

  String getShortGameType() {
    if (gameTypeStr == 'HOLDEM') {
      return 'NLH';
    } else if (gameTypeStr.contains('5 Card PLO')) {
      return '5PLO';
    }
    return gameTypeStr;
  }
}