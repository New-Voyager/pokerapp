import 'dart:developer';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_cards_view/community_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_cards_view/flop_community_cards.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/community_cards_view/turn_or_river_community_cards.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/card_view.dart';
import 'package:provider/provider.dart';
import 'package:pokerapp/resources/card_back_assets.dart';

const double pullUpOffset = -15.0;

/* THIS VIEW ITSELF TAKES CARE OF THE ANIMATION PART FOR THE COMMUNITY CARDS */

class CommunityCardsView extends StatelessWidget {
  final List<CardObject> cards;
  final bool horizontal;

  CommunityCardsView({
    @required this.cards,
    this.horizontal = true,
  });

  List<Widget> getCommunityCards() {
    List<CardObject> reversedList = this.cards?.reversed?.toList() ?? [];

    if (cards?.isEmpty ?? true) {
      /* if empty, make dummy cards to calculate positions */
      /* why I choose 17? No reason!!! */
      for (int i = 0; i < 5; i++) {
        reversedList.add(CardHelper.getCard(17));
      }
    }

    Map<int, GlobalKey> _globalKeys = Map();
    List<Widget> communityCards = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _globalKeys.forEach((idx, globalKey) {
        CommunityCardAttribute.addEntry(idx, globalKey);
      });
    });

    int idx = 0;
    for (var card in reversedList) {
      GlobalKey globalKey;

      if (!CommunityCardAttribute.hasEntry(idx)) {
        globalKey = GlobalKey();
        _globalKeys[idx] = globalKey;
      }

      /* THIS widget is a wrapper around the community card view, and helps in case of we need to highlight a card */
      Widget communityCardView = Container(
        margin: EdgeInsets.only(right: 2.0),
        child: Transform.translate(
          offset: Offset(
            0.0,
            card.highlight ? pullUpOffset : 0.0,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            child: CommunityCardView(
              key: globalKey,
              card: card,
            ),
          ),
        ),
      );
      communityCards.add(communityCardView);

      idx += 1;
    }
    return communityCards.toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    /* we only need to show animation for the following 3 cases */

    if (cards?.length == 3)
      return FlopCommunityCards(
        flopCards: getCommunityCards(),
      );

    if (cards?.length == 4 || cards?.length == 5)
      return TurnOrRiverCommunityCards(
        key: ValueKey(cards.length),
        riverOrTurnCards: getCommunityCards(),
      );

    /* default case - this is done to bake our data for animating in the future */
    return Opacity(
      /* if there are no community cards, do not show anything */
      opacity: (cards?.isEmpty ?? true) ? 0.0 : 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getCommunityCards(),
      ),
    );
  }
}
