import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/services/test/test_service.dart';
import 'package:provider/provider.dart';

class BackgroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            height: dimensions.height,
            child: Transform.translate(
              offset: boardAttributes.backDropOffset,
              child: Image.asset(
                TestService.isTesting ? AppAssetsNew.defaultBackdropPath : appService.appSettings.backdropAsset,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }
}
