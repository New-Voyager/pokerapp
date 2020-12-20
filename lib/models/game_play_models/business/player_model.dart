import 'dart:math';

import 'package:pokerapp/enums/game_play_enums/player_type.dart';

class PlayerModel {
  bool isMe;
  String name;
  int seatNo;
  String playerUuid;
  int buyIn;
  bool showBuyIn;
  int stack;
  String avatarUrl;
  String status;

  List<int> cards;
  PlayerType playerType;
  bool highlight;
  bool playerFolded;

  PlayerModel.fromJson(var data) {
    this.name = data['name'];
    this.seatNo = data['seatNo'];
    this.playerUuid = data['playerUuid'];
    this.buyIn = data['buyIn'];
    this.stack = data['stack'];
    this.status = data['status'];

    // default values
    this.isMe = false;
    this.playerType = PlayerType.None;
    this.highlight = false;

    // todo: at later point data may contain the player avatar
    // for now randomly choose from the asset files
    int tmpN = Random().nextInt(6) + 1;
    this.avatarUrl = 'assets/images/$tmpN.png';
  }

  // a util method for updating the class variables
  void update({
    int seatNo,
    int buyIn,
    int stack,
    String status,
    bool showBuyIn,
    PlayerType playerType,
  }) {
    this.seatNo = seatNo ?? this.seatNo;
    this.buyIn = buyIn ?? this.buyIn;
    this.stack = stack ?? this.stack;
    this.status = status;
    this.showBuyIn = showBuyIn ?? this.showBuyIn;
    this.playerType = playerType ?? this.playerType;
  }

  @override
  String toString() => this.name;
}
