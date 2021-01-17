import 'package:pokerapp/models/game_play_models/ui/card_object.dart';

class HhNotificationModel {
  String gameCode;
  int handNum;
  String playerName;
  List<CardObject> hhCards;
  List<CardObject> playerCards;

  HhNotificationModel({
    this.gameCode,
    this.handNum,
    this.playerName,
    this.hhCards,
    this.playerCards,
  });
}
