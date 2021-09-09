import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/jumping_text_widget.dart';
import 'package:pokerapp/services/data/box_type.dart';
import 'package:pokerapp/services/data/hive_datasource_impl.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:math' as math;

const double betButtonSize = 40.0;

class BetWidget extends StatelessWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;
  final int remainingTime;

  BetWidget({
    @required this.action,
    this.onSubmitCallBack,
    this.remainingTime,
  });

  // TODO: MAKE THIS CLASS A GENERAL ONE SOMEWHERE OUTSIDE IN UTILS
  // WE CAN REUSE THIS CLASS FOR OTHER PLACES AS WELL
  Widget _buildToolTipWith({Widget child, AppTheme theme}) {
    final userSettingsBox = HiveDatasource.getInstance.getBox(
      BoxType.USER_SETTINGS_BOX,
    );

    final betTooltipCountKey = 'bet_tooltip_count';

    int betTooltipCount =
        userSettingsBox.get(betTooltipCountKey, defaultValue: 0) as int;

    // NUMBER OF TIMES WE WANT TO SHOW THE HINT WIDGET
    if (betTooltipCount >= 3) {
      // we dont need to show BET tooltip anymore
      return child;
    }

    // else
    // increment the tool tip count
    userSettingsBox.put(betTooltipCountKey, betTooltipCount + 1);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // swipe up arrow
        JumpingTextWidget(text: 'Swipe up to bet'),

        // main child
        child,
      ],
    );
  }

  Widget _buildBetButton(BuildContext context, final bool isLargerDisplay,
      vnBetAmount, AppTheme theme) {
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
    final double s = betButtonSize.dp;

    betImage = Image.memory(
      imageBytes,
      height: s,
      width: s,
    );
    // SvgPicture.string(
    //   _getBetChipSvg(theme),
    //   height: s,
    //   width: s,
    // ),
    final Widget betChipWidget = Container(
      height: s,
      width: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // bet coin
          Transform.scale(
            scale: boardAttributes.betImageScale,
            child: betImage,
          ),

          // bet text
          IgnorePointer(
            child: AnimatedTextKit(
              // isRepeatingAnimation: true,
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  'BET',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final bool isBetByTapActive = HiveDatasource.getInstance
        .getBox(BoxType.USER_SETTINGS_BOX)
        .get('isTapForBetAction?', defaultValue: false);

    final Widget mainWidget = _buildToolTipWith(
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* drag bet button */
        isBetByTapActive
            // if confirm by tap is active, show a bouncing widget
            ? BouncingWidget(
                scaleFactor: 1.5,
                child: mainWidget,
                onPressed: () {
                  onSubmitCallBack?.call(vnBetAmount.value);
                },
              )
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

  _buildOtherBetOptionsButton(double angle, {Widget child}) {
    final double rad = (math.pi / 180.0) * angle;
    final double radius = betButtonSize.dp * 1.5;

    // TODO: THIS MAY BE DEPENDING UPON SCREEN SIZE
    final double extraYOffset = 15.0;

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          radius * math.cos(rad),
          radius * math.sin(rad) - extraYOffset,
        ),
      child: child,
    );
  }

  double _getAngleBy(index) {
    final double angle = 45;
    switch (index) {

      // keyboard
      case -1:
        return angle * 4;

      case 0:
        return -angle;
      case 1:
        return 0;
      case 2:
        return angle;

      case 3:
        return angle * 3;
      case 5:
        return angle * 5;

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
    final actionOptions = action.options.asMap().entries.map<Widget>(
      (value) {
        final int index = value.key;
        final Option option = value.value;

        return _buildOtherBetOptionsButton(
          _getAngleBy(index),
          child: _buildBetAmountChild(
            theme: appTheme,
            option: action.options[index],
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

      // keyboard button
      _buildOtherBetOptionsButton(
        _getAngleBy(-1),
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

    return ListenableProvider(
      create: (_) => ValueNotifier<double>(
        action.minRaiseAmount.toDouble(),
      ),
      builder: (context, _) {
        final valueNotifierVal = context.read<ValueNotifier<double>>();

        Widget bottomGap = SizedBox(
          height: boardAttributes.betWidgetBottomGap,
        );

        Widget middleGap = SizedBox(
          height: boardAttributes.betWidgetBetChipBottomGap,
        );

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /* bet button */
                _buildBetButton(
                  context,
                  isLargerDisplay,
                  valueNotifierVal,
                  appTheme,
                ),

                // gap
                middleGap,
                middleGap,
                middleGap,

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

                /* SEEK BAR to bet */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // - button
                    RoundSecondaryColorButton(
                      theme: appTheme,
                      iconData: Icons.remove,
                      onTap: (BuildContext context) {
                        double value = valueNotifierVal.value;
                        value--;
                        if (value < action.minRaiseAmount) {
                          value = action.minRaiseAmount.toDouble();
                        }
                        valueNotifierVal.value = value;
                      },
                    ),

                    // seek bar
                    _buildBetSeekBar(betSliderWidth, appTheme),

                    // + button
                    RoundSecondaryColorButton(
                      theme: appTheme,
                      iconData: Icons.add,
                      onTap: (BuildContext context) {
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

                // gap
                bottomGap,
              ],
            ),

            // show the other bet options
            ..._buildOtherBetOptions(
              context: context,
              isLargerDisplay: isLargerDisplay,
              appTheme: appTheme,
              valueNotifierVal: valueNotifierVal,
            ),
          ],
        );
      },
    );
  }

  Widget sleekSlider(AppTheme theme) {
    return Consumer<ValueNotifier<double>>(
      builder: (_, vnValue, __) => SleekCircularSlider(
        onChange: (value) {
          log('min: ${action.minRaiseAmount} max: ${action.maxRaiseAmount} val: ${vnValue.value}');
          vnValue.value = value.round().toDouble();
        },
        min: action.minRaiseAmount.toDouble(),
        max: action.maxRaiseAmount.toDouble(),
        initialValue: vnValue.value,
        appearance: CircularSliderAppearance(
          size: 300.pw,
          // startAngle: 0,
          // angleRange: 275,
          startAngle: 215,
          angleRange: 110,
          animationEnabled: false,
          infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(
              fontSize: 0,
              color: Colors.white70,
            ),
            modifier: (double value) => '',
          ),
          customColors: CustomSliderColors(
            hideShadow: false,
            trackColor: theme.fillInColor.withAlpha(100),
            dotColor: theme.accentColor,
            progressBarColors: [
              theme.primaryColorWithLight().withAlpha(50),
              theme.primaryColorWithLight().withAlpha(100),
              theme.primaryColorWithLight().withAlpha(150),

              theme.primaryColorWithLight().withAlpha(200),
              theme.primaryColorWithLight(),

              theme.primaryColor,
              theme.primaryColorWithDark(),
              // AppColorsNew.newBorderColor,
              // AppColorsNew.newBorderColor,
              // AppColorsNew.newBorderColor,
              // Colors.red,
              // Colors.yellow,
              // Colors.green,
            ],
          ),
          customWidths: CustomSliderWidths(
            trackWidth: 12,
            progressBarWidth: 12,
            handlerSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBetAmountChild({
    bool isKeyboard = false,
    Option option,
    void onTap(),
    AppTheme theme,
  }) =>
      FittedBox(
        fit: BoxFit.fitHeight,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
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
              ),
              Text(
                isKeyboard ? '' : '${option.amount.toInt().toString()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  // Widget betAmountList(ValueNotifier<double> vnValue, AppTheme theme) {
  //   return Container(
  //     height: 70.ph,
  //     child: ListView.builder(
  //       physics: BouncingScrollPhysics(),
  //       scrollDirection: Axis.horizontal,
  //       shrinkWrap: true,
  //       itemBuilder: (context, index) {
  //         if (index == 0) {
  //           // show keyboard
  //           return _buildBetAmountChild(
  //             theme: theme,
  //             isKeyboard: true,
  //             onTap: () async {
  //               double min = action.minRaiseAmount.toDouble();
  //               double max = action.maxRaiseAmount.toDouble();

  //               final double res = await NumericKeyboard2.show(
  //                 context,
  //                 title:
  //                     'Enter your bet/raise amount (${action.minRaiseAmount.toString()} - ${action.maxRaiseAmount.toString()})',
  //                 min: min,
  //                 max: max,
  //               );

  //               if (res != null) vnValue.value = res;
  //             },
  //           );
  //         }

  //         final option = action.options[index - 1];

  //         return _buildBetAmountChild(
  //           theme: theme,
  //           option: action.options[index - 1],
  //           onTap: () {
  //             vnValue.value = option.amount.toDouble();
  //           },
  //         );
  //       },
  //       itemCount: action.options.length + 1,
  //     ),
  //   );
  // }
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
              ? IgnorePointer(
                  child: AnimatedTextKit(
                    // isRepeatingAnimation: true,
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'BET',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

// class CustomTrackShape extends RoundedRectSliderTrackShape {
//   Rect getPreferredRect({
//     @required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     @required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final double trackHeight = sliderTheme.trackHeight;
//     final double trackLeft = offset.dx;
//     final double trackTop =
//         offset.dy + (parentBox.size.height - trackHeight) / 2;
//     final double trackWidth = parentBox.size.width;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }
// }
