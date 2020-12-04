import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/auth_service.dart';
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

  /* This util function updates the UI and notifies
  * the provider that action has been taken
  * */
  void _actionTaken(BuildContext context) {
    assert(context != null);

    // put PlayerAction to null
    Provider.of<ValueNotifier<PlayerAction>>(
      context,
      listen: false,
    ).value = null;

    // change FooterStatus to NONE
    Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value = FooterStatus.None;
  }

  /* this function actually makes the connection with the GameComService
  * and sends the message in the Player to Server channel */
  void _takeAction({
    BuildContext context,
    String action,
    int amount,
  }) async {
    assert(context != null);
    assert(action != null);
    assert(amount != null);

    String playerID = await AuthService.getPlayerID();

    ActionInfo actionInfo = Provider.of<ValueNotifier<ActionInfo>>(
      context,
      listen: false,
    ).value;

    String message = """{
      "clubId": ${actionInfo.clubID},
      "gameId": "${actionInfo.gameID}",
      "playerId": "$playerID",
      "messageType": "PLAYER_ACTED",
      "playerActed": {
        "seatNo": ${actionInfo.seatNo},
        "action": "$action",
        "amount": $amount
      }
    }""";

    // todo: will this work?
    // delegate the request to the GameComService
    Provider.of<Function(String)>(
      context,
      listen: false,
    )(message);
  }

  /* These utility function actually takes actions */

  void _fold(
    int amount, {
    BuildContext context,
  }) {
    _takeAction(
      context: context,
      action: FOLD,
      amount: amount,
    );
    _actionTaken(context);
  }

  void _call(
    int amount, {
    BuildContext context,
  }) {
    _takeAction(
      context: context,
      action: CALL,
      amount: amount,
    );
    _actionTaken(context);
  }

  void _raise(
    int minAmount, {
    BuildContext context,
  }) {
    // todo: show a dialog to let user choose an amount
    int amount = minAmount;

    assert(amount >= minAmount);
    _takeAction(
      context: context,
      action: RAISE,
      amount: amount,
    );
    _actionTaken(context);
  }

  void _allIn({
    int amount,
    BuildContext context,
  }) {
    _takeAction(
      context: context,
      action: ALLIN,
      amount: amount,
    );
    _actionTaken(context);
  }

  Widget _buildActionButtons(BuildContext context) =>
      Consumer<ValueNotifier<PlayerAction>>(
        builder: (_, playerActionValueNotifier, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: playerActionValueNotifier.value.actions.map<Widget>(
            (playerAction) {
              switch (playerAction.actionName) {
                case FOLD:
                  return _buildRoundButton(
                    text: playerAction.actionName,
                    onTap: () => _fold(
                      playerAction.actionValue,
                      context: context,
                    ),
                  );
                case CALL:
                  return _buildRoundButton(
                    text: playerAction.actionName +
                        '\n' +
                        playerAction.actionValue.toString(),
                    onTap: () => _call(
                      playerAction.actionValue,
                      context: context,
                    ),
                  );
                case RAISE:
                  return _buildRoundButton(
                    text: playerAction.actionName +
                        '\n' +
                        'MIN: ' +
                        playerAction.minActionValue.toString(),
                    onTap: () => _raise(
                      playerAction.minActionValue,
                      context: context,
                    ),
                  );
                case ALLIN:
                  return _buildRoundButton(
                    text: playerAction.actionName +
                        '\n' +
                        playerAction.actionValue.toString(),
                    onTap: () => _allIn(
                      amount: playerAction.actionValue,
                      context: context,
                    ),
                  );
              }

              return _buildRoundButton();
            },
          ).toList(),
        ),
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
//
//    Function ss;
//
//    Timer timer = Timer.periodic(
//      const Duration(seconds: 1),
//      (_) {
//        _timeLeft--;
////        ss(() {});
//      },
//    );

    return Container(
      child: Center(
        child: StatefulBuilder(
          builder: (BuildContext context, setState) {
//            ss = setState;

//            if (_timeLeft <= 0) timer.cancel();

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
    FooterStatus footerStatus, {
    BuildContext context,
  }) {
    switch (footerStatus) {
      case FooterStatus.Action:
        return _buildActionButtons(context);
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
            context: context,
          ),
        ),
      );
}
