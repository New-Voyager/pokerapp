import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/notification_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

import 'dart:developer';

class HighHandService {
  HighHandService._();

  static void handle({
    BuildContext context,
    var data,
    bool showNotification = false,
  }) async {
    if (data == null) return;

    String gameCode = data['gameCode'] as String;
    int handNum = data['handNum'] as int;

    // TODO: DO WE NEED MULTIPLE PLAYERS?
    var winner = data['winners'][0];

    String playerName = winner['playerName'];
    List<CardObject> hhCards = winner['hhCards']
        ?.map<CardObject>((c) => CardHelper.getCard(c as int))
        ?.toList();

    List<CardObject> playerCards = winner['playerCards']
        ?.map<CardObject>((c) => CardHelper.getCard(c as int))
        ?.toList();

    if (showNotification) {
      // show a notification

      var notificationValueNotifier =
          Provider.of<ValueNotifier<HHNotificationModel>>(
        context,
        listen: false,
      );

      notificationValueNotifier.value = HHNotificationModel(
        gameCode: gameCode,
        handNum: handNum,
        playerName: playerName,
        hhCards: hhCards,
        playerCards: playerCards,
      );

      /* wait for 5 seconds, then remove the notification */
      await Future.delayed(AppConstants.notificationDuration);

      notificationValueNotifier.value = null;
    } else {
      /* the player is in the current game - firework this user */
      int seatNo = winner['seatNo'] as int;

      final GameState gameState = Provider.of<GameState>(
        context,
        listen: false,
      );

      // show firework
      final player = gameState.fromSeat(context, seatNo);
      player.showFirework = true;
      gameState.updatePlayers(context);

      await Future.delayed(AppConstants.notificationDuration);

      // turn off firework
      player.showFirework = false;
      gameState.updatePlayers(context);
    }
  }
}
