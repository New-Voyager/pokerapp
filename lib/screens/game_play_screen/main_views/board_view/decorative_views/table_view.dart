import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:provider/provider.dart';

class TableView extends StatelessWidget {
  final double tableWidthFactor;
  final GameState gameState;

  TableView({
    this.tableWidthFactor = 1.0,
    this.gameState,
  });

  Widget build(BuildContext context) {
    final tableWidth = MediaQuery.of(context).size.width * tableWidthFactor;
    final animationDuration = const Duration(milliseconds: 250);
    final gameState = GameState.getState(context);
    String tableAsset;
    if (!PlatformUtils.isWeb) {
      tableAsset = appService.appSettings.tableAsset;
      if (gameState.getBoardAttributes(context).isOrientationHorizontal) {
        tableAsset = appService.appSettings.tableAsset;
      } else {
        tableAsset = "assets/images/table/new_vertical.png";
      }
    } else {
      tableAsset = 'assets/images/table/redtable.png';
    }
    return Container(
      key: gameState.gameUIState.tableKey,
      width: tableWidth,
      child: Consumer<RedrawBoardSectionState>(
        builder: (_, __, ___) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          // child: Image.memory(
          //   gameState.assets.getBoard(),
          //   key: UniqueKey(),
          //   fit: BoxFit.fill,
          // ),
          child: Image.asset(
            tableAsset,
            key: UniqueKey(),
          ),
        ),
      ),
    );
  }
}
