import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/screens/layouts/utils/responsive_layout_builder.dart';

class TableImageView extends StatelessWidget {
  const TableImageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameState gameState;
    return Center(
      child: Container(
        key: gameState.gameUIState.tableKey,
        child: ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox.shrink(),
          medium: (_, child) => SizedBox(
            width: AppConstants.mediumTableWidth,
            child: child,
          ),
          large: (_, child) => SizedBox(
            width: AppConstants.largeTableWidth,
            child: child,
          ),
          child: (_) => Image.asset(
            AppAssetsNew.defaultTablePath,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
