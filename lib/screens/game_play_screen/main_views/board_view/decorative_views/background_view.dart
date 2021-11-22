import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:provider/provider.dart';

class BackgroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    return Consumer<RedrawBackdropSectionState>(builder: (_, __, ___) {
      final boardAttributes = gameState.getBoardAttributes(context);
      final dimensions = boardAttributes.dimensions(context);
      return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
            Transform.translate(
                    offset: boardAttributes.backDropOffset,
                    child:
      Container(
        width: dimensions.width,
        height: dimensions.height,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.fill,
            image: MemoryImage(
              gameState.assets.getBackDrop(),))
        ),
      )));
      return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:  Image.memory(
              gameState.assets.getBackDrop(),
              key: UniqueKey(),
              fit: BoxFit.fill,
            ),
          );
    });
  }
}
