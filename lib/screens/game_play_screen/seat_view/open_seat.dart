
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';

class OpenSeat extends StatelessWidget {
  final int seatPos;
  final Function(int) onUserTap;

  const OpenSeat({
    this.seatPos,
    this.onUserTap,
    Key key,
  }) : super(key: key);

  Widget _openSeat() {

    return InkWell(
          onTap: () {
            log('Pressed $seatPos');
            this.onUserTap(seatPos);
          },
          child: Padding(
        padding: const EdgeInsets.all(5),

        // child: AnimatedTextKit(
        //     animatedTexts: [
        //       ColorizeAnimatedText(
        //         'Open $seatPos',
        //         textStyle: AppColors.openSeatTextStyle,
        //         colors: AppColors.openSeatColors,
        //       ),
        //     ],
        //     isRepeatingAnimation: true,
        //   ),
          child: Text(
            'Open $seatPos',
            style: AppStyles.openSeatTextStyle,
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      padding: const EdgeInsets.all(10.0),
      child: _openSeat(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0XFF494444),
      ),
    );
  }
}