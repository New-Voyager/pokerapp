import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/services/game_play/game_messaging_service.dart';
import 'package:provider/provider.dart';

class UtilActionServices {
  UtilActionServices._();

  static void showCardsOfFoldedPlayers(
    int myPlayerId,
    GameState gameState,
    ChatMessage chatMessage,
  ) async {
    final String fromPlayerID = chatMessage.fromPlayer.toString();
    //final gameState = GameState.getState(context);
    final String myPlayerID = myPlayerId.toString();

    // we dont need to proceed showing empty cards
    if (chatMessage.cards.isEmpty) return;

    final int handNum = gameState.handInfo.handNum;
    final int receivedHandNum = int.parse(chatMessage.text ?? '-1');

    // if we receive an old hand message, discard it
    if (handNum != receivedHandNum) return;

    // if I am the sender and the receiver, discard it
    // if (fromPlayerID == myPlayerID) return;

    // print('this is here');
    final seat = gameState.getSeat(chatMessage.seatNo);
    if (seat != null) {
      seat.player.revealCards.addAll(chatMessage.cards);
      seat.notify();
    }
  }
}
