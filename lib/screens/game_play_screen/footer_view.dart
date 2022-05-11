import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/player_info.dart';
import 'package:provider/provider.dart';

import 'main_views/footer_view/footer_view.dart';

class FooterViewWidget extends StatelessWidget {
  final String gameCode;
  final GameContextObject gameContextObject;
  final PlayerInfo currentPlayer;
  final GameInfoModel gameInfo;
  final Function(BuildContext) toggleChatVisibility;
  final Function() onStartGame;

  FooterViewWidget(
      {this.gameCode,
      this.gameContextObject,
      this.currentPlayer,
      this.gameInfo,
      this.toggleChatVisibility,
      this.onStartGame});

  @override
  Widget build(BuildContext context) {
    final boa = context.read<BoardAttributesObject>();
    double footerHeight =
        MediaQuery.of(context).size.height * boa.footerViewScale / 2;
    footerHeight += boa.bottomHeightAdjust;
    log('RedrawFooter: FooterViewWidget build');

    return IntrinsicHeight(
      child: Container(
        height: footerHeight,
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
              this.toggleChatVisibility?.call(context);
            },
            clubCode: gameInfo.clubCode,
            onStartGame: onStartGame),
      ),
    );
  }
}
