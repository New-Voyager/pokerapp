import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class TestService {
  static var isTesting = false;
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

  static PlayerInfo get currentPlayer => _currentPlayer;

  static GameInfoModel get gameInfo => _gameInfo;

  static dynamic get handResult => _result;

  static bool get showResult => _showResult;

  // static List<CardObject> get boardCards => _boardCards;

  static List<int> get pots => _pots;

  static Future<void> load() async {
    if (isTesting) {
      final gameData =
          await rootBundle.loadString('assets/sample-data/gameinfo.json');
      final jsonData = jsonDecode(gameData);
      if (jsonData["currentPlayer"] != null) {
        _currentPlayer = PlayerInfo.fromJson(jsonData["currentPlayer"]);
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

  // static Future<void> runTesting(BuildContext context) async {
  //   //await simulateBetMovement(context);
  //   //showBets(context);
  //   await movePotToPlayer(context);
  // }

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
}
