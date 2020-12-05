import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/chip_amount_pop_up.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/services/game_play/footer_services.dart';
import 'package:pokerapp/widgets/round_button.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FooterView extends StatelessWidget {
  Widget _buildRoundButton({
    String text = 'Button',
    Function onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: 70.0,
          width: 70.0,
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
                fontSize: 11.0,
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

  void _check({
    BuildContext context,
  }) {
    _takeAction(
      context: context,
      action: CHECK,
      amount: null,
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

  void _bet({
    BuildContext context,
  }) async {
    // show a dialog to let user choose an amount
    int amount = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      child: ChipAmountPopUp(
        titleText: 'BET',
      ),
    );

    if (amount == null) return;

    _takeAction(
      context: context,
      action: BET,
      amount: amount,
    );
    _actionTaken(context);
  }

  void _raise(
    int minAmount, {
    BuildContext context,
  }) async {
    //  show a dialog to let user choose an amount
    int amount = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      child: ChipAmountPopUp(
        titleText: 'RAISE',
      ),
    );

    if (amount == null) return;

    if (amount < minAmount) return;

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
                case CHECK:
                  return _buildRoundButton(
                    text: playerAction.actionName,
                    onTap: () => _check(
                      context: context,
                    ),
                  );
                case BET:
                  return _buildRoundButton(
                    text: playerAction.actionName,
                    onTap: () => _bet(
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

              return SizedBox.shrink();
            },
          ).toList(),
        ),
      );

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
        return _buildActionButtons(context);
      case FooterStatus.Prompt:
        return _buildBuyInPromptButton(context);
      case FooterStatus.None:
        return null;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) => Consumer<ValueNotifier<FooterStatus>>(
        builder: (_, footerStatusValueNotifier, __) => Container(
          height: 150,
          child: _build(
            footerStatusValueNotifier.value,
            context: context,
          ),
        ),
      );
}
