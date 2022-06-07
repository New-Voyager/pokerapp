import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/utils/platform.dart';
import 'package:provider/provider.dart';

class BackgroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String backdropAsset;
    if (!PlatformUtils.isWeb) {
      backdropAsset = appService.appSettings.backdropAsset;
    } else {
      backdropAsset = 'assets/images/backgrounds/night-sky.png';
    }

    final gameState = GameState.getState(context);
    return Consumer<RedrawBackdropSectionState>(
      builder: (_, __, ___) {
        final boardAttributes = gameState.getBoardAttributes(context);
        final dimensions = boardAttributes.dimensions(context);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            width: dimensions.width,
            child: Transform.translate(
              offset: boardAttributes.backDropOffset,
              child: Image.asset(
                backdropAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
