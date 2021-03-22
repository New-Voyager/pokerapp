import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'players.dart';
import 'table_state.dart';


/*
 * This class maintains game state. This state is updated by hand messages.
 */
class GameState {

  ListenableProvider<HandInfoState> _handInfo;
  ListenableProvider<TableState> _tableState;
  
  ListenableProvider<Players> _players;

  void initialize({List<PlayerModel> players}) {
    // create hand info provider
    this._handInfo = ListenableProvider<HandInfoState>(create: (_) => HandInfoState());
    this._tableState = ListenableProvider<TableState>(create: (_) => TableState());

    if (players == null) {
      players = [];
    }
    this._players = ListenableProvider<Players>(
          create: (_) => Players(
            players: players,
          ),
        );
  }

  void clear(BuildContext context) {
    final tableState = this.getTableState(context);
    final players = this.getPlayers(context);
    
    // clear players
    players.clear();

    // clear table state
    tableState.clear();
    tableState.notifyAll();
  }

  HandInfoState getHandInfo(BuildContext context, {bool listen: false}) {
    return Provider.of<HandInfoState>(context, listen: listen);
  }

  TableState getTableState(BuildContext context, {bool listen: false}) {
    return Provider.of<TableState>(context, listen: listen);
  }

  Players getPlayers(BuildContext context, {bool listen: false}) {
    return Provider.of<Players>(context, listen: listen);
  }

  void setPlayers(BuildContext ctx, List<PlayerModel> players) {
    this.getPlayers(ctx).update(players);
  }

  List<SingleChildWidget> get providers {
    return [
      this._handInfo,
      this._tableState,
      this._players,
    ];
  }

  PlayerModel me(BuildContext context) {
    Players players = getPlayers(context);
    return players.me;
  }

  PlayerModel fromSeat(BuildContext context, int seatNo) {
    Players players = getPlayers(context);
    return players.fromSeat(seatNo);
  }

  void updatePlayers(BuildContext context) {
    final players = getPlayers(context);
    players.notifyAll();
  }

  void newPlayer(BuildContext context, PlayerModel newPlayer) {
    final players = getPlayers(context);
    players.addNewPlayerSilent(newPlayer);
  }

  void removePlayer(BuildContext context, int seatNo) {
    final players = getPlayers(context);
    players.removePlayerSilent(seatNo);
  }
  
  void resetPlayers(BuildContext context, {bool notify = false}) {
    final players = this.getPlayers(context);
    // remove all highlight winners
    players.removeWinnerHighlightSilent();

    // before marking the small, big blind or the dealer, remove any marking from the old hand
    players.removeMarkersFromAllPlayerSilent();

    // remove all the status (last action) of all the players
    players.removeAllPlayersStatusSilent();

    // remove all the folder players
    players.removeAllFoldedPlayersSilent();

    /* reset the noCardsVisible of each player and remove my cards too */
    players.removeCardsFromAllSilent();

    /* reset the reverse pot chips animation */
    players.resetMoveCoinsFromPotSilent();

    if (notify) {
      players.notifyAll();
    }
  }
}

/*
 * Maintains state of the current hand information. This information is populated at the beginning of the hand.
 */
class HandInfoState extends ChangeNotifier {
  int _noCards = 0;
  GameType _gameType = GameType.UNKNOWN;
  int _handNum = 0;

  get noCards {
    return _noCards;  
  }

  get gameType {
    return _gameType;
  }

  get handNum {
    return _handNum;
  }

  void clear() {
    this._noCards = 0;
    // this._gameType = GameType.UNKNOWN;
    // this._handNum = 0;
  }

  update({int noCards, GameType gameType, int handNum}) {
    this._noCards = noCards;
    this._gameType = gameType;
    this._handNum = handNum;

    this.notifyListeners();
  }
}
