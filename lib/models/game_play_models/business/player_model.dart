import 'dart:math';

import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/card_helper.dart';

class PlayerModel {
  bool isMe = false;
  String name = '';
  int seatNo = -1;
  String playerUuid = '';
  int buyIn = 0;
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

  // buyin status/timer
  bool showBuyIn = false;
  DateTime buyInTimeExpAt; // unix time in UTC
  bool  buyInExpired = false; // buy in time expired

  // break time
  bool inBreak = false;
  DateTime breakTimeExpAt;

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

    if (data['buyInExpTime'] != null) {
      // buyin time is kept in UTC
      this.buyInTimeExpAt = DateTime.tryParse(data['buyInExpTime']);
      // if (this.buyInTimeExpAt != null) {
      //   this.buyInTimeExpAt = this.buyInTimeExpAt.toLocal();
      // }
      DateTime now = DateTime.now();
      
      print('buyin expires at ${this.buyInTimeExpAt} now: ${now.toIso8601String()} utcNow: ${now.toUtc().toIso8601String()}');
    }

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

  List<CardObject> get cardObjects {
    return this.cards.map<CardObject>((c) => CardHelper.getCard(c)).toList();
  }

  
  @override
  String toString() => this.name;
}
