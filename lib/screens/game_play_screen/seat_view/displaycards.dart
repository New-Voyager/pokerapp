import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';

class DisplayCardsWidget extends StatelessWidget {
  final Seat seat;
  final FooterStatus status;

  DisplayCardsWidget(this.seat, this.status);

  @override
  Widget build(BuildContext context) {
    bool showDown = this.status == FooterStatus.Result;
    final seatPlayerCards = seat.player.cards;

    return Container(
      height: 19.50 * 3,
      child: AnimatedSwitcher(
        duration: AppConstants.fastAnimationDuration,
        child:
            showDown && (seatPlayerCards != null && seatPlayerCards.isNotEmpty)
                ? Transform.scale(
                    scale: 0.70, // fixme: WHAT IS THIS scale used for?
                    child: StackCardView(
                      cards: seat.player.cards?.map<CardObject>(
                            (int c) {
                              List<int> highlightedCards =
                                  seat.player.highlightCards;
                              CardObject card = CardHelper.getCard(c);

                              /* we use a small card type for display cards */
                              card.cardType = CardType.Small;

                              if (highlightedCards?.contains(c) ?? false)
                                card.highlight = true;

                              return card;
                            },
                          )?.toList() ??
                          [],
                    ),
                  )
                : SizedBox.shrink(),
      ),
    );
  }
}
