import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/player_info.dart';

import 'main_views/footer_view/footer_view.dart';

class FooterViewWidget extends StatelessWidget {
  final String gameCode;
  final GameContextObject gameContextObject;
  final PlayerInfo currentPlayer;
  final GameInfoModel gameInfo;
  final Function(BuildContext) toggleChatVisibility;
  FooterViewWidget({
    this.gameCode,
    this.gameContextObject,
    this.currentPlayer,
    this.gameInfo,
    this.toggleChatVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        key: UniqueKey(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bottom_pattern.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: FooterView(
          gameContext: gameContextObject,
          gameCode: gameCode,
          playerUuid: currentPlayer.uuid,
          chatVisibilityChange: () {
            this.toggleChatVisibility(context);
          },
          clubCode: gameInfo.clubCode,
        ),
      ),
    );
  }
}
