import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/widgets/cards/hidden_card_view.dart';

import 'animating_widgets/fold_card_animating_widget.dart';

class PlayerCardsWidget extends StatelessWidget {
  final Seat seat;
  final Alignment alignment;
  final bool showdown;
  final int noCards;
  final BoardAttributesObject boardAttributes;
  final GameState gameState;

  const PlayerCardsWidget(
    this.boardAttributes,
    this.gameState,
    this.seat,
    this.alignment,
    this.noCards,
    this.showdown,
  );

  @override
  Widget build(BuildContext context) {
    // if (seat.folded ?? false) {
    //   return shrinkedSizedBox;
    // }

    double shiftMultiplier = 1.0;
    if (this.noCards == 5) shiftMultiplier = 1.7;
    if (this.noCards == 4) shiftMultiplier = 1.45;
    if (this.noCards == 3) shiftMultiplier = 1.25;
    log('PlayerCardsWidget: building ${seat.serverSeatPos}');
    double xOffset;
    if (showdown)
      xOffset = (alignment == Alignment.centerLeft ? 1 : -1) *
          25.0 *
          (seat.cards?.length ?? 0.0);
    else {
      xOffset =
          (alignment == Alignment.centerLeft ? 35.0 : -45.0 * shiftMultiplier);
      xOffset = -45.0 * shiftMultiplier;
    }
    if (showdown) {
      return const SizedBox.shrink();
    } else if (seat.folded ?? false) {
      log('PlayerCardsWidget: [${seat.serverSeatPos}] Folded cards');
      return Transform.translate(
        offset: Offset(
          xOffset * 0.30,
          45.0,
        ),
        child: FoldCardAnimatingWidget(seat: seat),
      );
    } else {
      double xoffset = 0.90;
      double scale = 0.80;
      if (this.noCards == 5) {
        scale = 0.75;
        xoffset = 0.55;
      }
      if (this.noCards == 4) {
        scale = 0.75;
        xoffset = 0.75;
      }
      //log('Hole cards');
      log('PlayerCardsWidget: [${seat.serverSeatPos}] Hidden cards');
      Widget plateHoleCards = Transform.translate(
        offset: Offset(
          xOffset * xoffset,
          25.0,
        ),
        child: Transform.scale(
          scale: scale,
          child: HiddenCardView(noOfCards: this.noCards),
        ),
      );

      return Transform.translate(
        offset: boardAttributes.playerHoleCardOffset,
        child: Transform.scale(
          scale: boardAttributes.playerHoleCardScale,
          child: gameState.handState == HandState.RESULT
              ? SizedBox(width: 0, height: 0)
              : plateHoleCards,
        ),
      );
    }
  }
}

/*
              Transform.translate(
                offset: boardAttributes.playerHoleCardOffset,
                child: Transform.scale(
                  scale: boardAttributes.playerHoleCardScale,
                  child: gameState.handState == HandState.RESULT
                      ? SizedBox(width: 0, height: 0)
                      : PlayerCardsWidget(
                          widget.seat,
                          this.widget.cardsAlignment,
                          widget.seat.player?.noOfCardsVisible,
                          showdown,
                        ),
                ),
              )
              */
