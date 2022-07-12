import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/handlog_model.dart';
import 'package:pokerapp/models/player_info.dart' as pi;
import 'package:pokerapp/proto/hand.pb.dart';
import 'package:pokerapp/proto/handmessage.pb.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/seat_change_confirmation_pop_up.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/overlay_notification.dart';
import 'package:pokerapp/screens/util_screens/dealer_choice_prompt.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/services/test/hand_messages.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:provider/provider.dart';

class TestService {
  static bool get isTesting {
    return false;
  }

  static bool get isPartialTesting {
    return false;
  }

  static var _showResult = false;
  static pi.PlayerInfo _currentPlayer;
  static GameInfoModel _gameInfo;
  static dynamic _result;

  // static List<CardObject> _boardCards;
  static List<int> _pots;

  static BuildContext _context;
  //static HandActionService _handActionService;
  static HandActionProtoService _handActionProtoService;
  TestService._();
  static GameState _gameState;

  static set context(BuildContext context) => _context = context;
  static Future<GameState> initialize() async {
    // temporary to launch game screen in test mode
    final String gameCode = gameInfo.gameCode;
    final gameState = GameState();
    await gameState.initialize(
      gameInfo: gameInfo,
      gameCode: gameInfo.gameCode,
      customizationMode: false,
      replayMode: false,
      currentPlayer: TestService.currentPlayer,
    );
    _gameState = gameState;
    return gameState;
  }

  static GameState gameState() {
    return _gameState;
  }

  static showDealerWidget() {
    final gameState = GameState.getState(_context);
    for (int seatNo = 1; seatNo <= 9; seatNo++) {
      final seat = gameState.getSeat(seatNo);
      seat.dealer = true;
    }
  }

  static showMuckLosingHand() {
    final gameState = GameState.getState(_context);
    gameState.handState = HandState.RESULT;
    for (int seatNo = 1; seatNo <= 9; seatNo++) {
      final seat = gameState.getSeat(seatNo);
      seat.player.cards = [177, 177]; //, 177, 177]; //177];
      seat.player.muckLosingHand = true;
      seat.player.winner = false;
      seat.notify();
    }
  }

  static void promptRunItTwice() {
    final gameState = GameState.getState(_context);
    final gameContextObject = _context.read<GameContextObject>();
    OverlayRunItTwice.showPrompt(
      gameContextObject: gameContextObject,
      gameState: gameState,
      expiresAtInSeconds: 30,
      context: _context,
    );
    // RunItTwiceDialog.promptRunItTwice(
    //   context: _context,
    //   expTime: 30,
    // );
  }

  // static showPlayerFolded() {
  //   final gameState = GameState.getState(_context);
  //   for (int seatNo = 1; seatNo <= 9; seatNo++) {
  //     final seat = gameState.getSeat(seatNo);
  //     seat.player.playerFolded = true;
  //     seat.notify();
  //   }
  // }

  static showTextNotification() {
    String title = 'Seat Change Progress';
    String subTitle = 'Player bob is requested to switch seat';
    showOverlayNotification(
      (context) => OverlayNotificationWidget(
        title: title,
        subTitle: subTitle,
        svgPath: 'assets/images/seatchange.svg',
      ),
      duration: Duration(seconds: 10),
    );
  }

  static showMicAnimation() {
    final gameState = GameState.getState(_context);
    final commState = gameState.communicationState;
    commState.talking = true;
    //commState.muted = true;
    //gameState.myState.status = PlayerStatus.PLAYING;
    commState.audioConferenceStatus = AudioConferenceStatus.CONNECTED;
    commState.notify();
  }

  static showFireworks() async {
    final gameState = GameState.getState(_context);
    for (int seatNo = 1; seatNo <= 9; seatNo++) {
      final seat = gameState.getSeat(seatNo);
      seat.player.showFirework = true;
      seat.notify();
    }

    await Future.delayed(AppConstants.highHandFireworkAnimationDuration);

    // turn off firework
    for (int seatNo = 1; seatNo <= 9; seatNo++) {
      final seat = gameState.getSeat(seatNo);
      seat.player.showFirework = false;
      seat.notify();
    }
  }

  static showRank() async {
    final gameState = GameState.getState(_context);
    final seat = gameState.getSeat(1);
    final myState = gameState.myState;
    //seat.player.showFirework = true;
    seat.player.rankText = 'Two Pair';
    myState.notify();

    //await Future.delayed(AppConstants.highHandFireworkAnimationDuration);

    //seat.player.rankText = '';
    //myState.notify();
  }

