import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class TestService {
  static var _isTesting = false;
  static var _showResult = false;
  static PlayerInfo _currentPlayer;
  static GameInfoModel _gameInfo;
  static dynamic _result;
  static List<CardObject> _boardCards;
  static List<int> _pots;

  TestService._();

  static bool get isTesting {
    return _isTesting;
  }

  static PlayerInfo get currentPlayer {
    return _currentPlayer;
  }

  static GameInfoModel get gameInfo {
    return _gameInfo;
  }

  static dynamic get handResult {
    return _result;
  }

  static bool get showResult {
    return _showResult;
  }

  static List<CardObject> get boardCards {
    return _boardCards;
  }

  static List<int> get pots {
    return _pots;
  }

  static Future<void> load() async {
    if (_isTesting) {
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

      _boardCards = [130, 82, 193, 148, 20]
          .map<CardObject>((e) => CardHelper.getCard(e))
          .toList();
      _pots = [100];
    }
  }

  static Future<void> simulateBetMovement(BuildContext context) async {
    final gameState = Provider.of<GameState>(context, listen: false);
    final players = gameState.getPlayers(context);
    await players.moveCoinsToPot();
  }

  static void showBets(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final players = gameState.getPlayers(context);
    players.updateTestBet(20);
    players.notifyAll();
  }

  static Future<void> runTesting(BuildContext context) async {
    //await simulateBetMovement(context);
    //showBets(context);
    await movePotToPlayer(context);
  }

  static Future<void> movePotToPlayer(BuildContext context) async {
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
