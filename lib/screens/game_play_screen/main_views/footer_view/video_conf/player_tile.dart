import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatelessWidget {
  final PlayerModel player;
  final int totalPlayers;

  PlayerTile({
    @required this.player,
    @required this.totalPlayers,
  });

  Size _getPlayerTileSize(int n, BuildContext context) {
    final parentSize = MediaQuery.of(context).size;

    log('number of players: $n');

    switch (n + 1) {
      case 2:
        return Size(parentSize.width * 0.60, parentSize.width * 0.60);
      case 4:
        return Size(parentSize.width * 0.33, parentSize.width * 0.33);
      case 6:
        return Size(parentSize.width * 0.28, parentSize.width * 0.28);
      case 8:
        return Size(parentSize.width * 0.28, parentSize.width * 0.28);
      case 9:
        return Size(parentSize.width * 0.28, parentSize.width * 0.28);
      default:
        return Size(120, 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    final size = _getPlayerTileSize(totalPlayers, context);

    // Player Tile are of three types

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(10.0),
      decoration: AppDecorators.tileDecoration(theme),
      alignment: Alignment.bottomCenter,
      child: Text(player.name),
    );
  }
}