  static showSitBack() async {
    final gameState = GameState.getState(_context);
    final seat = gameState.getSeat(1);
    final myState = gameState.myState;
    seat.dealer = true;
    seat.player.inhand = false;
    seat.player.inBreak = true;
    seat.player.status = AppConstants.IN_BREAK;
    DateTime date = DateTime.now();
    date.add(Duration(minutes: 5));
    seat.player.breakTimeExpAt = date;
    //myState.player = seat.player;
    //seat.player.showFirework = true;
    //seat.player.rankText = 'Two Pair';
    myState.notify();

    //await Future.delayed(AppConstants.highHandFireworkAnimationDuration);

    //seat.player.rankText = '';
    //myState.notify();
  }

  static pi.PlayerInfo get currentPlayer {
    final data = jsonDecode('''  {
                  "myInfo": {
                    "id": 1,
                    "uuid": "371e8c15-39cb-4bd9-a932-ced7a9dd6aac",
                    "name": "poker club"
                  },
                  "role": {
                    "isHost": true,
                    "isOwner": true,
                    "isManager": false
                  }
                }''');
    _currentPlayer = pi.PlayerInfo.fromJson(data);
    return _currentPlayer;
  }

  static GameInfoModel get gameInfo => _gameInfo;

  static dynamic get handResult => _result;

  static bool get showResult => _showResult;

  // static List<CardObject> get boardCards => _boardCards;

  static List<int> get pots => _pots;

  // static void testIap() {
  //   if (_testIap == null) {
  //     _testIap = new InAppPurchaseTest();
  //   }
  //   _testIap.loadProducts();
  // }

  static Future<void> load() async {
    if (isTesting) {
      final gameData =
          await rootBundle.loadString('assets/sample-data/gameinfo.json');
      final jsonData = jsonDecode(gameData);
      if (jsonData["currentPlayer"] != null) {
        final data = jsonDecode('''  {
              "myInfo": {
                "id": 1,
                "uuid": "371e8c15-39cb-4bd9-a932-ced7a9dd6aac",
                "name": "matt"
              },
              "role": {
                "isHost": true,
                "isOwner": true,
                "isManager": false
              }
            }''');
        _currentPlayer = pi.PlayerInfo.fromJson(data);
        //_currentPlayer = PlayerInfo.fromJson(jsonData["currentPlayer"]);
      }
      // 2 4 6 8 9
      var maxPlayers = 9;
      if (jsonData["gameInfo"] != null) {
        // todo: debug remove: change the max Players in a game here
        _gameInfo = GameInfoModel.fromJson(
          jsonData["gameInfo"],
          maxPlayers: maxPlayers,
        );
        _gameInfo.showHandRank = true;
      }

      List<PlayerModel> playerInSeats = [];
      for (final player in _gameInfo.playersInSeats) {
        if (player.seatNo <= maxPlayers) {
          player.cards = [177, 24, 100, 104, 177, 164];
          playerInSeats.add(player);
        }
      }

      _gameInfo.playersInSeats = playerInSeats;

      final resultData =
          await rootBundle.loadString('assets/sample-data/result.json');
      _result = jsonDecode(resultData);
    }
  }

  static TableState _getTableState() {
    BuildContext context = _context;
    final gameState = Provider.of<GameState>(context, listen: false);
    return gameState.tableState;
  }

  static Future<void> clearBoardCards() async {
    final tableState = _getTableState();

    tableState.clear();
    tableState.notifyAll();
  }

  static void resetCommunityCards() {
    final gameState = GameState.getState(_context);
    gameState.communityCardState.reset();
  }

  static Future<void> addFlopCards() async {
    final gameState = GameState.getState(_context);
    gameState.communityCardState.reset();

    // await Future.delayed(const Duration(milliseconds: 500));

    // just call this to add flop cards
    await gameState.communityCardState.addFlopCards(
      board1: [1, 2, 161],
      board2: [1, 2, 177],
    );
    await gameState.communityCardState
        .addTurnCard(board1Card: 18, board2Card: 120);
    await Future.delayed(AppConstants.communityCardWaitDuration);
    await gameState.communityCardState
        .addRiverCard(board1Card: 20, board2Card: 130);
  }

  static Future<void> addTurnCard() async {
    final gameState = GameState.getState(_context);

    gameState.communityCardState.addTurnCard(
      board1Card: 50,
      // board2Card: 52,
    );
  }

  static Future<void> addRiverCard() async {
    final gameState = GameState.getState(_context);

    gameState.communityCardState.addRiverCard(
      board1Card: 68,
      // board2Card: 72,
    );
  }

