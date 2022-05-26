import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/services/audio/audio_service.dart';

class BetSlider extends StatefulWidget {
  final Function(double) onChanged;
  final double max;
  final double min;
  final int chipsCount;
  final double initialValue;
  final Size chipSize;

  BetSlider(
      {Key key,
      this.chipsCount = 10,
      this.onChanged,
      this.chipSize = const Size(60, 30),
      @required this.max,
      @required this.min,
      @required this.initialValue})
      : super(key: key);

  @override
  State<BetSlider> createState() => _BetSliderState();
}

class _BetSliderState extends State<BetSlider> {
  String swipeDirection;

  List<GlobalKey> keys = [];
  double overlapFactor = 2.7;
  List<double> keyPos = [];
  List<double> chipsXOffset = [];
  List<bool> keyVisibility = [];

  double prevValue = 0;
  double value = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    int visibleCount = (1 +
            ((widget.initialValue - widget.min) *
                (widget.chipsCount - 1) /
                (widget.max - widget.min)))
        .toInt();

    for (int i = 0; i < widget.chipsCount; i++) {
      keys.add(GlobalKey());
      keyPos.add(0);
      if (i == 0) {
        keyVisibility.add(true);
        chipsXOffset.add(0);
      } else {
        double posXOffset = random(0, widget.chipSize.width ~/ 10).toDouble();
        int sign = random(0, 1);
        if (sign == 0) {
          posXOffset = -posXOffset;
        }
        chipsXOffset.add(posXOffset);
        if (i >= visibleCount) {
          keyVisibility.add(false);
        } else {
          keyVisibility.add(true);
        }
      }
    }
  }

  _afterLayout(_) {
    for (int i = 0; i < keys.length; i++) {
      RenderBox box = keys[i].currentContext.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);
      keyPos[i] = position.dy;
    }
  }

  _processPointer(details) {
    double posY = details.globalPosition.dy;

    for (int i = 1; i < keys.length; i++) {
      if (posY < keyPos[i] + widget.chipSize.height) {
        // setState(() {
        if (!keyVisibility[i]) {
          // AudioService.playBet(mute: false);
          keyVisibility[i] = true;
        }
        // });
      } else {
        // setState(() {
        keyVisibility[i] = false;
        // });
      }
    }

    _processProgress(posY);
    // _processProgressDiscrete();
  }

  _processProgress(double pos) {
    // dev.log(pos.toString() +
    //     " " +
    //     keyPos[0].toString() +
    //     " " +
    //     keyPos[widget.size - 1].toString());

    int visibleCount = 0;

    keyVisibility.forEach((element) {
      if (element) {
        visibleCount++;
      }
    });

    // value = widget.min +
    //     (widget.max - widget.min) *
    //         ((pos - keyPos[widget.size - 1] - chipSize.height) /
    //             ((keyPos[0] - chipSize.height) -
    //                 (keyPos[widget.size - 1] - chipSize.height)));
    // dev.log(value.toString());

    double pointerPos = (pos - widget.chipSize.height);
    double minPos =
        (keyPos[widget.chipsCount - 1] - widget.chipSize.height / 2);
    double maxPos = (keyPos[0]) - widget.chipSize.height / 6;

    dev.log((pointerPos).toString() +
        " " +
        maxPos.toString() +
        " " +
        minPos.toString());

    if (pointerPos <= minPos) {
      value = widget.min;
    } else if (pointerPos >= maxPos) {
      value = widget.max;
    } else {
      value = widget.min +
          (widget.max - widget.min) *
              ((pointerPos - minPos) / (maxPos - minPos));
    }

    value = widget.max + widget.min - value;

    if (value >= widget.min && value <= widget.max) {
      if (value != prevValue) {
        prevValue = value;
        widget.onChanged(value);
      }
    }
  }

  _processProgressDiscrete() {
    int visibleCount = 0;

    keyVisibility.forEach((element) {
      if (element) {
        visibleCount++;
      }
    });

    value = widget.min +
        (widget.max - widget.min) *
            ((visibleCount - 1) / (widget.chipsCount - 1));

    if (value != prevValue) {
      dev.log(value.toString());
      prevValue = value;
      widget.onChanged(value);
    }
  }

  void _setProgress(int value) {
    for (int i = 0; i < widget.chipsCount; i++) {
      if (i >= value) {
        keyVisibility[i] = (false);
      } else {
        keyVisibility[i] = (true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant BetSlider oldWidget) {
    value = widget.initialValue;

    int visibleCount = (1 +
            ((widget.initialValue - widget.min) *
                (widget.chipsCount - 1) /
                (widget.max - widget.min)))
        .toInt();

    for (int i = 0; i < widget.chipsCount; i++) {
      if (i >= visibleCount) {
        keyVisibility[i] = (false);
      } else {
        keyVisibility[i] = (true);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var childrens = [];
    double position = 0;
    for (int i = 0; i < keys.length; i++) {
      childrens.add(Positioned(
        bottom: position,
        child: Transform.translate(
          offset: Offset(chipsXOffset[i], 0),
          child: Opacity(
            opacity: keyVisibility[i] ? 1 : 0,
            child: Container(
              key: keys[i],
              height: widget.chipSize.height,
              child: SvgPicture.asset(
                'assets/images/betchips/bet_chips_blue.svg',
                fit: BoxFit.fill,
                width: widget.chipSize.width,
              ),
            ),
          ),
        ),
      ));
      position = position + widget.chipSize.height / overlapFactor;
    }

    return GestureDetector(
      onVerticalDragUpdate: (final details) {
        _processPointer(details);
      },
      onTapDown: (final details) {
        _processPointer(details);
      },
      child: Container(
        // color: Colors.grey.shade800,
        padding: EdgeInsets.all(9),
        child: Container(
          height: (widget.chipSize.height * keys.length) / overlapFactor +
              widget.chipSize.height * (1 - 1 / overlapFactor),
          width: widget.chipSize.width,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              // alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/slide_up.png',
                      ),
                    ),
                  ),
                ),
                ...childrens
              ],
            ),
          ),
        ),
      ),
    );
  }

  int random(min, max) {
    return min + Random().nextInt(max - min);
  }
}
