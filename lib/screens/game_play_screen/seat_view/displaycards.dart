import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/card_helper.dart';

class DisplayCardsWidget extends StatelessWidget {
  final Seat seat;
  final bool showdown;

  DisplayCardsWidget(this.seat, this.showdown);

  List<CardObject> _getCards(List<int> cards) {
    if (cards == null || cards.isEmpty) return [];

    if (seat.player != null && seat.player.playerFolded) {
      if (seat.player.revealCards.length == 0) {
        return [];
      }
    }
    List<int> highlightedCards = seat.player.highlightCards;
    // log('RevealCards: name: ${seat.player.name} reveal: ${seat.player.revealCards}');
    //log('HiLo: name: ${seat.player.name} highlightedCards: ${highlightedCards} muck: ${seat.player.muckLosingHand} folded: ${seat.folded} seat.player.isActive: ${seat.player.isActive} reveal: ${seat.player.revealCards}');

    List<CardObject> cardObjects = [];
    for (int cardNum in cards) {
      CardObject card = CardHelper.getCard(cardNum);
      card.cardType = CardType.PlayerCard;
      card.dim = true;

      // if we are in showdown and this player is a winner, show his cards
      bool isWinner = false;
      if (seat.player.winner ?? false) {
        isWinner = true;
      }
      card.cardFace = CardFace.BACK;
      if (showdown) {
        card.cardFace = CardFace.FRONT;
      }
      if (isWinner) {
        if (highlightedCards != null && highlightedCards.contains(cardNum)) {
          card.highlight = true;
        }
      } else if (seat.player.muckLosingHand) {
        card.cardFace = CardFace.BACK;
      }

      if (seat.player.playerFolded) {
        card.cardFace = CardFace.BACK;
      }

      // did this player reveal any cards?
      if (seat.player.revealCards.contains(cardNum)) {
        card.cardFace = CardFace.FRONT;
      }
      cardObjects.add(card);
    }

    return cardObjects;
  }

  Widget _buildStackCardView(List<int> cards, context) {
    if (cards == null || cards.length == 0) {
      return Container();
    }

    if (seat.player.playerFolded && seat.player.revealCards.length == 0) {
      return Container();
    }

    double scale = 1.0;
    Offset offset = Offset(0, 0);
    if (cards.length == 4 || cards.length == 5) {
      offset = Offset(-18, 10);
      if (cards.length == 5) {
        scale = 0.85;
        offset = Offset(-30, 10);
      }
    }
    return Transform.translate(
        offset: offset,
        child: Transform.scale(
          scale: scale,
          child: StackCardView(
            cards: _getCards(cards),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<int> seatPlayerCards = seat.player.cards;
    if (seat.player.revealCards.isEmpty) {
      // player didn't reveal the cards
      // if this is not showdown, don't show the cards
      // if (!showdown) {
      //   seatPlayerCards = [];
      // }
    }
    return AnimatedSwitcher(
      duration: AppConstants.fastAnimationDuration,
      child: (seatPlayerCards != null && seatPlayerCards.isNotEmpty)
          ? _buildStackCardView(seatPlayerCards, context)
          : SizedBox.shrink(),
    );
  }
}
