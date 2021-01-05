import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/provider_models/action_info.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action/option.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action/player_action.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/ui/header_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';

const shrinkedBox = const SizedBox.shrink(
  key: ValueKey('none'),
);

class FooterActionView extends StatefulWidget {
  @override
  _FooterActionViewState createState() => _FooterActionViewState();
}

class _FooterActionViewState extends State<FooterActionView> {
  bool _showOptions = false;
  double betAmount;

  String selectedOptionText;

  final TextEditingController _controller = TextEditingController();

  /* this function decides, whom to call - bet or raise? */
  void _submit(PlayerAction playerAction) {
    int idx = playerAction.actions.indexWhere((pa) => pa.actionName == BET);
    if (idx == -1) return _raise();
    _bet();
  }

  Widget _buildRoundButton({
    String text = 'Button',
    Function onTap,
    bool isSelected = false,
  }) =>
      InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.fastAnimationDuration,
          curve: Curves.bounceInOut,
          height: 60.0,
          width: 60.0,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff319ffe) : Colors.transparent,
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
                fontSize: 10.5,
                color: isSelected ? Colors.white : null,
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
    // get current hand number
    int handNum = Provider.of<HeaderObject>(
      context,
      listen: false,
    ).currentHandNum;

    String message = """{
      "clubId": ${actionInfo.clubID},
      "gameId": "${actionInfo.gameID}",
      "playerId": "$playerID",
      "handNum": $handNum,
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

  void _bet() async {
    if (betAmount == null) return;

    _takeAction(
      context: context,
      action: BET,
      amount: betAmount.toInt(),
    );

    _actionTaken(context);
  }

  void _raise() async {
    if (betAmount == null) return;

    _takeAction(
      context: context,
      action: RAISE,
      amount: betAmount.toInt(),
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

  Widget _buildTopActionRow(PlayerAction playerAction) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: playerAction?.actions?.map<Widget>(
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

                  /* on tapping on BET this button should highlight and show further options */
                  case BET:
                    return _buildRoundButton(
                      isSelected: _showOptions,
                      text: playerAction.actionName,
                      onTap: () => setState(() {
                        _showOptions = true;
                      }),
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

                  /* on tapping on RAISE this button should highlight and show further options */
                  case RAISE:
                    return _buildRoundButton(
                      isSelected: _showOptions,
                      text: playerAction.actionName +
                          '\n' +
                          'MIN: ' +
                          playerAction.minActionValue.toString(),
                      onTap: () => setState(() {
                        _showOptions = true;
                      }),
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
            )?.toList() ??
            [],
      );

  Widget _buildSmallerRoundButton(Option o) => InkWell(
        onTap: () {
          _controller.text = o.amount.toStringAsFixed(0);

          setState(() {
            // change the slider and controller value
            betAmount = o.amount.toDouble();
            selectedOptionText = o.text;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppConstants.fastAnimationDuration,
              curve: Curves.bounceInOut,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: selectedOptionText == o.text
                    ? AppColors.appAccentColor
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.appAccentColor,
                  width: 2.0,
                ),
              ),
              child: Text(
                o.text,
                textAlign: TextAlign.center,
                style: AppStyles.clubItemInfoTextStyle.copyWith(
                  fontSize: 11.0,
                  color: selectedOptionText == o.text ? Colors.white : null,
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              o.amount.toString(),
              textAlign: TextAlign.center,
              style: AppStyles.clubItemInfoTextStyle.copyWith(
                fontSize: 11.0,
              ),
            ),
          ],
        ),
      );

  Widget _buildOptionsAndTextField(
    List<Option> options, {
    @required int max,
    @required int min,
  }) =>
      Transform.translate(
        offset: const Offset(
          0.0,
          10.0,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              /* buttons */
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: options
                      .map<Widget>(
                        (o) => _buildSmallerRoundButton(o),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Transform.scale(
                  scale: 0.70,
                  child: CardFormTextField(
                    controller: _controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    elevation: 0.0,
                    hintText: 'Amount',
                    keyboardType: TextInputType.number,
                    onChanged: (String s) => setState(
                      () {
                        double newValue = double.parse(s);

                        if (newValue < min) newValue = min.toDouble();
                        if (newValue > max) newValue = max.toDouble();

                        return betAmount = newValue;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSliderAndSubmit(PlayerAction playerAction) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 8.0,
            activeTrackColor: AppColors.cardBackgroundColor,
            inactiveTrackColor: AppColors.cardBackgroundColor,
            thumbColor: AppColors.appAccentColor,
          ),
          child: Column(
            children: [
              /* min - max label */
              Transform.translate(
                offset: const Offset(0.0, 15.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        playerAction.minRaiseAmount.toString(),
                        style: AppStyles.clubItemInfoTextStyle.copyWith(
                          fontSize: 11.0,
                        ),
                      ),
                      Text(
                        playerAction.maxRaiseAmount.toString(),
                        style: AppStyles.clubItemInfoTextStyle.copyWith(
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /* slider */
              Slider(
                min: playerAction.minRaiseAmount.toDouble(),
                max: playerAction.maxRaiseAmount.toDouble(),
                value: betAmount ?? playerAction.minRaiseAmount.toDouble(),
                onChanged: (double newValue) {
                  _controller.text = newValue.toStringAsFixed(0);
                  setState(() => betAmount = newValue);
                },
              ),
            ],
          ),
        ),
      );

  Widget _buildOptionsRow(PlayerAction playerAction) => AnimatedSwitcher(
        duration: AppConstants.fastAnimationDuration,
        reverseDuration: AppConstants.fastAnimationDuration,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: playerAction?.options == null
            ? shrinkedBox
            : _showOptions
                ? Column(
                    key: ValueKey('options'),
                    children: [
                      /* options */
                      _buildOptionsAndTextField(
                        playerAction.options,
                        min: playerAction.minRaiseAmount,
                        max: playerAction.maxRaiseAmount,
                      ),

                      /* slider and submit button */
                      Row(
                        children: [
                          Expanded(
                            child: _buildSliderAndSubmit(playerAction),
                          ),
                          Transform.translate(
                            offset: const Offset(
                              -20.0,
                              0.0,
                            ),
                            child: RoundRaisedButton(
                              radius: 5.0,
                              fontSize: 11.0,
                              color: AppColors.appAccentColor,
                              onButtonTap: () => _submit(playerAction),
                              buttonText: 'SUBMIT',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : shrinkedBox,
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<ValueNotifier<PlayerAction>>(
      key: ValueKey('buildActionButtons'),
      builder: (_, playerActionValueNotifier, __) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTopActionRow(
            playerActionValueNotifier.value,
          ),
          _buildOptionsRow(playerActionValueNotifier.value),
        ],
      ),
    );
  }
}
