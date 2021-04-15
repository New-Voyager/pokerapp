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
  double betAmount;
  List<Tuple2<String, String>> otherBets;
  String selectedOptionText;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    otherBets = const [
      Tuple2("AllIn", "435"),
      Tuple2("10BB", "50"),
      Tuple2("5BB", "20"),
      Tuple2("3BB", "12"),
      /*  Tuple2("10BB", "50"),
      Tuple2("5BB", "20"),
      Tuple2("3BB", "12"), */
    ];
  }

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
          height: 40.0,
          width: 40.0,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.all(5.0),
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
                    return _buildRoundButton(
                      //  isSelected: _showOptions,
                      text: playerAction.actionName,
                      onTap: () => setState(() {
                        _showOptions = true;
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
                    return _buildRoundButton(
                      isSelected: _showOptions,
                      text: playerAction.actionName +
                          '\n' +
                          'MIN: ' +
                          playerAction.minActionValue.toString(),
                      onTap: () => setState(() {
                        _showOptions = true;
                        // _showDialog(context);
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

  Widget _buildOptionsRow(PlayerAction playerAction) {
    log('Building bet widget');
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
                    
                    child: BetWidget(),
                    //child: _buildBetWidget(context, playerAction) 
                    /* Column(
                      key: ValueKey('options'),
                      children: [
                        /* options */
                        // BetWidget(),

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
                    ), */
                    )
                : shrinkedBox,
      );
  }

  @override
  Widget build(BuildContext context) {
    print("---------------------- rebuilding. ");
    return Consumer<ActionState>(
      key: ValueKey('buildActionButtons'),
      builder: (_, actionState, __) {
        print("STATE CHANGDDD ----- ${actionState.action}");
        return Container(
          height: MediaQuery.of(context).size.height / 2.5,
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                alignment: Alignment.bottomCenter,
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

  Widget _buildBetWidget(BuildContext context, PlayerAction playerAction) {
    // Default value is minimum
    double val = playerAction.minRaiseAmount.toDouble();

    print("---------------------- Before sTATEFUL: min ${playerAction.minRaiseAmount.toString()} max: ${playerAction.maxRaiseAmount.toString()} ");
    // StatefulBuilder to update localState of the widget
    return StatefulBuilder(builder: (ctx, localState) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    margin: EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      "assets/images/game/green bet.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          final amount = await showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController _controller1 =
                                  TextEditingController(
                                      text: "${val.toStringAsFixed(0)}");
                              return AlertDialog(
                                contentTextStyle:
                                    TextStyle(color: Colors.white),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(_controller1.text.trim());
                                      },
                                      child: Text("OK"))
                                ],
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: _controller1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          localState(() {
                                            val = double.parse(value);
                                          });
                                        },
                                        /*   onChanged: (String s) => localState(
                                          () {
                                            double newValue = double.parse(s);

                                            if (newValue <
                                                playerAction.minRaiseAmount)
                                              newValue = playerAction
                                                  .minRaiseAmount
                                                  .toDouble();
                                            if (newValue >
                                                playerAction.maxRaiseAmount)
                                              newValue = playerAction
                                                  .maxRaiseAmount
                                                  .toDouble();

                                            val = newValue;
                                          },
                                        ),
                                     */
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          if (amount != null && amount.toString().isNotEmpty) {
                            print("AMOUNT IS NOT NULL_______ $amount");
                            double newValue = double.parse(amount);

                            if (newValue < playerAction.minRaiseAmount)
                              newValue = playerAction.minRaiseAmount.toDouble();
                            if (newValue > playerAction.maxRaiseAmount)
                              newValue = playerAction.maxRaiseAmount.toDouble();
                            val = newValue;

                            localState(() {});
                          }
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.lime,
                          ),
                          alignment: Alignment.center,
                          child: Expanded(
                            child:
                                /* TextFormField(
                              // autofocus: true,
                              controller: _betTextController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (String s) {
                                localState(
                                  () {
                                    double newValue = double.parse(s);

                                    if (newValue < playerAction.minRaiseAmount)
                                      newValue = playerAction.minRaiseAmount
                                          .toDouble();
                                    if (newValue > playerAction.maxRaiseAmount)
                                      newValue = playerAction.maxRaiseAmount
                                          .toDouble();

                                    val = newValue;
                                    _betTextController.text =
                                        "${val.toStringAsFixed(0)}";
                                  },
                                );
                              },
                            ),
                          ), */
                                Text(
                              "${val.toStringAsFixed(0)}",
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            betAmount = val;
                            // _showOptions = false;
                          });
                          _submit(playerAction);
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "BET",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Slider.adaptive(
                    max: playerAction.maxRaiseAmount.toDouble(),
                    min: playerAction.minRaiseAmount.toDouble(),
                    inactiveColor: Colors.red.shade100,
                    activeColor: Colors.red.shade300,
                    onChanged: (value) {
                      // print("NEW VAL : $val");
                      localState(() {
                        val = value;
                      });
                    },
                    label: "${val.toStringAsFixed(0)}",
                    semanticFormatterCallback: (value) {
                      return "${val.toStringAsFixed(0)}";
                    },
                    value: val,
                    divisions: 10,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  height: 300,
                  width: 100,
                  alignment: Alignment.center,
                  //color: Colors.red,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final Tuple2<String, String> currentTuple =
                          otherBets[index];
                      return Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${currentTuple.item1}",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "${currentTuple.item2}",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: otherBets.length,
                    scrollDirection: Axis.vertical,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
