import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/services/audio/audio_service.dart';

class BetSlider extends StatefulWidget {
  BetSlider({Key key}) : super(key: key);

  @override
  State<BetSlider> createState() => _BetSliderState();
}

class _BetSliderState extends State<BetSlider> {
  String swipeDirection;

  List<GlobalKey> keys = [];
  Size chipSize = Size(60, 30);
  double overlapFactor = 2.7;
  List<double> keyPos = [];
  List<double> chipsXOffset = [];
  List<bool> keyVisibility = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    int size = 10;
    for (int i = 0; i < size; i++) {
      keys.add(GlobalKey());
      keyPos.add(0);
      if (i == 0) {
        keyVisibility.add(true);
        chipsXOffset.add(0);
      } else {
        double posXOffset = random(0, chipSize.width ~/ 10).toDouble();
        int sign = random(0, 1);
        if (sign == 0) {
          posXOffset = -posXOffset;
        }
        chipsXOffset.add(posXOffset);
        keyVisibility.add(false);
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
      if (posY < keyPos[i] + chipSize.height) {
        setState(() {
          if (!keyVisibility[i]) {
            AudioService.playBet(mute: false);
            keyVisibility[i] = true;
          }
        });
      } else {
        setState(() {
          keyVisibility[i] = false;
        });
      }
    }
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
              height: chipSize.height,
              child: SvgPicture.asset(
                'assets/images/betchips/bet_chips_blue.svg',
                fit: BoxFit.fill,
                width: chipSize.width,
              ),
            ),
          ),
        ),
      ));
      position = position + chipSize.height / overlapFactor;
    }

    return GestureDetector(
      onVerticalDragUpdate: (final details) {
        _processPointer(details);
      },
      onTapDown: (final details) {
        _processPointer(details);
      },
      child: Container(
        color: Colors.grey.shade800,
        padding: EdgeInsets.all(9),
        child: Container(
          height: (chipSize.height * keys.length) / overlapFactor +
              chipSize.height * (1 - 1 / overlapFactor),
          width: chipSize.width,
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
