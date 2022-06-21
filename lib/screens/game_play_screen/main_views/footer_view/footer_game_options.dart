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
  TableState get tableState => widget.gameState.tableState;
  AppTextScreen _appScreenText;

  void tableStateListener() {
    vnGameStatus.value = widget.gameState.tableState.gameStatus;
    vnTableStatus.value = widget.gameState.tableState.tableStatus;
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("centerView");
    tableState.addListener(tableStateListener);
  }

  @override
  void dispose() {
    tableState.removeListener(tableStateListener);
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
            ValueListenableBuilder2<String, String>(vnGameStatus, vnTableStatus,
                builder: (_, gameStatus, tableStatus, __) {
              if (!widget.gameState.isHost()) {
                return SizedBox.shrink();
              }
              // if table is running, don't show the buttons
              if (widget.gameState.tableState.gameStatus !=
                      AppConstants.GAME_CONFIGURED ||
                  widget.gameState.gameInfo.demoGame) {
                return SizedBox.shrink();
              }
              AppTheme appTheme = AppTheme.getTheme(context);
              List<Widget> actionButtons = [];
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
              // actionButtons.add(GameActionButton(
              //     theme: appTheme,
              //     onTap: () {},
              //     text: ' Shuffle ',
              //     btnColor: Colors.blueGrey,
              //     icon: Icons.shuffle));
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: actionButtons,
                  ),
                ],
              );
              //return Container(child: Text(tableState.gameStatus.toString()));
            }));

    //return Container(child: Text(tableState.gameStatus.toString()));
  }
}