  static Future<void> addCardsWithoutAnimating() async {
    final gameState = GameState.getState(_context);

    gameState.communityCardState.reset();

    await Future.delayed(const Duration(milliseconds: 300));

    final board1Cards = [33, 34, 36, 104, 104];
    //final board2Cards = [33, 34, 36, 68, 104]; // run it twice case
    final board2Cards = [130, 136, 129, 100, 104];

    gameState.communityCardState.addBoardCardsWithoutAnimating(
      board1: board1Cards,
      board2: board2Cards,
    );
  }

  static Future<void> addRunItTwiceAfterFlop() async {
    final gameState = GameState.getState(_context);

    /// SETUP FOR THE TEST
    gameState.communityCardState.reset();
    await Future.delayed(const Duration(milliseconds: 500));
    final board1Cards = [33, 34, 36, 68, 72];
    final board2Cards = [33, 34, 36, 100, 104];

    // add flop cards -> just add 3 cards from board 1

    await gameState.communityCardState.addFlopCards2(board1Cards.sublist(0, 3),
        cardState: gameState.communityCardState.ritBoardFlop);

    // await Future.delayed(const Duration(seconds: 1));

    /// THE REAL TEST BEGINS HERE

    // run it twice case
    gameState.communityCardState.addRunItTwiceCards(
      board1: board1Cards,
      board2: board2Cards,
    );
  }

  static Future<void> addRunItTwiceAfterTurn() async {
    final gameState = GameState.getState(_context);

    /// SETUP FOR THE TEST
    gameState.communityCardState.reset();
    // await Future.delayed(const Duration(milliseconds: 500));
    final board1Cards = [33, 34, 36, 68, 72];
    final board2Cards = [33, 34, 36, 100, 104];
    // add flop cards -> just add 3 cards from board 1
    // await gameState.communityCardState.addFlopCards(
    //   board1: board1Cards.sublist(0, 3),
    // );

    await gameState.communityCardState.addFlopCards2(board1Cards.sublist(0, 4),
        cardState: gameState.communityCardState.ritBoardTurn);

    // await Future.delayed(const Duration(milliseconds: 500));
    // await gameState.communityCardState.addTurnCard(
    //   board1Card: board1Cards[3],
    // );
    await gameState.communityCardState.addTurnCard2(
      board1Cards[4],
      startWith: 1,
      cardState: gameState.communityCardState.ritBoardTurn1,
    );
    // await Future.delayed(const Duration(milliseconds: 500));

    /// THE REAL TEST BEGINS HERE

    // run it twice case
    gameState.communityCardState.addRunItTwiceCards(
      board1: board1Cards,
      board2: board2Cards,
    );
  }

