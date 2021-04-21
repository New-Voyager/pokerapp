import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'hand_result.dart';
import 'player_action.dart';
import 'players.dart';
import 'table_state.dart';

/*
 * This class maintains game state. This game state is used by game play screen.
 * All the other states in the game play screen are managed by this game state object.
 */
class GameState {
  ListenableProvider<MarkedCards> _markedCards;
  Provider<GameMessagingService> _gameMessagingService;
  ListenableProvider<HandInfoState> _handInfo;
  ListenableProvider<TableState> _tableState;
  ListenableProvider<Players> _players;
  ListenableProvider<ActionState> _playerAction;
  ListenableProvider<HandResultState> _handResult;
  ListenableProvider<MyState> _myStateProvider;
  MyState _myState;

  String _gameCode;
  GameInfoModel _gameInfo;
  Map<int, Seat> _seats = Map<int, Seat>();
  String _currentPlayerUuid;

  void initialize({
    String gameCode,
    GameInfoModel gameInfo,
    String uuid,
    GameMessagingService gameMessagingService,
  }) {
    this._seats = Map<int, Seat>();
    this._gameInfo = gameInfo;
    this._gameCode = gameCode;
    this._currentPlayerUuid = uuid;

    for (int seatNo = 1; seatNo <= gameInfo.maxPlayers; seatNo++) {
      this._seats[seatNo] = Seat(seatNo, seatNo, null);
    }

    final tableState = TableState();
    if (gameInfo != null) {
      tableState.updateGameStatusSilent(gameInfo.status);
      tableState.updateTableStatusSilent(gameInfo.tableStatus);
    }

    this._gameMessagingService = Provider<GameMessagingService>(
      create: (_) => gameMessagingService,
    );

    this._handInfo =
        ListenableProvider<HandInfoState>(create: (_) => HandInfoState());
    this._tableState =
        ListenableProvider<TableState>(create: (_) => tableState);
    this._playerAction =
        ListenableProvider<ActionState>(create: (_) => ActionState());
    this._handResult =
        ListenableProvider<HandResultState>(create: (_) => HandResultState());

    this._myState = MyState();
    this._myStateProvider =
        ListenableProvider<MyState>(create: (_) => this._myState);
    /* provider for holding the marked cards */
    this._markedCards =
        ListenableProvider<MarkedCards>(create: (_) => MarkedCards());

    List<PlayerModel> players = [];
    if (gameInfo.playersInSeats != null) {
      players = gameInfo.playersInSeats;
    }

    final values = PlayerStatus.values;
    for (var player in players) {
      if (player.playerUuid == this._currentPlayerUuid) {
        player.isMe = true;
        if (player.status == null) {
          player.status = AppConstants.NOT_PLAYING;
        }
        log('name: ${player.name} player status: ${player.status}');
        this._myState.status = values
            .firstWhere((e) => e.toString() == 'PlayerStatus.' + player.status);
      }
      if (player.buyInTimeExpAt != null && player.stack == 0) {
        // show buyin button/timer if the player is in middle of buyin
        player.showBuyIn = true;
      }
    }

    this._players = ListenableProvider<Players>(
      create: (_) => Players(
        players: players,
      ),
    );
  }

  GameInfoModel get gameInfo {
    return this._gameInfo;
  }

  String get gameCode {
    return this._gameCode;
  }

  String get currentPlayerUuid {
    return this._currentPlayerUuid;
  }

  void refresh(BuildContext context) async {
    log('************ Refreshing game state');
    // fetch new player using GameInfo API and add to the game
    GameInfoModel gameInfo = await GameService.getGameInfo(this._gameCode);

    this._gameInfo = gameInfo;

    // reset seats
    for (var seat in this._seats.values) {
      seat.player = null;
    }

    final players = this.getPlayers(context);
    List<PlayerModel> playersInSeats = [];
    if (gameInfo.playersInSeats != null) {
      playersInSeats = gameInfo.playersInSeats;
    }

    // show buyin button/timer if the player is in middle of buyin
    for (var player in playersInSeats) {
      if (player.buyInTimeExpAt != null && player.stack == 0) {
        player.showBuyIn = true;
      }

      if (player.seatNo != 0) {
        final seat = this._seats[player.seatNo];
        seat.player = player;
      }

      if (player.playerUuid == this._currentPlayerUuid) {
        player.isMe = true;
      }
    }
    players.updatePlayersSilent(playersInSeats);

    final tableState = this.getTableState(context);
    tableState.updateGameStatusSilent(gameInfo.status);
    tableState.updateTableStatusSilent(gameInfo.tableStatus);
    players.notifyAll();
    tableState.notifyAll();
    for (Seat seat in this._seats.values) {
      seat.notify();
    }
  }

