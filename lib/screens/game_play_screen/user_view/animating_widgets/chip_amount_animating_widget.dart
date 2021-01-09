import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';

const Map<int, Offset> offsetMapping = {
  1: Offset(0, -90),
  2: Offset(30, -40),
  3: Offset(40, 10),
  4: Offset(50, 100),
  5: Offset(50, 100),
  6: Offset(-50, 100),
  7: Offset(-20, 80),
  8: Offset(-20, 10),
  9: Offset(-50, -50),
};

class ChipAmountAnimatingWidget extends StatelessWidget {
  final int seatPos;
  final Widget child;

  ChipAmountAnimatingWidget({
    this.seatPos,
    this.child,
  });

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Offset>(
        curve: Curves.easeInOut,
        tween: Tween<Offset>(
          begin: Offset(0, 0),
          end: offsetMapping[seatPos],
        ),
        child: child,
        duration: AppConstants.animationDuration,
        builder: (_, offset, child) {
          double offsetPercentageLeft =
              1 - (offset.dy / offsetMapping[seatPos].dy);
          return Transform.translate(
            offset: offset,
            child: Opacity(
              opacity: offsetPercentageLeft,
              child: child,
            ),
          );
        },
      );
}
