import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/game_model.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/hand_log_model_new.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/seat_change_confirmation_pop_up.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/services/test/hand_messages.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/host_seat_change.dart';

import 'iap_test.dart';

class TestService {
  static bool get isTesting {
    return false;
  }

  static var _showResult = false;
  static PlayerInfo _currentPlayer;
  static GameInfoModel _gameInfo;
  static dynamic _result;
  // static List<CardObject> _boardCards;
  static List<int> _pots;

  static BuildContext _context;
  static HandActionService _handActionService;
  static InAppPurchaseTest _testIap;
  TestService._();

  static set context(BuildContext context) => _context = context;

  static PlayerInfo get currentPlayer {
    final data = jsonDecode('''  {
                  "myInfo": {
                    "id": 1,
                    "uuid": "185ecfc9c80b5ee6",
                    "name": "s"
                  },
                  "role": {
                    "isHost": true,
                    "isOwner": true,
                    "isManager": false
                  }
                }''');
    _currentPlayer = PlayerInfo.fromJson(data);
    return _currentPlayer;
  }

  static GameInfoModel get gameInfo => _gameInfo;

  static dynamic get handResult => _result;

  static bool get showResult => _showResult;

  // static List<CardObject> get boardCards => _boardCards;

  static List<int> get pots => _pots;

