import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/hh_notification_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:provider/provider.dart';

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
    List<CardObject> hhCards =
        winner['hhCards']?.map((c) => CardHelper.getCard(c as int))?.toList();

    List<CardObject> playerCards = winner['playerCards']
        ?.map((c) => CardHelper.getCard(c as int))
        ?.toList();

    if (showNotification) {
      // show a notification

      var notificationValueNotifier =
          Provider.of<ValueNotifier<HhNotificationModel>>(
        context,
        listen: false,
      );

      notificationValueNotifier.value = HhNotificationModel(
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
      int seatNo = data['seatNo'] ?? 1; // FIXME: SEAT-NO SHOULD NOT BE NULL

      /* setting as winner would firework the user too
      * TODO: MAY BE THE WINNER NEEDS NOT TO BE FIREWORK-ED ALWAYS? */
      Provider.of<Players>(
        context,
        listen: false,
      ).highlightWinner(seatNo);
    }
  }
}
