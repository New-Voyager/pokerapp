import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:provider/provider.dart';

class TableView extends StatelessWidget {
  final Size tableSize;

  TableView({
    @required this.tableSize,
  });

  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    return Container(
      height: tableSize.height,
      child: Consumer<RedrawBoardSectionState>(
        builder: (_, __, ___) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Image.memory(
            gameState.assets.getBoard(),
            key: UniqueKey(),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
