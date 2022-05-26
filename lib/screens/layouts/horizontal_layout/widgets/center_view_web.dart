import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';

class WebCenterView extends StatelessWidget {
  // final String gameCode;
  // final bool isHorizontal;
  // final bool isHost;
  // final onStartGame;
  // final TableState tableState;
  final GameState gameState;
  const WebCenterView({Key key, this.gameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenterView(
      gameCode: gameState.gameCode,
      isBoardHorizontal: true,
      isHost: gameState.currentPlayer.isHost(),
      onStartGame: () {},
      tableState: gameState.tableState,
    );
  }
}
