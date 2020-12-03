import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/game_play/footer_services.dart';
import 'package:pokerapp/widgets/round_button.dart';
import 'package:provider/provider.dart';

class FooterView extends StatelessWidget {
  Widget _buildRoundButton({
    String text = 'Button',
    Function onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: 80.0,
          width: 80.0,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff319ffe),
              width: 2.0,
            ),
          ),
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: AppStyles.clubItemInfoTextStyle.copyWith(
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      );

  void _fold() {}

  void _call100() {}

  void _raise() {}

  Widget _buildActionButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRoundButton(
            text: 'Fold',
            onTap: _fold,
          ),
          _buildRoundButton(
            text: 'call 100',
            onTap: _call100,
          ),
          _buildRoundButton(
            text: 'raise',
            onTap: _raise,
          ),
        ],
      );

  Widget _buildTimer({int time = 10}) => Transform.translate(
        offset: const Offset(0, -15.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xff474747),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff14e81b),
              width: 1.0,
            ),
          ),
          child: Text(
            time.toString(),
            style: AppStyles.itemInfoTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );

  // todo: a better way to dispose off the timer?
  // todo: a better way to implement this functionality?
  Widget _buildBuyInPromptButton() {
    int _timeLeft = AppConstants.buyInTimeOutSeconds;

    Function ss;

    Timer timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _timeLeft--;
        ss(() {});
      },
    );

    return Container(
      child: Center(
        child: StatefulBuilder(
          builder: (BuildContext context, setState) {
            ss = setState;

            if (_timeLeft <= 0) timer.cancel();

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundRaisedButton(
                  color: AppColors.appAccentColor,
                  buttonText: 'Buy Chips',
                  onButtonTap: _timeLeft <= 0
                      ? null
                      : () => FooterServices.promptBuyIn(
                            context: context,
                          ),
                ),
                _buildTimer(
                  time: _timeLeft,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _build(
    FooterStatus footerStatus,
  ) {
    switch (footerStatus) {
      case FooterStatus.Action:
        return _buildActionButtons();
      case FooterStatus.Prompt:
        return _buildBuyInPromptButton();
      case FooterStatus.None:
        return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) => Consumer<ValueNotifier<FooterStatus>>(
        builder: (_, footerStatusValueNotifier, __) => Container(
          height: 200,
          child: _build(
            footerStatusValueNotifier.value,
          ),
        ),
      );
}
