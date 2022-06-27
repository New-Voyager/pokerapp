import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';

class OvalTableView extends StatelessWidget {
  final double tableWidthFactor;
  final GameState gameState;

  OvalTableView({
    this.tableWidthFactor = 1.0,
    this.gameState,
  });

  Widget build(BuildContext context) {
    final tableWidth = MediaQuery.of(context).size.width * tableWidthFactor;
    final gameState = GameState.getState(context);

    return Container(
      key: gameState.gameUIState.tableKey,
      width: tableWidth,
      height: tableWidth * 0.6,
      child: Stack(
        children: [
          ClipOval(
            child: Container(color: Colors.grey.shade900),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 30.0, top: 10.0, left: 10.0, right: 10.0),
            child: ClipOval(
              child: Container(
                color: Colors.green.shade700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 50.0, top: 15.0, left: 30.0, right: 30.0),
            // child: Container(
            //   decoration: BoxDecoration(
            //     border:
            //         Border.all(color: Colors.green.withAlpha(100), width: 8.0),
            //     borderRadius: BorderRadius.all(
            //       Radius.elliptical(tableWidth / 2, tableWidth * 0.6 / 2 - 16),
            //     ),
            //   ),
            // ),
            child: ClipOval(
              child: Container(
                color: Colors.green.shade400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 60.0, top: 20.0, left: 40.0, right: 40.0),
            // child: Container(
            //   decoration: BoxDecoration(
            //     border:
            //         Border.all(color: Colors.green.withAlpha(100), width: 8.0),
            //     borderRadius: BorderRadius.all(
            //       Radius.elliptical(tableWidth / 2, tableWidth * 0.6 / 2 - 16),
            //     ),
            //   ),
            // ),
            child: ClipOval(
              child: Container(
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
