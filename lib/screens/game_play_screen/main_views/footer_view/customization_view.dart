import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/game_circle_button.dart';

class HoleCardCustomizationView extends StatefulWidget {
  HoleCardCustomizationView();

  @override
  _HoleCardCustomizationViewState createState() =>
      _HoleCardCustomizationViewState();
}

class _HoleCardCustomizationViewState extends State<HoleCardCustomizationView> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    final gameState = GameState.getState(context);
    List<Widget> children = [];
    if (gameState.customizationMode && gameState.showCustomizationEditFooter) {
      children.add(GameCircleButton(
        onClickHandler: () async {
          await Navigator.of(context).pushNamed(Routes.select_cards);
          await gameState.assets.initialize();
          final redrawBottom = gameState.getRedrawFooterSectionState(context);
          redrawBottom.notify();
        },
        child: Icon(Icons.edit, size: 24, color: theme.primaryColorWithDark()),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }
}
