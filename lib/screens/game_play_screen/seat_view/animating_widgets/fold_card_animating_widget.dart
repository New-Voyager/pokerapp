import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';
import 'package:provider/provider.dart';

class FoldCardAnimatingWidget extends StatelessWidget {
  final Seat seat;
  FoldCardAnimatingWidget({
    this.seat,
  });

  @override
  Widget build(BuildContext context) {
    // if (!seat.player.animatingFold) {
    //   return Container();
    // }
    final openSeat = seat.isOpen;
    final ba = context.read<BoardAttributesObject>();

    Map<SeatPos, Offset> offsetMapping = ba.foldCardPos();

    final widget = TweenAnimationBuilder<Offset>(
      curve: Curves.linearToEaseOut,
      tween: Tween<Offset>(
        begin: Offset.zero,
        end: offsetMapping[this.seat.seatPos],
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
        double pertDone = offset.dx / offsetMapping[this.seat.seatPos].dx;
        log('fold animation: seat pos: ${seat.seatPos.toString()} seat no: ${seat.serverSeatPos} offset: $offset duration: ${AppConstants.animationDuration}');

        /* we start fading away the card after the cards have moved animatingFold90% */
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
