import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/next_action_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/your_action_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class QueryCurrentHandService {
  QueryCurrentHandService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    int handNum = data['handNum'];
    Provider.of<GameContextObject>(
      context,
      listen: false,
    ).currentHandNum = handNum;

    var currentHandState = data['currentHandState'];
    // log('Current hand state: $currentHandState');

    // current players cards
    String playerCards = currentHandState['playerCards'];

    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    final GameState gameState = Provider.of<GameState>(
      context,
      listen: false,
    );
    final tableState = gameState.getTableState(context);
    final handInfo = gameState.getHandInfo(context);

    /* store the cards of the current player */
    int idxOfMe = players.players.indexWhere((p) => p.isMe);
    if (idxOfMe != -1)
      players.updateCardSilent(
        players.players[idxOfMe].seatNo,
        CardHelper.getRawCardNumbers(playerCards),
      );

    /* set the noOfVisible cards for other players */
    int noOfCards = int.parse(currentHandState["noCards"].toString());
    handInfo.update(noCards: noOfCards);
    players.visibleCardNumbersForAllSilent(noOfCards);

    // boardCards update if available
    try {
      List<int> boardCardsNum = currentHandState['boardCards']
          .map<int>((e) => int.parse(e.toString()))
          .toList();
      if (boardCardsNum != null)
        tableState.setBoardCards(
          1,
          boardCardsNum.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
        );
    } catch (e) {}

    // update the pot values
    List<int> pots = currentHandState['pots']
        ?.map<int>((e) => int.parse(e.toString()))
        ?.toList();
    var potUpdates = currentHandState['potUpdates'];

    tableState.updatePotChipsSilent(
      potChips: pots,
      potUpdatesChips: potUpdates,
    );

    tableState.notifyAll();

    // remainingActionTime
    int remainingActionTime = currentHandState['remainingActionTime'] != null
        ? int.parse(
            currentHandState['remainingActionTime'].toString(),
          )
        : 0;

    // put the remaining time in the provider
    Provider.of<RemainingTime>(
      context,
      listen: false,
    ).time = remainingActionTime;

    players.updateStackBulkSilent(
      currentHandState['playersStack'],
    );

    players.notifyAll();

    // next seat to ACT - handle using Next_Action service
    debugPrint('$currentHandState');
    int nextSeatToAct = int.parse(currentHandState['nextSeatToAct'].toString());
    int idx = players.players.indexWhere((p) => p.seatNo == nextSeatToAct);

    if (players.players[idx].isMe) {
      NextActionService.handle(
        context: context,
        data: {
          'actionChange': {
            'seatNo': nextSeatToAct,
            'pots': [{}],
          },
        },
      );

      YourActionService.handle(
        context: context,
        data: jsonDecode("""{
           "clubId":${data['clubId']},
           "gameId":"${data['gameId']}",
           "gameCode":"${data['gameCode']}",
           "handNum":${data['handNum']},
           "playerId":"${data['playerId']}",
           "seatAction":${jsonEncode(data['currentHandState']['nextSeatAction'])}
        }"""),
      );
    } else
      NextActionService.handle(
        context: context,
        data: {
          'actionChange': {
            'seatNo': nextSeatToAct,
            'pots': [{}],
          },
        },
      );
  }
}
