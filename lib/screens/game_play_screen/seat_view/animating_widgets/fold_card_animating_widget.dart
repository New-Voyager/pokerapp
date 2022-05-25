import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';
import 'package:provider/provider.dart';

class FoldCardAnimatingWidget extends StatelessWidget {
  final Seat seat;
  final Widget child;

  FoldCardAnimatingWidget({
    this.seat,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isThrowCase = child != null;
    final openSeat = seat.isOpen;
    final ba = context.read<BoardAttributesObject>();

    Map<SeatPos, Offset> offsetMapping = ba.foldCardPos();

    return TweenAnimationBuilder<Offset>(
      curve: Curves.linearToEaseOut,
      tween: Tween<Offset>(
        begin: Offset.zero,
        end: offsetMapping[this.seat.seatPos],
      ),
      child: child ??
          HiddenCardView(
            noOfCards: seat.player.noOfCardsVisible,
          ),
      onEnd: () {
        if (!openSeat) {
          seat.player.animatingFold = false;
        }
      },
      duration: isThrowCase
          ? AppConstants.cardThrowAnimationDuration
          : AppConstants.animationDuration,
      builder: (_, offset, child) {
        /* percentage of animation done */
        double pertDone = offset.dx / offsetMapping[this.seat.seatPos].dx;

        /* we start fading away the card after the cards have moved animatingFold 90% */
        double opacityValue = pertDone > 0.90 ? (10 - 10 * pertDone) : 1.0;

        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: opacityValue,
            child: isThrowCase
                ? Transform.scale(
                    scale: max(1 - pertDone, 0.60),
                    child: child,
                  )
                : child,
          ),
        );
      },
    );
  }
}
