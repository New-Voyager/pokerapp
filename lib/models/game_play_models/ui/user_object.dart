import 'package:flutter/foundation.dart';
import 'package:pokerapp/enums/game_play_enums/player_type.dart';

class Seat {
  bool isMe;
  String name;
  int stack;
  String avatarUrl;
  int buyIn;

  int serverSeatPos;

  List<int> cards;
  List<int> highlightCards;

  // this status is shown to all the players, by showing a little pop up below the user object
  String status;
  bool highlight;
  PlayerType playerType;
  bool playerFolded = false;
  bool winner;
  int coinAmount;
  bool animatingCoinMovement;
  bool animatingCoinMovementReverse;
  bool showFirework;

  int noOfCardsVisible;
  bool animatingFold = false;

  Seat({
    @required this.serverSeatPos,
    @required this.name,
    @required this.stack,
    this.isMe,
    this.avatarUrl,
  });

  @override
  String toString() => this.name;

  get openSeat {
    return name != null;
  }
}
