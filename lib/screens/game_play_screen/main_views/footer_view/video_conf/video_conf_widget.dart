import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/video_conf/player_tile.dart';
import 'package:provider/provider.dart';

class VideoConfWidget extends StatelessWidget {
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

  Widget _buildMyVideoFeedWidget(PlayerModel me, AppTheme theme) {
    // if i am not in the game, return an empty widget
    if (me == null) return const SizedBox.shrink();

    // otherwise, build my video feed widget
    final Size meTileSize = Size(90, 80);
    return Positioned(
      top: -meTileSize.height / 2,
      left: 20,
      child: Container(
        height: meTileSize.height,
        width: meTileSize.width,
        padding: EdgeInsets.all(5.0),
        decoration: AppDecorators.tileDecoration(theme),
        alignment: Alignment.bottomCenter,
        child: Text(
          me.name,
          style: AppStylesNew.labelTextStyle,
        ),
      ),
    );
  }

  Widget _buildPlayers(final GameState gameState) {
    if (gameState.playersInGame.isEmpty) return Text('No one is around');

    final List<PlayerModel> playersExceptMe =
        gameState.playersInGame.where((p) => p.isMe == false).toList();

    if (playersExceptMe.isEmpty) return Text('No one is around');

    return Wrap(
      alignment: WrapAlignment.center,
      verticalDirection: VerticalDirection.up,
      spacing: 10.0,
      runSpacing: 10.0,
      children: playersExceptMe
          .map<Widget>((p) => PlayerTile(
                player: p,
                totalPlayers: playersExceptMe.length,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size parentSize = MediaQuery.of(context).size;
    final AppTheme theme = context.read<AppTheme>();
    final GameState gameState = context.read<GameState>();

    return Container(
      color: theme.primaryColor,
      height: parentSize.height / 2,
      width: parentSize.width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          _buildMyVideoFeedWidget(gameState.me, theme),
          _buildPlayers(gameState),
          _closeButton(context, theme),
        ],
      ),
    );
  }
}
