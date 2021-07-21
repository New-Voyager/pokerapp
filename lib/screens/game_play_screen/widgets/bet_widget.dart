import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/pulsating_button.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard2.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:timer_count_down/timer_count_down.dart';

class BetWidget extends StatelessWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;
  final int remainingTime;

  BetWidget({
    @required this.action,
    this.onSubmitCallBack,
    this.remainingTime,
  });

  Widget betButton1(ValueNotifier<double> vnVal) {
    return Container(
      width: 60.pw,
      height: 74.ph,
      child: Stack(fit: StackFit.expand, children: [
        PulsatingCircleIconButton(
          onTap: () => onSubmitCallBack?.call(vnVal.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DataFormatter.chipsFormat(
                  vnVal.value,
                ),
                style: TextStyle(
                  fontSize: 10.dp,
                  color: Colors.white,
                ),
              ),
              //  SizedBox(height: 5),
              Text(
                "BET",
                style: TextStyle(
                  fontSize: 10.dp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget betButton(ValueNotifier<double> vnVal, int remainingTime) {
    return Container(
      width: 40.pw,
      height: 40.pw,
      //decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      decoration: BoxDecoration(
        //color: Colors.red,
        border:
            Border.all(color: AppColorsNew.newSelectedGreenColor, width: 2.pw),
        color: AppColorsNew.newGreenRadialStopColor,
        shape: BoxShape.circle,
      ),
      child: Stack(fit: StackFit.expand, children: [
        // Countdown(
        //     seconds: remainingTime,
        //     onFinished: () {},
        //     build: (_, time) {
        //       double value = time / remainingTime;
        //       return  CircularProgressIndicator(
        //         strokeWidth: 2.pw,
        //           value: value,
        //           color: AppColorsNew.newBorderColor,
        //       );
        //     }),
        CircularProgressIndicator(
          strokeWidth: 2.pw,
          color: AppColorsNew.newBorderColor,
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DataFormatter.chipsFormat(
                vnVal.value,
              ),
              style: TextStyle(
                fontSize: 10.dp,
                color: Colors.white,
              ),
            ),
            //  SizedBox(height: 5),
            Text(
              "BET",
              style: TextStyle(
                fontSize: 10.dp,
                color: Colors.white,
              ),
            )
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    log('slider $width');
    return ListenableProvider<ValueNotifier<double>>(
      create: (_) => ValueNotifier<double>(
        action.minRaiseAmount.toDouble(),
      ),
      builder: (BuildContext context, _) {
        final valueNotifierVal = Provider.of<ValueNotifier<double>>(
          context,
          listen: false,
        );
        return Stack(
          children: [
            /* top */
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  /* (-) button */
                  GestureDetector(
                    onTap: () {
                      log('1 - button is pressed');
                    },
                    child: Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          log('- button is pressed');
                        },
                        child: Container(
                          child: Transform.translate(
                            offset: Offset(85.pw, 10.ph),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_rounded,
                                    color: AppColorsNew.newGreenButtonColor,
                                  ),
                                  onPressed: () {
                                    log('on - pressed');
                                    if (valueNotifierVal.value <=
                                        action.minRaiseAmount) return;
                                    valueNotifierVal.value--;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /* center widget - bet amount, bet button & slider */
                  Expanded(
                    flex: 20,
                    child: Stack(
                      children: [
                        /* seek slider */
                        Transform.translate(
                          offset: Offset(0, 70.ph),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: sleekSlider(),
                            ),
                          ),
                        ),

                        /* bet button */
                        Align(
                          alignment: Alignment.center,
                          child: Transform.translate(
                            offset: const Offset(0.0, -30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Consumer<ValueNotifier<double>>(
                                    builder: (_, vnVal, __) {
                                  return betButton1(vnVal);
                                })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* (+) button */
                  Expanded(
                    flex: 2,
                    child: Transform.translate(
                      offset: Offset(-80.pw, 10.ph),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.add_circle_rounded,
                              color: AppColorsNew.newGreenButtonColor,
                            ),
                            onPressed: () {
                              log('+ button');
                              if (valueNotifierVal.value >=
                                  action.maxRaiseAmount) return;
                              valueNotifierVal.value++;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /* button row for other bet options */
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0.0, 64.0),
                child: Container(
                  alignment: Alignment.center,
                  width: width / 1.5,
                  height: 65.ph,
                  child: betAmountList(valueNotifierVal),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget sleekSlider() {
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
            trackColor: AppColors.lightGrayColor,
            dotColor: AppColorsNew.newBorderColor,
            progressBarColors: [
              Colors.red,
              Colors.yellow,
              Colors.green,
            ],
          ),
          customWidths: CustomSliderWidths(
            trackWidth: 16,
            progressBarWidth: 16,
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
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
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
                          AppColorsNew.newGreenRadialStartColor,
                          AppColorsNew.newGreenRadialStopColor,
                        ],
                        stops: [
                          0.2,
                          0.8,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColorsNew.newGreenButtonColor,
                          offset: Offset(0, 1),
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                        )
                      ]),
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
          SizedBox(width: 10),
        ],
      );

  Widget betAmountList(ValueNotifier<double> vnValue) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0) {
          // show keyboard
          return _buildBetAmountChild(
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

              if (res != null) vnValue.value = res;
            },
          );
        }

        final option = action.options[index - 1];

        return _buildBetAmountChild(
          option: action.options[index - 1],
          onTap: () {
            vnValue.value = option.amount.toDouble();
          },
        );
      },
      itemCount: action.options.length + 1,
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
