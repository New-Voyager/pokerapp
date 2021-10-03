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
    log('DisplayCards: name: ${seat.player.name} muck: ${seat.player.muckLosingHand} folded: ${seat.folded} seat.player.isActive: ${seat.player.isActive} reveal: ${seat.player.revealCards}');

    if (seat.player != null && seat.player.playerFolded) {
      if (seat.player.revealCards.length == 0) {
        return [];
      }
    }
    List<int> highlightedCards = seat.player.highlightCards;

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
      if (isWinner && showdown) {
        if (highlightedCards != null && highlightedCards.contains(cardNum)) {
          card.highlight = true;
        }
      } else if (seat.player.muckLosingHand) {
        // this player is not a winner
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
    log('Reveal Cards Seat: ${seat.player.seatNo} card objects: $cardObjects');

    return cardObjects;
  }

  Widget _buildStackCardView(List<int> cards, context) {
    if (cards.length == 4 || cards.length == 5) {
      return Transform.scale(
        scale: 1.5,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: StackCardView(cards: _getCards(cards)),
        ),
      );
    }

    // default case
    return StackCardView(cards: _getCards(cards));
  }

  @override
  Widget build(BuildContext context) {
    log('UpdateSeat: DisplayCardsWidget Seat: ${seat.player.seatNo} player: ${seat.player.name} cards: ${seat.player.cards} reveal cards: ${seat.player.revealCards}');
    // log('UpdateSeat: seat no: ${seat.player.seatNo} updating cards widget: ${seat.player.cards}');
    List<int> seatPlayerCards = seat.player.cards;
    if (seat.player.revealCards.isEmpty) {
      // player didn't reveal the cards
      // if this is not showdown, don't show the cards
      if (!showdown) {
        seatPlayerCards = [];
      }
    }
    return AnimatedSwitcher(
      duration: AppConstants.fastAnimationDuration,
      child: (seatPlayerCards != null && seatPlayerCards.isNotEmpty)
          ? _buildStackCardView(seatPlayerCards, context)
          : SizedBox.shrink(),
    );
  }
}