  void seatPlayer(int seatNo, PlayerModel player) {
    //debugPrint('SeatNo $seatNo player: ${player.name}');
    if (this._seats.containsKey(seatNo)) {
      this._seats[seatNo].player = player;
    }
  }

  List<Seat> get seats {
    return this._seats.values.toList();
  }

  static GameState getState(BuildContext context) =>
      Provider.of<GameState>(context, listen: false);

  void clear(BuildContext context) {
    final tableState = this.getTableState(context);
    final players = this.getPlayers(context);
    final handResult = this.getResultState(context);

    // clear players
    players.clear();

    // clear table state
    tableState.clear();
    tableState.notifyAll();

    handResult.reset();
    handResult.notifyAll();
  }

  GameMessagingService getGameMessagingService(BuildContext context) =>
      Provider.of<GameMessagingService>(
        context,
        listen: false,
      );

  HandInfoState getHandInfo(BuildContext context, {bool listen = false}) =>
      Provider.of<HandInfoState>(context, listen: listen);

  TableState getTableState(BuildContext context, {bool listen = false}) =>
      Provider.of<TableState>(context, listen: listen);

  Players getPlayers(BuildContext context, {bool listen = false}) =>
      Provider.of<Players>(context, listen: listen);

  ActionState getActionState(BuildContext context, {bool listen = false}) =>
      Provider.of<ActionState>(context, listen: listen);

  HandResultState getResultState(BuildContext context, {bool listen = false}) =>
      Provider.of<HandResultState>(context, listen: listen);

  MarkedCards getMarkedCards(
    BuildContext context, {
    bool listen = false,
  }) =>
      Provider.of<MarkedCards>(
        context,
        listen: listen,
      );

  MyState getMyState(BuildContext context, {bool listen: false}) {
    return Provider.of<MyState>(context, listen: listen);
  }

  MyState get myState => this._myState;

  Seat mySeat(BuildContext context) {
    final players = getPlayers(context);
    final me = players.me;
    if (me == null) {
      return null;
    }
    final seat = getSeat(context, me.seatNo);
    return seat;
  }

  BoardAttributesObject getBoardAttributes(BuildContext context,
      {bool listen: false}) {
    return Provider.of<BoardAttributesObject>(context, listen: listen);
  }

  Seat getSeat(BuildContext context, int seatNo, {bool listen: false}) {
    return this._seats[seatNo];
  }

  void markOpenSeat(BuildContext context, int seatNo) {
    final seat = getSeat(context, seatNo);
    seat.player = null;
    seat.notify();
  }

  void resetActionHighlight(BuildContext context, int nextActionSeatNo,
      {bool listen: false}) {
    for (final seat in this._seats.values) {
      if (seat.player != null && seat.player.highlight) {
        // debugPrint('*** seatNo: ${seat.serverSeatPos} highlight: ${seat.player.highlight} nextActionSeatNo: $nextActionSeatNo');
        seat.player.highlight = false;
        seat.notify();
      }
    }
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
      this._handResult,
      this._myStateProvider,
      this._markedCards,
      this._gameMessagingService,
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
    players.clear(notify: notify);
  }

  void showAction(BuildContext context, bool show, {bool notify = false}) {
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

void loadGameStateFromFile(BuildContext context) async {
  final data = await rootBundle.loadString('assets/sample-data/players.json');
  final jsonData = json.decode(data);
  final List players = jsonData['players'];
  final gameState = GameState.getState(context);
}
