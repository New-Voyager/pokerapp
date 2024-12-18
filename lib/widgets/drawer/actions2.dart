import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/screens/game_context_screen/game_options/game_option/pending_approvals.dart';
import 'package:pokerapp/services/app/game_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/menu_list_tile.dart';
import 'package:provider/provider.dart';

class Actions2Widget extends StatelessWidget {
  final AppTextScreen text;
  final GameState gameState;
  const Actions2Widget({Key key, @required this.text, @required this.gameState})
      : super(key: key);

  void onPause() {
    Alerts.showNotification(
        titleText: 'Pause',
        leadingIcon: Icons.pause_circle_outline,
        subTitleText: 'Game will be paused next hand');
    GameService.pauseGame(gameState.gameCode);
  }

  void onTerminate(BuildContext context) async {
    final response = await showPrompt(
        context, 'End Game', "Do you want to end the game?",
        positiveButtonText: 'Yes', negativeButtonText: 'No');
    if (response != null && response == true) {
      if (gameState.isGameRunning) {
        GameService.endGame(gameState.gameCode);
      } else {
        await GameService.endGame(gameState.gameCode);
        gameState.refresh();
      }
    }
  }

  void onApprovals(BuildContext context) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return PendingApprovalsBottomSheet(
            gameState, gameState.gameCode, gameState.currentPlayerUuid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Consumer<PendingApprovalsState>(builder: (_, value, ___) {
      return MenuListTile(
        icon: Icons.task_alt,
        padding: EdgeInsets.all(8),
        title: text["approvals"],
        onPressed: () {
          Navigator.of(context).pop();
          onApprovals(context);
        },
        badgeCount: value.approvalList.length,
      );
    }));

    if (gameState.isGameRunning) {
      children.add(MenuListTile(
        icon: Icons.pause,
        padding: EdgeInsets.all(8),
        title: text["pause"],
        onPressed: () {
          onPause();
          Navigator.of(context).pop();
        },
      ));
    }
    children.add(MenuListTile(
      icon: Icons.close,
      padding: EdgeInsets.all(8),
      title: text["terminate"],
      onPressed: () async {
        await onTerminate(context);
        Navigator.of(context).pop();
      },
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [...children],
    );
  }
}
