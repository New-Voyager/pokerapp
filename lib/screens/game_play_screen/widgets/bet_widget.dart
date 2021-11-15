import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/jumping_text_widget.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BetWidget extends StatelessWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;
  final int remainingTime;
  final List<int> playerCards;

  BetWidget({
    @required this.action,
    @required this.playerCards,
    this.onSubmitCallBack,
    this.remainingTime,
  });

  _buildOtherBetOptionsButton(double angle, {Widget child}) {
    final double rad = (math.pi / 180.0) * angle;
    final double radius = 70;

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
        return 0;

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

        return _buildOtherBetOptionsButton(
          _getAngleBy(index),
          child: _buildBetAmountChild(
            theme: appTheme,
            option: option,
            onTap: () {
              valueNotifierVal.value = option.amount.toDouble();
            },
          ),
        );
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

            final double res = await NumericKeyboard2.show(
              context,
              title:
                  'Enter your bet/raise amount (${action.minRaiseAmount.toString()} - ${action.maxRaiseAmount.toString()})',
              min: min,
              max: max,
            );

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
    return _buildBetAmountChild(
      onTap: () async {
        double min = action.minRaiseAmount.toDouble();
        double max = action.maxRaiseAmount.toDouble();

        final double res = await NumericKeyboard2.show(
          context,
          title:
              'Enter your bet/raise amount (${action.minRaiseAmount.toString()} - ${action.maxRaiseAmount.toString()})',
          min: min,
          max: max,
        );

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
        _showTip()
            ? Transform.translate(
                offset: Offset(100.pw, 0.ph),
                child: JumpingTextWidget(text: 'Tap\nto\nbet', jumpHeight: 5))
            : Container(),
      ],
    );
    final Widget betChipWidget = GestureDetector(
      onTap: () {
        log('BET: tap detected');
        onSubmitCallBack?.call(vnBetAmount.value);
      },
      child: Container(
        height: s * boardAttributes.betImageScale,
        width: s * boardAttributes.betImageScale,
        child: betChipImage,
      ),
    );

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

  Widget _buildBetSeekBar(double width, AppTheme appTheme) {
    return Container(
      width: width,
      child: SliderTheme(
        data: SliderThemeData(
          thumbColor: appTheme.accentColor,
          activeTrackColor: appTheme.secondaryColor,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
          inactiveTrackColor: appTheme.secondaryColor.withOpacity(
            0.5,
          ),
          trackHeight: 10.0,
        ),
        child: Consumer<ValueNotifier<double>>(
          builder: (_, vnBetAmount, __) => Slider(
            min: action.minRaiseAmount.toDouble(),
            max: action.maxRaiseAmount.toDouble(),
            value: vnBetAmount.value,
            onChanged: (newBetAmount) {
              vnBetAmount.value = newBetAmount;
            },
          ),
        ),
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

    return Stack(children: [
      ListenableProvider<ValueNotifier<double>>(
        create: (_) => ValueNotifier<double>(
          action.minRaiseAmount.toDouble(),
        ),
        builder: (BuildContext context, _) {
          final valueNotifierVal = context.read<ValueNotifier<double>>();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // cards
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Transform.scale(
                    scale: 1.0,
                    child: StackCardView(cards: _getCards(playerCards))),
              ),

              /* progress drag to bet */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleImageButton2(
                    theme: appTheme,
                    icon: Icons.remove,
                    onTap: () {
                      double value = valueNotifierVal.value;
                      value--;
                      if (value < action.minRaiseAmount) {
                        value = action.minRaiseAmount.toDouble();
                      }
                      valueNotifierVal.value = value;
                    },
                  ),
                  _buildBetSeekBar(betSliderWidth, appTheme),
                  CircleImageButton2(
                    theme: appTheme,
                    icon: Icons.add,
                    onTap: () {
                      double value = valueNotifierVal.value;
                      value++;
                      if (value > action.maxRaiseAmount) {
                        value = action.maxRaiseAmount.toDouble();
                      }
                      valueNotifierVal.value = value;
                    },
                  ),
                ],
              ),

              /* OLD UI button row for other bet options */
              // Transform.scale(
              //   alignment: Alignment.topCenter,
              //   scale: 0.90,
              //   child: Container(
              //     alignment: Alignment.center,
              //     width: width / 1.5,
              //     height: 40.ph,
              //     child: betAmountList(valueNotifierVal, appTheme),
              //   ),
              // ),
              // SizedBox(height: 5.ph),

              /* bet amount */
              ValueListenableBuilder<double>(
                valueListenable: valueNotifierVal,
                builder: (_, double betAmount, __) => Text(
                  DataFormatter.chipsFormat(betAmount.roundToDouble()),
                  style: TextStyle(
                    fontSize: 12.dp,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent,
                  ),
                ),
              ),

              Stack(
                alignment: Alignment.center,
                children: [
                  // other bet buttons
                  ..._buildOtherBetOptions(
                    context: context,
                    isLargerDisplay: isLargerDisplay,
                    valueNotifierVal: valueNotifierVal,
                    appTheme: appTheme,
                  ),

                  /* bet button */
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
                    child: _buildBetButton(
                      context,
                      isLargerDisplay,
                      valueNotifierVal,
                      appTheme,
                    ),
                  ),
                ],
              ),

              //SizedBox(height: 10.ph),
            ],
          );
        },
      ),
    ]);
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
              // Text(
              //   isKeyboard ? '' : '${option.amount.toInt().toString()}',
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget betAmountList(ValueNotifier<double> vnValue, AppTheme theme) {
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
