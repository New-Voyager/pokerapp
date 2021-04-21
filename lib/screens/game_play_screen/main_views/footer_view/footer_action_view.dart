import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/bet_widget.dart';
import 'package:pokerapp/services/app/auth_service.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:pokerapp/services/game_play/message_id.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

const shrinkedBox = const SizedBox.shrink(
  key: ValueKey('none'),
);

class FooterActionView extends StatefulWidget {
  @override
  _FooterActionViewState createState() => _FooterActionViewState();
}

class _FooterActionViewState extends State<FooterActionView> {
  bool _showOptions = false;
  bool _disableBetButton = false;
  double betAmount;
  String selectedOptionText;
  bool bet = false;
  bool raise = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /* this function decides, whom to call - bet or raise? */
  void _submit(PlayerAction playerAction) {
    int idx = playerAction.actions.indexWhere((pa) => pa.actionName == BET);
    if (idx == -1) return _raise();
    _bet();
  }

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
        color: isSelected ? const Color(0xff319ffe) : Colors.transparent,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: btnColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: btnTextStyle,
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

    String playerID = await AuthService.getPlayerID();
    final gameState = Provider.of<GameState>(context, listen: false);
    final actionState = gameState.getActionState(context);
    final gameContext = Provider.of<GameContextObject>(
      context,
      listen: false,
    );
    // get current hand number
    int handNum = gameContext.currentHandNum;

    String gameCode = gameContext.gameCode;

    int messageId = MessageId.incrementAndGet(gameCode);
    String message = """{
      "gameId": "${gameContext.gameId}",
      "playerId": "$playerID",
      "handNum": $handNum,
      "messageType": "PLAYER_ACTED",
      "messageId": $messageId,
      "playerActed": {
        "seatNo": ${actionState.action.seatNo},
        "action": "$action",
        "amount": $amount
      }
    }""";

    log(message);

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

  Widget _buildTopActionRow(PlayerAction playerAction) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
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
                    bet = true;
                    return _buildRoundButton(
                      //  isSelected: _showOptions,
                      text: playerAction.actionName,
                      disable: _disableBetButton,
                      onTap: () => setState(() {
                        _showOptions = true;
                        _disableBetButton = true;
                        // _showDialog(context);
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
                        _showOptions = true;
                      }),
                    );
                  /* case ALLIN:
                    return _buildRoundButton(
                      text: playerAction.actionName +
                          '\n' +
                          playerAction.actionValue.toString(),
                      onTap: () => _allIn(
                        amount: playerAction.actionValue,
                        context: context,
                      ),
                    ); */
                }

                return SizedBox.shrink();
              },
            )?.toList() ??
            [],
      );

  Widget _buildOptionsRow(PlayerAction playerAction) {
    return AnimatedSwitcher(
      duration: AppConstants.fastAnimationDuration,
      reverseDuration: AppConstants.fastAnimationDuration,
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      child: playerAction?.options == null
          ? shrinkedBox
          : _showOptions
              ? Container(
                  color: Colors.black.withOpacity(0.85),
                  child: BetWidget(
                    action: playerAction,
                    onSubmitCallBack: _betOrRaise,
                  ),
                )
              : shrinkedBox,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("---------------------- rebuilding. ");
    return Consumer<ActionState>(
      key: ValueKey('buildActionButtons'),
      builder: (_, actionState, __) {
        // print("STATE CHANGDDD ----- ${actionState.action}");
        return Container(
          height: MediaQuery.of(context).size.height / 2.5,
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 8),
                child: _buildTopActionRow(actionState.action),
              ),
              Container(
                constraints: BoxConstraints.expand(),
                alignment: Alignment.topCenter,
                child: _buildOptionsRow(actionState.action),
              ),
            ],
          ),
        );
      },
    );
  }
}
