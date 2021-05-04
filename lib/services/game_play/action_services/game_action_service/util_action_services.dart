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
  ) {
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
