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
import 'package:pokerapp/widgets/reload_dialog.dart';

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
    final me = gameState.me;
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
    final ret = await GameService.reload(gameState.gameCode, value);
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

  void onAutoReload(BuildContext context) async {
    // get current player's stack
    final me = gameState.me;
    if (me != null) {
      double reloadThreshold = gameState.playerSettings.reloadThreshold;
      if (reloadThreshold == null) {
        reloadThreshold = (gameState.gameInfo.buyInMax ~/ 2).toDouble();
      }
      double reloadTo = gameState.playerSettings.reloadTo;
      if (reloadTo == null) {
        reloadTo = gameState.gameInfo.buyInMax;
      }
      /* use numeric keyboard to get reload value */
      ReloadOptions reloadReturn = await ReloadDialog.prompt(
          context: context,
          autoReload: gameState.playerSettings.autoReload ?? false,
          reloadThreshold: reloadThreshold,
          reloadTo: reloadTo,
          reloadMax: gameState.gameInfo.buyInMax,
          decimalAllowed: gameState.gameInfo.chipUnit == ChipUnit.CENT);
      if (reloadReturn == null) {
        return;
      }
      if (reloadReturn.autoReload != null) {
        // set auto reload
        if (reloadReturn.autoReload) {
          log('reload threshold: ${reloadReturn.stackBelowAmount}, reload to: ${reloadReturn.stackReloadTo}');
          final ret = await GameService.autoReload(gameState.gameCode,
              reloadReturn.stackBelowAmount, reloadReturn.stackReloadTo);
          if (ret) {
            Alerts.showNotification(
                titleText: 'Auto Reload',
                subTitleText: 'Auto Reload is turned on');
          }
        } else {
          // set auto reload off
          final ret = await GameService.autoReloadOff(gameState.gameCode);
          if (ret) {
            Alerts.showNotification(
                titleText: 'Auto Reload',
                subTitleText: 'Auto Reload is turned off');
          }
        }
        // update player settings
        gameState
            .refreshPlayerSettings()
            .then((value) {})
            .onError((error, stackTrace) => null);
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
        IconWidgetTile(
          icon: Icons.refresh,
          title: 'Auto Reload',
          onPressed: () async {
            Navigator.pop(context);
            this.onAutoReload(context);
          },
        ),
      ],
    );
  }
}
