import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/hidden_card_view.dart';

const Map<int, Offset> offsetMapping = {
  -1: Offset(0, 0),
  1: Offset(20, -140),
  2: Offset(80, -80),
  3: Offset(80, -50),
  4: Offset(80, -30),
  5: Offset(50, 50),
  6: Offset(-50, 50),
  7: Offset(-80, -30),
  8: Offset(-80, -50),
  9: Offset(-80, -80),
};

class FoldCardAnimatingWidget extends StatelessWidget {
  final seatPos;
  FoldCardAnimatingWidget({
    this.seatPos,
  });

  @override
  Widget build(BuildContext context) {
    log('offset end value: ${seatPos}');

    return TweenAnimationBuilder<Offset>(
      curve: Curves.easeInOut,
      tween: Tween<Offset>(
        begin: Offset(0, 0),
        end: offsetMapping[seatPos],
      ),
      child: HiddenCardView(),
      duration: AppConstants.animationDuration,
      builder: (_, offset, child) {
        double offsetPercentageLeft =
            1 - (offset.dx / offsetMapping[seatPos].dx);

        // todo: the opacity change can be smoothed out

        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: offsetPercentageLeft == 0.0 ? 0.0 : 1.0,
            child: child,
          ),
        );
      },
    );
  }
}
