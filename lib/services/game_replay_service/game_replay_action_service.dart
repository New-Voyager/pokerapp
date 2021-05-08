import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_replay_models/game_replay_action.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class GameReplayActionService {
  GameReplayActionService._();

  static void _preflopStartedAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    int pot = action.actionData['pot'] as int;

    tableState.updatePotChipsSilent(potChips: [pot]);
    tableState.notifyAll();
  }

  static void _playerAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    /*
    "seatNo":7,
    "action":"SB",
    "amount":1,
    "timedOut":false,
    "stack":0
    */

    int seatNo = action.actionData['seatNo'] as int;
    String actionName = action.actionData['action'] as String;
    int amount = action.actionData['amount'] as int;
    bool timedOut = action.actionData['timedOut'] as bool;
    int stack = action.actionData['stack'] as int;
    final gameState = GameState.getState(context);
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    int idx = players.players.indexWhere(
      (p) => p.seatNo == seatNo,
    );

    assert(idx != -1);

    if (actionName == AppConstants.FOLD)
      players.updatePlayerFoldedStatusSilent(
        idx,
        true,
      );
    else {
      final seat = gameState.getSeat(context, seatNo);
      seat.player.action.setAction(action);
      // players.updateCoinAmountSilent(
      //   idx,
      //   amount,
      // );

      players.updateStatusSilent(
        idx,
        actionName,
      );

      players.updateStackWithValueSilent(
        idx,
        stack,
      );
    }

    players.notifyAll();
  }

  static Future<void> _stageUpdateUtilAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    // show the move coin to pot animation, after that update the pot
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    final gameState = GameState.getState(context);

    //await players.moveCoinsToPot();
    await gameState.animateSeatActions();

    tableState.updatePotChipsSilent(
      potChips: [action.actionData['pot']],
      potUpdatesChips: null,
    );
    tableState.notifyAll();

    players.notifyAll();
  }

  static void _flopStartedAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(
      action,
      context,
    );

    /* finally update the community cards */
    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    /* FIXME: HARD CODED FOR BOARD 1 */
    tableState.addFlopCards(
      1,
      action.actionData['cards']
          .map<CardObject>(
            (c) => CardHelper.getCard(c as int),
          )
          .toList(),
    );

    tableState.notifyAll();
  }

  static void _riverOrTurnStartedAction(
    GameReplayAction action,
    BuildContext context, {
    bool isRiver = false,
  }) async {
    /* show animation of chips moving to pots and update the pot */
    await _stageUpdateUtilAction(
      action,
      context,
    );

    /* finally update the community cards */
    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    /* FIXME: HARD CODED FOR BOARD 0 */

    tableState.addTurnOrRiverCard(
      1,
      CardHelper.getCard(
        action.actionData['cards'][0],
      ),
    );

    // if (isRiver) {
    //   tableState.turnOrRiver(
    //     1,
    //     CardHelper.getCard(
    //       action.actionData['cards'][0],
    //     ),
    //   );
    // } else {
    //   tableState.turnOrRiver(
    //     1,
    //     CardHelper.getCard(
    //       action.actionData['cards'][0],
    //     ),
    //   );
    // }

    tableState.notifyAll();
  }

  static void _showdownAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    Map<int, List<int>> _getCards(var players) {
      Map<int, List<int>> cards = {};

      players.forEach((var seatNo, var player) {
        cards[int.parse(seatNo.toString())] =
            player['cards'].map<int>((c) => int.parse(c.toString())).toList();
      });

      print(cards.toString());

      return cards;
    }

    var playersData = action.actionData;
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    /* then, change the status of the footer to show the result */
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.Result;

    /* remove all highlight - silently */
    players.removeAllHighlightsSilent();

    players.removeMarkersFromAllPlayerSilent();

    /* seat no - list of cards */
    players.updateUserCardsSilent(_getCards(playersData));

    players.notifyAll();
  }

  static void _declareWinnerAction(
    GameReplayAction action,
    BuildContext context,
  ) {
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    final TableState tableState = Provider.of<TableState>(
      context,
      listen: false,
    );

    // TODO: HANDLE LOW AND HIGH WINNERS

    /* highlight cards of players and community cards for winner */

    final potWinners = action.actionData;

    // TODO: FOR NOW ONLY USING THE FIRST POT
    final highWinners = potWinners[0]['hiWinners'];
    final lowWinners = potWinners[0]['lowWinners'];

    /* highlight players (winners) */
    highWinners.forEach((winner) {
      // highlight the winner seat No
      players.highlightWinnerSilent(int.parse(winner['seatNo'].toString()));
    });

    /* highlight players winning cards */
    players.highlightCardsSilent(
      seatNo: int.parse(highWinners[0]['seatNo'].toString()),
      cards: highWinners[0]['playerCards']
          .map<int>((c) => int.parse(c.toString()))
          .toList(),
    );

    /* highlight community cards */
    tableState.highlightCardsSilent(
      1,
      highWinners[0]['boardCards']
          .map<int>((c) => int.parse(c.toString()))
          .toList(),
    );

    /* finally notify */
    players.notifyAll();
    tableState.notifyAll();
  }

  static void takeAction(
    GameReplayAction action,
    BuildContext context,
  ) async {
    log('takeAction : ${action.actionType}');

    assert(context != null);

    switch (action.actionType) {
      case GameReplayActionType.card_distribution:
        GameState gameState = Provider.of<GameState>(
          context,
          listen: false,
        );

        // TODO: FIND A GOOD PLACE TO UPDATE THE NO. OF CARDS

        final handInfo = gameState.getHandInfo(context);
        handInfo.update(noCards: 2);

        /* set the table status to NEW_HAND and thus shows the card shuffle animation */
        final tableState = gameState.getTableState(context);
        tableState.updateTableStatusSilent(AppConstants.NEW_HAND);
        tableState.notifyAll();

        // TODO: DO SOMETHING ABOUT THE DURATION
        await Future.delayed(const Duration(seconds: 2));
        HandActionService handActionService =
            HandActionService(context, gameState, null);
        await handActionService.handleDealStarted();

        return handActionService.handleDealStarted(
          fromGameReplay: true,
        );

      case GameReplayActionType.pre_flop_started:
        return _preflopStartedAction(
          action,
          context,
        );

      case GameReplayActionType.player_action:
        return _playerAction(
          action,
          context,
        );

      case GameReplayActionType.flop_started:
        return _flopStartedAction(
          action,
          context,
        );

      case GameReplayActionType.river_started:
        return _riverOrTurnStartedAction(
          action,
          context,
          isRiver: true,
        );

      case GameReplayActionType.turn_started:
        return _riverOrTurnStartedAction(
          action,
          context,
          isRiver: false,
        );

      case GameReplayActionType.showdown:
        return _showdownAction(
          action,
          context,
        );

      case GameReplayActionType.declare_winner:
        return _declareWinnerAction(
          action,
          context,
        );
    }
  }
}
