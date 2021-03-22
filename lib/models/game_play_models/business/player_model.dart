import 'dart:math';

import 'package:pokerapp/enums/game_play_enums/player_type.dart';
import 'package:pokerapp/models/game_play_models/ui/seat.dart';

class PlayerModel {
  bool isMe = false;
  String name = '';
  int seatNo = -1;
  String playerUuid = '';
  int buyIn = 0;
  bool showBuyIn = false;
  int stack = 0;
  String avatarUrl = '';
  String status = '';

  List<int> cards = [];
  List<int> highlightCards = [];

  TablePosition playerType;
  bool highlight = false;
  bool playerFolded = false;
  bool winner = false;
  int coinAmount = 0;
  bool animatingCoinMovement = false;
  bool animatingCoinMovementReverse = false;
  bool animatingFold = false;
  bool showFirework = false;

  int noOfCardsVisible = 0;

  /* TODO: CAN WE SAFELY DELETE THIS CONSTRUCTOR? */
  // PlayerModel({
  //   this.name,
  //   this.seatNo,
  //   this.playerUuid,
  //   this.stack,
  //   this.status,
  // });

  PlayerModel({
    String name,
    int seatNo,
    String playerUuid,
    int buyIn,
    int stack,
    String status,
  }) {
    this.name = name;
    this.seatNo = seatNo;
    this.playerUuid = playerUuid;
    this.buyIn = buyIn;
    this.stack = stack;
    this.status = status;

    // default values
    this.isMe = false;

    /* TODO: WHY IS PLAYER TYPE VARIBLAE HOLDING TABLE POSITION? */
    this.playerType = TablePosition.None;
    this.highlight = false;

    // todo: at later point data may contain the player avatar
    // for now randomly choose from the asset files
    int tmpN = Random().nextInt(6) + 1;
    this.avatarUrl = 'assets/images/$tmpN.png';
  }

  PlayerModel.fromJson(var data) {
    this.name = data['name'];
    this.seatNo = data['seatNo'];
    this.playerUuid = data['playerUuid'];
    this.buyIn = data['buyIn'];
    this.stack = data['stack'];
    this.status = data['status'];

    // default values
    this.isMe = false;
    this.playerType = TablePosition.None;
    this.highlight = false;

    this.highlight = false;
    this.playerFolded = false;
    this.winner = false;
    this.coinAmount = 0;
    this.animatingCoinMovement = false;
    this.animatingCoinMovementReverse = false;
    this.animatingFold = false;
    this.showFirework = false;

    this.noOfCardsVisible = 0;

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
    TablePosition playerType,
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
