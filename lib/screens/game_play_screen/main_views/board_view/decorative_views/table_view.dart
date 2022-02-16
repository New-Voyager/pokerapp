import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:provider/provider.dart';

class TableView extends StatelessWidget {
  final double tableWidthFactor;

  TableView({
    this.tableWidthFactor = 1.0,
  });

  Widget build(BuildContext context) {
    final tableWidth = MediaQuery.of(context).size.width * tableWidthFactor;
    final animationDuration = const Duration(milliseconds: 250);
    final gameState = GameState.getState(context);
    return Center(
      child: Container(
        width: tableWidth,
        height: tableWidth,
        clipBehavior: Clip.none,
        child: Consumer<RedrawBoardSectionState>(
          builder: (_, __, ___) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            // child: Image.memory(
            //   gameState.assets.getBoard(),
            //   key: UniqueKey(),
            //   fit: BoxFit.fill,
            // ),
            child: Image.asset(
              appService.appSettings.tableAsset,
              key: UniqueKey(),
            ),
          ),
        ),
      ),
    );
  }
}
