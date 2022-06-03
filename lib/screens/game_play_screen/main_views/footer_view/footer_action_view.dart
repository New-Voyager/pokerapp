import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/footer_view/time_bank.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget_new.dart';
import 'package:pokerapp/services/game_play/action_services/hand_action_proto_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/color_generator.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/utils.dart';
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

  Widget _buildGradientBorderContainer(
    Widget child,
    AppTheme theme,
  ) {
    final kInnerDecoration = BoxDecoration(
      color: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(32),
    );

    final kGradientBoxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [theme.accentColor, theme.accentColor.withAlpha(100)],
        begin: Alignment.centerLeft,
        stops: [0.1, 0.7],
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(32),
    );
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          child: child,
          decoration: kInnerDecoration,
        ),
      ),
      decoration: kGradientBoxDecoration,
    );
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
      btnColor = Colors.red.shade400;
    } else if (text.toLowerCase().contains("call")) {
      btnColor = Colors.green.shade600;
    } else if (text.toLowerCase().contains("bet")) {
      btnColor = Colors.yellow.shade700;
    } else if (text.toLowerCase().contains("check")) {
      btnColor = Colors.green.shade700;
    } else if (text.toLowerCase().contains("raise")) {
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
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: btnColor,
        shape: BoxShape.rectangle,
        // border: Border.all(
        //   color: Colors.white,
        //   width: 1.5,
        // ),
        borderRadius: BorderRadius.circular(4),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black,
        //     spreadRadius: 0.1,
        //     blurRadius: 5,
        //   ),
        // ],
        gradient: LinearGradient(
          colors: [
            btnColor,
            lighten(btnColor, 0.13),
            btnColor,
          ],
          begin: Alignment.centerLeft,
          stops: [0.0, 0.5, 1],
          end: Alignment.centerRight,
        ),
      ),
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
      height: 32.ph,
      width: 150.pw,
      // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.all(5.ph),
      // decoration: BoxDecoration(
      //     color: btnColor,
      //     shape: BoxShape.rectangle,
      //     border: Border.all(
      //       color: borderColor,
      //       width: 1.ph,
      //     ),
      //     borderRadius: BorderRadius.circular(17.pw),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black,
      //         spreadRadius: 0.1,
      //         blurRadius: 5,
      //       ),
      //     ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    final gameState = GameState.getState(context);
    gameState.showAction(false);
  }

  /* this function actually makes the connection with the GameComService
  * and sends the message in the Player to Server channel */
  void _takeAction({
    BuildContext context,
    String action,
    double amount,
  }) {
    final gameContextObj = context.read<GameContextObject>();
    final gameState = GameState.getState(context);

    HandActionProtoService.takeAction(
      gameContextObject: gameContextObj,
      gameState: gameState,
      action: action,
      amount: amount,
    );
  }

  /* These utility function actually takes actions */

  void _fold(
    double amount, {
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
    double amount, {
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
      amount: betAmount,
    );

    // bet twice
    _actionTaken(context);
  }

  void _raise() async {
    if (betAmount == null) return;

    _takeAction(
      context: context,
      action: RAISE,
      amount: betAmount,
    );
    _actionTaken(context);
  }

  void _allIn({
    double amount,
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
    List<Widget> actionButtons = [];

    bool closeButton = false;
    for (final action in playerAction?.actions) {
      Widget actionWidget = SizedBox();

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
          }
          break;
        case CALL:
          if (playerAction.callAmount > 0) {
            actionWidget = _buildRoundButton(
              text: action.actionName +
                  ' ' +
                  DataFormatter.chipsFormat(action.actionValue),
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
          }
          break;
      }
      actionButtons.add(actionWidget);
    }

    if ((!bet) && (!raise) && (allin != null)) {
      actionButtons.add(_buildRoundButton(
        text: allin.actionName +
            ' ' +
            DataFormatter.chipsFormat(allin.actionValue),
        onTap: () => _allIn(
          amount: playerAction.allInAmount,
          context: context,
        ),
        theme: theme,
      ));
    }

    // log('BetAction: actionButtons.length ${actionButtons.length}');

    /*  if (actionButtons.length > 0 && actionButtons.length < 3 && allin != null) {
      actionButtons.add(_buildRoundButton(
        text: allin.actionName + '\n' + allin.actionValue.toString(),
        onTap: () => _allIn(
          amount: allin.actionValue,
          context: context,
        ),
      ));
    } */

    if (closeButton) {
      actionButtons = [];
      // actionButtons.add(Align(
      //     alignment: Alignment.bottomRight,
      //     child: CircleImageButton(
      //       theme: theme,
      //       icon: Icons.close,
      //       onTap: () {
      //         setState(() {
      //           _showOptions = !_showOptions;
      //           betWidgetShown = false;
      //           widget.isBetWidgetVisible?.call(_showOptions);
      //         });
      //       },
      //     )));
    }

// Consumer<ActionState>(builder: (_, __, ___) {
//                   // show time widget if the player is acting
//                   final gameState = GameState.getState(context);
//                   if (gameState.actionState.show) {
//                     return DebugBorderWidget(child: TimeBankWidget(gameState));
//                   } else {
//                     return Container();
//                   }
//                 });

// final gameState = GameState.getState(context);

//   actionButtons.add(
// TimeBankWidget(gameState),
//   );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: actionButtons,
        ),
      ],
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
      mainAxisSize: MainAxisSize.min,
      children: actionButtons,
    );
  }

  Widget _buildBetWidget(
    GameState gameState,
    Seat mySeat,
    List<int> playerCards,
    PlayerAction playerAction,
    int remainingTime, {
    @required final BoardAttributesObject boardAttributes,
  }) {
    return AnimatedSwitcher(
      // duration: AppConstants.fastestAnimationDuration,
      // reverseDuration: AppConstants.fastestAnimationDuration,
      duration: Duration(milliseconds: 0),
      reverseDuration: Duration(milliseconds: 0),
      transitionBuilder: (child, animation) => ScaleTransition(
        alignment: Alignment.bottomCenter,
        scale: animation,
        child: child,
      ),
      child: playerAction?.options == null
          ? shrinkedBox
          : _showOptions
              ? BetWidgetNew(
                  gameState: gameState,
                  seat: mySeat,
                  action: playerAction,
                  playerCards: playerCards,
                  onSubmitCallBack: _betOrRaise,
                  remainingTime: remainingTime,
                  boardAttributesObject: boardAttributes,
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
        // width: Screen.width,

        padding: EdgeInsets.symmetric(horizontal: 6.0),
        height: betWidgetShown ? (Screen.height / 2) - 15.ph : null,
        // decoration: BoxDecoration(
        //   color: Colors.grey.shade900.withAlpha(220),
        //   borderRadius: BorderRadius.circular(42),
        //   border: Border.all(
        //     color: Colors.white,
        //     width: 1.5,
        //   ),
        // ),
        child: Consumer<ActionState>(
            key: ValueKey('buildActionButtons'),
            builder: (_, actionState, __) {
              // log('BetAction: build actionState.show ${actionState.show} handState: ${gameState.handState.toString()}');
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
                  AnimatedSwitcher(
                      duration: AppConstants.fastestAnimationDuration,
                      reverseDuration: AppConstants.fastestAnimationDuration,
                      transitionBuilder: (child, animation) => ScaleTransition(
                            alignment: Alignment.bottomCenter,
                            scale: animation,
                            child: child,
                          ),
                      child: Transform.scale(
                        scale: boardAttributes.footerActionScale,
                        child: _buildBetWidget(
                          gameState,
                          gameState.mySeat,
                          me.cards,
                          actionState.action,
                          30,
                          boardAttributes: boardAttributes,
                        ),
                      )),
                  /* bottom row */ Align(
                    alignment: Alignment.bottomRight,
                    child: Transform.scale(
                      scale: boardAttributes.footerActionScale,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: _buildActionWidgets(actionState.action, theme),
                      ),
                    ),
                  ),
                ]);
              } else if (actionState.showCheckFold) {
                final mySeat = gameState.mySeat;
                if (mySeat.player != null &&
                    mySeat.player.isActive &&
                    mySeat.player.inhand &&
                    mySeat.player.cards != null &&
                    mySeat.player.cards.length > 0 &&
                    gameState.playerLocalConfig.showCheckFold) {
                  children.add(
                    /* bottom row */
                    Transform.scale(
                      scale: boardAttributes.footerActionScale,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: _buildCheckFoldWidget(actionState, theme),
                      ),
                    ),
                  );
                }
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  ...children,
                ],
              );
            }),
      ),
    );
  }
}
