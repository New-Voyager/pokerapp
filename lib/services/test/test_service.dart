import 'dart:convert';
import 'dart:developer';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/deal_started_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class TestService {
  static var _showResult = false;
  static PlayerInfo _currentPlayer;
  static GameInfoModel _gameInfo;
  static dynamic _result;
  // static List<CardObject> _boardCards;
  static List<int> _pots;

  static BuildContext _context;

  TestService._();

  static set context(BuildContext context) => _context = context;

  // static set isTesting(bool isTesting) => _isTesting = isTesting;
  //
  // static bool get isTesting => _isTesting;

  static PlayerInfo get currentPlayer {
    final data = jsonDecode('''  {
                  "myInfo": {
                    "id": 1,
                    "uuid": "d04d24d1-be90-4c02-b8fb-c2499d9b76ed",
                    "name": "john"
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

  static get isTesting {
    return false;
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
      if (jsonData["gameInfo"] != null) {
        _gameInfo = GameInfoModel.fromJson(jsonData["gameInfo"]);
      }
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

    await DealStartedService.handle(
      context: _context,
    );

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
    final players = gameState.getPlayers(context);
    await players.moveCoinsToPot();
  }

  static void showBets() {
    BuildContext context = _context;

    final gameState = Provider.of<GameState>(context, listen: false);
    final players = gameState.getPlayers(context);
    players.updateTestBet(20);
    players.notifyAll();
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
    player1.coinAmount = 100;
    player1.animatingCoinMovement = false;
    player1.animatingCoinMovementReverse = true;

    seat2.player.coinAmount = 100;
    seat2.player.animatingCoinMovement = false;
    seat2.player.animatingCoinMovementReverse = true;

    seat3.player.coinAmount = 100;
    seat3.player.animatingCoinMovement = false;
    seat3.player.animatingCoinMovementReverse = true;
    log('Updating pot to players');
    players.notifyAll();

    // wait for the animation to finish, then update the stack
    Future.delayed(Duration(seconds: 1)).then(
      (_) {
        players.removeWinnerHighlightSilent();
        players.resetMoveCoinsFromPotSilent();
        players.notifyAll();
      },
    );
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
    // Flushbar(
    //   flushbarPosition: FlushbarPosition.TOP,
    //   flushbarStyle: FlushbarStyle.GROUNDED,
    //   // reverseAnimationCurve: Curves.decelerate,
    //   // forwardAnimationCurve: Curves.elasticOut,
    //   backgroundColor: Colors.red,
    //   //boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    //   backgroundGradient:
    //       LinearGradient(colors: [Colors.black, Colors.blueGrey]),
    //   isDismissible: false,
    //   duration: Duration(seconds: 10),
    //   icon: Icon(
    //     Icons.queue_play_next,
    //     color: Colors.greenAccent,
    //   ),
    //   showProgressIndicator: false,
    //   progressIndicatorBackgroundColor: Colors.blueGrey,
    //   titleText: Text(
    //     "Waitlist Seating",
    //     style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 15.0,
    //         color: Colors.white,
    //         fontFamily: "ShadowsIntoLightTwo"),
    //   ),
    //   messageText: Text(
    //     "bob is invited to take the open seat",
    //     style: TextStyle(
    //         fontSize: 12.0,
    //         color: Colors.green,
    //         fontFamily: "ShadowsIntoLightTwo"),
    //   ),
    // )..show(_context);
  }
}
