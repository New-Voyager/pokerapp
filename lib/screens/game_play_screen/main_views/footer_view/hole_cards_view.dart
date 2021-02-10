import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';

import 'footer_action_view.dart';

// MyCardView represent the player who has hole cards
// The cards may be active or dead/folded
//
class HoleCardsView extends StatelessWidget {
  final PlayerModel playerModel;
  final FooterStatus footerStatus;

  const HoleCardsView({Key key, this.playerModel, this.footerStatus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      cards(
        playerFolded: playerModel.playerFolded,
        cards: playerModel?.cards?.map(
              (int c) {
                CardObject card = CardHelper.getCard(c);
                card.smaller = true;
                card.cardFace = CardFace.FRONT;

                return card;
              },
            )?.toList() ??
            List<CardObject>(),
      ),

      // action view (show when it is time for this user to act)
      footerStatus == FooterStatus.Action
          ? FooterActionView()
          : SizedBox(
              height: 0,
            )
    ]);
  }

  // the following two widgets are only built for the current active player
  Widget cards({
    List<CardObject> cards,
    @required playerFolded,
  }) {
    return Transform.scale(
      scale: 1.0,
      child: GestureDetector(
        onLongPressEnd: (_) {
          log('cards: onLongPressEND');
          for (var card in cards) {
            card.cardShowBack();
          }
        },
        onLongPress: () {
          log('cards: onLongPress');
          for (var card in cards) {
            card.cardShowFront();
          }
        },
        onDoubleTap: () {
          log('cards: onDoubleTap');
          for (int i = 0; i < cards.length; i++) {
            cards[i].flipCard();
          }
        },
        child: StackCardView(
          cards: cards,
          deactivated: playerFolded ?? false,
        ),
      ),
    );
  }
}
