import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/enums/player_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/agora/agora.dart';
import 'package:pokerapp/services/app/asset_service.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/app/handlog_cache_service.dart';
import 'package:pokerapp/services/data/asset_hive_store.dart';
import 'package:pokerapp/services/data/game_hive_store.dart';
import 'package:pokerapp/services/data/hive_models/game_settings.dart';
import 'package:pokerapp/services/data/user_settings_store.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/services/janus/janus.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;

import 'host_seat_change.dart';
import 'player_action.dart';
import 'players.dart';
import 'table_state.dart';

enum HandState {
  UNKNOWN,
  STARTED,
  NEW_HAND,
  DEAL,
  PREFLOP,
  FLOP,
  TURN,
  RIVER,
  SHOWDOWN,
  RESULT,
  ENDED,
}

enum HoleCardOrder {
  DEALT,
  SEQUENCE,
  SUIT,
  PAIR,
}
List<HoleCardOrder> holeCardOrders = [
  HoleCardOrder.DEALT,
  HoleCardOrder.PAIR,
  HoleCardOrder.SEQUENCE,
  HoleCardOrder.SUIT
];

/*
 * This class maintains game state. This game state is used by game play screen.
 * All the other states in the game play screen are managed by this game state object.
 */
class GameState {
  ListenableProvider<MarkedCards> _markedCards;
  Provider<GameMessagingService> _gameMessagingService;
  ListenableProvider<HandInfoState> _handInfoProvider;
  ListenableProvider<TableState> _tableStateProvider;
  ListenableProvider<Players> _playersProvider;
  ListenableProvider<ActionState> _playerAction;
  ListenableProvider<MyState> _myStateProvider;
  ListenableProvider<ServerConnectionState> _connectionState;
  ListenableProvider<JanusEngine> _janusEngine;
  ListenableProvider<TappedSeatState> _tappedSeatStateProvider;
  ListenableProvider<CommunicationState> _communicationStateProvider;
  ListenableProvider<StraddlePromptState> _straddlePromptProvider;
  ListenableProvider<RedrawTopSectionState> _redrawTopSectionState;
  ListenableProvider<RedrawFooterSectionState>
      _redrawFooterSectionStateProvider;

  StraddlePromptState _straddlePromptState;
  HoleCardsState _holeCardsState;
  ListenableProvider<HoleCardsState> _holeCardsProvider;
  TappedSeatState _tappedSeatState;
  RedrawFooterSectionState _redrawFooterState;

  // For posting blind
  // bool postedBlind;

  CommunicationState _communicationState;
  Players _players;
  TableState _tableState;
  HandInfoState _handInfo;

  final Map<String, Uint8List> _audioCache = Map<String, Uint8List>();
  GameComService gameComService;
  Seat popupSelectedSeat;

  MyState _myState;
  SeatPos _tappedSeatPos;
  HandState handState = HandState.UNKNOWN;

  String _gameCode;
  GameInfoModel _gameInfo;
  Map<int, Seat> _seats = Map<int, Seat>();
  PlayerInfo _currentPlayer;
  JanusEngine janusEngine;
  Agora agoraEngine;
  int _currentHandNum;
  bool _playerSeatChangeInProgress = false;
  int _seatChangeSeat = 0;
  HandlogCacheService handlogCacheService;
  List<int> currentCards;
  List<int> lastCards;
  Map<int, String> _playerIdsToNames = Map<int, String>();
  bool straddlePrompt = false;
  bool straddleBetThisHand = false;

  // host seat change state (only used when initialization)
  List<PlayerInSeat> _hostSeatChangeSeats = [];
  bool hostSeatChangeInProgress = false;

  bool gameSounds = true;
  GameSettings settings;
  GameHiveStore gameHiveStore;
  bool replayMode = false;

  // high-hand state
  dynamic highHand; // high-hand state

  // central board key
  GlobalKey boardKey;

  // tracks whether buyin keyboard is shown or not
  bool buyInKeyboardShown = false;

  // hole card order
  HoleCardOrder holecardOrder = HoleCardOrder.DEALT;

  // last hand number
  int lastHandNum = 0;

  // indicates a hand in progress
  bool handInProgress = false;