  static Future<void> simulateBetMovement() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();
  }

  static void clearBets() {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.resetSeatActions();
    gameState.notifyAllSeats();
  }

  static void showBets() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.resetSeatActions();
    for (final seat in gameState.seats) {
      if (seat.player != null) {
        seat.player.action.animateAction = false;
        seat.player.action.animateBet = true;
        seat.player.action.setActionProto(ACTION.BET, 40.0);
        seat.notify();
        await Future.delayed(Duration(milliseconds: 300));
        seat.player.action.animateBet = false;
        seat.player.action.animateAction = false;
        seat.notify();
      }
    }
    // for (final seat in gameState.seats) {
    //   if (seat.player != null) {
    //     seat.player.action.animateAction = false;
    //     seat.player.action.animateBet = false;
    //     seat.player.action.setActionProto(ACTION.BET, 40.0);
    //   }
    // }
    // gameState.notifyAllSeats();
    // await Future.delayed(Duration(milliseconds: 300));
    // for (final seat in gameState.seats) {
    //   if (seat.player != null) {
    //     if (seat.seatPos == SeatPos.topCenter1) {
    //       seat.player.action.animateAction = true;
    //     }
    //   }
    // }
    // gameState.notifyAllSeats();
    // await Future.delayed(Duration(milliseconds: 300));
    // gameState.resetSeatActions();

    // final seat1 = gameState.getSeat(1);
    // seat1.player.action.button = true;

    // final seat2 = gameState.getSeat(2);
    // seat2.player.action.amount = 1;
    // seat2.player.action.sb = true;

    // final seat3 = gameState.getSeat(3);
    // seat3.player.action.amount = 2;
    // seat3.player.action.bb = true;

    // final seat4 = gameState.getSeat(4);
    // seat4.player.action.amount = 4;
    // seat4.player.action.straddle = true;

    // // final seat5 = gameState.getSeat(5);
    // // seat5.player.action.setAction(jsonDecode('''
    // //       {
    // //         "action": "CALL",
    // //         "amount": 4.0
    // //       }
    // //     '''));

    // for (final seat in gameState.seats) {
    //   if (seat.serverSeatPos <= 5) {
    //     seat.notify();
    //     continue;
    //   }

    //   if (seat.serverSeatPos == 6) {
    //     dynamic json = jsonDecode('''
    //       {
    //         "action": "BET",
    //         "amount": 20.0
    //       }
    //     ''');
    //     seat.player.action.setAction(json);
    //   } else {
    //     dynamic json = jsonDecode('''
    //       {
    //         "action": "CALL",
    //         "amount": 20.0
    //       }
    //     ''');
    //     seat.player.action.setAction(json);
    //   }

    //   seat.notify();
    // }
  }

  static Future<void> buyInTest() async {
    final gameState = GameState.getState(_context);
    final now = DateTime.now();
    var exp = DateTime.now();
    exp = exp.add(Duration(seconds: 20));
    gameState.me.buyInTimeExpAt = exp.toUtc();
    log('now: ${now.toIso8601String()} exp: ${exp.toIso8601String()} utc: ${gameState.me.buyInTimeExpAt.toIso8601String()}');
    gameState.me.showBuyIn = true;
    gameState.me.stack = 0;

    final seat4 = gameState.getSeat(4);
    exp = now.add(Duration(seconds: 30));
    seat4.player.showBuyIn = true;
    seat4.player.stack = 0;
    seat4.player.buyInTimeExpAt = exp.toUtc();
    // redraw seat
    final seat = gameState.getSeat(gameState.me.seatNo);
    seat.notify();
  }

  static Future<void> movePotToPlayer() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);

    final seat1 = gameState.getSeat(1);
    final seat2 = gameState.getSeat(3);
    final seat3 = gameState.getSeat(9);

    seat1.player.action.amount = 100.0;
    seat1.player.action.winner = true;
    seat2.player.action.amount = 100.0;
    seat2.player.action.winner = true;
    seat3.player.action.amount = 100.0;
    seat3.player.action.winner = true;
    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();
  }

  static void showCardDistribution() {
    final gameState = Provider.of<GameState>(_context, listen: false);
    HandActionProtoService.cardDistribution(gameState, 3);
  }

  static Future<void> testBetWidget() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    final actionState = gameState.actionState;

    final seatActionJsonStr = '''
        {
          "seatNo": 1,
          "availableActions": ["FOLD", "BET", "CALL", "ALLIN"],
          "callAmount": 2.0,
          "minRaiseAmount": 4.0,
          "maxRaiseAmount": 30.0,
          "allInAmount": 30.0,
          "betOptions": [{
            "text": "3BB",
            "amount": 6.0
          }, {
            "text": "5BB",
            "amount": 10.0
          }, {
            "text": "10BB",
            "amount": 20.0
          }, {
            "text": "All-In",
            "amount": 30.0
          }]
        }''';
    final seatAction = jsonDecode(seatActionJsonStr);
    actionState.setAction(1, seatAction);
    gameState.setAction(1, seatAction);
    gameState.showCheckFold();
    gameState.showAction(true);

    actionState.notifyListeners();
  }

  static Future<void> testCountdownTimer() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    final seat = gameState.getSeat(1);

    if (seat.actionCount == 0) {
      seat.player.highlight = true;
      seat.setActionTimer(30, remainingTime: 20);
      seat.actionCount++;
    } else if (seat.actionCount == 1) {
      seat.setActionTimer(60, remainingTime: 45);
      seat.actionCount++;
    } else {
      seat.player.highlight = false;
      seat.actionCount = 0;
    }
    seat.notify();
  }

  // static Future<void> showFlushBar() async {
  //   String message = 'emma is invited to take the open seat';
  //   showWaitlistStatus(_context, message, 10);
  // }

  static int i = 0;
  static Future<void> showHoleCards() async {
    GameState gameState = Provider.of<GameState>(
      _context,
      listen: false,
    );
    final player = gameState.me;
    i++;
    /*
    113, 71: 9♠
    114, 72: 9❤
    116, 74: 9♦
    120, 78: 9♣    
    130, 82: T❤
    132, 84: T♦
    136, 88: T♣
    129, 81: T♠
    152, 98: J♣
    145, 91: J♠
    146, 92: J❤
    148, 94: J♦
    161, A1: Q♠
    162, A2: Q❤
    164, A4: Q♦
    168, A8: Q♣
    177, B1: K♠
    178, B2: K❤
    180, B4: K♦
    184, B8: K♣
    200, C8: A♣
    193, C1: A♠
    194, C2: A❤
    196, C4: A♦
    Ah, 10c, 9s, Jd, Ks 
    */
    player.cards = [
      161,
      200,
      168,
      177,
      194,
      // 196,
    ]; //, 168, 177, 194];
    player.rankText = 'Full House';
    final myState = gameState.myState;
    myState.notify();

    List<int> communityCards = [161, 200, 168, 177];

    // final rabbitState = gameState.rabbitState;
    // player.noOfCardsVisible = player.cards.length;
    // gameState.handState = HandState.RESULT;
    gameState.notifyAllSeats();
    // rabbitState.putResult(HandStatus.FLOP, 1, communityCards, player.cards);
    // int r = i % 4;
    // if (r == 1) {
    //   player.cards[0] = 184;
    // }
    // if (r == 2) {
    //   player.cards[0] = 178;
    // }
    // if (r == 3) {
    //   player.cards[0] = 196;
    // }

    //gameState.myState.notify();
  }

  // static Future<void> sendNewHand() async {
  //   final gameState = GameState.getState(_context);
  //   if (_handActionService == null) {
  //     _handActionService =
  //         HandActionService(_context, gameState, null, null, null);
  //     _handActionService.loop();
  //   }
  //   await _handActionService.handle(newHandMessage());
  //   //await _handActionService.handle(dealCardsMessage());
  //   //await HandActionService.handle(context: _context, message: yourActionNextActionMsg());
  //   //await HandActionService.handle(context: _context, message: dealStartedMessage());
  // }

  // static Future<void> sendResult() async {
  //   final gameState = GameState.getState(_context);
  //   gameState.settings.gameSound = false;
  //   if (_handActionService == null) {
  //     _handActionService =
  //         HandActionService(_context, gameState, null, null, null);
  //     _handActionService.loop();
  //   }
  //   await _handActionService.handle(testResultMessage);
  //   //await _handActionService.handle(dealCardsMessage());
  //   //await HandActionService.handle(context: _context, message: yourActionNextActionMsg());
  //   //await HandActionService.handle(context: _context, message: dealStartedMessage());
  // }

  static void emptySeatDealer() {
    final gameState = GameState.getState(_context);
    final seat = gameState.getSeat(5);

    seat.dealer = true;
  }

  static void seatChange() {
    final hostSeatChange =
        Provider.of<SeatChangeNotifier>(_context, listen: false);

    /* start animation */
    hostSeatChange.onSeatDrop(1, 5);

    /* refresh */
    final gameState = GameState.getState(_context);
    gameState.refresh();
  }

  // static void reloadStack() {
  //   initHandSevice();
  //   _context
  //       .read<GameContextObject>()
  //       .gameUpdateService
  //       .handle(reloadStackMessage);
  // }

  // static void runItTwiceResult() {
  //   final resultMessage = runItTwiceMessage();
  //   initHandSevice();
  //   _handActionService.handle(resultMessage);
  // }

  static void dealerChoicePrompt() async {
    DealerChoiceSelection selection = await DealerChoicePrompt.prompt(
      listOfGameTypes: [
        GameType.HOLDEM,
        GameType.PLO,
        GameType.PLO_HILO,
        GameType.FIVE_CARD_PLO,
        GameType.FIVE_CARD_PLO_HILO,
      ],
      timeLimit: Duration(seconds: 10),
    );
    log('Dealer choice: ${selection.gameType} doubleBoard: ${selection.doubleBoard}');
  }

  static void showNamePlateHoleCards() async {
    final gameState = GameState.getState(_context);
    gameState.handState = HandState.RESULT;
    gameState.showdown = true;
    for (final seat in gameState.seats) {
      if (seat.player == null) {
        continue;
      }
      if (seat.serverSeatPos == 1) {
        seat.player.winner = true;
        seat.player.cards = [72, 84];
        seat.player.highlightCards = [72, 100];
      } else if (seat.serverSeatPos == 4) {
        seat.player.cards = [120, 130, 136, 162, 180];
        seat.player.highlightCards = [130, 163, 180];
        seat.player.winner = true;
      } else if (seat.serverSeatPos == 5) {
        seat.player.cards = [120, 130, 162, 180];
        seat.player.highlightCards = [162];
        seat.player.winner = true;
      } else if (seat.serverSeatPos == 7) {
        seat.player.cards = [120, 130, 162, 180, 136, 72];
        seat.player.highlightCards = [130, 163, 180];
        seat.player.winner = true;
      } else {
        seat.player.playerFolded = true;
      }
      seat.notify();
      //break;
    }
  }

  static void showShuffle() {
    final gameState = GameState.getState(_context);
    final TableState tableState = gameState.tableState;
    tableState.updateCardShufflingAnimation(true);
    Future.delayed(Duration(seconds: 2), () {
      tableState.updateCardShufflingAnimation(false);
    });
  }

  static void animateFold() {
    final gameState = GameState.getState(_context);
    for (final seat in gameState.seats) {
      if (seat.seatPos != SeatPos.bottomCenter) {
        continue;
      }
      if (seat.player != null) {
        seat.player.cards = [177, 177];
        seat.player.playerFolded = true;
        seat.player.animatingFold = true;
        seat.notify();
      }
    }
    Future.delayed(Duration(seconds: 2), () {
      for (final seat in gameState.seats) {
        if (seat.player != null) {
          seat.player.cards = [177, 177];
          seat.player.playerFolded = false;
          seat.player.animatingFold = false;
          seat.notify();
        }
      }
    });
  }

  // static initHandSevice() {
  //   final gameState = GameState.getState(_context);
  //   if (_handActionService == null) {
  //     _handActionService =
  //         HandActionService(_context, gameState, null, null, null);
  //     _handActionService.loop();
  //   }
  // }

  // static Future<void> flop() async {
  //   initHandSevice();
  //   await _handActionService.handle(flopMessage());
  // }

  // static Future<void> fold() async {
  //   initHandSevice();
  //   await _handActionService.handle(foldMessage());
  // }

  static void resetGameState() {
    final gameState = GameState.getState(_context);
    gameState.clear();
    gameState.tableState.notifyAll();
    ActionState state = gameState.actionState;
    state.show = false;

    gameState.resetSeatActions();
    final seats = gameState.seats;
    for (final seat in seats) {
      seat.player.noOfCardsVisible = 2;
    }
    gameState.notifyAllSeats();

    /* wait then run fold */
    //Future.delayed(const Duration(milliseconds: 800)).then((value) => fold());
  }

  static void setActionTimer() {
    final gameState = GameState.getState(_context);
    final seat1 = gameState.getSeat(1);
    seat1.actionTimer.setTime(30, 30);
    seat1.player.highlight = true;
    seat1.notify();
  }

