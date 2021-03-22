import 'package:pokerapp/models/game_play_models/business/player_model.dart';

enum TablePosition {
  Dealer,
  SmallBlind,
  BigBlind,
  None,
}

/*
 * This class represents a seat on the poker table. A seat has a number (assigned by the server) and also
 * a locat seat number for display purposes. All the server APIs and messages use server seat number.
 * The local seating is relative to the current user playing the game. The current user is always in the 
 * bottom center seat.
 * 
 * This class has a property to indicate whether the seat is open. If a player is in the seat, then
 * the player property is non null.
 * 
 * In additon to these base attributes, it has attributes for various animations performed in the seat.
 * 
 * e.g. folding, betting, showing cards, highlighting winner, show highhand animation (fireworks) 
 */
class Seat {
  int localSeatPos;
  int serverSeatPos;
  bool _openSeat;
  PlayerModel _player;

  // List<int> cards;
  // List<int> highlightCards;

  // // this status is shown to all the players, by showing a little pop up below the user object
  // String status;
  
  // // seat status for animations
  // bool highlight;
  // TablePosition playerType;
  // bool playerFolded = false;
  // bool winner;
  // int coinAmount;
  // bool animatingCoinMovement;
  // bool animatingCoinMovementReverse;
  // bool showFirework;

  // int noOfCardsVisible;
  // bool animatingFold = false;

  Seat(int localSeatPos, int serverSeatPos, PlayerModel player) {
    this.localSeatPos = localSeatPos;
    this._openSeat = false;
    if (player == null) {
      this._openSeat = true;
    }
    this._player = player;
    this.serverSeatPos = serverSeatPos;
  }

  @override
  String toString() {
    if (player != null) {
      return 'Seat: $serverSeatPos Player: ${_player.name} Stack: ${_player.stack}';
    }
    return 'Seat: $serverSeatPos Open';
  }

  bool get isOpen {
    return _openSeat;
  }

  get player {
    return this._player;
  }

  bool get folded {
    if (this.player == null) {
      return false;
    }
    return this._player.playerFolded;
  }

  List<int> get cards {
    if (this.player == null) {
      return [];
    }
    return this._player.cards;
  }

  bool get isMe {
    if (this.player == null) {
      return false;
    }
    return this._player.isMe;
  }
}
