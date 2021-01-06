import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';

const Map<int, Offset> offsetMapping = {
  1: Offset(0, -90),
  2: Offset(30, -40),
  3: Offset(20, 10),
  4: Offset(30, 80),
  5: Offset(50, 50),
  6: Offset(-50, 50),
  7: Offset(-20, 80),
  8: Offset(-20, 10),
  9: Offset(-30, -40),
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