//   static void sendRunItTwiceMessage() {
//     initHandSevice();
//     String message = '''{
//    "messageType":"RUN_IT_TWICE",
//    "runItTwice":{
//       "board1":[
//          200,
//          196,
//          8,
//          132,
//          33
//       ],
//       "board2":[
//          72,
//          84,
//          40,
//          100,
//          97
//       ],
//       "stage":"PREFLOP",
//       "seatsPots":[
//          {
//             "seats":[
//                5,
//                8
//             ],
//             "pot":100
//          }
//       ],
//       "seat1":5,
//       "seat2":8
//    }
// }''';
//     //final handActionService = HandActionService( _context, gameState);
//     _handActionService.clear();
//     _handActionService.handle('{"messages": [$message]}');
//   }

//   static void runItTwicePrompt() {
//     initHandSevice();

//     String message =
//         '''{"clubId": 1,"gameId": "1620287740","gameCode": "1620287740","handNum": 1,"messageId": "ACTION:1:FLOP:0:","handStatus": "FLOP","messages": [{"messageType": "PLAYER_ACTED","playerActed": {"seatNo": 8,"action": "ALLIN","amount": 50}}, {"messageType": "YOUR_ACTION","seatAction": {"seatNo": 1,"availableActions": ["RUN_IT_TWICE_PROMPT"]}}, {"messageType": "YOUR_ACTION","seatAction": {"seatNo": 8,"availableActions": ["RUN_IT_TWICE_PROMPT"]}}]}''';
//     //final handActionService = HandActionService( _context, gameState);
//     _handActionService.clear();
//     _handActionService.handle(message);
//   }

