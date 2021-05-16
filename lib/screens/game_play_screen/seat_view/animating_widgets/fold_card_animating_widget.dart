import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';

const Map<int, Offset> offsetMapping = {
  1: Offset(20, -140),
  2: Offset(100, -120),
  3: Offset(100, -50),
  4: Offset(100, 0),
  5: Offset(30, 20),
  6: Offset(-10, 20),
  7: Offset(-70, 0),
  8: Offset(-70, -50),
  9: Offset(-70, -120),
};

class FoldCardAnimatingWidget extends StatelessWidget {
  final Seat seat;
  FoldCardAnimatingWidget({
    this.seat,
  });

  @override
  Widget build(BuildContext context) {
    final openSeat = seat.isOpen;

    final widget = TweenAnimationBuilder<Offset>(
      curve: Curves.linearToEaseOut,
      tween: Tween<Offset>(
        begin: Offset(0, 0),
        end: offsetMapping[this.seat.serverSeatPos],
      ),
      child: HiddenCardView(
        noOfCards: seat.player.noOfCardsVisible,
      ),
      onEnd: () {
        if (!openSeat) {
          seat.player.animatingFold = false;
        }
      },
      duration: AppConstants.animationDuration,
      builder: (_, offset, child) {
        /* percentage of animation done */
        double pertDone = offset.dx / offsetMapping[this.seat.serverSeatPos].dx;

        /* we start fading away the card after the cards have moved 90% */
        double opacityValue = pertDone > 0.90 ? (10 - 10 * pertDone) : 1.0;

        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: opacityValue,
            child: child,
          ),
        );
      },
    );
    return widget;
  }
}
