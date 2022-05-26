import 'package:flutter/material.dart';
import 'package:pokerapp/screens/game_play_screen/widgets/custom_slider_widget.dart';

class CustomSlider extends StatelessWidget {
  final Gradient activeTrackBarGradient;
  final Color inactiveTrackBarColor;
  final Gradient thumbGradient;
  final double max;
  final double min;
  final List<double> values;
  final Function onChanged;

  const CustomSlider({
    Key key,
    this.activeTrackBarGradient,
    this.inactiveTrackBarColor,
    this.thumbGradient,
    this.max,
    this.min,
    this.values,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlutterSlider(
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: 10,
        inactiveTrackBarHeight: 10,
        inactiveTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: inactiveTrackBarColor ?? Colors.grey.shade800.withAlpha(180),
        ),
        activeTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: activeTrackBarGradient ??
              LinearGradient(
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade200,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
              ),
        ),
      ),
      handlerHeight: 30,
      handlerWidth: 30,
      handler: FlutterSliderHandler(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withAlpha(60),
                  ],
                  stops: [
                    0.2,
                    0.9,
                  ],
                ),
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: thumbGradient ??
                    LinearGradient(
                      colors: [
                        Colors.yellow,
                        Colors.yellow.shade800,
                      ],
                      begin: const FractionalOffset(0.7, 0.0),
                      end: const FractionalOffset(0.3, 1.0),
                      stops: [0.3, 0.75],
                    ),
              ),
            ),
          ],
        ),
      ),
      max: max,
      min: min,
      values: values,
      handlerAnimation: FlutterSliderHandlerAnimation(
          duration: Duration(milliseconds: 0), scale: 1),
      onDragging: onChanged,
      tooltip: FlutterSliderTooltip(
        disabled: true,
      ),
    );
  }
}