//   static void handMessage() {
//     initHandSevice();

//     // final seat = gameState.getSeat(1);
//     // seat.player.highlight = true;
//     // seat.setActionTimer(gameState.gameInfo.actionTime);
//     // seat.notify();
//     String message =
//         '''{"version":"", "clubId":254, "gameId":"284", "gameCode":"CG-A2DHJIG7497MNKP", "handNum":36,
//      "seatNo":0, "playerId":"0", "messageId":"ACTION:36:RIVER:2443:40", "gameToken":"", "handStatus":"RIVER",
//      "messages":[
//        {"messageType":"PLAYER_ACTED", "playerActed":{"seatNo":1, "action":"CHECK", "amount":0, "timedOut":false, "actionTime":0, "stack":28}},
//        {"messageType":"RIVER", "river":{"board":[97, 145, 2, 130, 66], "riverCard":66, "cardsStr":"[ 8♠  J♠  2❤  T❤  6❤ ]", "pots":[4], "seatsPots":[{"seats":[1, 2], "pot":4}], "playerBalance":{"1":28, "2":98}}},
//        {"messageType":"YOUR_ACTION", "seatAction":{"seatNo":2, "availableActions":["FOLD", "CHECK", "BET", "ALLIN"], "straddleAmount":0, "callAmount":0, "raiseAmount":0, "minBetAmount":0, "maxBetAmount":0, "minRaiseAmount":2, "maxRaiseAmount":98, "allInAmount":98, "betOptions":[{"text":"100%", "amount":4}, {"text":"All-In", "amount":98}]}},
//        {"messageType":"NEXT_ACTION", "actionChange":{"seatNo":2, "pots":[4], "potUpdates":0, "seatsPots":[{"seats":[1, 2], "pot":4}]}}
//       ]}''';
//     //final handActionService = HandActionService( _context, gameState);
//     _handActionService.clear();
//     _handActionService.handle(message);
//   }

  static void waitlistDialog() {
    final data = '''
        {
          "type": "WAITLIST_SEATING",
          "gameCode": "CG-Q8QC9I95J54N8BM",
          "gameType": "HOLDEM",
          "smallBlind": 1,
          "bigBlind": 2,
          "title": "HOLDEM 1/2",
          "clubName": "test",
          "expTime": "2021-05-03T15:03:27.304Z",
          "requestId": "af4b966a-eee7-4bee-8f79-8aa5ec34543e"
        }
    ''';
    final json = jsonDecode(data);
    String type = json['type'].toString();
    String gameCode = json['gameCode'].toString();
    if (type == 'WAITLIST_SEATING') {
      String game = '';
      if (json["gameType"] != null) {
        String gameType = json["gameType"].toString();
        String sb = DataFormatter.chipsFormat(
            double.parse(json['smallBlind'].toString()));
        String bb = DataFormatter.chipsFormat(
            double.parse(json['bigBlind'].toString()));
        game = ' at $gameType $sb/$bb';
      }
      String title = 'Do you want to take a open seat $game?';
      String subTitle = 'Code: ${json["gameCode"]}';
      if (json['clubName'] != null) {
        subTitle = subTitle + '\n' + 'Club: ${json["clubName"]}';
      }

      final alert = AlertDialog(
        title: Text('Waitlist Seating'),
        content: Text('$title \n$subTitle'),
        actions: [
          ElevatedButton(
            //textColor: Color(0xFF6200EE),
            onPressed: () {
              Navigator.of(_context).pop();
              navigatorKey.currentState.pushNamed(
                Routes.game_play,
                arguments: gameCode,
              );
            },
            child: Text('Accept'),
          ),
          ElevatedButton(
            //textColor: Color(0xFF6200EE),
            onPressed: () {
              Navigator.of(_context).pop();
            },
            child: Text('Decline'),
          ),
        ],
      );
      // show the dialog
      showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  static void handlogView() {
    navigatorKey.currentState.pushNamed(
      Routes.hand_log_view,
      arguments: {
        'gameCode': 'CG-7OF3IOXKBWJLDD',
        'handNum': 1,
        'isTest': true,
      },
    );
  }

  // static void handAnnouncement() async {
  //   initHandSevice();
  //   await _handActionService.handle(newGameAnnouncement());
  // }

  static void showPlayerStatus() {
    final gameState = GameState.getState(_context);
    final players = gameState.playersInGame;

    for (int i = 1; i < 10; i++) {
      final seat = gameState.getSeat(i);

      final action = seat.player.action;
      action.setAction(ActionElement(
        action: HandActions.CALL,
      ));
    }

    gameState.notifyAllSeats();
  }

  static void showDownCards() {
    final gameState = GameState.getState(_context);
    final players = gameState.playersInGame;

    // _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.Result;

    for (int i = 1; i < 10; i++) {
      players[i].cards = [50, 50, 50, 50, 50];
    }

    gameState.notifyAllSeats();
  }

  static void removeShowDownCards() {
    final gameState = GameState.getState(_context);
    final players = gameState.playersInGame;

    // _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    for (int i = 1; i < 10; i++) {
      players[i].cards = [];
    }

    gameState.notifyAllSeats();
  }

  // static void dealerChoiceGame() async {
  //   initHandSevice();

  //   await _handActionService.handle(dealerChoiceMessage());
  // }

  static List<GameModel> fetchLiveGames() {
    var json = jsonDecode('''{
      "clubCode": "ABC",
      "gameCode": "ABC",
      "smallBlind": 1,
      "bigBlind": 2,
      "gameType": "HOLDEM"
    }''');
    final game1 = GameModel.fromJson(json);
    return [game1];
  }

  static setIsAdminFalse() {
    BuildContext context = _context;

    final gameContextObj =
        Provider.of<GameContextObject>(context, listen: false);
    gameContextObj.gameState.currentPlayer.role.isHost = false;
    gameContextObj.gameState.currentPlayer.role.isManager = false;
    gameContextObj.gameState.currentPlayer.role.isOwner = false;
    gameContextObj.notifyListeners();

    log('In TestService gameContextObj.isAdmin() = ${gameContextObj.isAdmin()}');
  }

  static setIsAdminTrue() {
    BuildContext context = _context;

    final gameContextObj =
        Provider.of<GameContextObject>(context, listen: false);
    gameContextObj.gameState.currentPlayer.role.isHost = true;
    gameContextObj.notifyListeners();

    log('In TestService gameContextObj.isAdmin() = ${gameContextObj.isAdmin()}');
  }

  // static setGameStateActive() {
  //   BuildContext context = _context;
  //   final myState = Provider.of<MyState>(context, listen: false);
  //   myState.gameStatus = GameStatus.RUNNING;
  //   myState.notify();
  // }

  // static setGameStateInActive() {
  //   BuildContext context = _context;

  //   final myState = Provider.of<MyState>(context, listen: false);
  //   myState.gameStatus = GameStatus.UNKNOWN;
  //   myState.notify();
  // }

  static setCurrentPlayerStatusPlaying() {
    final gameState = GameState.getState(_context);
    final me = gameState.me;
    if (me != null) {
      me.status = AppConstants.PLAYING;
    }
    gameState.myState.notify();
  }

  static setCurrentPlayerStatusNotPlaying() {
    final gameState = GameState.getState(_context);
    final me = gameState.me;
    if (me != null) {
      me.status = AppConstants.NOT_PLAYING;
    }
    gameState.myState.notify();
  }

  static void showSeatChangePrompt() async {
    final gameState = GameState.getState(_context);
    final seat1 = gameState.getSeat(1);
    seat1.player = null;
    seat1.notify();
    gameState.playerSeatChangeInProgress = true;

    SeatChangeConfirmationPopUp.dialog(
        context: _context,
        gameCode: 'test',
        promptSecs: 300,
        openSeats: [3, 4]);
  }

  static void showKeyboard() async {
    final value = await NumericKeyboard2.show(_context,
        title: 'Buyin amount 30-100', min: 30, max: 100, decimalAllowed: false);
    log('typed value: $value');
  }

  static setPlayerTalking() {
    final gameState = GameState.getState(_context);
    for (int seatNo = 1; seatNo <= gameState.gameInfo.maxPlayers; seatNo++) {
      final seat1 = gameState.getSeat(seatNo);
      if (seat1.player != null) {
        seat1.player.talking = true;
        seat1.notify();
      }
    }
  }

  static setPlayerStoppedTalking() {
    BuildContext context = _context;
    final gameState = GameState.getState(_context);
    for (int seatNo = 1; seatNo <= gameState.gameInfo.maxPlayers; seatNo++) {
      final seat1 = gameState.getSeat(seatNo);
      if (seat1.player != null) {
        seat1.player.talking = false;
        seat1.notify();
      }
    }
  }

  static showHandResult2() async {
    // final result = HandResultClient();
    try {
      if (_handActionProtoService == null) {
        final gameState = GameState.getState(_context);
        final gameContextObj =
            Provider.of<GameContextObject>(_context, listen: false);
        _handActionProtoService = HandActionProtoService(
            _context, gameState, gameContextObj, null, null, null, null);
        _handActionProtoService.loop();
      }

      final result = HandResultClient.fromJson(hiloMultiplePotsMessage);
      log('$result');
      _handActionProtoService.handleResult2(result);
    } catch (err) {
      log('Error: ${err.toString()}, ${err.stackTrace}');
    }
  }
}
