import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:provider/provider.dart';

class TableView extends StatelessWidget {
  final double tableWidthFactor;
  final GameState gameState;

  TableView({
    Key key,
    this.tableWidthFactor = 1,
    this.gameState,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final tableWidth = MediaQuery.of(context).size.width * tableWidthFactor;
    final animationDuration = const Duration(milliseconds: 250);
    // final gameState = GameState.getState(context);
    return Container(
      key: gameState.gameUIState.tableKey,
      alignment: Alignment.center,
      width: tableWidth,
      child: Consumer<RedrawBoardSectionState>(
        builder: (_, __, ___) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Image.asset(
            appService.appSettings.tableAsset,
            key: UniqueKey(),
          ),
        ),
      ),
    );
  }
}
