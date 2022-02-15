import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:pokerapp/models/ui/app_theme.dart';

class PokerSlider extends StatefulWidget {
  final AppTheme theme;
  final int defaultValue;
  final int min;
  final int max;
  final Function onDragging;
  final Function onDragCompleted;

  const PokerSlider(
      {Key key,
      @required this.theme,
      @required this.defaultValue,
      this.onDragging,
      this.onDragCompleted,
      @required this.min,
      @required this.max})
      : super(key: key);
  @override
  State<PokerSlider> createState() => _SliderState();
}

class _SliderState extends State<PokerSlider> {
  int defaultValue;
  int value;
  @override
  void initState() {
    super.initState();
    defaultValue = widget.defaultValue;
    value = defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      handlerHeight: 20,
      handler: FlutterSliderHandler(
          child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      // colors: [
                      //   Colors.black38,
                      //   Colors.black87,
                      //   Colors.black,
                      // ],
                      colors: [
                        widget.theme.accentColorWithDark(0.1),
                        widget.theme.accentColorWithDark(0.2),
                        widget.theme.accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)))),
      tooltip: FlutterSliderTooltip(
        disabled: true,
      ),
      values: [value.toDouble()],
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: 8,
        inactiveTrackBarHeight: 8,
        inactiveTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: widget.theme.accentColor),
        ),
        activeTrackBar: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.theme.accentColor,
            border: Border.all(width: 1, color: widget.theme.accentColor)),
      ),
      max: widget.max.toDouble(),
      min: widget.min.toDouble(),
      onDragCompleted: (val, val1, val2) {
        //gmp.bombPotHandInterval = val1.toInt();
        value = val1.toInt();
        if (widget.onDragging != null) {
          widget.onDragging(value);
        }
        //setState(() {});
      },
      onDragging: (handlerIndex, lowerValue, upperValue) {
        value = lowerValue.toInt();
        if (widget.onDragCompleted != null) {
          widget.onDragCompleted(value);
        }
        //gmp.bombPotHandInterval = lowerValue.toInt();
        //setState(() {});
      },
    );
  }
}
