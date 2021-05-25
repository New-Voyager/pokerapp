import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/multiple_stack_card_views.dart';
import 'package:pokerapp/utils/card_helper.dart';

class DisplayCardsWidget extends StatelessWidget {
  final Seat seat;
  final FooterStatus status;

  DisplayCardsWidget(this.seat, this.status);

  List<CardObject> _getCards(List<int> cards) {
    if (cards == null || cards.isEmpty) return [];

    List<int> highlightedCards = seat.player.highlightCards;

    final List<CardObject> cardObjects = cards.map<CardObject>(
      (int c) {
        CardObject card = CardHelper.getCard(c);
        card.cardType = CardType.PlayerCard;

        /* we dim cards ONLY IF other cards are highlighted */

        if (highlightedCards?.contains(c) ?? false)
          card.highlight = true;
        else
          card.dim = true;

        if (highlightedCards == null || highlightedCards.isEmpty)
          card.dim = false;

        return card;
      },
    ).toList();

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
    bool needToShowCards = this.status == FooterStatus.Result;
    final seatPlayerCards = seat.player.cards;

    return AnimatedSwitcher(
      duration: AppConstants.fastAnimationDuration,
      child: needToShowCards &&
              (seatPlayerCards != null && seatPlayerCards.isNotEmpty)
          ? _buildStackCardView(seatPlayerCards, context)
          : SizedBox.shrink(),
    );
  }
}
