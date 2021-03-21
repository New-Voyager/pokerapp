import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:provider/provider.dart';

class ChipAmountAnimatingWidget extends StatelessWidget {
  final int seatPos;
  final Widget child;
  final bool reverse;

  ChipAmountAnimatingWidget({
    this.seatPos,
    this.child,
    this.reverse,
  });

  @override
  Widget build(BuildContext context) => Consumer<BoardAttributesObject>(
        builder: (_, boardAttrObj, __) => TweenAnimationBuilder<Offset>(
          curve: Curves.easeInOut,
          tween: (reverse ?? false)
              ? Tween<Offset>(
                  begin: boardAttrObj.chipAmountAnimationOffsetMapping[seatPos],
                  end: Offset(0, 0),
                )
              : Tween<Offset>(
                  begin: Offset(0, 0),
                  end: boardAttrObj.chipAmountAnimationOffsetMapping[seatPos],
                ),
          child: child,
          duration: AppConstants.animationDuration,
          builder: (_, offset, child) {
            double offsetPercentageLeft;
            if (reverse ?? false)
              offsetPercentageLeft = 1;
            else
              offsetPercentageLeft = 1 -
                  (offset.dy /
                      boardAttrObj
                          .chipAmountAnimationOffsetMapping[seatPos].dy);

            return Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: offsetPercentageLeft,
                child: child,
              ),
            );
          },
        ),
      );
}
