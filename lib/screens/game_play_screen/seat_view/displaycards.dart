import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/card_helper.dart';

class DisplayCardsWidget extends StatelessWidget {
  final Seat seat;
  final bool showdown;
  final bool isReplayHandsActor;
  final bool colorCards;

  DisplayCardsWidget({
    @required this.seat,
    @required this.showdown,
    this.isReplayHandsActor = false,
    this.colorCards = false,
  });

  List<CardObject> _getCards(List<int> cards) {
    if (!isReplayHandsActor) {
      if (cards == null || cards.isEmpty) return [];

      if (seat.player != null && seat.player.playerFolded) {
        if (seat.player.revealCards.length == 0) {
          return [];
        }
      }
    }
    List<int> highlightedCards = seat.player.highlightCards;
    // log('RevealCards: name: ${seat.player.name} reveal: ${seat.player.revealCards}');
    //log('HiLo: name: ${seat.player.name} highlightedCards: ${highlightedCards} muck: ${seat.player.muckLosingHand} folded: ${seat.folded} seat.player.isActive: ${seat.player.isActive} reveal: ${seat.player.revealCards}');

    List<CardObject> cardObjects = [];
    for (int cardNum in cards) {
      CardObject card =
          CardHelper.getCard(cardNum, colorCards: this.colorCards);
      card.cardType = CardType.PlayerCard;
      card.dim = true;

      if (seat.player.revealCards.length > 0) {
        bool revealedCard = seat.player.revealCards.indexOf(card.cardNum) != -1;
        if (revealedCard) {
          card.reveal = true;
        }
      }

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
      if (isReplayHandsActor) {
        card.cardFace = CardFace.FRONT;
      }
      cardObjects.add(card);
    }

    return cardObjects;
  }

  Widget _buildStackCardView(List<int> cards, context) {
    if (cards == null || cards.length == 0) {
      return const SizedBox.shrink();
    }

    if (seat.player.playerFolded && seat.player.revealCards.length == 0) {
      return const SizedBox.shrink();
    }
    return NamePlateStackCardView(
      cards: _getCards(cards),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackCardView(
      seat.player.cards,
      context,
    );
  }
}
