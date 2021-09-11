import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
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
  bool betWidgetShown = false;

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
    AppTheme theme,
  }) {
    TextStyle btnTextStyle = AppDecorators.getHeadLine4Style(theme: theme)
        .copyWith(
            color: isSelected
                ? theme.primaryColorWithDark()
                : theme.supportingColor);
    Color btnColor = theme.primaryColor;
    if (disable) {
      btnColor = Colors.grey;
      btnTextStyle = AppDecorators.getSubtitle3Style(theme: theme);
    }

    final button = AnimatedContainer(
      duration: AppConstants.fastAnimationDuration,
      curve: Curves.bounceInOut,
      height: 32.ph,
      width: 80.pw,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: isSelected ? theme.accentColor : Colors.transparent,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: theme.accentColor,
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
                  ? theme.primaryColorWithDark()
                  : theme.supportingColor,
            ),
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
    gameState.showAction(false);
  }

  /* this function actually makes the connection with the GameComService
  * and sends the message in the Player to Server channel */
  void _takeAction({
    BuildContext context,
    String action,
    int amount,
  }) {
    final gameContextObj = context.read<GameContextObject>();
    final gameState = context.read<GameState>();

    HandActionProtoService.takeAction(
      gameContextObject: gameContextObj,
      gameState: gameState,
      action: action,
      amount: amount,
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

  Widget _buildActionWidgets(PlayerAction playerAction, AppTheme theme) {
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
    List<Widget> actionButtons = [];

    for (final action in playerAction?.actions) {
      Widget actionWidget = SizedBox();
      bool closeButton = false;
      switch (action.actionName) {
        case FOLD:
          actionWidget = _buildRoundButton(
            text: action.actionName,
            onTap: () => _fold(
              action.actionValue,
              context: context,
            ),
            theme: theme,
          );
          break;
        case CHECK:
          actionWidget = _buildRoundButton(
            text: action.actionName,
            onTap: () => _check(
              context: context,
            ),
            theme: theme,
          );
          break;

        /* on tapping on BET this button should highlight and show further options */
        case BET:
          bet = true;
          if (!betWidgetShown) {
            actionWidget = _buildRoundButton(
              isSelected: _showOptions,
              text: action.actionName,
              onTap: () => setState(() {
                _showOptions = !_showOptions;
                betWidgetShown = true;
                widget.isBetWidgetVisible?.call(_showOptions);
              }),
              theme: theme,
            );
          } else {
            closeButton = true;
            actionWidget = CloseCircleButton(
              theme: theme,
              onTap: (BuildContext context) {
                setState(() {
                  _showOptions = !_showOptions;
                  betWidgetShown = false;
                  widget.isBetWidgetVisible?.call(_showOptions);
                });
              },
            );
          }
          break;
        case CALL:
          actionWidget = _buildRoundButton(
            text: action.actionName + ' ' + action.actionValue.toString(),
            onTap: () => _call(
              playerAction.callAmount,
              context: context,
            ),
            theme: theme,
          );
          break;

        /* on tapping on RAISE this button should highlight and show further options */
        case RAISE:
          raise = true;
          actionWidget = _buildRoundButton(
            isSelected: _showOptions,
            text: action.actionName,
            onTap: () => setState(() {
              _showOptions = !_showOptions;
              widget.isBetWidgetVisible?.call(_showOptions);
            }),
            theme: theme,
          );
          break;
      }
      if (closeButton) {
        actionButtons.add(SizedBox(width: 10.pw));
      }
      actionButtons.add(actionWidget);
    }

    if ((!bet) && (!raise) && (allin != null)) {
      actionButtons.add(_buildRoundButton(
        text: allin.actionName + ' ' + allin.actionValue.toString(),
        onTap: () => _allIn(
          amount: playerAction.allInAmount,
          context: context,
        ),
        theme: theme,
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
    final theme = AppTheme.getTheme(context);

    return IntrinsicHeight(
      child: Container(
        color: theme.primaryColor.withOpacity(0.80),
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
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildActionWidgets(actionState.action, theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
