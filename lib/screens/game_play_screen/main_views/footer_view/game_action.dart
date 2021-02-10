import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';

import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/user_view_util_widgets.dart';
import 'package:pokerapp/services/game_play/footer_services.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'footer_action_view.dart';

class GameAction extends StatelessWidget {
  final PlayerModel playerModel;
  final FooterStatus footerStatus;
  const GameAction({Key key, this.playerModel, this.footerStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserViewUtilWidgets.buildVisibleCard(
          playerFolded: playerModel?.playerFolded ?? false,
          cards: playerModel?.cards?.map(
                (int c) {
                  CardObject card = CardHelper.getCard(c);
                  card.smaller = true;
                  card.cardFace = CardFace.FRONT;

                  return card;
                },
              )?.toList() ??
              List<CardObject>(),
        ),
        _build(
          footerStatus,
          context: context,
        ),
        // Expanded(child: GameChat(this.gameComService.chat))
      ],
    );
  }

  Widget _build(
    FooterStatus footerStatus, {
    BuildContext context,
  }) {
    switch (footerStatus) {
      case FooterStatus.Action:
        return FooterActionView();
      case FooterStatus.Prompt:
        return _buildBuyInPromptButton(context);
      // case FooterStatus.Result:
      //   return Consumer<FooterResult>(
      //     key: ValueKey('buildFooterResult'),
      //     builder: (_, FooterResult footerResult, __) => FooterResultView(
      //       footerResult: footerResult,
      //     ),
      //   );
      case FooterStatus.Result:
        return Container();
      case FooterStatus.None:
        return Container();
      /*return GameContextView(
            this.gameCode, this.playerUuid, this.gameComService.chat);*/
    }

    return null;
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
