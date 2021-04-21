import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';

import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'hole_cards_view.dart';

class GameAction extends StatelessWidget {
  final PlayerModel playerModel;
  final FooterStatus footerStatus;
  final bool showActionWidget;

  const GameAction(
      {Key key, this.playerModel, this.footerStatus, this.showActionWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        playerModel != null
            ? HoleCardsView(
                playerModel: playerModel,
                showActionWidget: showActionWidget,
              )
            : Container(),
        _build(
          footerStatus,
          context: context,
        ),
      ],
    );
  }

  Widget _build(
    FooterStatus footerStatus, {
    BuildContext context,
  }) {
    switch (footerStatus) {
      // case FooterStatus.Prompt:
      //   return _buildBuyInPromptButton(context);
      default:
        return Container();
    }
  }
}
