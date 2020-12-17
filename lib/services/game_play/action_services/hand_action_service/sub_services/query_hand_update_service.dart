import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/remaining_time.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/next_action_service.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_service/sub_services/your_action_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

class QueryHandUpdateService {
  QueryHandUpdateService._();

  static void handle({
    BuildContext context,
    var data,
  }) {
    var currentHandState = data['currentHandState'];

    // current players cards
    String playerCards = currentHandState['playerCards'];
    Provider.of<ValueNotifier<List<CardObject>>>(
      context,
      listen: false,
    ).value = CardHelper.getCards(playerCards);

    // boardCards update if available
    try {
      List<int> boardCardsNum = currentHandState['boardCards']
          .map<int>((e) => int.parse(e.toString()))
          .toList();
      if (boardCardsNum != null)
        Provider.of<TableState>(
          context,
          listen: false,
        ).updateCommunityCards(
          boardCardsNum.map<CardObject>((c) => CardHelper.getCard(c)).toList(),
        );
    } catch (e) {}

    // update the pot values
    List<int> pots = currentHandState['pots']
        ?.map<int>((e) => int.parse(e.toString()))
        ?.toList();
    var potUpdates = currentHandState['potUpdates'];

    Provider.of<TableState>(
      context,
      listen: false,
    ).updatePostChips(
      potChips: pots,
      potUpdatesChips: potUpdates,
    );

    // remainingActionTime
    int remainingActionTime =
        int.parse(currentHandState['remainingActionTime'].toString());

    // put the remaining time in the provider
    Provider.of<RemainingTime>(
      context,
      listen: false,
    ).time = remainingActionTime;

    Provider.of<Players>(
      context,
      listen: false,
    ).updateStack(
      currentHandState['playersStack'],
    );

    // next seat to ACT - handle using Next_Action service
    int nextSeatToAct = int.parse(currentHandState['nextSeatToAct'].toString());
    Players players = Provider.of<Players>(
      context,
      listen: false,
    );
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
