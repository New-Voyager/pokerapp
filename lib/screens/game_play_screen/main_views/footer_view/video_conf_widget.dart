import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

class VideoConfWidget extends StatelessWidget {
  Widget _buildPlayerTile({
    PlayerModel p,
    AppTheme theme,
    int totalPlayers,
  }) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: AppDecorators.tileDecoration(theme),
      child: Text(p.name),
    );
  }

  Widget _closeButton(BuildContext context, AppTheme theme) {
    return Positioned(
      top: -10,
      right: 20,
      child: Container(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.accentColor,
            ),
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.close,
              size: 20,
              color: theme.primaryColorWithDark(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size parentSize = MediaQuery.of(context).size;
    final AppTheme theme = context.read<AppTheme>();
    final GameState gameState = context.read<GameState>();
    List<PlayerModel> players = gameState.playersInGame;

    return Container(
      color: theme.primaryColor,
      height: parentSize.height / 2,
      width: parentSize.width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Wrap(
            children: players
                .map<Widget>((p) => _buildPlayerTile(
                      totalPlayers: players.length,
                      theme: theme,
                      p: p,
                    ))
                .toList(),
          ),
          _closeButton(context, theme),
        ],
      ),
    );
  }
}
