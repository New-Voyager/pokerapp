import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';

import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/game_play/footer_services.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'hole_cards_view.dart';

class GameAction extends StatelessWidget {
  final PlayerModel playerModel;
  final FooterStatus footerStatus;
  final bool showActionWidget;

  const GameAction({Key key, this.playerModel, this.footerStatus, this.showActionWidget})
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
      case FooterStatus.Prompt:
        return _buildBuyInPromptButton(context);
      default:
        return Container();
    }
  }

  Widget _buildBuyInPromptButton(BuildContext context) {
    int _endTime = Provider.of<ValueNotifier<GameInfoModel>>(
          context,
          listen: false,
        ).value.actionTime ??
        AppConstants.buyInTimeOutSeconds;

    return Center(
      key: ValueKey('buildBuyInPrompt'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimer(
            time: _endTime,
          ),
          RoundRaisedButton(
            color: AppColors.appAccentColor,
            buttonText: 'Buy Chips',
            onButtonTap: () => FooterServices.promptBuyIn(
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer({int time = 10}) => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xff474747),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xff14e81b),
            width: 1.0,
          ),
        ),
        child: Countdown(
          seconds: time,
          onFinished: () {
            // TODO: HANDLE TIME UP EVENT
          },
          build: (_, time) => Text(
            time.toStringAsFixed(0),
            style: AppStyles.itemInfoTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
}
