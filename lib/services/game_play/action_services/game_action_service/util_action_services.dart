import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:provider/provider.dart';

class UtilActionServices {
  UtilActionServices._();

  static void showCardsOfFoldedPlayers(
    BuildContext context,
    ChatMessage chatMessage,
  ) async {
    final String fromPlayerID = chatMessage.fromPlayer.toString();
    final String myPlayerID = context.read<Players>().me?.playerId?.toString();

    final int handNum = context.read<HandInfoState>().handNum;
    final int receivedHandNum = int.parse(chatMessage.text ?? '-1');

    // if we receive an old hand message, discard it
    if (handNum != receivedHandNum) return;

    // if I am the sender and the receiver, discard it
    if (fromPlayerID == myPlayerID) return;

    // print('this is here');
    final Players players = Provider.of<Players>(
      context,
      listen: false,
    );

    players.updateCardSilent(
      chatMessage.seatNo,
      chatMessage.cards,
    );
    players.notifyAll();
  }
}
