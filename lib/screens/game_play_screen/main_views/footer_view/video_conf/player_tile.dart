import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/models/video_req_state.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/services/ion/ion.dart';
import 'package:pokerapp/widgets/button_widget.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatelessWidget {
  final PlayerModel player;
  final int totalPlayers;
  final IonAudioConferenceService ion;

  PlayerTile({
    @required this.player,
    @required this.totalPlayers,
    @required this.ion,
  });

  Widget _buildVideoControlButtons() {
    if (player.offersVideo == false) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Container(),
      ),
    );
  }

  void _sendVideoRequest() {
    ion.chatService.requestVideo(ion.me().playerId, player.playerId);
  }

  Widget _buildReqVideoButton() {
    if (player.offersVideo) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topCenter,
      child: IntrinsicHeight(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ButtonWidget(
            text: 'Request Video',
            onTap: _sendVideoRequest,
          ),
        ),
      ),
    );
  }

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
        return Size(parentSize.width * 0.28, parentSize.width * 0.28);
    }
  }

  @override
  Widget build(BuildContext context) {
    // doing this will cause a UI rebuild whenever VideoReqState changeNotifier is called
    Provider.of<VideoReqState>(context);

    final theme = context.read<AppTheme>();
    final size = _getPlayerTileSize(totalPlayers, context);

    final renderer = ion.getVideoRenderer(player.playerId);

    // Player Tile are of three types
    // 1. video on - shows buttons to turn off video, mute / unmute
    // 2. video off - shows button to req video

    return Container(
      height: size.height,
      width: size.width,
      decoration: AppDecorators.tileDecoration(theme),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // rtc renderer
          player.offersVideo
              ? ClipRRect(
                  borderRadius:
                      AppDecorators.tileDecoration(theme).borderRadius,
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: RTCVideoView(
                      renderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                )
              : const SizedBox.shrink(),

          // player name
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Text(
                player.name,
                style: AppStylesNew.labelTextStyle,
              ),
            ),
          ),

          // request video button
          _buildReqVideoButton(),

          // video call during buttons - mute/unmute, video enable/disable
          _buildVideoControlButtons(),
        ],
      ),
    );
  }
}
