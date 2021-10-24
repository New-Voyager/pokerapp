import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:provider/provider.dart';

const shrinkedBox = const SizedBox.shrink(
  key: ValueKey('none'),
);

class FooterActionView extends StatefulWidget {
  final GameContextObject gameContext;
  final Function isBetWidgetVisible;
  final ActionState actionState;
  FooterActionView({
    this.gameContext,
    this.isBetWidgetVisible(bool _),
    this.actionState,
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
    Color btnColor = theme.accentColor;
    if (text.toLowerCase().contains("fold")) {
      btnColor = Colors.blueGrey.shade600;
    } else if (text.toLowerCase().contains("call")) {
      btnColor = Colors.green.shade600;
    } else if (text.toLowerCase().contains("bet")) {
      btnColor = Colors.redAccent.shade700;
    } else if (text.toLowerCase().contains("check")) {
      btnColor = Colors.green.shade700;
    }
    if (disable) {
      btnColor = Colors.grey;
      btnTextStyle = AppDecorators.getSubtitle3Style(theme: theme);
    }

    final button = Container(
      // duration: AppConstants.fastAnimationDuration,
      // curve: Curves.bounceInOut,
      height: 32.ph,
      width: 80.pw,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          color: btnColor,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: btnColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.1,
              blurRadius: 5,
            ),
          ]),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: btnTextStyle.copyWith(
              fontSize: 10.dp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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

  Widget _buildCheckFoldButton({
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
    Color btnColor = theme.accentColor;
    btnColor = isSelected ? Colors.blueGrey : Colors.black;
    Color borderColor = Colors.white;

    final button = Container(
      // duration: AppConstants.fastAnimationDuration,
      // curve: Curves.bounceInOut,
      height: 34.ph,
      width: 150.pw,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.all(5.ph),
      decoration: BoxDecoration(
          color: btnColor,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: borderColor,
            width: 1.ph,
          ),
          borderRadius: BorderRadius.circular(10.pw),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.1,
              blurRadius: 5,
            ),
          ]),
      child: Row(
        children: [
          // seperator
          const SizedBox(width: 5.0),

          // selection button indicator
          isSelected
              ? Icon(Icons.check_circle_outline_rounded, size: 20.0)
              : Icon(Icons.circle_outlined, size: 20.0),

          // spacer
          Spacer(),

          // text
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: btnTextStyle.copyWith(
                fontSize: 10.dp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          // spacer
          Spacer(),
        ],
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
              onTap: () {
                setState(() {
                  _showOptions = !_showOptions;
                  betWidgetShown = true;
                  widget.isBetWidgetVisible?.call(_showOptions);
                });
              },
              theme: theme,
            );
          } else {
            closeButton = true;
            actionWidget = CircleImageButton(
              theme: theme,
              icon: Icons.close,
              onTap: () {
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
          if (playerAction.callAmount > 0) {
            actionWidget = _buildRoundButton(
              text: action.actionName + ' ' + action.actionValue.toString(),
              onTap: () => _call(
                playerAction.callAmount,
                context: context,
              ),
              theme: theme,
            );
          }
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

    log('BetAction: actionButtons.length ${actionButtons.length}');

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

  Widget _buildCheckFoldWidget(ActionState actionState, AppTheme theme) {
    List<Widget> actionButtons = [];
    Widget actionWidget = _buildCheckFoldButton(
        isSelected: actionState.checkFoldSelected,
        theme: theme,
        text: 'Check/Fold',
        onTap: () {
          actionState.checkFoldSelected = !actionState.checkFoldSelected;
          actionState.notify();
        });
    actionButtons.add(actionWidget);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: actionButtons,
    );
  }

  Widget _buildBetWidget(
      List<int> playerCards, PlayerAction playerAction, int remainingTime) {
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
                  playerCards: playerCards,
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
    final gameState = GameState.getState(context);
    final me = gameState.me;
    return IntrinsicHeight(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Consumer<ActionState>(
            key: ValueKey('buildActionButtons'),
            builder: (_, actionState, __) {
              log('BetAction: build actionState.show ${actionState.show} handState: ${gameState.handState.toString()}');
              if (gameState.handState == HandState.RESULT ||
                  gameState.handState == HandState.SHOWDOWN ||
                  gameState.handState == HandState.ENDED ||
                  gameState.me == null ||
                  !gameState.me.inhand) {
                return Container();
              }

              List<Widget> children = [];
              if (actionState.show) {
                children.addAll([
                  /* bet widget */
                  Transform.scale(
                    scale: boardAttributes.footerActionViewScale,
                    child: _buildBetWidget(me.cards, actionState.action, 30),
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
                ]);
              } else if (actionState.showCheckFold) {
                final mySeat = gameState.mySeat;
                if (mySeat.player != null &&
                    mySeat.player.isActive &&
                    mySeat.player.inhand &&
                    gameState.playerLocalConfig.showCheckFold) {
                  children.add(
                    /* bottom row */
                    Transform.scale(
                      scale: boardAttributes.footerActionViewScale,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: _buildCheckFoldWidget(actionState, theme),
                      ),
                    ),
                  );
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              );
            }),
      ),
    );
  }
}
