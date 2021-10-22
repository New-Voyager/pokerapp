import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/video_conf/player_tile.dart';
import 'package:pokerapp/services/ion/ion.dart';
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

  Widget _buildMyVideoFeedWidget(
      PlayerModel me, AppTheme theme, IonAudioConferenceService ion) {
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
        decoration: AppDecorators.tileDecoration(theme),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // rtc renderer
            ClipRRect(
              borderRadius: AppDecorators.tileDecoration(theme).borderRadius,
              child: SizedBox(
                width: meTileSize.width,
                height: meTileSize.height,
                child: RTCVideoView(
                  ion.me().renderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
            ),

            // player name
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: Text(
                  me.name,
                  style: AppStylesNew.labelTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayers(final GameContextObject gameContextObject) {
    final gameState = gameContextObject.gameState;

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
                ion: gameContextObject.ionAudioConferenceService,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size parentSize = MediaQuery.of(context).size;
    final AppTheme theme = context.read<AppTheme>();
    final GameContextObject gameContextObject =
        context.read<GameContextObject>();
    final GameState gameState = gameContextObject.gameState;
    final IonAudioConferenceService ion =
        gameContextObject.ionAudioConferenceService;

    return WillPopScope(
      onWillPop: () async {
        await ion.leave();
        return true;
      },
      child: Container(
        color: theme.primaryColor,
        height: parentSize.height / 2,
        width: parentSize.width,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _buildMyVideoFeedWidget(gameState.me, theme, ion),
            _buildPlayers(gameContextObject),
            _closeButton(context, theme),
          ],
        ),
      ),
    );
  }
}
