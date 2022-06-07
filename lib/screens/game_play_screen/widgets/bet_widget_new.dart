import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/enums/game_type.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_play_screen/new_bet_slider.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/help_text.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/jumping_text_widget.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/color_generator.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/slider_widget.dart';
import 'package:provider/provider.dart';

class BetWidgetNew extends StatelessWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;
  final int remainingTime;
  final List<int> playerCards;
  final BoardAttributesObject boardAttributesObject;
  final GameState gameState;
  final Seat seat;

  BetWidgetNew({
    @required this.seat,
    @required this.gameState,
    @required this.action,
    @required this.playerCards,
    @required this.boardAttributesObject,
    this.onSubmitCallBack,
    this.remainingTime,
  });

  _buildOtherBetOptionsButton(double angle, {Widget child}) {
    final double rad = (math.pi / 180.0) * angle;
    final double radius =
        boardAttributesObject.otherBetOptionButtonsSpreadRadius;

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          radius * math.cos(rad),
          radius * math.sin(rad),
        ),
      child: child,
    );
  }

  double _getAngleBy(index) {
    final double angle = 45;
    switch (index) {
      case -1: // case -1 is keyboard
        return angle / 2;

      case 0: // case 0 is All In or Pot
        return angle;

      // other bet option buttons

      case 1:
        return 3 * angle;
      case 2:
        return 4 * angle;
      case 3:
        return 5 * angle;

      default:
        return 0;
    }
  }

  List<Widget> _buildOtherBetOptions({
    @required BuildContext context,
    @required bool isLargerDisplay,
    @required ValueNotifier<double> valueNotifierVal,
    @required AppTheme appTheme,
  }) {
    final gameState = GameState.getState(context);
    final boa = gameState.getBoardAttributes(context);
    // keyboard button gets the index -1
    // all in or pot gets the index 0 // Option.text = "Pot" OR Option.text = "All-In"
    // other buttons gets index 1 - anything

    // as the last of the list always contains the All In or Pot option, we can simply reverse the list to
    // have the All In or Pot option at index 0
    final actionOptions =
        action.options.reversed.toList().asMap().entries.map<Widget>(
      (value) {
        final int index = value.key;
        final Option option = value.value;

        Widget child = _buildOtherBetOptionsButton(
          _getAngleBy(index),
          child: _buildBetAmountChild(
            theme: appTheme,
            option: option,
            onTap: () {
              valueNotifierVal.value = option.amount.toDouble();
            },
          ),
        );
        return Transform.translate(offset: boa.betButtonsOffset, child: child);
      },
    ).toList();

    return [
      // action option buttons
      ...actionOptions,

      // all in OR POT button has the index 0

      // keyboard button
      _buildOtherBetOptionsButton(
        _getAngleBy(-1), //  keyboard button has the index -1
        child: _buildBetAmountChild(
          theme: appTheme,
          isKeyboard: true,
          onTap: () async {
            double min = action.minRaiseAmount.toDouble();
            double max = action.maxRaiseAmount.toDouble();

            final double res = await NumericKeyboard2.show(context,
                title:
                    'Enter your bet/raise amount (${DataFormatter.chipsFormat(action.minRaiseAmount)} - ${DataFormatter.chipsFormat(action.maxRaiseAmount)})',
                min: min,
                max: max,
                decimalAllowed: gameState.gameInfo.chipUnit == ChipUnit.CENT);

            if (res != null) valueNotifierVal.value = res;
          },
        ),
      ),
    ];
  }

  List<CardObject> _getCards(List<int> cards) {
    if (cards == null || cards.isEmpty) return [];
    List<CardObject> cardObjects = [];
    for (int cardNum in cards) {
      CardObject card = CardHelper.getCard(cardNum);
      card.cardType = CardType.PlayerCard;
      card.dim = true;

      // if we are in showdown and this player is a winner, show his cards
      cardObjects.add(card);
    }
    return cardObjects.reversed.toList();
  }

  // TODO: MAKE THIS CLASS A GENERAL ONE SOMEWHERE OUTSIDE IN UTILS
  // WE CAN REUSE THIS CLASS FOR OTHER PLACES AS WELL
  Widget _betWidget({Widget child, AppTheme theme}) {
    final userSettingsBox = HiveDatasource.getInstance.getBox(
      BoxType.USER_SETTINGS_BOX,
    );

    final betTooltipCountKey = 'bet_tooltip_count';

    int betTooltipCount =
        userSettingsBox.get(betTooltipCountKey, defaultValue: 0) as int;

    // NUMBER OF TIMES WE WANT TO SHOW THE HINT WIDGET

    // if (betTooltipCount >= 3) {
    //   // we dont need to show BET tooltip anymore
    //   return child;
    // }

    // else
    // increment the tool tip count
    userSettingsBox.put(betTooltipCountKey, betTooltipCount + 1);

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // swipe up arrow
        Transform.translate(
          offset: Offset(0, 85.ph),
          child: JumpingTextWidget(text: 'Tap to bet'),
        ),

        // main child
        child,
      ],
    );
  }

  bool _showTip() {
    try {
      final userSettingsBox = HiveDatasource.getInstance.getBox(
        BoxType.USER_SETTINGS_BOX,
      );
      final betTooltipCountKey = 'bet_tooltip_count';
      int betTooltipCount =
          userSettingsBox.get(betTooltipCountKey, defaultValue: 0) as int;

      // NUMBER OF TIMES WE WANT TO SHOW THE HINT WIDGET
      bool showTip = true;
      if (betTooltipCount >= 3) {
        // we dont need to show BET tooltip anymore
        showTip = false;
      } else {
        // else
        // increment the tool tip count
        userSettingsBox.put(betTooltipCountKey, betTooltipCount + 1);
      }
      return showTip;
    } catch (err) {}
    return false;
  }

  Widget _buildKeyboardButton(
      BuildContext context, AppTheme theme, ValueNotifier<double> vnValue) {
    final gameState = GameState.getState(context);
    return _buildBetAmountChild(
      onTap: () async {
        double min = action.minRaiseAmount.toDouble();
        double max = action.maxRaiseAmount.toDouble();

        final double res = await NumericKeyboard2.show(context,
            title:
                'Enter your bet/raise amount (${DataFormatter.chipsFormat(action.minRaiseAmount)} - ${DataFormatter.chipsFormat(action.maxRaiseAmount)})',
            min: min,
            max: max,
            decimalAllowed: gameState.gameInfo.chipUnit == ChipUnit.CENT);

        if (res != null) vnValue.value = res;
      },
      theme: theme,
      isKeyboard: true,
    );
  }

  Widget _buildBetButton(BuildContext context, final bool isLargerDisplay,
      vnBetAmount, AppTheme theme) {
    log('_buildBetButton $vnBetAmount');
    final vnOffsetValue = ValueNotifier<double>(.0);

    final colorizeColors = [
      Colors.green,
      Colors.green[400],
      Colors.green[200],
      Colors.green[100],
    ];

    final colorizeTextStyle = TextStyle(
      fontSize: 12.0.dp,
      fontWeight: FontWeight.bold,
    );
    final gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);
    final imageBytes = gameState.assets.getBetImage();
    Widget betImage;
    final double s = 32.pw;

    double height = s * boardAttributes.betImageScale;

    betImage = Image.memory(
      imageBytes,
      height: s,
      width: s,
    );

    Widget betChipImage = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // bet coin
        Transform.scale(
          scale: boardAttributes.betImageScale,
          child: betImage,
        ),
        // bet text
        Text('BET', style: TextStyle(fontSize: 12.dp)),
        // _showTip()
        //     ? Transform.translate(
        //         offset: Offset(100.pw, 0.ph),
        //         child: JumpingTextWidget(text: 'Tap\nto\nbet', jumpHeight: 5))
        //     : Container(),
      ],
    );
    final Widget betChipWidget = GestureDetector(
      onTap: () {
        log('BET: tap detected');
        appService.appSettings.showBetTip = false;
        onSubmitCallBack?.call(vnBetAmount.value);
      },
      child: Container(
        height: height,
        width: s * boardAttributes.betImageScale,
        child: betChipImage,
      ),
    );
    return betChipWidget;

    final bool isBetByTapActive = true;
    //gameState.playerLocalConfig.tapOrSwipeBetAction;

    final Widget betWidget = _betWidget(
      child: IntrinsicWidth(
        child: Container(
          height: 2 * s,
          child: AnimatedBuilder(
            animation: vnOffsetValue,
            builder: (_, __) {
              return Align(
                alignment: Alignment(.5, 1 - vnOffsetValue.value * 2),
                child: betChipWidget,
              );
            },
          ),
        ),
      ),
      theme: theme,
    );
    List<Widget> betButtons = [];
    bool showKeyboard = true;
    if (showKeyboard) {
      betButtons.add(Positioned(
          top: -20,
          left: 30,
          child: _buildKeyboardButton(context, theme, vnBetAmount)));
    }

    // show all-in or pot button on the left
    for (final option in action.options) {
      if (option.text == 'All-In' || option.text == 'Pot') {
        betButtons.add(
          Positioned(
            top: 40,
            left: 30,
            child: _buildBetAmountChild(
              onTap: () {
                vnBetAmount.value = option.amount.toDouble();
              },
              theme: theme,
              option: option,
            ),
          ),
        );
        break;
      }
    }

    // other buttons go on the right
    double top = -20;
    double right = 40;
    for (final option in action.options) {
      if (option.text == 'All-In' || option.text == 'Pot') {
        // skip handled
      } else {
        betButtons.add(
          Positioned(
            top: top,
            right: right,
            child: _buildBetAmountChild(
              onTap: () {
                vnBetAmount.value = option.amount.toDouble();
              },
              theme: theme,
              option: option,
            ),
          ),
        );
        top += 40;
      }
    }
    final Widget widgetWithBetAmounts = Container(
        width: Screen.width * 3 / 4,
        height: 80,
        child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              betChipWidget,
              ...betButtons,
            ]));

    final Widget mainWidget = betChipWidget;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* drag bet button */
        isBetByTapActive
            // if confirm by tap is active, show a bouncing widget
            ? mainWidget
            : GestureDetector(
                // confirm bet ON SLIDE UP TILL THE TOP
                onVerticalDragEnd: (_) {
                  // if we reach 1.0 and leave the chip, CONFIRM BET
                  if (vnOffsetValue.value == 1.0) {
                    return onSubmitCallBack?.call(vnBetAmount.value);
                  }

                  // ELSE on drag release bounce back to start
                  vnOffsetValue.value = 0.0;
                },
                onVerticalDragUpdate: (details) {
                  if (isBetByTapActive) return;
                  vnOffsetValue.value =
                      (vnOffsetValue.value - details.delta.dy / s)
                          .clamp(.0, 1.0);
                },
                child: mainWidget,
              ),
      ],
    );
  }

  Widget _buildBetSeekBar(double width, AppTheme theme, GameState gameState) {
    return Container(
      width: width,
      // child: SliderTheme(
      //   data: SliderThemeData(
      //     thumbColor: appTheme.accentColor,
      //     activeTrackColor: appTheme.secondaryColor,
      //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
      //     inactiveTrackColor: appTheme.secondaryColor.withOpacity(
      //       0.5,
      //     ),
      //     trackHeight: 10.0,
      //   ),
      //   child: Consumer<ValueNotifier<double>>(
      //     builder: (_, vnBetAmount, __) {
      //       final min = action.minRaiseAmount.toDouble();
      //       final max = action.maxRaiseAmount.toDouble();
      //       return Slider(
      //         min: min,
      //         max: max,
      //         value: vnBetAmount.value,
      //         onChanged: (newBetAmount) {
      //           if (gameState.gameInfo.chipUnit == ChipUnit.DOLLAR) {
      //             vnBetAmount.value = newBetAmount.round().toDouble();
      //           } else {
      //             vnBetAmount.value = newBetAmount;
      //           }
      //         },
      //       );
      //     },
      //   ),
      // ),

      child: Consumer<ValueNotifier<double>>(
        builder: (_, vnBetAmount, __) {
          final min = action.minRaiseAmount.toDouble();
          final max = action.maxRaiseAmount.toDouble();

          return CustomSlider(
            max: max,
            min: min,
            values: [vnBetAmount.value],
            onChanged: (handlerIndex, newBetAmount, upperValue) {
              if (gameState.gameInfo.chipUnit == ChipUnit.DOLLAR) {
                vnBetAmount.value = newBetAmount.round().toDouble();
              } else {
                vnBetAmount.value = newBetAmount;
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final appTheme = context.read<AppTheme>();
    final gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);
    final betSliderWidth = width / boardAttributes.betSliderScale;
    final int screenSize = boardAttributes.screenDiagnolSize;
    final bool isLargerDisplay = screenSize >= 9;
    log('bet_widget : screenSize : $screenSize');
    //List<int> cards = [161, 200, 168, 177, 194];
    Offset offset = boardAttributes.betWidgetOffset;
    double betWidgetGap = boardAttributes.betWidgetGap;

    final bool isCentsGame = gameState.gameInfo.chipUnit == ChipUnit.CENT;

    return ListenableProvider<ValueNotifier<double>>(
      create: (_) => ValueNotifier<double>(
        action.minRaiseAmount.toDouble(),
      ),
      builder: (BuildContext context, _) {
        final valueNotifierVal = context.read<ValueNotifier<double>>();
        return Container(
          // margin: EdgeInsets.only(bottom: 30),
          width: MediaQuery.of(context).size.width,
          height: boardAttributes.footerHeight,
          padding: EdgeInsets.only(
            right: 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 4.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 30.0,
                          ),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/bet-widget/add-sub-background.png',
                                  ),
                                  fit: BoxFit.fill)),
                          padding: EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _stopIncrementDecrement();
                                },
                                onTapDown: (v) {
                                  _startIncrementDecrement(
                                      true, valueNotifierVal, isCentsGame);
                                },
                                onTapUp: (v) {
                                  _stopIncrementDecrement();
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/bet-widget/add.png',
                                          ),
                                          fit: BoxFit.fill)),
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _stopIncrementDecrement();
                                },
                                onTapDown: (v) {
                                  _startIncrementDecrement(
                                      false, valueNotifierVal, isCentsGame);
                                },
                                onTapUp: (v) {
                                  _stopIncrementDecrement();
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/bet-widget/minus.png',
                                          ),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        betAmountList(context, valueNotifierVal, appTheme),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 80.pw,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueGrey.shade800, width: 2),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.blueGrey.shade900,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /* bet amount */
                              ValueListenableBuilder<double>(
                                valueListenable: valueNotifierVal,
                                builder: (_, double betAmount, __) =>
                                    GestureDetector(
                                  onTap: () async {
                                    double min =
                                        action.minRaiseAmount.toDouble();
                                    double max =
                                        action.maxRaiseAmount.toDouble();

                                    final double res =
                                        await NumericKeyboard2.show(
                                      context,
                                      title: 'Enter your bet',
                                      min: min,
                                      currentVal: valueNotifierVal.value,
                                      max: max,
                                    );

                                    if (res != null)
                                      valueNotifierVal.value = res;
                                  },
                                  child: Container(
                                    width: double.maxFinite,
                                    // alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              'assets/images/bet-widget/header.png',
                                            ),
                                            fit: BoxFit.fill)),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            DataFormatter.chipsFormat(
                                                betAmount),
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.yellowAccent,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 4,
                                          child: Center(
                                            child: Icon(
                                              Icons.keyboard,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     double value = valueNotifierVal.value;
                              //     if (isCentsGame) {
                              //       value += 0.01;
                              //     } else {
                              //       value++;
                              //     }
                              //     if (value > action.maxRaiseAmount) {
                              //       value = action.maxRaiseAmount.toDouble();
                              //     }
                              //     valueNotifierVal.value = value;
                              //   },
                              //   child: Container(
                              //     height: 24,
                              //     width: double.maxFinite,
                              //     decoration: BoxDecoration(
                              //         color: Colors.blueGrey.shade400),
                              //     child: Icon(
                              //       Icons.add,
                              //       size: 18,
                              //     ),
                              //   ),
                              // ),
                              Consumer<ValueNotifier<double>>(
                                  builder: (_, vnBetAmount, __) {
                                log(vnBetAmount.value.toString());
                                return BetSlider(
                                  initialValue: vnBetAmount.value,
                                  max: action.maxRaiseAmount.toDouble(),
                                  min: action.minRaiseAmount.toDouble(),
                                  chipsCount: 12,
                                  chipSize: Size(50, 25),
                                  onChanged: (value) {
                                    if (gameState.gameInfo.chipUnit ==
                                        ChipUnit.DOLLAR) {
                                      vnBetAmount.value =
                                          value.round().toDouble();
                                    } else {
                                      vnBetAmount.value = value;
                                    }
                                  },
                                );
                              }),
                              // GestureDetector(
                              //   onTap: () {
                              //     double value = valueNotifierVal.value;
                              //     if (isCentsGame) {
                              //       value -= 0.01;
                              //     } else {
                              //       value--;
                              //     }
                              //     if (value < action.minRaiseAmount) {
                              //       value = action.minRaiseAmount.toDouble();
                              //     }
                              //     valueNotifierVal.value = value;
                              //   },
                              //   child: Container(
                              //     height: 24,
                              //     width: double.maxFinite,
                              //     decoration:
                              //         BoxDecoration(color: Colors.blueGrey.shade300),
                              //     child: Icon(
                              //       Icons.remove,
                              //       size: 18,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              _buildRaiseButton(
                  theme: appTheme,
                  onTap: () {
                    appService.appSettings.showBetTip = false;
                    onSubmitCallBack?.call(valueNotifierVal.value);
                  },
                  text: (action.actions.firstWhere(
                            (element) => element.actionName == BET,
                            orElse: () => null,
                          ) !=
                          null)
                      ? BET
                      : RAISE),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBetAmountChild({
    bool isKeyboard = false,
    Option option,
    void onTap(),
    AppTheme theme,
  }) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: isKeyboard
                    ? const EdgeInsets.all(4)
                    : const EdgeInsets.all(8),
                margin: isKeyboard
                    ? const EdgeInsets.fromLTRB(0, 4, 0, 0)
                    : const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  //color: Colors.red,
                  //  border: Border.all(color: Colors.white, width: 1.0),
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    // begin: Alignment.topRight,
                    // end: Alignment.bottomLeft,
                    colors: [
                      theme.fillInColor,
                      theme.primaryColorWithDark(),
                    ],
                    stops: [
                      0.2,
                      0.8,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.secondaryColor,
                      offset: Offset(0, 1),
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                    )
                  ],
                ),
                child: isKeyboard
                    ? Icon(
                        Icons.keyboard,
                        color: Colors.white,
                      )
                    : Text(
                        "${option.text}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
              ),
              Text(
                isKeyboard ? '' : '${DataFormatter.chipsFormat(option.amount)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget betAmountList(
      BuildContext context, ValueNotifier<double> vnValue, AppTheme theme) {
    List<BetAmountButton> buttons = [];
    // buttons.add(BetAmountButton(
    //   onTap: () async {
    //     double min = action.minRaiseAmount.toDouble();
    //     double max = action.maxRaiseAmount.toDouble();

    //     final double res = await NumericKeyboard2.show(
    //       context,
    //       title: 'Enter your bet',
    //       min: min,
    //       max: max,
    //     );

    //     if (res != null) vnValue.value = res;
    //   },
    //   theme: theme,
    //   isKeyboard: true,
    //   text: '',
    // ));

    final bettingOptions = appService.userSettings.getBettingOptions();
    final preflop = bettingOptions.preFlop;
    final postflop = bettingOptions.postFlop;
    final raise = bettingOptions.raise;

    if (!action.raiseAvailable) {
      if (gameState.handState == HandState.PREFLOP) {
        for (int i = 0; i < preflop.length; i++) {
          final amount = preflop[i].toDouble() * gameState.handInfo.bigBlind;
          if (amount > gameState.handInfo.bigBlind &&
              amount <= action.maxRaiseAmount) {
            buttons.add(BetAmountButton(
              onTap: () {
                vnValue.value = amount;
              },
              theme: theme,
              isKeyboard: false,
              text: '${preflop[i]}BB',
            ));
          }
        }
      } else {
        for (int i = 0; i < postflop.length; i++) {
          double amount = (postflop[i] * action.potAmount) / 100;
          if (gameState.gameInfo.chipUnit == ChipUnit.DOLLAR) {
            amount = amount.toInt().toDouble();
          }

          if (amount > gameState.handInfo.bigBlind &&
              amount <= action.maxRaiseAmount) {
            buttons.add(BetAmountButton(
              onTap: () {
                vnValue.value = amount;
              },
              theme: theme,
              isKeyboard: false,
              text: '${postflop[i]}%',
            ));
          }
        }
      }
    } else {
      // a player raised
      for (int i = 0; i < raise.length; i++) {
        final amount = (raise[i] * action.raiseAmount) + action.seatInSoFar;
        if (amount > gameState.handInfo.bigBlind &&
            amount <= action.maxRaiseAmount) {
          buttons.add(BetAmountButton(
            onTap: () {
              vnValue.value = amount;
            },
            theme: theme,
            isKeyboard: false,
            text: '${raise[i]}X',
          ));
        }
      }
    }

    if (action.ploPotAmount != 0) {
      buttons.add(BetAmountButton(
        onTap: () {
          vnValue.value = action.ploPotAmount;
        },
        theme: theme,
        isKeyboard: false,
        text: 'POT',
      ));
    }

    if (action.allInAmount != 0) {
      buttons.add(BetAmountButton(
        onTap: () {
          vnValue.value = action.allInAmount;
        },
        theme: theme,
        isKeyboard: false,
        text: 'ALL-IN',
      ));
    }

    return Container(
      height: 26.ph,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buttons[index];
          if (index == 0) {
            // show keyboard
            return BetAmountButton(
              onTap: () async {
                double min = action.minRaiseAmount.toDouble();
                double max = action.maxRaiseAmount.toDouble();

                final double res = await NumericKeyboard2.show(
                  context,
                  title: 'Enter your bet',
                  min: min,
                  max: max,
                );

                if (res != null) vnValue.value = res;
              },
              theme: theme,
              isKeyboard: true,
              text: '',
            );
          }

          final option = action.options[index - 1];

          return BetAmountButton(
            onTap: () {
              vnValue.value = option.amount.toDouble();
            },
            theme: theme,
            text: action.options[index - 1].text,
            //option: action.options[index - 1],
          );
        },
        itemCount: buttons.length, //action.options.length + 1,
      ),
    );
  }

  Widget betAmountList2(ValueNotifier<double> vnValue, AppTheme theme) {
    return Container(
      height: 40,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            // show keyboard
            return _buildBetAmountChild(
              onTap: () async {
                double min = action.minRaiseAmount.toDouble();
                double max = action.maxRaiseAmount.toDouble();

                final double res = await NumericKeyboard2.show(
                  context,
                  title: 'Enter your bet',
                  min: min,
                  max: max,
                );

                if (res != null) vnValue.value = res;
              },
              theme: theme,
              isKeyboard: true,
            );
          }

          final option = action.options[index - 1];

          return _buildBetAmountChild(
            onTap: () {
              vnValue.value = option.amount.toDouble();
            },
            theme: theme,
            option: action.options[index - 1],
          );
        },
        itemCount: action.options.length + 1,
      ),
    );
  }

  Widget _buildRaiseButton({
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
    if (disable) {
      btnColor = Colors.grey;
      btnTextStyle = AppDecorators.getSubtitle3Style(theme: theme);
    }

    final button = Container(
      height: 32.ph,
      width: 80.pw,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: btnColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
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

  bool _holding = false;

  void _startIncrementDecrement(
    bool increment,
    ValueNotifier valueNotifierVal,
    bool isCentsGame,
  ) async {
    if (_holding) return;
    _holding = true;
    var initialDelay = 549;
    var decreaseStep = 300;
    var divider = 1;

    while (_holding) {
      if (increment) {
        double value = valueNotifierVal.value;

        if (isCentsGame) {
          value += 0.01;
        } else {
          value++;
        }

        if (value > action.maxRaiseAmount) {
          value = action.maxRaiseAmount.toDouble();
        }
        valueNotifierVal.value = value;
      } else {
        double value = valueNotifierVal.value;
        if (isCentsGame) {
          value -= 0.01;
        } else {
          value--;
        }
        if (value < action.minRaiseAmount) {
          value = action.minRaiseAmount.toDouble();
        }
        valueNotifierVal.value = value;
      }

      await Future.delayed(Duration(milliseconds: initialDelay));
      if (initialDelay > 100) {
        initialDelay = initialDelay - decreaseStep ~/ divider;
      }
      divider++;
    }
  }

  void _stopIncrementDecrement() {
    _holding = false;
  }
}

class BetIconButton extends StatelessWidget {
  final bool displayBetText;
  BetIconButton({@required this.displayBetText});

  @override
  Widget build(BuildContext context) {
    final double s = 40.dp;
    final colorizeColors = [
      Colors.green,
      Colors.green[400],
      Colors.green[200],
      Colors.green[100],
    ];

    final gameState = GameState.getState(context);
    final imageBytes = gameState.assets.getBetImage();
    final colorizeTextStyle = TextStyle(
      fontSize: 12.0.dp,
      fontWeight: FontWeight.bold,
    );

    return Container(
      height: s,
      width: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bet coin
          Transform.scale(
            scale: 1.5,
            child: SvgPicture.memory(
              imageBytes,
              height: s,
              width: s,
            ),
          ),

          // bet text
          this.displayBetText
              ? Text(
                  'BET',
                  style: TextStyle(fontSize: 14.dp),
                )
              // IgnorePointer(
              //     child: AnimatedTextKit(
              //       // isRepeatingAnimation: true,
              //       repeatForever: true,
              //       animatedTexts: [
              //         ColorizeAnimatedText(
              //           'BET',
              //           textStyle: colorizeTextStyle,
              //           colors: colorizeColors,
              //         ),
              //       ],
              //     ),
              //   )
              : Container(),
        ],
      ),
    );
  }
}
