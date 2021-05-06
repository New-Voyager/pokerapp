import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/pulsating_button.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BetWidget extends StatelessWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;

  BetWidget({
    @required this.action,
    this.onSubmitCallBack,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ListenableProvider<ValueNotifier<double>>(
      create: (_) => ValueNotifier<double>(
        action.minRaiseAmount.toDouble(),
      ),
      builder: (BuildContext context, _) {
        final valueNotifierVal = Provider.of<ValueNotifier<double>>(
          context,
          listen: false,
        );

        return FittedBox(
          fit: BoxFit.fitHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /* - button */
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.remove_circle_rounded),
                        color: Colors.blue,
                        onPressed: () {
                          if (valueNotifierVal.value <= action.minRaiseAmount)
                            return;
                          valueNotifierVal.value--;
                        },
                      ),
                    ),

                    /* center widget */
                    Container(
                      child: Stack(
                        children: [
                          /* seek slider */
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              height: height / 5,
                              width: width / 2,
                              child: sleekSlider(),
                            ),
                          ),

                          /* bet button */
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Transform.translate(
                              offset: Offset(0, 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Consumer<ValueNotifier<double>>(
                                    builder: (_, vnVal, __) => Container(
                                      width: 70,
                                      height: 70,
                                      child: PulsatingCircleIconButton(
                                        onTap: () =>
                                            onSubmitCallBack?.call(vnVal.value),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DataFormatter.chipsFormat(
                                                vnVal.value,
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "BET",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /* + button */
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_rounded,
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          if (valueNotifierVal.value >= action.maxRaiseAmount)
                            return;
                          valueNotifierVal.value++;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                width: width / 1.5,
                height: 64,
                child: betAmountList(valueNotifierVal),
              )
            ],
          ),
        );
      },
    );
  }

  Widget sleekSlider() {
    // log('min: ${action.minRaiseAmount} max: ${action.maxRaiseAmount} val: $val');

    return Consumer<ValueNotifier<double>>(
      builder: (_, vnValue, __) => SleekCircularSlider(
        onChange: (value) => vnValue.value = value,
        min: action.minRaiseAmount.toDouble(),
        max: action.maxRaiseAmount.toDouble(),
        initialValue: vnValue.value,
        appearance: CircularSliderAppearance(
          size: 350,
          startAngle: 180,
          angleRange: 180,
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
            dotColor: AppColors.buttonBorderColor,
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

  Widget betAmountList(ValueNotifier<double> vnValue) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0) {
          // show keyboard
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(children: [
              InkWell(
                onTap: () async {
                  double min = action.minRaiseAmount.toDouble();
                  double max = action.maxRaiseAmount.toDouble();

                  final double res = await NumericKeyboard.show(
                    context,
                    title: 'Enter your bet/raise amount ($min - $max)',
                    min: min,
                    max: max,
                  );

                  if (res != null) vnValue.value = res;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.0),
                      shape: BoxShape.circle,
                      color: Colors.white,
                      gradient: LinearGradient(
                        // begin: Alignment.topRight,
                        // end: Alignment.bottomLeft,
                        colors: [
                          Colors.indigo,
                          Colors.cyan,
                        ],
                      )),
                  child: Icon(Icons.keyboard, color: Colors.white),
                ),
              ),
              Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ]),
            SizedBox(width: 10),
          ]);
        }

        final option = action.options[index - 1];
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            InkWell(
              onTap: () {
                vnValue.value = option.amount.toDouble();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    //color: Colors.red,
                    border: Border.all(color: Colors.white, width: 1.0),
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      // begin: Alignment.topRight,
                      // end: Alignment.bottomLeft,
                      colors: [
                        Colors.indigo,
                        Colors.cyan,
                      ],
                    )),
                child: Text(
                  "${option.text}",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
            Text(
              "${option.amount.toInt().toString()}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ]),
          SizedBox(width: 10),
        ]);
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