  // assets used in the game screen
  GameScreenAssets assets;

  bool isBotGame = false;

  bool uiClosing = false;

  bool customizationMode = false;
  bool showCustomizationEditFooter = true;
  Future<void> initialize({
    String gameCode,
    @required GameInfoModel gameInfo,
    @required PlayerInfo currentPlayer,
    GameMessagingService gameMessagingService,
    List<PlayerInSeat> hostSeatChangeSeats,
    bool hostSeatChangeInProgress,
    bool replayMode,
    bool customizationMode = false,
  }) async {
    // this.postedBlind = true;
    this._seats = Map<int, Seat>();
    this._gameInfo = gameInfo;
    this._gameCode = gameCode;
    this._currentPlayer = currentPlayer;
    this._currentHandNum = -1;
    this._tappedSeatPos = null;
    this.customizationMode = customizationMode;
    this.replayMode = replayMode ?? false;

    this._hostSeatChangeSeats = hostSeatChangeSeats;
    this.hostSeatChangeInProgress = hostSeatChangeInProgress ?? false;

    for (int seatNo = 1; seatNo <= gameInfo.maxPlayers; seatNo++) {
      this._seats[seatNo] = Seat(seatNo, null);
    }

    _tableState = TableState();
    if (gameInfo != null) {
      _tableState.updateGameStatusSilent(gameInfo.status);
      _tableState.updateTableStatusSilent(gameInfo.tableStatus);
    }

    this._gameMessagingService = Provider<GameMessagingService>(
      create: (_) => gameMessagingService,
    );

    this._handInfo = HandInfoState();
    this._handInfoProvider =
        ListenableProvider<HandInfoState>(create: (_) => this._handInfo);
    this._tableStateProvider =
        ListenableProvider<TableState>(create: (_) => _tableState);
    this._playerAction =
        ListenableProvider<ActionState>(create: (_) => ActionState());

    this._myState = MyState();
    this._myStateProvider =
        ListenableProvider<MyState>(create: (_) => this._myState);
    /* provider for holding the marked cards */
    this._markedCards =
        ListenableProvider<MarkedCards>(create: (_) => MarkedCards());

    this._tappedSeatState = TappedSeatState();

    // this._waitlistProvider =
    //     ListenableProvider<WaitlistState>(create: (_) => WaitlistState());

    this._connectionState = ListenableProvider<ServerConnectionState>(
        create: (_) => ServerConnectionState());

    this._redrawTopSectionState = ListenableProvider<RedrawTopSectionState>(
        create: (_) => RedrawTopSectionState());

    this._redrawFooterState = RedrawFooterSectionState();
    this._redrawFooterSectionStateProvider =
        ListenableProvider<RedrawFooterSectionState>(
            create: (_) => this._redrawFooterState);

    _communicationState = CommunicationState(this);
    _straddlePromptState = StraddlePromptState();

    this._communicationStateProvider = ListenableProvider<CommunicationState>(
        create: (_) => _communicationState);
    this._straddlePromptProvider = ListenableProvider<StraddlePromptState>(
        create: (_) => _straddlePromptState);
    _holeCardsState = HoleCardsState();
    this._holeCardsProvider =
        ListenableProvider<HoleCardsState>(create: (_) => _holeCardsState);

    this.janusEngine = JanusEngine(
        gameState: this,
        janusUrl: this.gameInfo.janusUrl,
        roomId: this.gameInfo.janusRoomId,
        janusToken: this.gameInfo.janusToken,
        roomPin: this.gameInfo.janusRoomPin,
        janusSecret: this.gameInfo.janusSecret,
        uuid: this._currentPlayer.uuid,
        playerId: this._currentPlayer.id);

    if (this.gameInfo.useAgora ?? false) {
      this.agoraEngine = Agora(
        appId: this.gameInfo.agoraAppId,
        gameCode: this.gameInfo.gameCode,
        uuid: this._currentPlayer.uuid,
        state: _communicationState,
        gameState: this,
        playerId: this._currentPlayer.id,
      );
    }

    this._janusEngine =
        ListenableProvider<JanusEngine>(create: (_) => this.janusEngine);

    this._tappedSeatStateProvider =
        ListenableProvider<TappedSeatState>(create: (_) => _tappedSeatState);

    List<PlayerModel> players = [];
    if (gameInfo.playersInSeats != null) {
      players = gameInfo.playersInSeats;
    }

    //final values = PlayerStatus.values;
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
        // this._myState.status = values
        //     .firstWhere((e) => e.toString() == 'PlayerStatus.' + player.status);
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
    // load assets
    this.assets = new GameScreenAssets();
    await this.assets.initialize();

    final playersState = Players(
      players: players,
    );

    if (hostSeatChangeInProgress ?? false) {
      log('host seat change is in progress');
      playersState.refreshWithPlayerInSeat(_hostSeatChangeSeats, notify: false);
    }
    _players = playersState;
    this._playersProvider =
        ListenableProvider<Players>(create: (_) => _players);

    log('In GameState initialize(), _gameInfo.status = ${_gameInfo.status}');
    if (_gameInfo.status == AppConstants.GAME_ACTIVE) {
      //this._myState.gameStatus = GameStatus.RUNNING;
      this._myState.notify();
    }

    gameHiveStore = GameHiveStore();
    await gameHiveStore.open(_gameInfo.gameCode);
    if (!(this.customizationMode ?? false)) {
      if (!this.replayMode) {
        if (!gameHiveStore.haveGameSettings()) {
          log('In GameState initialize(), gameBox is empty');

          // create a new settings object, and init it (by init -> saves locally)
          settings = GameSettings(gameCode, gameHiveStore);
          await settings.init();
        } else {
          log('In GameState initialize(), getting gameSettings from gameBox');
          settings = gameHiveStore.getGameSettings();
        }
        log('In GameState initialize(), gameSettings = $settings');
        _communicationState.showTextChat = settings.showChat;
      }
    }
  }

