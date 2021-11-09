import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class HHNotificationModel {
  String gameCode;
  int handNum;
  String playerName;
  List<int> hhCards;
  List<int> playerCards;
  List<int> boardCards;

  HHNotificationModel({
    this.gameCode,
    this.handNum,
    this.playerName,
    this.hhCards,
    this.playerCards,
    this.boardCards,
  });
}
