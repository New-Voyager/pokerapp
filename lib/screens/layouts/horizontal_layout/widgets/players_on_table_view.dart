import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';


class PlayersOnTableView extends StatelessWidget {
  final Size tableSize;

  const PlayersOnTableView({
    Key key,
    this.tableSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameState gameState;// = GameStateX.getGameState(context);

    return SizedBox.fromSize(
      key: gameState.gameUIState.playerOnTableKey,
      size: tableSize,
      child: ValueListenableBuilder(
        valueListenable: gameState.gameUIState.playerOnTablePositionVn,
        builder: (_, Offset size, __) {
          if (size == null) return const SizedBox.shrink();

          return SizedBox();
        },
      ),
    );
  }
}
