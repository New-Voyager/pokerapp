import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_context_screen/game_chat/chat.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_action_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/other_views/context_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view_util_widgets.dart';
import 'package:pokerapp/services/game_play/footer_services.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'communication_view.dart';
import 'hand_analyse_view.dart';

class FooterView extends StatelessWidget {
  final GameComService gameComService;
  final String gameCode;
  final String playerUuid;
  FooterView(this.gameComService, this.gameCode, this.playerUuid);

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

  @override
  Widget build(BuildContext context) =>
      Consumer2<ValueNotifier<FooterStatus>, Players>(
        builder: (_, footerStatusValueNotifier, players, __) {
          PlayerModel playerModel;

          try {
            playerModel = players.players.firstWhere(
              (p) => p.isMe,
              orElse: null,
            );
          } catch (_) {
            playerModel = null;
          }

          return Container(
            height: 300,
            color: Colors.amber,
            child: Stack(
              children: [
                playerModel == null
                    ? const SizedBox.shrink()
                    : Column(
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
                            footerStatusValueNotifier.value,
                            context: context,
                          ),
                          Expanded(child: GameChat(this.gameComService.chat))
                        ],
                      ),
                /*Container(
                      height: 190,
                      child: AnimatedSwitcher(
                        switchInCurve: Curves.bounceInOut,
                        switchOutCurve: Curves.bounceInOut,
                        duration: AppConstants.fastAnimationDuration,
                        reverseDuration: AppConstants.fastAnimationDuration,
                        transitionBuilder: (widget, animation) =>
                            ScaleTransition(
                          scale: animation,
                          child: widget,
                        ),
                        child: _build(
                          footerStatusValueNotifier.value,
                          context: context,
                        ),
                      ),
                    ),*/
                HandAnalyseView(),
                CommunicationView()
              ],
            ),
          );
        },
      );
}
