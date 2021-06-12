import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/enums/game_status.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/handlog_cache_service.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/janus/janus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'hand_result.dart';
import 'host_seat_change.dart';
import 'player_action.dart';
import 'players.dart';
import 'table_state.dart';
import 'waitlist_state.dart';

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
  ListenableProvider<WaitlistState> _waitlistProvider;
  ListenableProvider<ServerConnectionState> _connectionState;
  ListenableProvider<JanusEngine> _janusEngine;
  ListenableProvider<PopupButtonState> _popupButtonState;
  ListenableProvider<CommunicationState> _communicationStateProvider;
  CommunicationState _communicationState;

  final Map<String, Uint8List> _audioCache = Map<String, Uint8List>();
  GameComService gameComService;
  Seat popupSelectedSeat;

  MyState _myState;
  SeatPos _tappedSeatPos;

  String _gameCode;
  GameInfoModel _gameInfo;
  Map<int, Seat> _seats = Map<int, Seat>();
  PlayerInfo _currentPlayer;
  JanusEngine janusEngine;
  int _currentHandNum;
  bool _playerSeatChangeInProgress = false;
  int _seatChangeSeat = 0;
  HandlogCacheService handlogCacheService;
  Map<int, String> _handlogs = Map<int, String>();
  List<int> currentCards;
  List<int> lastCards;
  String _lastHand;
  Map<int, String> _playerIdsToNames = Map<int, String>();
  Map<int, List<int>> _myCards = Map<int, List<int>>();

  // host seat change state (only used when initialization)
  List<PlayerInSeat> _hostSeatChangeSeats;
  bool hostSeatChangeInProgress;

  bool gameSounds = false;

  void initialize({
    String gameCode,
    @required GameInfoModel gameInfo,
    @required PlayerInfo currentPlayer,
    GameMessagingService gameMessagingService,
    List<PlayerInSeat> hostSeatChangeSeats,
    bool hostSeatChangeInProgress,
  }) {
    this._seats = Map<int, Seat>();
    this._gameInfo = gameInfo;
    this._gameCode = gameCode;
    this._currentPlayer = currentPlayer;
    this._currentHandNum = -1;
    this._tappedSeatPos = null;

    this._hostSeatChangeSeats = hostSeatChangeSeats;
    this.hostSeatChangeInProgress = hostSeatChangeInProgress ?? false;

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

    this._waitlistProvider =
        ListenableProvider<WaitlistState>(create: (_) => WaitlistState());

    this._connectionState = ListenableProvider<ServerConnectionState>(
        create: (_) => ServerConnectionState());

    _communicationState = CommunicationState();
    this._communicationStateProvider = ListenableProvider<CommunicationState>(
        create: (_) => _communicationState);

    this.janusEngine = JanusEngine(
        gameState: this,
        janusUrl: this.gameInfo.janusUrl,
        roomId: this.gameInfo.janusRoomId,
        janusToken: this.gameInfo.janusToken,
        roomPin: this.gameInfo.janusRoomPin,
        janusSecret: this.gameInfo.janusSecret,
        uuid: this._currentPlayer.uuid,
        playerId: this._currentPlayer.id);

    this._janusEngine =
        ListenableProvider<JanusEngine>(create: (_) => this.janusEngine);

    this._popupButtonState =
        ListenableProvider<PopupButtonState>(create: (_) => PopupButtonState());

    List<PlayerModel> players = [];
    if (gameInfo.playersInSeats != null) {
      players = gameInfo.playersInSeats;
    }

    final values = PlayerStatus.values;
    for (var player in players) {
      if (player.playerId != null) {
        _playerIdsToNames[player.playerId] = player.name;
      }
      if (player.playerUuid == this._currentPlayer.uuid) {
        player.isMe = true;
        if (player.status == null) {
          player.status = AppConstants.NOT_PLAYING;
        }
        //log('name: ${player.name} player status: ${player.status}');
        this._myState.status = values
            .firstWhere((e) => e.toString() == 'PlayerStatus.' + player.status);
      }
      if (player.buyInTimeExpAt != null && player.stack == 0) {
        // show buyin button/timer if the player is in middle of buyin
        player.showBuyIn = true;
      }
      if (player.status == 'IN_BREAK') {
        // show buyin button/timer if the player is in middle of buyin
        player.inBreak = true;
        player.breakTimeExpAt = player.breakTimeExpAt.toLocal();
        DateTime now = DateTime.now();
        if (player.breakTimeExpAt != null) {
          final diff = player.breakTimeExpAt.difference(now);
          log('now: ${now.toIso8601String()} breakTimeExpAt: ${player.breakTimeExpAt.toIso8601String()} break time expires in ${diff.inSeconds}');
        }
      }
    }

    final playersState = Players(
      players: players,
    );

    if (hostSeatChangeInProgress) {
      log('host seat change is in progress');
      playersState.refreshWithPlayerInSeat(_hostSeatChangeSeats, notify: false);
    }

    this._players = ListenableProvider<Players>(create: (_) => playersState);

    log('In GameState initialize(), _gameInfo.status = ${_gameInfo.status}');
    if (_gameInfo.status == AppConstants.GAME_ACTIVE) {
      this._myState.gameStatus = GameStatus.RUNNING;
      this._myState.notify();
    }
  }

  void setTappedSeatPos(BuildContext context, SeatPos seatPos, Seat seat,
      GameComService gameComService) {
    bool showPopup = true;
    this.gameComService = gameComService;
    this.popupSelectedSeat = seat;
    if (this._tappedSeatPos != null) {
      if (this._tappedSeatPos == seatPos) {
        showPopup = false;
      }
      this._tappedSeatPos = null;
      final state = this.getPopupState(context);
      state.notify();
    }

    if (showPopup) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (seatPos != null) {
          this._tappedSeatPos = seatPos;
        } else {
          this._tappedSeatPos = null;
        }

        final state = this.getPopupState(context);
        state.notify();
      });
    }
  }

  void dismissPopup(BuildContext context) {
    this._tappedSeatPos = null;
    final state = this.getPopupState(context);
    state.notify();
  }

  SeatPos get getTappedSeatPos => this._tappedSeatPos;

  GameInfoModel get gameInfo {
    return this._gameInfo;
  }

  String get gameCode {
    return this._gameCode;
  }

  String get currentPlayerUuid {
    return this._currentPlayer.uuid;
  }

  int get currentPlayerId {
    return this._currentPlayer?.id;
  }

  PlayerInfo get currentPlayer {
    return this._currentPlayer;
  }

  bool get audioConfEnabled {
    return this._gameInfo?.audioConfEnabled;
  }

  int get currentHandNum => this._currentHandNum;

  set currentHandNum(int handNum) => this._currentHandNum = currentHandNum;

  void refresh(BuildContext context) async {
    log('************ Refreshing game state');
    // fetch new player using GameInfo API and add to the game
    GameInfoModel gameInfo = await GameService.getGameInfo(this._gameCode);

    this._gameInfo = gameInfo;

    // reset seats
    for (var seat in this._seats.values) {
      seat.player = null;
      seat.potViewPos = null;
      seat.betWidgetPos = null;
    }

    final players = this.getPlayers(context);
    List<PlayerModel> playersInSeats = [];
    if (gameInfo.playersInSeats != null) {
      playersInSeats = gameInfo.playersInSeats;
    }

    for (final player in gameInfo.allPlayers.values) {
      _playerIdsToNames[player.id] = player.name;
    }

    // show buyin button/timer if the player is in middle of buyin
    for (var player in playersInSeats) {
      if (player.buyInTimeExpAt != null && player.stack == 0) {
        player.showBuyIn = true;
        player.buyInTimeExpAt = player.buyInTimeExpAt.toLocal();
      }

      if (player.breakTimeExpAt != null) {
        player.inBreak = true;
        player.breakTimeExpAt = player.breakTimeExpAt.toLocal();
      }

      if (player.seatNo != 0) {
        final seat = this._seats[player.seatNo];
        seat.player = player;
      }

      if (player.playerUuid == this._currentPlayer.uuid) {
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

    log('In GameState refresh(), _gameInfo.status = ${_gameInfo.status}');
    if (_gameInfo.status == AppConstants.GAME_ACTIVE &&
        this._myState.gameStatus != GameStatus.RUNNING) {
      this._myState.gameStatus = GameStatus.RUNNING;
      this._myState.notify();
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

  Seat getSeatByPlayer(int playerId) {
    for (final seat in this._seats.values.toList()) {
      if (seat.player?.playerId == playerId) {
        return seat;
      }
    }
    return null;
  }

  static GameState getState(BuildContext context) => context.read<GameState>();

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

  WaitlistState getWaitlistState(BuildContext context, {bool listen = false}) =>
      Provider.of<WaitlistState>(context, listen: listen);

  ServerConnectionState getConnectionState(BuildContext context,
          {bool listen = false}) =>
      Provider.of<ServerConnectionState>(context, listen: listen);

  PopupButtonState getPopupState(BuildContext context, {bool listen = false}) =>
      Provider.of<PopupButtonState>(context, listen: listen);

  CommunicationState getCommunicationState() => this._communicationState;

  // JanusEngine getJanusEngine(BuildContext context, {bool listen = false}) =>
  //     Provider.of<JanusEngine>(context, listen: listen);

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

  BoardAttributesObject getBoardAttributes(
    BuildContext context, {
    bool listen: false,
  }) {
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
    for (final player in players) {
      if (player.playerId != null) {
        _playerIdsToNames[player.playerId] = player.name;
      }
    }

    this.getPlayers(ctx).update(players);
  }

  Map<int, String> get playerIdToNames => this._playerIdsToNames;

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
      this._waitlistProvider,
      this._connectionState,
      this._janusEngine,
      this._popupButtonState,
      this._communicationStateProvider
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
    if (newPlayer.playerId != null) {
      _playerIdsToNames[newPlayer.playerId] = newPlayer.name;
    }
    players.addNewPlayerSilent(newPlayer);
  }

  void removePlayer(BuildContext context, int seatNo) {
    final players = getPlayers(context);
    final seat = getSeat(context, seatNo);
    if (seat != null && seat.player != null) {
      this.janusEngine.leaveChannel();
    }
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

  //
  void resetSeatActions({bool newHand}) {
    for (final seat in this._seats.values) {
      if (seat.player == null) {
        continue;
      }
      // if newHand is true, we pass 'false' flag to say don't stick any action to player.
      // otherwise stick last player action to nameplate
      seat.player.reset(
          stickAction: newHand ?? false
              ? false
              : (seat.player.action.action == HandActions.ALLIN));
      seat.notify();
    }
  }

  Future<void> animateSeatActions() async {
    for (final seat in this._seats.values) {
      if (seat.player == null) {
        continue;
      }
      seat.player.action.animateAction = true;
      seat.notify();
    }
  }

  bool get playerSeatChangeInProgress => this._playerSeatChangeInProgress;

  set playerSeatChangeInProgress(bool v) =>
      this._playerSeatChangeInProgress = v;

  int get seatChangeSeat => this._seatChangeSeat;

  set seatChangeSeat(int seat) => this._seatChangeSeat = seat;

  HandLogModelNew getHandLog(int handNum) {
    if (_handlogs.containsKey(handNum)) {
      //final String data = jsonDecode(_handlogs[handNum]);
      final handLog = HandLogModelNew.handLogModelNewFromJson(
          _handlogs[handNum],
          serviceResult: true,
          playerIdsToNames: this.playerIdToNames,
          myCards: this._myCards);
      return handLog;
    }
    return null;
  }

  void setHandLog(int handNum, String data, List<int> cards) {
    log(data);
    _handlogs[handNum] = data;
    _myCards[handNum] = cards;
  }

  get lastHand {
    if (_lastHand == null) {
      return null;
    }
    //final jsonData = jsonDecode(_lastHand);
    log(_lastHand);
    final handLog = HandLogModelNew.handLogModelNewFromJson(_lastHand,
        serviceResult: true,
        authorizedToView: true,
        playerIdsToNames: this.playerIdToNames,
        myCards: _myCards);
    return handLog;
  }

  set lastHand(String hand) => _lastHand = hand;

  Future<Uint8List> getAudioBytes(String assetFile) async {
    if (_audioCache[assetFile] == null) {
      log('Loading file $assetFile');
      try {
        final data = (await rootBundle.load(assetFile)).buffer.asUint8List();
        _audioCache[assetFile] = data;
      } catch (err) {
        _audioCache[assetFile] = Uint8List(0);
      }
    }
    return _audioCache[assetFile];
  }
}

/*
 * Maintains state of the current hand information. This information is populated at the beginning of the hand.
 */
class HandInfoState extends ChangeNotifier {
  int _noCards = 0;
  GameType _gameType = GameType.UNKNOWN;
  int _handNum = 0;
  double _smallBlind = 0;
  double _bigBlind = 0;

  int get noCards => _noCards;

  String get gameType {
    String gameTypeStr = '';
    switch (this._gameType) {
      case GameType.HOLDEM:
        gameTypeStr = 'No Limit Holdem';
        break;
      case GameType.PLO:
        gameTypeStr = 'Omaha (PLO)';
        break;
      case GameType.PLO_HILO:
        gameTypeStr = 'Omaha (Hi Lo)';
        break;
      case GameType.FIVE_CARD_PLO:
        gameTypeStr = '5 cards Omaha';
        break;
      case GameType.FIVE_CARD_PLO_HILO:
        gameTypeStr = '5 cards Omaha (Hi Lo)';
        break;
      default:
        gameTypeStr = 'Unknown game';
    }
    return gameTypeStr;
  }

  int get handNum => _handNum;

  void clear() => this._noCards = 0;

  double get smallBlind => this._smallBlind;

  double get bigBlind => this._bigBlind;

  update(
      {int noCards,
      GameType gameType,
      int handNum,
      double smallBlind,
      double bigBlind}) {
    if (noCards != null) this._noCards = noCards;
    if (gameType != null) this._gameType = gameType;
    if (handNum != null) this._handNum = handNum;
    if (smallBlind != null) this._smallBlind = smallBlind;
    if (bigBlind != null) this._bigBlind = bigBlind;
    this.notifyListeners();
  }

  void notify() {
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

enum ConnectionStatus {
  UNKNOWN,
  CONNECTED,
  DISCONNECTED,
  RECONNECTING,
}

class ServerConnectionState extends ChangeNotifier {
  ConnectionStatus _status = ConnectionStatus.UNKNOWN;

  ConnectionStatus get status => this._status;

  set status(ConnectionStatus status) => this._status = status;

  notify() {
    notifyListeners();
  }
}

class PopupButtonState extends ChangeNotifier {
  SeatPos _prevPos = null;
  SeatPos _currentPos = null;

  setCurrentPos(SeatPos pos) {
    _currentPos = pos;
  }

  void notify() {
    notifyListeners();
  }
}

enum AudioConferenceStatus {
  CONNECTING,
  CONNECTED,
  FAILED,
  ERROR,
}

class CommunicationState extends ChangeNotifier {
  AudioConferenceStatus _audioConferenceStatus = AudioConferenceStatus.ERROR;
  bool showTextChat = false;
  bool audioConfEnabled = false;
  bool voiceChatEnable = false;
  bool _muted = false;
  bool _talking = false;

  AudioConferenceStatus get audioConferenceStatus => _audioConferenceStatus;

  set audioConferenceStatus(AudioConferenceStatus audioConferenceStatus) =>
      this._audioConferenceStatus = audioConferenceStatus;

  set muted(bool v) {
    _muted = v;
    notifyListeners();
  }

  bool get muted => _muted ?? false;

  set talking(bool v) {
    _talking = v;
    notifyListeners();
  }

  bool get talking => _talking ?? false;

  void connecting() {
    _audioConferenceStatus = AudioConferenceStatus.CONNECTING;
    notifyListeners();
  }

  void failed() {
    _audioConferenceStatus = AudioConferenceStatus.FAILED;
    notifyListeners();
  }

  void connected() {
    _audioConferenceStatus = AudioConferenceStatus.CONNECTED;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
