import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/screens/util_screens/util.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/list_tile.dart';

class Actions1Widget extends StatelessWidget {
  final AppTextScreen text;
  final GameState gameState;
  Actions1Widget({Key key, @required this.text, @required this.gameState})
      : super(key: key);

  void onStandup() async {
    if (gameState.isGameRunning) {
      GameService.leaveGame(gameState.gameCode);

      Alerts.showNotification(
        titleText: 'Leave',
        svgPath: 'assets/images/casino.svg',
        subTitleText:
            'You will standup after this hand', //_appScreenText['youWillStandupAfterThisHand'],
      );
    } else {
      await GameService.leaveGame(gameState.gameCode);
      gameState.refresh();
    }
  }

  void onBreak() {
    if (gameState.isGameRunning) {
      Alerts.showNotification(
          titleText: 'Break',
          leadingIcon: Icons.time_to_leave,
          subTitleText: 'You will take a break after the current hand');
    }
    GameService.takeBreak(gameState.gameCode);
  }

  void onReload(BuildContext context) async {
    // get current player's stack
    final me = gameState.me;
    if (me != null) {
      if (me.stack >= gameState.gameInfo.buyInMax) {
        showAlertDialog(
            context, "Reload", 'Chips in Stack are more than buyin max');
        return;
      }
      double reloadMax = gameState.gameInfo.buyInMax - me.stack;
      int reloadMin = 1;
      /* use numeric keyboard to get reload value */
      double value = await NumericKeyboard2.show(
        context,
        title:
            'Reload (${DataFormatter.chipsFormat(reloadMin.toDouble())} - ${DataFormatter.chipsFormat(reloadMax)})',
        min: reloadMin.toDouble(),
        max: reloadMax.toDouble(),
        decimalAllowed: gameState.gameInfo.chipUnit == ChipUnit.CENT,
      );

      if (value == null) return;

      final ret = await GameService.reload(gameState.gameCode, value.toInt());
      if (!ret.approved) {
        if (ret.insufficientCredits) {
          String message =
              'Not enough credits available. Available credits: ${DataFormatter.chipsFormat(ret.availableCredits)}';
          await showErrorDialog(context, 'Credits', message);
        } else if (ret.pendingRequest) {
          await showErrorDialog(context, 'Reload',
              'There is a pending reload request. Cannot make another request.');
        } else if (ret.waitingForApproval) {
          await showErrorDialog(context, 'Reload',
              'Your reload request is pending for host approval.');
        }
      } else {
        if (ret.appliedNextHand) {
          // show notification
          Alerts.showNotification(
              titleText: 'Reload',
              subTitleText: 'Reload is approved. Applied in next hand.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidgetTile(
          icon: Icons.exit_to_app,
          title: text['standup'],
          onPressed: () async {
            bool ret = await showPrompt(context, 'Standup',
                'Are you sure you want to standup from the table?');
            if (ret) {
              Navigator.pop(context);
              await onStandup();
            }
          },
        ),
        IconWidgetTile(
          svgIconPath: 'assets/images/game/break.svg',
          title: text['break'],
          onPressed: () async {
            Navigator.pop(context);
            this.onBreak();
          },
        ),
        IconWidgetTile(
          icon: Icons.refresh,
          title: text['reload'],
          onPressed: () async {
            Navigator.pop(context);
            this.onReload(context);
          },
        ),
      ],
    );
  }
}
