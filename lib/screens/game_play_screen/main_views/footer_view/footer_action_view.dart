import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
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
    TextStyle btnTextStyle = AppStyles.clubItemInfoTextStyle.copyWith(
      fontSize: 10.5,
      color: isSelected ? Colors.white : null,
    );
    Color btnColor = AppColors.buttonBorderColor;
    if (disable) {
      btnColor = Colors.grey;
      btnTextStyle = AppStyles.disabledButtonTextStyle.copyWith(
        fontSize: 10.5,
      );
    }

    final button = AnimatedContainer(
      duration: AppConstants.fastAnimationDuration,
      curve: Curves.bounceInOut,
      height: 32.0,
      width: 80.0,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.appAccentColor : Colors.transparent,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isSelected ? AppColors.appAccentColor : btnColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: btnTextStyle.copyWith(
              color: isSelected ? Colors.white : AppColors.appAccentColor),
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
  }) async {
    assert(context != null);
    assert(action != null);

    final gameState = Provider.of<GameState>(context, listen: false);
    final actionState = gameState.getActionState(context);
    final handInfo = gameState.getHandInfo(context);
    final gameContextObject = Provider.of<GameContextObject>(
      context,
      listen: false,
    );

    // get current hand number
    int handNum = handInfo.handNum;
    widget.gameContext.handActionService.playerActed(
      gameContextObject.playerId,
      handNum,
      actionState.action.seatNo,
      action,
      amount,
    );
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
    final allin = playerAction?.actions
        ?.firstWhere((element) => element.actionName == ALLIN);
    var actionButtons = [];
    actionButtons = playerAction?.actions?.map<Widget>(
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
            bet = true;
            return _buildRoundButton(
              isSelected: _showOptions,
              text: playerAction.actionName,
              onTap: () => setState(() {
                _showOptions = !_showOptions;
                widget.isBetWidgetVisible?.call(_showOptions);
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
            raise = true;
            return _buildRoundButton(
              isSelected: _showOptions,
              text: playerAction.actionName,
              onTap: () => setState(() {
                _showOptions = !_showOptions;
                widget.isBetWidgetVisible?.call(_showOptions);
              }),
            );
        }

        return SizedBox.shrink();
      },
    )?.toList();

    if (actionButtons.length > 0 && actionButtons.length < 3 && allin != null) {
      actionButtons.add(_buildRoundButton(
        text: allin.actionName + '\n' + allin.actionValue.toString(),
        onTap: () => _allIn(
          amount: allin.actionValue,
          context: context,
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: actionButtons,
    );
  }

  Widget _buildBetWidget(PlayerAction playerAction) => AnimatedSwitcher(
        duration: AppConstants.fastAnimationDuration,
        reverseDuration: AppConstants.fastAnimationDuration,
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
                  )
                : shrinkedBox,
      );

  @override
  Widget build(BuildContext context) {
    final boardAttributes = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    );

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
                child: _buildBetWidget(actionState.action),
              ),
            ),

            /* bottom row */
            Transform.scale(
              scale: boardAttributes.footerActionViewScale,
              alignment: Alignment.bottomCenter,
              child: _buildActionWidgets(actionState.action),
            ),
          ],
        ),
      ),
    );
  }
}
