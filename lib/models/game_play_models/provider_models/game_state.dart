import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'player_action.dart';
import 'players.dart';
import 'table_state.dart';

/*
 * This class maintains game state. This state is updated by hand messages.
 */
class GameState {
  ListenableProvider<HandInfoState> _handInfo;
  ListenableProvider<TableState> _tableState;
  ListenableProvider<Players> _players;
  ListenableProvider<ActionState> _playerAction;

  void initialize({List<PlayerModel> players, GameInfoModel gameInfo}) {
    final tableState = TableState();
    if (gameInfo != null) {
      tableState.updateGameStatusSilent(gameInfo.status);
      tableState.updateTableStatusSilent(gameInfo.tableStatus);
    }

    // create hand info provider
    this._handInfo =
        ListenableProvider<HandInfoState>(create: (_) => HandInfoState());
    this._tableState =
        ListenableProvider<TableState>(create: (_) => tableState);
    this._playerAction =
        ListenableProvider<ActionState>(create: (_) => ActionState());

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

  ActionState getActionState(BuildContext context, {bool listen: false}) {
    return Provider.of<ActionState>(context, listen: listen);
  }

  void setPlayers(BuildContext ctx, List<PlayerModel> players) {
    this.getPlayers(ctx).update(players);
  }

  List<SingleChildStatelessWidget> get providers {
    return [
      this._handInfo,
      this._tableState,
      this._players,
      this._playerAction,
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

  void resetPlayers(BuildContext context, {bool notify = true}) {
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

  void showAction(BuildContext context, bool show) {
    final actionState = getActionState(context);
    actionState.show = show;
  }

  void setAction(BuildContext context, int seatNo, var seatAction) {
    final actionState = getActionState(context);
    actionState.setAction(seatNo, seatAction);
  }
}

/*
 * Maintains state of the current hand information. This information is populated at the beginning of the hand.
 */
class HandInfoState extends ChangeNotifier {
  int _noCards = 0;
  GameType _gameType = GameType.UNKNOWN;
  int _handNum = 0;

  int get noCards {
    return _noCards;
  }

  GameType get gameType {
    return _gameType;
  }

  int get handNum {
    return _handNum;
  }

  void clear() {
    this._noCards = 0;
    // this._gameType = GameType.UNKNOWN;
    // this._handNum = 0;
  }

  update({int noCards, GameType gameType, int handNum}) {
    if (noCards != null) this._noCards = noCards;
    if (gameType != null) this._gameType = gameType;
    if (handNum != null) this._handNum = handNum;

    this.notifyListeners();
  }
}

/* This provider gets a value when YOUR_ACTION message is received,
* other time this value is kept null, signifying,
* there is no action to take on THIS user's end
* */
class ActionState extends ChangeNotifier {
  PlayerAction _currentAction;
  bool _showAction = false;

  set show(bool v) {
    _showAction = v;
    this.notifyListeners();
  }

  bool get show {
    return this._showAction;
  }

  void setAction(int seatNo, var seatAction) {
    this._currentAction = PlayerAction(seatNo, seatAction);
  }

  PlayerAction get action {
    return this._currentAction;
  }
}
