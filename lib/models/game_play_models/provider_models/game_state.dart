import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game/game_player_settings.dart';
import 'package:pokerapp/models/game/game_settings.dart';
import 'package:pokerapp/models/game_play_models/business/game_chat_notfi_state.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/models/rabbit_state.dart';
import 'package:pokerapp/proto/hand.pbenum.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/services/game_play/graphql/gamesettings_service.dart';
import 'package:pokerapp/services/app/handlog_cache_service.dart';
import 'package:pokerapp/services/data/game_hive_store.dart';
import 'package:pokerapp/services/data/hive_models/game_settings.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pokerapp/proto/hand.pb.dart' as proto;

import 'game_assets.dart';
import 'host_seat_change.dart';
import 'player_action.dart';
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
  ListenableProvider<MarkedCards> _markedCardsProvider;
  Provider<GameMessagingService> _gameMessagingService;
  ListenableProvider<HandInfoState> _handInfoProvider;
  ListenableProvider<TableState> _tableStateProvider;
  ListenableProvider<ActionState> _playerActionProvider;
  ListenableProvider<MyState> _myStateProvider;
  ListenableProvider<ServerConnectionState> _connectionStateProvider;
  ListenableProvider<TappedSeatState> _tappedSeatStateProvider;
  ListenableProvider<CommunicationState> _communicationStateProvider;
  ListenableProvider<StraddlePromptState> _straddlePromptProvider;
  ListenableProvider<RedrawBoardSectionState> _redrawBoardSectionStateProvider;
  ListenableProvider<RedrawBackdropSectionState>
      _redrawBackdropSectionStateProvider;
  ListenableProvider<RedrawNamePlateSectionState>
      _redrawNameplateSectionStateProvider;

  ListenableProvider<RedrawFooterSectionState>
      _redrawFooterSectionStateProvider;
  ListenableProvider<HandChangeState> _handChangeStateProvider;
  ListenableProvider<HandResultState> _handResultStateProvider;
  ListenableProvider<HoleCardsState> _holeCardsProvider;
  /* rabbit state */
  ListenableProvider<RabbitState> _rabbitStateProvider;
  ListenableProvider<SeatsOnTableState> _seatsOnTableProvider;
  ListenableProvider<GameSettingsState> _gameSettingsProvider;
  ListenableProvider<ActionTimerState> _actionTimerStateProvider;
  ListenableProvider<SeatChangeNotifier> _seatChangeProvider;
  ListenableProvider<GameChatNotifState> _chatNotifyProvider;

  StraddlePromptState _straddlePromptState;
  HoleCardsState _holeCardsState;
  TappedSeatState _tappedSeatState;
  RedrawFooterSectionState _redrawFooterState;
  RedrawBoardSectionState _redrawBoardState;
  RedrawNamePlateSectionState _redrawNameplateState;
  RedrawBackdropSectionState _redrawBackdropState;

  ActionState _actionState;
  MarkedCards _markedCardsState;
  ServerConnectionState _connectionState;
  HandChangeState _handChangeState;
  HandResultState _handResultState;
  GameMessagingService _gameMessageService;
  RabbitState _rabbitState;
  SeatsOnTableState _seatsOnTableState;
  GameSettingsState _gameSettingsState;
  ActionTimerState _actionTimerState;
  SeatChangeNotifier _seatChangeState;
  GameChatNotifState _chatNotifState;
  AudioConfState _audioConfState;
  GameChatBubbleNotifyState _gameChatBubbleNotifyState;
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  final Map<int, GamePlayerInfo> players = Map<int, GamePlayerInfo>();
  // For posting blind
  // bool postedBlind;

  CommunicationState _communicationState;
  TableState _tableState;
  HandInfoState _handInfo;

  final Map<String, Uint8List> _audioCache = Map<String, Uint8List>();
  GameComService gameComService;
  Seat popupSelectedSeat;

  MyState _myState;
  SeatPos _tappedSeatPos;
  HandState handState = HandState.UNKNOWN;
  HandStatus wonat;

  String _gameCode;
  GameInfoModel _gameInfo;
  GameSettings _gameSettings;
  GamePlayerSettings _playerSettings;
  ClubInfo clubInfo;

  //Map<int, Seat> _seats = Map<int, Seat>();
  List<Seat> _seats = [];
  List<PlayerModel> _playersInGame;

  PlayerInfo _currentPlayer;
  // Agora agoraEngine;
  int _currentHandNum;
  bool _playerSeatChangeInProgress = false;
  Seat _seatChangeSeat = null;
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
  GameLocalConfig playerLocalConfig;
  GameHiveStore gameHiveStore;
  bool replayMode = false;

  // high-hand state
  dynamic highHand; // high-hand state

  // table key - we need this to calculate the exact dimension of the table image
  final GlobalKey tableKey = GlobalKey();

  final ValueNotifier<Size> tableSizeVn = ValueNotifier<Size>(null);

  void calculateTableSizePostFrame({bool force = false}) {
    if (!force && tableSizeVn.value != null) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      while (true) {
        final box = tableKey.currentContext.findRenderObject() as RenderBox;
        if (box.size.shortestSide != 0.0) {
          tableSizeVn.value = box.size;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 10));
      }
    });
  }

  final GlobalKey playerOnTableKey = GlobalKey();

  final GlobalKey boardKey = GlobalKey();

  final ValueNotifier<Offset> playerOnTablePositionVn =
      ValueNotifier<Offset>(null);

  Size _playerOnTableSize;
  Size get playerOnTableSize => _playerOnTableSize;

  void calculatePlayersOnTablePositionPostFrame() {
    if (playerOnTablePositionVn.value != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (playerOnTableKey.currentContext == null) {
        await Future.delayed(const Duration(milliseconds: 10));
      }

      final box =
          playerOnTableKey.currentContext.findRenderObject() as RenderBox;

      _playerOnTableSize = box.size;
      final tempPos = box.localToGlobal(Offset.zero);

      final box1 = boardKey.currentContext.findRenderObject() as RenderBox;
      final playerOnTablePos = box1.globalToLocal(tempPos);

      playerOnTablePositionVn.value = playerOnTablePos;

      print(
        'calculatePlayersOnTablePositionPostFrame: ${playerOnTablePositionVn.value}',
      );
    });
  }

  // tracks whether buyin keyboard is shown or not
  bool buyInKeyboardShown = false;

  // hole card order
  HoleCardOrder holecardOrder = HoleCardOrder.DEALT;

  // last hand number
  int lastHandNum = 0;

  // indicates whether this hand result was showdown or not
  bool showdown = false;

  // indicates a hand in progress
  bool handInProgress = false;

  // assets used in the game screen
  GameScreenAssets assets;

  bool isBotGame = false;

  bool uiClosing = false;

  bool customizationMode = false;
  bool showCustomizationEditFooter = true;

  // location of the current player (valid only if the game requires gps check)
  LocationData currentLocation;

  // players with notes
  MyPlayerNotes playersWithNotes;

  bool chatScreenVisible = false;
  String chatTextBoxText = "";

  // next action id
  String currentActionId;

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
    this.wonat = HandStatus.HandStatus_UNKNOWN;
    this._seats = [];
    this._gameInfo = gameInfo;
    this._gameCode = gameCode;
    this._currentPlayer = currentPlayer;
    this._currentHandNum = -1;
    this._tappedSeatPos = null;
    this.customizationMode = customizationMode;
    this.replayMode = replayMode ?? false;
    this._gameSettings = GameSettings();
    this._playerSettings = GamePlayerSettings();

    this._hostSeatChangeSeats = hostSeatChangeSeats;
    this.hostSeatChangeInProgress = hostSeatChangeInProgress ?? false;

    Map<int, SeatPos> seatPosLoc = getSeatLocations(gameInfo.maxPlayers);
    log('Diagnoal inches: ${Screen.diagonalInches}');
    final seatPosAttribs = getSeatMap(Screen.screenSize);

    // 0: index reserved
    this._seats.add(Seat(0, null, null));
    for (int localSeatNo = 1;
        localSeatNo <= gameInfo.maxPlayers;
        localSeatNo++) {
      SeatPos pos = seatPosLoc[localSeatNo];
      SeatPosAttribs attribs = seatPosAttribs[pos];
      //this._seats[localSeatNo] = Seat(localSeatNo, pos, attribs);
      this._seats.add(Seat(localSeatNo, pos, attribs));
    }

    this._playersInGame = [];

    _tableState = TableState();
    if (gameInfo != null) {
      _tableState.updateGameStatusSilent(gameInfo.status);
      _tableState.updateTableStatusSilent(gameInfo.tableStatus);
    }

    _actionState = ActionState();
    _actionTimerState = ActionTimerState();
    _markedCardsState = MarkedCards();
    _gameMessageService = gameMessagingService;

    this._gameMessagingService = Provider<GameMessagingService>(
      create: (_) => _gameMessageService,
    );
    _gameMessageService?.gameState = this;

    this._handInfo = HandInfoState();
    this._handInfo.update(
          handNum: gameInfo.handNum,
          gameType: gameTypeFromStr(gameInfo.gameType),
          smallBlind: gameInfo.smallBlind.toDouble(),
          bigBlind: gameInfo.bigBlind.toDouble(),
          notify: false,
        );

    this._handInfoProvider =
        ListenableProvider<HandInfoState>(create: (_) => this._handInfo);
    this._tableStateProvider =
        ListenableProvider<TableState>(create: (_) => _tableState);
    this._playerActionProvider =
        ListenableProvider<ActionState>(create: (_) => _actionState);

    this._myState = MyState();
    this._myStateProvider =
        ListenableProvider<MyState>(create: (_) => this._myState);
    /* provider for holding the marked cards */
    this._markedCardsProvider =
        ListenableProvider<MarkedCards>(create: (_) => _markedCardsState);

    this._tappedSeatState = TappedSeatState();
    this._connectionState = ServerConnectionState();
    this._redrawBoardState = RedrawBoardSectionState();
    this._redrawNameplateState = RedrawNamePlateSectionState();
    this._redrawBackdropState = RedrawBackdropSectionState();
    this._handChangeState = HandChangeState();
    this._handResultState = HandResultState();
    this._rabbitState = RabbitState();
    this._seatsOnTableState = SeatsOnTableState();
    this._gameSettingsState = GameSettingsState();
    this._chatNotifState = GameChatNotifState();
    this._gameChatBubbleNotifyState = GameChatBubbleNotifyState();
    this._audioConfState = AudioConfState();

    // this._waitlistProvider =
    //     ListenableProvider<WaitlistState>(create: (_) => WaitlistState());

    this._handChangeStateProvider =
        ListenableProvider<HandChangeState>(create: (_) => _handChangeState);
    this._handResultStateProvider =
        ListenableProvider<HandResultState>(create: (_) => _handResultState);

    this._connectionStateProvider = ListenableProvider<ServerConnectionState>(
        create: (_) => _connectionState);

    this._redrawBoardSectionStateProvider =
        ListenableProvider<RedrawBoardSectionState>(
      create: (_) => _redrawBoardState,
    );

    this._redrawBackdropSectionStateProvider =
        ListenableProvider<RedrawBackdropSectionState>(
      create: (_) => _redrawBackdropState,
    );

    this._redrawNameplateSectionStateProvider =
        ListenableProvider<RedrawNamePlateSectionState>(
      create: (_) => _redrawNameplateState,
    );

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
    this._rabbitStateProvider =
        ListenableProvider<RabbitState>(create: (_) => _rabbitState);
    this._seatsOnTableProvider = ListenableProvider<SeatsOnTableState>(
        create: (_) => _seatsOnTableState);
    this._gameSettingsProvider = ListenableProvider<GameSettingsState>(
        create: (_) => _gameSettingsState);
    this._actionTimerStateProvider =
        ListenableProvider<ActionTimerState>(create: (_) => _actionTimerState);

    /* Provider to deal with host seat change functionality */
    _seatChangeState = SeatChangeNotifier();
    _seatChangeState.initialize(gameInfo.maxPlayers);
    this._seatChangeProvider = ListenableProvider<SeatChangeNotifier>(
      create: (_) => _seatChangeState,
    );

    this._tappedSeatStateProvider =
        ListenableProvider<TappedSeatState>(create: (_) => _tappedSeatState);

    this._chatNotifyProvider =
        ListenableProvider<GameChatNotifState>(create: (_) => _chatNotifState);

    // load assets
    this.assets = new GameScreenAssets();
    await this.assets.initialize();

    List<PlayerModel> players = [];
    if (gameInfo.playersInSeats != null) {
      players = gameInfo.playersInSeats;
    }

    this._playersInGame = [];
    //final values = PlayerStatus.values;
    for (var player in players) {
      if (player.playerId != null) {
        _playerIdsToNames[player.playerId] = player.name;
      }
      if (player.playerUuid == this._currentPlayer.uuid) {
        player.namePlateId = getNameplateId();
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
      player.inhand = true;
      this._playersInGame.add(player);
    }

    // final playersState = Players(
    //   players: players,
    // );

    if (hostSeatChangeInProgress ?? false) {
      log('host seat change is in progress');
      //playersState.refreshWithPlayerInSeat(_hostSeatChangeSeats, notify: false);
      this.seatChangePlayersUpdate(_hostSeatChangeSeats, notify: false);
    }

    log('In GameState initialize(), _gameInfo.status = ${_gameInfo.status}');
    if (_gameInfo.status == AppConstants.GAME_ACTIVE) {
      //this._myState.gameStatus = GameStatus.RUNNING;
      this._myState.notify();
    }

    String code = gameCode;
    if (code == null) {
      code = _gameInfo.gameCode;
    }
    gameHiveStore = GameHiveStore();
    await gameHiveStore.initialize(code);

    if (!(this.customizationMode ?? false)) {
      if (!this.replayMode) {
        if (!gameHiveStore.haveGameSettings()) {
          log('In GameState initialize(), gameBox is empty');

          // create a new settings object, and init it (by init -> saves locally)
          playerLocalConfig = GameLocalConfig(gameCode, gameHiveStore);
          await playerLocalConfig.init();
        } else {
          log('In GameState initialize(), getting gameSettings from gameBox');
          playerLocalConfig = gameHiveStore.getGameConfiguration();
        }
        log('In GameState initialize(), gameSettings = $playerLocalConfig');
        _communicationState.showTextChat = playerLocalConfig.showChat;
      }
    }

    // init card distribution variables
    _initializeCardDistributionMap();
  }

  void close() {
    if (!this.replayMode) {
      if (gameHiveStore != null) {
        gameHiveStore.close();
      }
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

  void dismissPopup() {
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

  bool get botGame {
    return this._gameInfo.botGame ?? false;
  }

  int get playersInSeatsCount {
    return _playersInGame.length;
  }

  List<PlayerModel> get playersInGame {
    return _playersInGame;
  }

  bool get colorCards {
    if (playerLocalConfig == null) {
      return false;
    }
    return playerLocalConfig.colorCards;
  }

  bool get ended {
    return this._gameInfo.status == AppConstants.GAME_ENDED;
  }

  set ended(bool v) {
    this._gameInfo.status = AppConstants.GAME_ENDED;
  }

  MarkedCards get markedCardsState => this._markedCardsState;

  HandChangeState get handChangeState => this._handChangeState;

  HandResultState get handResultState => this._handResultState;

  AudioConfState get audioConfState => this._audioConfState;

  ListenableProvider<HandChangeState> get handChangeStateProvider =>
      this._handChangeStateProvider;

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
    final playerInGame = this.getPlayerById(this.currentPlayerId);
    if (playerInGame != null) {
      return true;
    }
    return false;
  }

  bool get audioConfEnabled {
    return this._gameInfo?.audioConfEnabled ?? false;
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

  RabbitState get rabbitState => this._rabbitState;

  SeatsOnTableState get seatsOnTableState => this._seatsOnTableState;

  GameSettingsState get gameSettingsState => this._gameSettingsState;

  GameSettings get gameSettings => this._gameSettings;

  GamePlayerSettings get playerSettings => this._playerSettings;

  GameChatNotifState get gameChatNotifState => this._chatNotifState;

  GameChatBubbleNotifyState get gameChatBubbleNotifyState =>
      this._gameChatBubbleNotifyState;

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

  Future<void> refreshSettings() async {
    log('************ Refreshing game state');
    // fetch new player using GameInfo API and add to the game
    GameSettings settings = await GameSettingsService.getGameSettings(gameCode);

    // copy values here (we need to keep the reference)
    this._gameSettings.buyInApproval = settings.buyInApproval;
    this._gameSettings.runItTwiceAllowed = settings.runItTwiceAllowed;
    this._gameSettings.allowRabbitHunt = settings.allowRabbitHunt;
    this._gameSettings.showHandRank = settings.showHandRank;
    this._gameSettings.doubleBoardEveryHand = settings.doubleBoardEveryHand;
    this._gameSettings.bombPotEnabled = settings.bombPotEnabled;
    this._gameSettings.bombPotBet = settings.bombPotBet;
    this._gameSettings.doubleBoardBombPot = settings.doubleBoardBombPot;
    this._gameSettings.bombPotInterval = settings.bombPotInterval;
    this._gameSettings.bombPotIntervalInSecs = settings.bombPotIntervalInSecs;
    this._gameSettings.bombPotEveryHand = settings.bombPotEveryHand;
    this._gameSettings.seatChangeAllowed = settings.seatChangeAllowed;
    this._gameSettings.seatChangeTimeout = settings.seatChangeTimeout;
    this._gameSettings.waitlistAllowed = settings.waitlistAllowed;
    this._gameSettings.breakAllowed = settings.breakAllowed;
    this._gameSettings.breakLength = settings.breakLength;
    this._gameSettings.resultPauseTime = settings.resultPauseTime;
    this._gameSettings.ipCheck = settings.ipCheck;
    this._gameSettings.gpsCheck = settings.gpsCheck;
    this._gameSettings.funAnimations = settings.funAnimations;
    this._gameSettings.chat = settings.chat;
    this._gameSettings.showResult = settings.showResult;
    this._gameSettings.roeGames = [];
    this._gameSettings.roeGames.addAll(settings.roeGames);
    this._gameSettings.dealerChoiceGames = [];
    this._gameSettings.dealerChoiceGames.addAll(settings.dealerChoiceGames);
  }

  Future<void> refreshPlayerSettings() async {
    log('************ Refreshing game state');
    GamePlayerSettings settings =
        await GameSettingsService.getGamePlayerSettings(gameCode);

    // copy values here (we need to keep the reference)
    this._playerSettings.autoStraddle = settings.autoStraddle;
    this._playerSettings.bombPotEnabled = settings.bombPotEnabled;
    this._playerSettings.buttonStraddle = settings.buttonStraddle;
    this._playerSettings.buttonStraddleBet = settings.buttonStraddleBet;
    this._playerSettings.muckLosingHand = settings.muckLosingHand;
    this._playerSettings.runItTwiceEnabled = settings.runItTwiceEnabled;
    this._playerSettings.autoReload = settings.autoReload;
    this._playerSettings.reloadThreshold = settings.reloadThreshold;
    this._playerSettings.reloadTo = settings.reloadTo;
  }

  bool get isTableFull {
    for (int i = 1; i <= _gameInfo.maxPlayers; i++) {
      final seat = getSeat(i);
      if (seat?.player == null) {
        return false;
      }
    }
    return true;
  }

  RedrawNamePlateSectionState getNameplateSectionState() =>
      this.redrawNameplateSectionState;

  RedrawBoardSectionState getBoardSectionState() =>
      this.redrawBoardSectionState;

  RedrawBackdropSectionState getBackdropSectionState() =>
      this.redrawBackdropSectionState;

  void redrawBoard() {
    this.redrawBoardSectionState.notify();
  }

  void redrawFooter() {
    this.redrawFooterState.notify();
  }

  Future<void> refresh({bool rebuildSeats = false}) async {
    log('************ Refreshing game state');
    GameInfoModel gameInfo = await GameService.getGameInfo(this._gameCode);
    if (gameInfo == null) {
      // check whether the game has ended
      this._gameInfo.status = 'ENDED';
      return;
    }
    this._gameInfo = gameInfo;
    // reset seats
    for (var seat in this._seats) {
      seat.player = null;
    }

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
    // if (rebuildSeats) {
    //   log('GameState: Rebuilding all the seats again');
    //   Map<int, SeatPos> seatPosLoc = getSeatLocations(gameInfo.maxPlayers);
    //   for (int localSeatNo = 1; localSeatNo <= gameInfo.maxPlayers; localSeatNo++) {
    //     SeatPos pos = seatPosLoc[localSeatNo];
    //     this._seats[localSeatNo] = Seat(localSeatNo, pos, null);
    //   }
    // }

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
        for (final seat in this._seats) {
          if (seat.serverSeatPos == player.seatNo) {
            seat.player = player;
            break;
          }
        }
      }

      if (player.playerUuid == this._currentPlayer.uuid) {
        player.isMe = true;
      }
    }
    _playersInGame = playersInSeats;

    final tableState = this._tableState;
    tableState.updateGameStatusSilent(gameInfo.status);
    tableState.updateTableStatusSilent(gameInfo.tableStatus);
    tableState.notifyAll();
    for (Seat seat in this._seats) {
      seat.notify();
    }

    // log('In GameState refresh(), _gameInfo.status = ${_gameInfo.status}');
    if (_gameInfo.status == AppConstants.GAME_ACTIVE &&
        tableState.gameStatus != AppConstants.GAME_RUNNING) {
      //this._myState.gameStatus = GameStatus.RUNNING;
      this._myState.notify();
    }
    log('GAMESTATE: Ended? ${this.ended}');
    this._handInfo.notify();
  }

  PlayerModel getPlayerById(int playerId) {
    for (final player in _playersInGame) {
      if (player.playerId == playerId) {
        return player;
      }
    }
    return null;
  }

  Future<void> refreshNotes() async {
    try {
      // final playerIds = this._playersInGame.map((e) => e.playerId).toList();
      // final playerNotes = await PlayerService.getPlayerNotes(playerIds);
      final playerNotes = await GameService.getPlayersWithNotes(gameCode);
      playersWithNotes = playerNotes;
      updatePlayersWithNotes();
    } catch (err) {
      log('Error when fetching player notes');
    }
  }

  void updatePlayersWithNotes() {
    if (playersWithNotes == null) {
      return;
    }
    for (final playerInSeat in _playersInGame) {
      playerInSeat.hasNotes = false;
      playerInSeat.notes = '';
    }

    for (final notesPlayer in playersWithNotes.players) {
      final playerInSeat = this.getPlayerById(notesPlayer.playerId);
      if (playerInSeat != null) {
        playerInSeat.hasNotes = true;
        playerInSeat.notes = notesPlayer.notes;
      }
    }
  }

  Seat seatPlayer(int localSeatNo, PlayerModel player) {
    //debugPrint('SeatNo $seatNo player: ${player.name}');
    this._seats[localSeatNo].player = player;
    if (player != null) {
      this._seats[localSeatNo].serverSeatPos = player.seatNo;
    }
    return this._seats[localSeatNo];
  }

  List<Seat> get seats => this._seats;

  void rebuildSeats() {
    // log('potViewPos: rebuilding seats.');
    for (final seat in this._seats) {
      seat.notify();
    }
  }

  Seat getSeatByPlayer(int playerId) {
    for (final seat in this._seats) {
      if (seat.player?.playerId == playerId) {
        return seat;
      }
    }
    return null;
  }

  static GameState getState(BuildContext context) => context.read<GameState>();

  void clear() {
    final tableState = this.tableState;
    this.holecardOrder = HoleCardOrder.DEALT;
    this.showdown = false;
    handState = HandState.UNKNOWN;
    this.wonat = HandStatus.HandStatus_UNKNOWN;
    _markedCardsState.clear();
    for (final player in _playersInGame) {
      player.reset();
    }
    markedCardsState.clear();
    // clear table state
    tableState.clear();
    tableState.notifyAll();
  }

  GameMessagingService get gameMessageService => this._gameMessageService;
  TableState get tableState => this._tableState;

  CommunicationState get communicationState => this._communicationState;

  MyState get myState => this._myState;
  RedrawFooterSectionState get redrawFooterState => this._redrawFooterState;
  RedrawBoardSectionState get redrawBoardSectionState => this._redrawBoardState;
  RedrawNamePlateSectionState get redrawNameplateSectionState =>
      this._redrawNameplateState;
  RedrawBackdropSectionState get redrawBackdropSectionState =>
      this._redrawBackdropState;

  bool get wonAtShowdown => this.wonat == proto.HandStatus.SHOW_DOWN;

  Seat get mySeat {
    for (final seat in _seats) {
      if (seat.player != null && seat.player.isMe) {
        return seat;
      }
    }
    return null;
  }

  BoardAttributesObject getBoardAttributes(
    BuildContext context, {
    bool listen: false,
  }) {
    return Provider.of<BoardAttributesObject>(context, listen: listen);
  }

  Seat getSeat(int seatNo) {
    // return this._seats[seatNo];
    for (final seat in _seats) {
      if (seat.serverSeatPos == seatNo) {
        return seat;
      }
    }
    return null;
  }

  void markOpenSeat(int seatNo) {
    final seat = getSeat(seatNo);
    seat.player = null;
    seat.notify();
  }

  void resetActionHighlight(int nextActionSeatNo) {
    for (final seat in this._seats) {
      if (seat.player != null && seat.player.highlight) {
        // debugPrint('*** seatNo: ${seat.serverSeatPos} highlight: ${seat.player.highlight} nextActionSeatNo: $nextActionSeatNo');
        seat.player.highlight = false;
        seat.notify();
      }
    }
  }

  void setPlayers(List<PlayerModel> players) {
    for (final player in players) {
      if (player.playerId != null) {
        _playerIdsToNames[player.playerId] = player.name;
      }
    }
    _playersInGame = players;
  }

  void seatChangePlayersUpdate(List<PlayerInSeat> playersInSeats,
      {bool notify}) {
    assert(playersInSeats != null);

    _playersInGame.clear();

    playersInSeats.forEach((playerInSeatModel) {
      _playersInGame.add(PlayerModel(
        name: playerInSeatModel.name,
        seatNo: playerInSeatModel.seatNo,
        playerUuid: playerInSeatModel.playerId,
        stack: playerInSeatModel.stack,
      ));
    });
    if (notify) {
      notifyAllSeats();
    }
  }

  Map<int, String> get playerIdToNames => this._playerIdsToNames;

  List<SingleChildStatelessWidget> get providers {
    return [
      this._handInfoProvider,
      this._tableStateProvider,
      this._playerActionProvider,
      this._myStateProvider,
      this._markedCardsProvider,
      this._gameMessagingService,
      // this._waitlistProvider,
      this._connectionStateProvider,
      this._tappedSeatStateProvider,
      this._communicationStateProvider,
      this._straddlePromptProvider,
      this._holeCardsProvider,
      this._redrawBoardSectionStateProvider,
      this._redrawBackdropSectionStateProvider,
      this._redrawNameplateSectionStateProvider,
      this._redrawFooterSectionStateProvider,
      this._handChangeStateProvider,
      this._handResultStateProvider,
      this._rabbitStateProvider,
      this._seatsOnTableProvider,
      this._gameSettingsProvider,
      this._actionTimerStateProvider,
      this._seatChangeProvider,
      this._chatNotifyProvider,
    ];
  }

  PlayerModel get me {
    final mySeat = this.mySeat;
    if (mySeat != null) {
      return mySeat.player;
    }
    for (final player in _playersInGame) {
      if (player.isMe) {
        return player;
      }
    }
    return null;
  }

  String get myStatus {
    final me = this.me;
    if (me != null) {
      return me.status;
    }
    return '';
  }

  void notifyAllSeats() {
    this._seatsOnTableState.notify();
    // for(final seat in _seats.values) {
    //   seat.notify();
    // }
  }

  String getNameplateId() {
    return this.assets.getNameplate().id;
  }

  bool newPlayer(PlayerModel newPlayer) {
    if (newPlayer.playerId != null) {
      _playerIdsToNames[newPlayer.playerId] = newPlayer.name;
    }
    _seats[newPlayer.seatNo].player = newPlayer;
    _playersInGame.add(newPlayer);
    return true;
  }

  void removePlayer(int seatNo) {
    final seat = getSeat(seatNo);

    if (seat.player != null) {
      // remove this player
      for (int i = 0; i < _playersInGame.length; i++) {
        if (_playersInGame[i].playerId == seat.player.playerId) {
          _playersInGame.removeAt(i);
          break;
        }
      }
      seat.player = null;
    }
  }

  void resetSeats({bool notify = true}) {
    for (final player in _playersInGame) {
      player.reset(stickAction: false);
    }
    for (final seat in _seats) {
      seat.dealer = false;
      seat.reserved = false;
    }

    if (notify) {
      for (final seat in _seats) {
        seat.notify();
      }
    }
  }

  ActionState get actionState => this._actionState;
  ActionTimerState get actionTimerState => this._actionTimerState;

  void showAction(bool show) {
    _actionState.show = show;
    _actionState.notify();
  }

  void setAction(int seatNo, var seatAction) {
    _actionState.setAction(seatNo, seatAction);
  }

  void showCheckFold() {
    _actionState.showCheckFold = true;
  }

  void setActionProto(int seatNo, proto.NextSeatAction seatAction) {
    _actionState.setActionProto(seatNo, seatAction);
  }

  void resetDealerButton() {
    for (final seat in this._seats) {
      seat.dealer = false;
    }
  }

  void resetSeatActions({bool newHand = false}) {
    for (final seat in this._seats) {
      if (seat.player == null) {
        continue;
      }
      seat.enLargeCardsVn.value = false;
      seat.player.action.animateAction = false;
      bool stickAction = true;
      if (newHand) {
        stickAction = false;
      } else {
        stickAction = false;
        if (seat.player.action != null &&
            seat.player.action.action == HandActions.ALLIN) {
          stickAction = true;
        }
      }
      // if newHand is true, we pass 'false' flag to say don't stick any action to player.
      // otherwise stick last player action to nameplate
      seat.player.resetSeatAction(stickAction: stickAction);
      seat.notify();
    }
  }

  Future<void> animateSeatActions() async {
    for (final seat in this._seats) {
      if (seat.player == null) {
        continue;
      }
      if (seat.player.action != null && seat.player.action.amount > 0) {
        seat.player.action.animateAction = true;
      }
      seat.notify();
    }
  }

  bool get playerSeatChangeInProgress => this._playerSeatChangeInProgress;

  set playerSeatChangeInProgress(bool v) =>
      this._playerSeatChangeInProgress = v;

  SeatChangeNotifier get seatChangeState => this._seatChangeState;

  Seat get seatChangeSeat => this._seatChangeSeat;

  set seatChangeSeat(Seat seat) => this._seatChangeSeat = seat;

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
    return this._straddlePromptState;
  }

  void changeHoleCardOrder({int inc = 1}) {
    int i = HoleCardOrder.values.indexOf(holecardOrder);
    i = i + inc;
    if (i < 0) {
      i = HoleCardOrder.values.length - 1;
    } else {
      if (i >= HoleCardOrder.values.toList().length) {
        i = 0;
      }
    }
    holecardOrder = HoleCardOrder.values[i];
    _holeCardsState.notify();
  }

  HoleCardsState get holeCardsState => _holeCardsState;

  void setPlayerNoCards(int n) {
    for (int i = 0; i < _playersInGame.length; i++) {
      if (_playersInGame[i].status == AppConstants.PLAYING &&
          _playersInGame[i].inhand) {
        _playersInGame[i].noOfCardsVisible = n;
      } else {
        _playersInGame[i].noOfCardsVisible = 0;
      }
    }
  }

  void updatePlayersStack(Map<dynamic, dynamic> stackData) {
    Map<int, double> stacks = Map<int, double>();

    for (final key in stackData.keys) {
      stacks[key.toInt()] = stackData[key];
    }
    // stacks contains, <seatNo, stack> mapping
    stacks.forEach((seatNo, stack) {
      int idx = _playersInGame.indexWhere((p) => p.seatNo == seatNo);
      // log('player seat no: $seatNo index: $idx');
      _playersInGame[idx].stack = stack;
    });
  }

  List<int> getHoleCards() {
    if (this.customizationMode) {
      // we are in customization mode
      return [177, 168];
    }

    final player = this.me;
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

  void stoppedTalking(List<Seat> seats) {
    // stopped talking seats
    for (final seat in seats) {
      seat.player.talking = false;
      seat.notify();
      if (seat.isMe) {
        this.communicationState.talking = false;
        this.communicationState.notify();
      }
    }
  }

  void talking(List<Seat> seats) {
    // talking seats
    for (final seat in seats) {
      seat.player.talking = true;
      seat.notify();
      if (seat.isMe) {
        this.communicationState.talking = true;
        this.communicationState.notify();
      }
    }
  }

  void talkingOld(List<int> players) {
    for (final playerId in players) {
      PlayerModel player;
      for (final playerInSeat in _playersInGame) {
        if (playerInSeat.playerId == playerId) {
          player = playerInSeat;
          break;
        }
      }
      if (player != null) {
        player.talking = true;
        if (player.seatNo > 0) {
          final seat = getSeat(player.seatNo);
          if (seat != null) {
            seat.notify();
          }
        }
        if (player.isMe) {
          this.communicationState.talking = true;
        }
      }
    }
  }

  void stoppedTalkingOld(List<int> players) {
    for (final playerId in players) {
      final player = this
          ._playersInGame
          .firstWhere((element) => element.playerId == playerId, orElse: null);
      if (player != null) {
        player.talking = false;
        final seat = getSeat(player.seatNo);
        seat.notify();
        if (player.isMe) {
          this.communicationState.talking = false;
        }
      }
    }
  }

  // card distribution logic

  /// seat no, value notifier mapping
  final Map<int, ValueNotifier<bool>> _cardDistributionMap = {};
  Map<int, ValueNotifier<bool>> get cardDistributionMap => _cardDistributionMap;

  void _initializeCardDistributionMap() {
    for (int seat = 1; seat <= 9; seat++) {
      _cardDistributionMap[seat] = ValueNotifier(false);
    }
  }

  void _updateCardDistribution(int forSeat, bool value) {
    assert(1 <= forSeat && forSeat <= 9);
    _cardDistributionMap[forSeat].value = value;
  }

  void startCardDistributionFor(int seatNo) {
    _updateCardDistribution(seatNo, true);
  }

  void stopCardDistributionFor(int seatNo) {
    _updateCardDistribution(seatNo, false);
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
    return gameTypeStr(this._gameType);
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
      double bombPotBet,
      bool notify = true}) {
    if (noCards != null) this._noCards = noCards;
    if (gameType != null) this._gameType = gameType;
    if (handNum != null) this._handNum = handNum;
    if (smallBlind != null) this._smallBlind = smallBlind;
    if (bigBlind != null) this._bigBlind = bigBlind;
    this._bombPot = false;
    if (bombPot != null) this._bombPot = bombPot;
    this._doubleBoard = doubleBoard ?? false;
    if (this._bombPot) {
      this._bombPotBet = bombPotBet;
    }
    if (notify) {
      this.notifyListeners();
    }
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
  bool _showCheckFold = false;
  bool _checkFoldSelected = false;

  void reset() {
    _showAction = false;
    _showCheckFold = false;
    _checkFoldSelected = false;
  }

  set show(bool v) {
    _showCheckFold = false;
    _showAction = v;
    this.notifyListeners();
  }

  set showCheckFold(bool v) {
    _showCheckFold = true;
    _showAction = false;
    this.notifyListeners();
  }

  set checkFoldSelected(bool v) {
    _checkFoldSelected = v;
    this.notifyListeners();
  }

  bool get checkFoldSelected => _checkFoldSelected;

  bool get show {
    return this._showAction;
  }

  bool get showCheckFold {
    return this._showCheckFold;
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

  void notify() {
    this.notifyListeners();
  }
}

// Used for extending the time
class ActionTimerState extends ChangeNotifier {
  void notify() {
    notifyListeners();
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

class MeTalkingState extends ChangeNotifier {
  void notify() {
    this.notifyListeners();
  }
}

class CommunicationState extends ChangeNotifier {
  AudioConferenceStatus _audioConferenceStatus = AudioConferenceStatus.ERROR;
  bool showTextChat = true;
  bool audioConfEnabled = false;
  bool voiceChatEnable = false;
  bool _mutedAll = false;
  bool _muted = false;
  bool _talking = false;
  final GameState gameState;
  MeTalkingState talkingState = new MeTalkingState();

  CommunicationState(this.gameState);

  AudioConferenceStatus get audioConferenceStatus => _audioConferenceStatus;

  set audioConferenceStatus(AudioConferenceStatus audioConferenceStatus) =>
      this._audioConferenceStatus = audioConferenceStatus;

  set muted(bool v) {
    _muted = v;
    notifyListeners();
  }

  bool get muted => _muted ?? false;

  set mutedAll(bool v) {
    _mutedAll = v;
    notifyListeners();
  }

  bool get mutedAll => _mutedAll ?? false;

  set talking(bool v) {
    _talking = v;
    talkingState.notify();
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

class HoleCardsState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class RedrawNamePlateSectionState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class RedrawBoardSectionState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class RedrawBackdropSectionState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class RedrawFooterSectionState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class HandChangeState extends ChangeNotifier {
  void notify() {
    this.notifyListeners();
  }
}

class HandResultState extends ChangeNotifier {
  void notify() {
    this.notifyListeners();
  }
}

// /**
//  * The states that affect the current player.
//  */
class MyState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class SeatsOnTableState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class GameSettingsState extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class AudioConfState extends ChangeNotifier {
  bool join = false;
  bool leave = false;
  bool joined = false;
  bool left = false;
  void joinConf() {
    join = true;
    notifyListeners();
  }

  void leaveConf() {
    leave = true;
    notifyListeners();
  }

  void joinedConf() {
    join = false;
    joined = true;
    left = false;
    leave = false;
  }

  void leftConf() {
    join = false;
    joined = true;
    left = false;
    leave = false;
  }
}
