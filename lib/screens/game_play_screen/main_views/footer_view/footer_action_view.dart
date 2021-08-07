import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:provider/provider.dart';

const shrinkedBox = const SizedBox.shrink(
  key: ValueKey('none'),
);

class FooterActionView extends StatefulWidget {
  final GameContextObject gameContext;
  final Function isBetWidgetVisible;

  FooterActionView({
    this.gameContext,
    this.isBetWidgetVisible(bool _),
  });

  @override
  _FooterActionViewState createState() => _FooterActionViewState();
}

class _FooterActionViewState extends State<FooterActionView> {
  bool _showOptions = false;
  double betAmount;
  String selectedOptionText;
  bool bet = false;
  bool raise = false;

  void _betOrRaise(double val) {
    _showOptions = false;
    setState(() {});
    betAmount = val;
    if (bet) {
      log('bet');
      _bet();
    } else if (raise) {
      log('raise');
      _raise();
    }
  }

  Widget _buildRoundButton({
    String text = 'Button',
    Function onTap,
    bool isSelected = false,
    bool disable = false,
  }) {
    TextStyle btnTextStyle = AppStylesNew.clubItemInfoTextStyle.copyWith(
      fontSize: 10.5,
      color: isSelected ? Colors.white : null,
    );
    Color btnColor = AppColorsNew.newGreenButtonColor;
    if (disable) {
      btnColor = Colors.grey;
      btnTextStyle = AppStylesNew.disabledButtonTextStyle.copyWith(
        fontSize: 10.5,
      );
    }

    final button = AnimatedContainer(
      duration: AppConstants.fastAnimationDuration,
      curve: Curves.bounceInOut,
      height: 32.ph,
      width: 80.pw,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: isSelected ? AppColorsNew.newActiveBoxColor : Colors.transparent,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isSelected ? AppColorsNew.newActiveBoxColor : btnColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: btnTextStyle.copyWith(
                fontSize: 10.dp,
                color: isSelected
                    ? AppColorsNew.darkGreenShadeColor
                    : AppColorsNew.newGreenButtonColor),
          ),
        ),
      ),
    );

    if (disable) {
      return button;
    }

    return InkWell(
      onTap: onTap,
      child: button,
    );
  }

  /* This util function updates the UI and notifies
  * the provider that action has been taken
  * */
  void _actionTaken(BuildContext context) {
    assert(context != null);

    /* close the card overlay widget */
    widget.isBetWidgetVisible?.call(false);

    /* finally change the state to no more allow user to take action */
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.showAction(context, false);
  }

  /* this function actually makes the connection with the GameComService
  * and sends the message in the Player to Server channel */
  void _takeAction({
    BuildContext context,
    String action,
    int amount,
  }) =>
      HandActionProtoService.takeAction(
        context: context,
        action: action,
        amount: amount,
      );

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

    // bet twice
    // _actionTaken(context);
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

  Widget _buildActionWidgets(PlayerAction playerAction) {
    AvailableAction allin;
    playerAction.sort();
    for (final action in playerAction?.actions) {
      if (action.actionName == ALLIN) {
        allin = action;
        break;
      }
    }
    playerAction.actions.map((e) => log("player actionsL:  ${e.actionName} "));
    // final allin = playerAction?.actions
    //     ?.firstWhere((element) => element.actionName == ALLIN, orElse: null);
    var actionButtons = [];
    actionButtons = playerAction?.actions?.map<Widget>(
      (action) {
        switch (action.actionName) {
          case FOLD:
            return _buildRoundButton(
              text: action.actionName,
              onTap: () => _fold(
                action.actionValue,
                context: context,
              ),
            );
          case CHECK:
            return _buildRoundButton(
              text: action.actionName,
              onTap: () => _check(
                context: context,
              ),
            );

          /* on tapping on BET this button should highlight and show further options */
          case BET:
            bet = true;
            return _buildRoundButton(
              isSelected: _showOptions,
              text: action.actionName,
              onTap: () => setState(() {
                _showOptions = !_showOptions;
                widget.isBetWidgetVisible?.call(_showOptions);
              }),
            );
          case CALL:
            return _buildRoundButton(
              text: action.actionName + ' ' + action.actionValue.toString(),
              onTap: () => _call(
                playerAction.callAmount,
                context: context,
              ),
            );

          /* on tapping on RAISE this button should highlight and show further options */
          case RAISE:
            raise = true;
            return _buildRoundButton(
              isSelected: _showOptions,
              text: action.actionName,
              onTap: () => setState(() {
                _showOptions = !_showOptions;
                widget.isBetWidgetVisible?.call(_showOptions);
              }),
            );
        }

        return SizedBox.shrink();
      },
    )?.toList();

    if ((!bet) && (!raise) && (allin != null)) {
      actionButtons.add(_buildRoundButton(
        text: allin.actionName + ' ' + allin.actionValue.toString(),
        onTap: () => _allIn(
          amount: playerAction.allInAmount,
          context: context,
        ),
      ));
    }

    /*  if (actionButtons.length > 0 && actionButtons.length < 3 && allin != null) {
      actionButtons.add(_buildRoundButton(
        text: allin.actionName + '\n' + allin.actionValue.toString(),
        onTap: () => _allIn(
          amount: allin.actionValue,
          context: context,
        ),
      ));
    } */
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: actionButtons,
    );
  }

  Widget _buildBetWidget(PlayerAction playerAction, int remainingTime) {
    return AnimatedSwitcher(
      duration: AppConstants.fastestAnimationDuration,
      reverseDuration: AppConstants.fastestAnimationDuration,
      transitionBuilder: (child, animation) => ScaleTransition(
        alignment: Alignment.bottomCenter,
        scale: animation,
        child: child,
      ),
      child: playerAction?.options == null
          ? shrinkedBox
          : _showOptions
              ? BetWidget(
                  action: playerAction,
                  onSubmitCallBack: _betOrRaise,
                  remainingTime: remainingTime,
                )
              : shrinkedBox,
    );
  }

  @override
  Widget build(BuildContext context) {
    final boardAttributes = context.read<BoardAttributesObject>();

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Consumer<ActionState>(
        key: ValueKey('buildActionButtons'),
        builder: (_, actionState, __) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* bet widget */
            Expanded(
              child: Transform.scale(
                scale: boardAttributes.footerActionViewScale,
                child: _buildBetWidget(actionState.action, 30),
              ),
            ),

            /* bottom row */
            Transform.scale(
              scale: boardAttributes.footerActionViewScale,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.80),
                ),
                child: _buildActionWidgets(actionState.action),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