  void close() {
    if (!this.replayMode) {
      gameHiveStore.close();
    }
    if (this.agoraEngine != null) {
      this.agoraEngine.disposeObject();
    }
    if (this.janusEngine != null) {
      this.janusEngine.disposeObject();
    }
  }

  void setTappedSeatPos(
    BuildContext context,
    SeatPos seatPos,
    Seat seat,
    GameComService gameComService,
  ) {
    bool showPopup = true;
    this.gameComService = gameComService;
    this.popupSelectedSeat = seat;
    if (this._tappedSeatPos != null) {
      if (this._tappedSeatPos == seatPos) {
        showPopup = false;
      }
      this._tappedSeatPos = null;
      this._tappedSeatState.notify();
    }

    if (showPopup) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (seatPos != null) {
          this._tappedSeatPos = seatPos;
        } else {
          this._tappedSeatPos = null;
        }
        this._tappedSeatState.notify();
      });
    }
  }

  void dismissPopup(BuildContext context) {
    this._tappedSeatPos = null;
    this._tappedSeatState.notify();
  }

  SeatPos get getTappedSeatPos => this._tappedSeatPos;

  GameInfoModel get gameInfo {
    return this._gameInfo;
  }

  GameType get currentHandGameType {
    return this._handInfo._gameType;
  }

  bool get running {
    if (this._gameInfo.status == 'ACTIVE' &&
        this._gameInfo.tableStatus == 'GAME_RUNNING') {
      return true;
    }
    return false;
  }

  bool get botGame {
    return this._gameInfo.botGame ?? false;
  }

  int get playersInSeatsCount {
    return _players.count;
  }

  Players get players {
    return _players;
  }

  bool get ended {
    return this._gameInfo.status == AppConstants.GAME_ENDED;
  }

  bool get started {
    return this._gameInfo.status == AppConstants.GAME_ACTIVE;
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

  bool get isPlaying {
    for (final seat in this.seats) {
      if (seat.player != null &&
          seat.player.playerId == this.currentPlayer.id) {
        return true;
      }
    }
    return false;
  }

  bool get audioConfEnabled {
    return this._gameInfo?.audioConfEnabled;
  }

  bool get useAgora {
    return this._gameInfo?.useAgora ?? false;
  }

  String get agoraAppId {
    return this._gameInfo?.agoraAppId ?? '';
  }

  String get agoraToken {
    return this._gameInfo?.agoraToken ?? '';
  }

  set agoraToken(String v) {
    this._gameInfo?.agoraToken = v;
  }

  HandInfoState get handInfo => this._handInfo;

  bool get isGameRunning {
    bool tableRunning =
        _tableState.tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING ||
            _tableState.tableStatus == AppConstants.TABLE_STATUS_GAME_RUNNING_1;

    if ((_tableState.gameStatus == AppConstants.GAME_ACTIVE ||
            _tableState.gameStatus == AppConstants.GAME_CONFIGURED) &&
        tableRunning) {
      return true;
    }
    return false;
  }

  int get currentHandNum => this._currentHandNum;

  set currentHandNum(int handNum) => this._currentHandNum = currentHandNum;

  Future<void> refresh(BuildContext context,
      {bool rebuildSeats = false}) async {
    log('************ Refreshing game state');
    // fetch new player using GameInfo API and add to the game
    GameInfoModel gameInfo = await GameService.getGameInfo(this._gameCode);

    this._gameInfo = gameInfo;

    if (rebuildSeats) {
      this._seats.clear();
    }

    // reset seats
    for (var seat in this._seats.values) {
      seat.player = null;
      // seat.potViewPos = null;
      // seat.betWidgetPos = null;
    }

    final players = this._players;
    List<PlayerModel> playersInSeats = [];
    if (gameInfo.playersInSeats != null) {
      playersInSeats = gameInfo.playersInSeats;
    }

    for (final player in gameInfo.allPlayers.values) {
      _playerIdsToNames[player.id] = player.name;
    }

    // for (Seat seat in this._seats.values) {
    //   seat.notify();
    // }
    if (rebuildSeats) {
      log('GameState: Rebuilding all the seats again');
      for (int seatNo = 1; seatNo <= gameInfo.maxPlayers; seatNo++) {
        this._seats[seatNo] = Seat(seatNo, null);
      }
    }

    // show buyin button/timer if the player is in middle of buyin
    for (var player in playersInSeats) {
      player.startingStack = player.stack;
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

    final tableState = this._tableState;
    tableState.updateGameStatusSilent(gameInfo.status);
    tableState.updateTableStatusSilent(gameInfo.tableStatus);
    players.notifyAll();
    tableState.notifyAll();
    for (Seat seat in this._seats.values) {
      seat.notify();
    }

    log('In GameState refresh(), _gameInfo.status = ${_gameInfo.status}');
    if (_gameInfo.status == AppConstants.GAME_ACTIVE &&
        tableState.gameStatus != AppConstants.GAME_RUNNING) {
      //this._myState.gameStatus = GameStatus.RUNNING;
      this._myState.notify();
    }

    this._handInfo.notify();
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

  void rebuildSeats() {
    // log('potViewPos: rebuilding seats.');
    for (final seat in this._seats.values) {
      seat.notify();
    }
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
    final tableState = this.tableState;
    final players = this.getPlayers(context);
    this.holecardOrder = HoleCardOrder.DEALT;
    // clear players
    players.clear();
    if (players.me != null) {
      players.me.rankText = '';
    }

    // clear table state
    tableState.clear();
    tableState.notifyAll();
  }

  GameMessagingService getGameMessagingService(BuildContext context) =>
      Provider.of<GameMessagingService>(
        context,
        listen: false,
      );

  TableState get tableState => this._tableState;

  HandInfoState getHandInfo(BuildContext context, {bool listen = false}) =>
      Provider.of<HandInfoState>(context, listen: listen);

  TableState getTableState(BuildContext context, {bool listen = false}) =>
      Provider.of<TableState>(context, listen: listen);

  Players getPlayers(BuildContext context, {bool listen = false}) =>
      Provider.of<Players>(context, listen: listen);

  ActionState getActionState(BuildContext context, {bool listen = false}) =>
      Provider.of<ActionState>(context, listen: listen);

  // WaitlistState getWaitlistState(BuildContext context, {bool listen = false}) =>
  //     Provider.of<WaitlistState>(context, listen: listen);

  ServerConnectionState getConnectionState(BuildContext context,
          {bool listen = false}) =>
      Provider.of<ServerConnectionState>(context, listen: listen);

  TappedSeatState getTappedSeatState(BuildContext context,
          {bool listen = false}) =>
      Provider.of<TappedSeatState>(context, listen: listen);

  RedrawTopSectionState getRedrawTopSectionState(BuildContext context,
          {bool listen = false}) =>
      Provider.of<RedrawTopSectionState>(context, listen: listen);

  RedrawFooterSectionState getRedrawFooterSectionState(BuildContext context,
          {bool listen = false}) =>
      Provider.of<RedrawFooterSectionState>(context, listen: listen);

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
  RedrawFooterSectionState get redrawFooterState => this._redrawFooterState;

  Seat mySeat(BuildContext context) {
    if (context == null) {
      for (final seat in _seats.values) {
        if (seat.isMe) {
          return seat;
        }
      }
      return null;
    } else {
      final players = getPlayers(context);
      final me = players.me;
      if (me == null) {
        return null;
      }
      final seat = getSeat(context, me.seatNo);
      return seat;
    }
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
      this._handInfoProvider,
      this._tableStateProvider,
      this._playersProvider,
      this._playerAction,
      this._myStateProvider,
      this._markedCards,
      this._gameMessagingService,
      // this._waitlistProvider,
      this._connectionState,
      this._janusEngine,
      this._tappedSeatStateProvider,
      this._communicationStateProvider,
      this._straddlePromptProvider,
      this._holeCardsProvider,
      this._redrawTopSectionState,
      this._redrawFooterSectionStateProvider
    ];
  }

  // PlayerModel me(BuildContext context) {
  //   return _players.me;
  // }

  PlayerModel get me {
    return _players.me;
  }

  String get myStatus {
    final me = this.me;
    if (me != null) {
      return me.status;
    }
    return '';
  }

  PlayerModel fromSeat(BuildContext context, int seatNo) {
    Players players = getPlayers(context);
    return players.fromSeat(seatNo);
  }

  void updatePlayers(BuildContext context) {
    final players = getPlayers(context);
    players.notifyAll();
  }

  bool newPlayer(BuildContext context, PlayerModel newPlayer) {
    final players = this._players; //getPlayers(context);
    if (newPlayer.playerId != null) {
      _playerIdsToNames[newPlayer.playerId] = newPlayer.name;
    }
    return players.addNewPlayerSilent(newPlayer);
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

  void setActionProto(
      BuildContext context, int seatNo, proto.NextSeatAction seatAction) {
    final actionState = getActionState(context);
    actionState.setActionProto(seatNo, seatAction);
  }

  void resetDealerButton() {
    for (final seat in this._seats.values) {
      if (seat.player == null) {
        continue;
      }
      seat.isDealer = false;
    }
  }

  void resetSeatActions({bool newHand}) {
    for (final seat in this._seats.values) {
      if (seat.player == null) {
        continue;
      }
      seat.player.action.animateAction = false;
      // if newHand is true, we pass 'false' flag to say don't stick any action to player.
      // otherwise stick last player action to nameplate
      seat.player.reset(
          stickAction: (newHand ?? false)
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

  Future<Uint8List> getAudioBytes(String assetFile) async {
    if (_audioCache[assetFile] == null) {
      log('Loading file $assetFile');
      try {
        final data = (await rootBundle.load(assetFile)).buffer.asUint8List();
        _audioCache[assetFile] = data;
      } catch (err) {
        log('File loading failed. ${err.toString()}');
        _audioCache[assetFile] = Uint8List(0);
      }
    }
    return _audioCache[assetFile];
  }

  StraddlePromptState get straddlePromptState {
    return this.straddlePromptState;
  }

  PlayerModel getMe() {
    for (PlayerModel player in this._players.players) {
      if (player.isMe) {
        return player;
      }
    }
    return null;
  }

  void changeHoleCardOrder(BuildContext context) {
    int i = HoleCardOrder.values.indexOf(holecardOrder);
    if (i == -1) {
    } else {
      i++;
      if (i >= HoleCardOrder.values.toList().length) {
        i = 0;
      }
    }
    holecardOrder = HoleCardOrder.values[i];
    _holeCardsState.notify();
  }

  List<int> getHoleCards() {
    final player = getMe();
    if (player == null) {
      return [];
    }
    if (player.cards == null) {
      return [];
    }
    if (holecardOrder == HoleCardOrder.DEALT) {
      return player.cards;
    } else if (holecardOrder == HoleCardOrder.PAIR) {
      List<int> playerCards = player.cards.sublist(0, player.cards.length);
      List<int> cardsToReturn = [];
      for (String letter in CardConvUtils.getCardLetters()) {
        List<int> updatedCards = [];
        // let us find out whether we have this card
        for (int i = 0; i < playerCards.length; i++) {
          String cardLetter = CardConvUtils.getCardLetter(playerCards[i]);
          if (cardLetter == letter) {
            cardsToReturn.add(playerCards[i]);
          } else {
            updatedCards.add(playerCards[i]);
          }
        }
        playerCards = updatedCards;
      }
      return cardsToReturn.reversed.toList();
    } else if (holecardOrder == HoleCardOrder.SUIT) {
      List<int> playerCards = player.cards.sublist(0, player.cards.length);
      List<int> cardsToReturn = [];
      for (String suit in CardConvUtils.getCardSuits()) {
        for (String letter in CardConvUtils.getCardLetters()) {
          List<int> updatedCards = [];
          var set1 = Set.from(player.cards);
          var set2 = Set.from(cardsToReturn);
          playerCards = List.from(set1.difference(set2));
          // let us find out whether we have this card
          for (int i = 0; i < playerCards.length; i++) {
            String cardSuit = CardConvUtils.getCardSuit(playerCards[i]);
            if (cardSuit != suit) {
              continue;
            }

            String cardLetter = CardConvUtils.getCardLetter(playerCards[i]);
            if (cardLetter == letter) {
              cardsToReturn.add(playerCards[i]);
            } else {
              updatedCards.add(playerCards[i]);
            }
          }
          playerCards = updatedCards;
        }
      }
      return cardsToReturn.reversed.toList();
    } else if (holecardOrder == HoleCardOrder.SEQUENCE) {
      List<int> remainingCards = player.cards.sublist(0, player.cards.length);
      List<int> cardsToReturn = [];
      while (remainingCards.length > 0) {
        for (String letter in CardConvUtils.getCardLetters()) {
          List<int> updatedCards = [];
          var set1 = Set.from(player.cards);
          var set2 = Set.from(cardsToReturn);
          remainingCards = List.from(set1.difference(set2));
          // let us find out whether we have this card
          for (int i = 0; i < remainingCards.length; i++) {
            String cardLetter = CardConvUtils.getCardLetter(remainingCards[i]);
            if (cardLetter == letter) {
              cardsToReturn.add(remainingCards[i]);
              break;
            } else {
              updatedCards.add(remainingCards[i]);
            }
          }
          remainingCards = updatedCards;
        }
      }
      var set1 = Set.from(player.cards);
      var set2 = Set.from(cardsToReturn);
      remainingCards = List.from(set1.difference(set2));
      cardsToReturn.addAll(remainingCards);
      return cardsToReturn.reversed.toList();
    } else {
      return player.cards.reversed.toList();
    }
  }
}

class TappedSeatState extends ChangeNotifier {
  void notify() {
    this.notifyListeners();
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
  bool _bombPot = false;
  bool _doubleBoard = false;
  double _bombPotBet = 0;

  int get noCards => _noCards;

  GameType get gameTypeVal => this._gameType;

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

  bool get bombPot => this._bombPot;

  bool get doubleBoard => this._doubleBoard;

  double get bombPotBet => this._bombPotBet;

  update(
      {int noCards,
      GameType gameType,
      int handNum,
      double smallBlind,
      double bigBlind,
      bool bombPot,
      bool doubleBoard,
      double bombPotBet}) {
    if (noCards != null) this._noCards = noCards;
    if (gameType != null) this._gameType = gameType;
    if (handNum != null) this._handNum = handNum;
    if (smallBlind != null) this._smallBlind = smallBlind;
    if (bigBlind != null) this._bigBlind = bigBlind;
    this._bombPot = false;
    if (bombPot != null) this._bombPot = bombPot;
    if (this._bombPot) {
      this._doubleBoard = doubleBoard;
      this._bombPotBet = bombPotBet;
    }
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
    this._currentAction = PlayerAction.fromJson(seatNo, seatAction);
  }

  void setActionProto(int seatNo, proto.NextSeatAction seatAction) {
    this._currentAction = PlayerAction.fromProto(seatNo, seatAction);
  }

  PlayerAction get action {
    return this._currentAction;
  }
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

class SeatContextState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

enum AudioConferenceStatus {
  CONNECTING,
  CONNECTED,
  LEFT,
  FAILED,
  ERROR,
}

class CommunicationState extends ChangeNotifier {
  AudioConferenceStatus _audioConferenceStatus = AudioConferenceStatus.ERROR;
  bool showTextChat = true;
  bool audioConfEnabled = false;
  bool voiceChatEnable = false;
  bool _muted = false;
  bool _talking = false;
  final GameState gameState;

  CommunicationState(this.gameState);

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

  void left() {
    _audioConferenceStatus = AudioConferenceStatus.LEFT;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}

class StraddlePromptState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class GameScreenAssets {
  String backdropImage;
  String boardImage;
  String holeCardBackImage;
  String holeCardFaceDir;

  Uint8List backdropBytes;
  Uint8List boardBytes;
  Uint8List holeCardBackBytes;
  Uint8List betImageBytes;
  Map<String, Uint8List> cardStrImage;
  Map<int, Uint8List> cardNumberImage;

  Uint8List getBackDrop() {
    return backdropBytes;
  }

  Uint8List getBoard() {
    return boardBytes;
  }

  Uint8List getHoleCardBack() {
    return holeCardBackBytes;
  }

  Uint8List getHoleCard(int card) {
    return cardNumberImage[card];
  }

  Uint8List getHoleCardStr(String card) {
    return cardStrImage[card];
  }

  Uint8List getBetImage() {
    return betImageBytes;
  }

  Future<void> initialize() async {
    cardStrImage = Map<String, Uint8List>();
    cardNumberImage = Map<int, Uint8List>();
    Asset backdrop =
        AssetService.getAssetForId(UserSettingsStore.getSelectedBackdropId());
    if (backdrop == null) {
      backdrop =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_BACKDROP);
    }
    backdropBytes = await backdrop.getBytes();

    Asset table =
        AssetService.getAssetForId(UserSettingsStore.getSelectedTableId());
    if (table == null) {
      table = AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_TABLE);
    }
    boardBytes = await table.getBytes();

    Asset betImage =
        AssetService.getAssetForId(UserSettingsStore.getSelectedBetDial());
    if (betImage == null) {
      betImage =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_BETDIAL);
    }
    betImageBytes = await betImage.getBytes();

    Asset cardBack =
        AssetService.getAssetForId(UserSettingsStore.getSelectedCardBackId());
    if (cardBack == null) {
      cardBack =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_CARDBACK);
    }
    holeCardBackBytes = await cardBack.getBytes();

    Asset cardFace =
        AssetService.getAssetForId(UserSettingsStore.getSelectedCardFaceId());
    if (cardFace == null) {
      cardFace =
          AssetService.getAssetForId(UserSettingsStore.VALUE_DEFAULT_CARDFACE);
    }

    for (int card in CardConvUtils.cardNumbers.keys) {
      final cardStr = CardConvUtils.getString(card);
      Uint8List cardBytes;
      if (cardFace.bundled ?? false) {
        cardBytes =
            (await rootBundle.load('${cardFace.downloadDir}/$cardStr.svg'))
                .buffer
                .asUint8List();
      } else {
        String filename = '${cardFace.downloadDir}/$card.svg';
        if (!File(filename).existsSync()) {
          filename = '${cardFace.downloadDir}/$card.png';
          if (!File(filename).existsSync()) {
            filename = '${cardFace.downloadDir}/$cardStr.svg';
            if (!File(filename).existsSync()) {
              filename = '${cardFace.downloadDir}/$cardStr.png';
            }
          }
        }
        cardBytes = File(filename).readAsBytesSync();
      }
      cardStrImage[cardStr] = cardBytes;
      cardNumberImage[card] = cardBytes;
    }
  }
}

class HoleCardsState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class RedrawTopSectionState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class RedrawFooterSectionState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
