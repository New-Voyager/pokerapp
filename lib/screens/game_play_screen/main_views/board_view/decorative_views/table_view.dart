import 'package:flutter/material.dart';
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

    return Container(
      key: gameState.tableKey,
      // height is used as per the aspect ratio
      width: tableWidth,
      // color is used while debugging
      color: Colors.amber,
      child: Consumer<RedrawBoardSectionState>(
        builder: (_, __, ___) => AnimatedSwitcher(
          duration: animationDuration,
          child: Image.asset(
            "assets/images/table/redtable.png",
            key: UniqueKey(),
          ),
        ),
      ),
    );
  }
}
