import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/game_play_screen_util_methods.dart';
import 'package:pokerapp/utils/listenable.dart';
import 'package:pokerapp/utils/loading_utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

const shrinkedBox = const SizedBox.shrink(
  key: ValueKey('none'),
);

class FooterGameActionView extends StatefulWidget {
  final GameState gameState;
  FooterGameActionView({
    this.gameState,
  });

  @override
  _FooterGameActionViewState createState() => _FooterGameActionViewState();
}

class _FooterGameActionViewState extends State<FooterGameActionView> {
  final vnGameStatus = ValueNotifier<String>(null);
  final vnTableStatus = ValueNotifier<String>(null);
  final vnPlayerStatus = ValueNotifier<String>(null);
  TableState get tableState => widget.gameState.tableState;
  AppTextScreen _appScreenText;

  void tableStateListener() {
    vnGameStatus.value = widget.gameState.tableState.gameStatus;
    vnTableStatus.value = widget.gameState.tableState.tableStatus;
  }

  void playerStateListener() {
    vnPlayerStatus.value = widget.gameState.me.status;
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("centerView");
    tableState.addListener(tableStateListener);
    widget.gameState.myState.addListener(playerStateListener);
  }

  @override
  void dispose() {
    tableState.removeListener(tableStateListener);
    widget.gameState.myState.removeListener(playerStateListener);
    super.dispose();
  }

  startGame(BuildContext context) async {
    try {
      ConnectionDialog.show(
          context: widget.gameState.mainScreenContext,
          loadingText: "Starting...");
      await GamePlayScreenUtilMethods.startGame(widget.gameState.gameCode);
      await widget.gameState.refresh();
      ConnectionDialog.dismiss(context: widget.gameState.mainScreenContext);
    } catch (err) {
      ConnectionDialog.dismiss(context: widget.gameState.mainScreenContext);
      showErrorDialog(widget.gameState.mainScreenContext, 'Error',
          'Failed to start the game. Error: ${err.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableState>(
        builder: (_, TableState tableState, __) =>
            ValueListenableBuilder3<String, String, String>(
                vnGameStatus, vnTableStatus, vnPlayerStatus,
                builder: (_, gameStatus, tableStatus, playerStatus, __) {
              Widget ret = SizedBox.shrink();
              AppTheme appTheme = AppTheme.getTheme(context);
              List<Widget> actionButtons = [];
              bool showGameStartButtons = false;
              bool showGamePauseButtons = false;
              bool buyInButtons = false;
              if (widget.gameState.isHost()) {
                // if host or owner, show start/end buttons if the game is just configured
                if (widget.gameState.tableState.gameStatus ==
                        AppConstants.GAME_CONFIGURED &&
                    !widget.gameState.gameInfo.demoGame) {
                  showGameStartButtons = true;
                }
              }
              if ((widget.gameState.isHost() ||
                      widget.gameState.currentPlayer.isOwner()) &&
                  widget.gameState.tableState.gameStatus ==
                      AppConstants.GAME_PAUSED) {
                showGamePauseButtons = false;
              }

              if (playerStatus == AppConstants.WAIT_FOR_BUYIN) {
                buyInButtons = false;
              }

              if (showGameStartButtons) {
                actionButtons.add(GameActionButton(
                    theme: appTheme,
                    onTap: () async {
                      await startGame(context);
                    },
                    text: ' Start ',
                    btnColor: Colors.green,
                    icon: Icons.play_arrow));
                actionButtons.add(GameActionButton(
                    theme: appTheme,
                    onTap: () {},
                    text: ' End ',
                    btnColor: Color.fromARGB(255, 208, 91, 83),
                    icon: Icons.close));
              }

              if (showGamePauseButtons) {
                actionButtons.add(GameActionButton(
                    theme: appTheme,
                    onTap: () async {
                      await startGame(context);
                    },
                    text: ' Resume ',
                    btnColor: Colors.green,
                    icon: Icons.play_arrow));
                actionButtons.add(GameActionButton(
                    theme: appTheme,
                    onTap: () {},
                    text: ' Rearrange\n Seats ',
                    btnColor: Color.fromARGB(255, 208, 91, 83),
                    icon: Icons.close));
                actionButtons.add(GameActionButton(
                    theme: appTheme,
                    onTap: () {},
                    text: ' End \n Game ',
                    btnColor: Color.fromARGB(255, 208, 91, 83),
                    icon: Icons.close));
              }
              if (buyInButtons) {
                actionButtons.add(GameActionButton(
                    theme: appTheme,
                    onTap: () async {
                      await startGame(context);
                    },
                    text: ' Buyin ',
                    btnColor: Colors.green,
                    icon: Icons.play_arrow));
              }

              if (actionButtons.isNotEmpty) {
                ret = Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: actionButtons,
                    ),
                  ],
                );
              }
              return ret;
              //return Container(child: Text(tableState.gameStatus.toString()));
            }));

    //return Container(child: Text(tableState.gameStatus.toString()));
  }
}
