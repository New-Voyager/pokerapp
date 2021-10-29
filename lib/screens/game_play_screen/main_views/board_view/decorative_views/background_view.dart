import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:provider/provider.dart';

class BackgroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    return Consumer<RedrawBackdropSectionState>(
      builder: (_, __, ___) => Image.memory(
        gameState.assets.getBackDrop(),
        fit: BoxFit.contain,
      ),
    );
  }
}
