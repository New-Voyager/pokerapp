import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat_change_model.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/game_chat/chat.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/game_options/game_option_bottom_sheet.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_action_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/footer_result_view.dart';
import 'package:pokerapp/services/game_play/footer_services.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FooterView extends StatelessWidget {
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
      case FooterStatus.Result:
        return Consumer<FooterResult>(
          key: ValueKey('buildFooterResult'),
          builder: (_, FooterResult footerResult, __) => FooterResultView(
            footerResult: footerResult,
          ),
        );
      case FooterStatus.None:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<HeaderObject>(
                builder: (_, HeaderObject obj, __) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => ChangeNotifierProvider.value(
                            value: obj,
                            child: GameOptionsBottomSheet(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cardBackgroundColor),
                        child: Icon(
                          Icons.more_horiz,
                          color: AppColors.appAccentColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    /*  final vn = Provider.of<ValueNotifier<SeatChangeModel>>(
                      context,
                      listen: false,
                    );

                    vn.value = SeatChangeModel(
                      oldSeatNo: 2,
                      newSeatNo: 6,
                      stack: 100,
                    );

                    await Future.delayed(AppConstants.animationDuration);

                    vn.value = null;*/

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GameChat()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardBackgroundColor),
                    child: Icon(
                      Icons.chat_bubble,
                      color: AppColors.appAccentColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) => Consumer<ValueNotifier<FooterStatus>>(
        builder: (_, footerStatusValueNotifier, __) => Container(
          height: 190,
          child: AnimatedSwitcher(
            switchInCurve: Curves.bounceInOut,
            switchOutCurve: Curves.bounceInOut,
            duration: AppConstants.fastAnimationDuration,
            reverseDuration: AppConstants.fastAnimationDuration,
            transitionBuilder: (widget, animation) => ScaleTransition(
              scale: animation,
              child: widget,
            ),
            child: _build(
              footerStatusValueNotifier.value,
              context: context,
            ),
          ),
        ),
      );
}