  static void testIap() {
    if (_testIap == null) {
      _testIap = new InAppPurchaseTest();
    }
    _testIap.loadProducts();
  }

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
                "name": "tom"
              },
              "role": {
                "isHost": true,
                "isOwner": true,
                "isManager": false
              }
            }''');
        _currentPlayer = PlayerInfo.fromJson(data);
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
      }

      List<PlayerModel> playerInSeats = [];
      for (final player in _gameInfo.playersInSeats) {
        if (player.seatNo <= maxPlayers) {
          playerInSeats.add(player);
        }
      }

      // this removes a player from middle
      playerInSeats.removeAt(4);

      _gameInfo.playersInSeats = playerInSeats;

      final resultData =
          await rootBundle.loadString('assets/sample-data/result.json');
      _result = jsonDecode(resultData);
    }
  }

  static void addBoardCards() {
    // fixme: do nothing for testing
    return;

    List<CardObject> _boardCards = [130, 82, 193, 148, 20]
        .map<CardObject>((e) => CardHelper.getCard(e))
        .toList();

    final TableState tableState = _getTableState();
    tableState.setBoardCards(
      1,
      _boardCards,
    );
    tableState.notifyAll();
  }

  static TableState _getTableState() {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    return gameState.getTableState(context);
  }

  static Future<void> distributeCards() async {
    // table state
    final TableState tableState = _getTableState();
    tableState.updateTableStatusSilent('NEW_HAND');
    tableState.notifyAll();

    await Future.delayed(const Duration(seconds: 2));
    final gameState = GameState.getState(_context);
    HandActionService handActionService =
        HandActionService(_context, gameState, null);
    await handActionService.handleDealStarted();

    tableState.updateTableStatusSilent(null);
    tableState.notifyAll();
  }

  static Future<void> clearBoardCards() async {
    final tableState = _getTableState();

    tableState.clear();
    tableState.notifyAll();
  }

  static Future<void> addTurnOrRiverCard() async {
    final tableState = _getTableState();

    tableState.addTurnOrRiverCard(
      1,
      CardHelper.getCard(148),
    );

    tableState.notifyAll();
  }

  static Future<void> addFlopCards() async {
    final tableState = _getTableState();

    tableState.addFlopCards(
      1,
      [130, 82, 193].map<CardObject>((e) => CardHelper.getCard(e)).toList(),
    );
    tableState.notifyAll();
  }

  static Future<void> simulateBetMovement() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    await gameState.animateSeatActions();
    await Future.delayed(Duration(seconds: 1));
    gameState.resetSeatActions();
  }

  static void showBets() {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.resetSeatActions();

    final seat1 = gameState.getSeat(context, 1);
    seat1.player.action.button = true;

    final seat2 = gameState.getSeat(context, 2);
    seat2.player.action.amount = 1;
    seat2.player.action.sb = true;

    final seat3 = gameState.getSeat(context, 3);
    seat3.player.action.amount = 2;
    seat3.player.action.bb = true;

    final seat4 = gameState.getSeat(context, 4);
    seat4.player.action.amount = 4;
    seat4.player.action.straddle = true;

    final seat5 = gameState.getSeat(context, 5);
    seat5.player.action.setAction(jsonDecode('''
          {
            "action": "CALL",
            "amount": 4.0
          }
        '''));

    for (final seat in gameState.seats) {
      if (seat.serverSeatPos <= 5) {
        seat.notify();
        continue;
      }

      if (seat.serverSeatPos == 6) {
        dynamic json = jsonDecode('''
          {
            "action": "BET",
            "amount": 20.0
          }
        ''');
        seat.player.action.setAction(json);
      } else {
        dynamic json = jsonDecode('''
          {
            "action": "CALL",
            "amount": 20.0
          }
        ''');
        seat.player.action.setAction(json);
      }

      seat.notify();
    }
  }

  static Future<void> buyInTest() async {
    final gameState = Provider.of<GameState>(_context, listen: false);
    final players = gameState.getPlayers(_context);
    final now = DateTime.now();
    var exp = DateTime.now();
    exp = exp.add(Duration(seconds: 20));
    players.me.buyInTimeExpAt = exp.toUtc();
    log('now: ${now.toIso8601String()} exp: ${exp.toIso8601String()} utc: ${players.me.buyInTimeExpAt.toIso8601String()}');
    players.me.showBuyIn = true;
    players.me.stack = 0;

    final seat4 = gameState.getSeat(_context, 4);
    exp = now.add(Duration(seconds: 30));
    seat4.player.showBuyIn = true;
    seat4.player.stack = 0;
    seat4.player.buyInTimeExpAt = exp.toUtc();
    // redraw seat
    final seat = gameState.getSeat(_context, players.me.seatNo);
    players.notifyAll();
    seat.notify();
  }

  static Future<void> movePotToPlayer() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);

    final players = gameState.getPlayers(context);
    final seat1 = gameState.getSeat(context, 1);
    final seat2 = gameState.getSeat(context, 5);
    final seat3 = gameState.getSeat(context, 9);
    final player1 = seat1.player;
    // player1.coinAmount = 100;
    // player1.animatingCoinMovement = false;
    // player1.animatingCoinMovementReverse = true;

    // seat2.player.coinAmount = 100;
    // seat2.player.animatingCoinMovement = false;
    // seat2.player.animatingCoinMovementReverse = true;

    // seat3.player.coinAmount = 100;
    // seat3.player.animatingCoinMovement = false;
    // seat3.player.animatingCoinMovementReverse = true;
    // log('Updating pot to players');
    // players.notifyAll();
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

  static Future<void> testBetWidget() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    final actionState = gameState.getActionState(context);

    final seatActionJsonStr = '''
        {
          "seatNo": 1,
          "availableActions": ["FOLD", "CALL", "BET", "ALLIN"],
          "callAmount": 2,
          "minRaiseAmount": 4,
          "maxRaiseAmount": 30,
          "allInAmount": 30,
          "betOptions": [{
            "text": "3BB",
            "amount": 6
          }, {
            "text": "5BB",
            "amount": 10
          }, {
            "text": "10BB",
            "amount": 20
          }, {
            "text": "All-In",
            "amount": 30
          }]
        }''';
    final seatAction = jsonDecode(seatActionJsonStr);
    // actionState.setAction(1, seatAction);
    gameState.setAction(context, 1, seatAction);
    gameState.showAction(context, true);

    actionState.notifyListeners();
  }

  static Future<void> testCountdownTimer() async {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    final seat = gameState.getSeat(context, 1);

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

  static Future<void> showFlushBar() async {
    String message = 'emma is invited to take the open seat';
    showWaitlistStatus(_context, message, 10);
  }

  static Future<void> showHoleCards() async {
    GameState gameState = Provider.of<GameState>(
      _context,
      listen: false,
    );
    final player = gameState.me(_context);
    player.cards = [
      194,
      196,
      200,
      50,
      56,
    ];
    player.noOfCardsVisible = 2;
    final players = gameState.getPlayers(_context);
    players.notifyAll();
  }

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

  static Future<void> sendNewHand() async {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    await _handActionService.handle(newHandMessage());
    //await _handActionService.handle(dealCardsMessage());
    //await HandActionService.handle(context: _context, message: yourActionNextActionMsg());
    //await HandActionService.handle(context: _context, message: dealStartedMessage());
  }

  static void emptySeatDealer() {
    final gameState = GameState.getState(_context);
    final seat = gameState.getSeat(_context, 5);

    seat.isDealer = true;
  }

  static void seatChange() {
    final hostSeatChange =
        Provider.of<SeatChangeNotifier>(_context, listen: false);

    /* start animation */
    hostSeatChange.onSeatDrop(1, 5);

    /* refresh */
    final gameState = GameState.getState(_context);
    gameState.refresh(_context);
  }

  static void runItTwiceResult() {
    final resultMessage = runItTwiceMessage();

    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    _handActionService.handle(resultMessage);
  }

  static void fillBothBoardCards() {
    final gameState = GameState.getState(_context);
    final TableState tableState = gameState.getTableState(_context);

    /* board 1 */
    tableState.setBoardCards(
      1,
      [50, 50, 50, 50, 50].map((e) => CardHelper.getCard(e)).toList(),
    );

    /* board 2 */
    tableState.setBoardCards(
      2,
      [50, 50, 50, 50, 50].map((e) => CardHelper.getCard(e)).toList(),
    );

    tableState.updatePotChipsSilent(
      potChips: [578],
    );

    tableState.notifyAll();
  }

  static void fillCenterView() {
    final gameState = GameState.getState(_context);
    final TableState tableState = gameState.getTableState(_context);

    tableState.addFlopCards(
      1,
      [50, 50, 50].map((e) => CardHelper.getCard(e)).toList(),
    );

    tableState.addTurnOrRiverCard(
      1,
      CardHelper.getCard(200),
    );
    tableState.addTurnOrRiverCard(
      1,
      CardHelper.getCard(200),
    );

    tableState.updatePotChipsSilent(
      potChips: [578],
      potUpdatesChips: 120,
    );

    tableState.notifyAll();
  }

  static Future<void> flop() async {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    await _handActionService.handle(flopMessage());
  }

  static Future<void> fold() async {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    await _handActionService.handle(foldMessage());
  }

  static void resetGameState() {
    final gameState = GameState.getState(_context);
    gameState.clear(_context);
    gameState.getTableState(_context).notifyAll();
    ActionState state = gameState.getActionState(_context);
    state.show = false;

    gameState.resetSeatActions();
    final seats = gameState.seats;
    for (final seat in seats) {
      seat.player.noOfCardsVisible = 2;
    }
    final players = gameState.getPlayers(_context);
    players.notifyAll();

    /* wait then run fold */
    Future.delayed(const Duration(milliseconds: 800)).then((value) => fold());
  }

  static void sendRunItTwiceMessage() {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    String message = '''{
   "messageType":"RUN_IT_TWICE",
   "runItTwice":{
      "board1":[
         200,
         196,
         8,
         132,
         33
      ],
      "board2":[
         72,
         84,
         40,
         100,
         97
      ],
      "stage":"PREFLOP",
      "seatsPots":[
         {
            "seats":[
               5,
               8
            ],
            "pot":100
         }
      ],
      "seat1":5,
      "seat2":8
   }
}''';
    //final handActionService = HandActionService( _context, gameState);
    _handActionService.clear();
    _handActionService.handle('{"messages": [$message]}');
  }

  static void runItTwicePrompt() {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    String message =
        '''{"clubId": 1,"gameId": "1620287740","gameCode": "1620287740","handNum": 1,"messageId": "ACTION:1:FLOP:0:","handStatus": "FLOP","messages": [{"messageType": "PLAYER_ACTED","playerActed": {"seatNo": 8,"action": "ALLIN","amount": 50}}, {"messageType": "YOUR_ACTION","seatAction": {"seatNo": 1,"availableActions": ["RUN_IT_TWICE_PROMPT"]}}, {"messageType": "YOUR_ACTION","seatAction": {"seatNo": 8,"availableActions": ["RUN_IT_TWICE_PROMPT"]}}]}''';
    //final handActionService = HandActionService( _context, gameState);
    _handActionService.clear();
    _handActionService.handle(message);
  }

  static void handMessage() {
    final gameState = GameState.getState(_context);
    // final seat = gameState.getSeat(_context, 1);
    // seat.player.highlight = true;
    // seat.setActionTimer(gameState.gameInfo.actionTime);
    // seat.notify();
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    String message =
        '''{"version":"", "clubId":254, "gameId":"284", "gameCode":"CG-A2DHJIG7497MNKP", "handNum":36,
     "seatNo":0, "playerId":"0", "messageId":"ACTION:36:RIVER:2443:40", "gameToken":"", "handStatus":"RIVER", 
     "messages":[
       {"messageType":"PLAYER_ACTED", "playerActed":{"seatNo":1, "action":"CHECK", "amount":0, "timedOut":false, "actionTime":0, "stack":28}}, 
       {"messageType":"RIVER", "river":{"board":[97, 145, 2, 130, 66], "riverCard":66, "cardsStr":"[ 8♠  J♠  2❤  T❤  6❤ ]", "pots":[4], "seatsPots":[{"seats":[1, 2], "pot":4}], "playerBalance":{"1":28, "2":98}}}, 
       {"messageType":"YOUR_ACTION", "seatAction":{"seatNo":2, "availableActions":["FOLD", "CHECK", "BET", "ALLIN"], "straddleAmount":0, "callAmount":0, "raiseAmount":0, "minBetAmount":0, "maxBetAmount":0, "minRaiseAmount":2, "maxRaiseAmount":98, "allInAmount":98, "betOptions":[{"text":"100%", "amount":4}, {"text":"All-In", "amount":98}]}}, 
       {"messageType":"NEXT_ACTION", "actionChange":{"seatNo":2, "pots":[4], "potUpdates":0, "seatsPots":[{"seats":[1, 2], "pot":4}]}}
      ]}''';
    //final handActionService = HandActionService( _context, gameState);
    _handActionService.clear();
    _handActionService.handle(message);
  }

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

  static void handAnnouncement() async {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    await _handActionService.handle(newGameAnnouncement());
  }

  static void showPlayerStatus() {
    final gameState = GameState.getState(_context);
    final players = gameState.getPlayers(_context);

    for (int i = 1; i < 10; i++) {
      final seat = gameState.getSeat(_context, i);

      final action = seat.player.action;
      action.setAction(ActionElement(
        action: HandActions.CALL,
      ));
    }

    players.notifyAll();
  }

  static void showDownCards() {
    final gameState = GameState.getState(_context);
    final players = gameState.getPlayers(_context);

    _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.Result;

    for (int i = 1; i < 10; i++) {
      players.updateCardSilent(i, [50, 50, 50, 50, 50]);
    }

    players.notifyAll();
  }

  static void removeShowDownCards() {
    final gameState = GameState.getState(_context);
    final players = gameState.getPlayers(_context);

    _context.read<ValueNotifier<FooterStatus>>().value = FooterStatus.None;

    for (int i = 1; i < 10; i++) {
      players.updateCardSilent(i, []);
    }

    players.notifyAll();
  }

  static void dealerChoiceGame() async {
    final gameState = GameState.getState(_context);
    if (_handActionService == null) {
      _handActionService = HandActionService(_context, gameState, null);
      _handActionService.loop();
    }
    await _handActionService.handle(dealerChoiceMessage());
  }

  static void showSeatChangePrompt() async {
    final gameState = GameState.getState(_context);
    final seat5 = gameState.getSeat(_context, 5);
    seat5.player = null;
    seat5.notify();
    gameState.playerSeatChangeInProgress = true;

    SeatChangeConfirmationPopUp.dialog(
        context: _context, gameCode: 'test', promptSecs: 10);
  }
}
