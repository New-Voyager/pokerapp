import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/community_card_view.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/flop_community_cards.dart';
import 'package:pokerapp/widgets/cards/community_cards_view/turn_or_river_community_cards.dart';

/* THIS VIEW ITSELF TAKES CARE OF THE ANIMATION PART FOR THE COMMUNITY CARDS */

class CommunityCardsView extends StatelessWidget {
  final List<CardObject> cards;
  final List<CardObject> cardsOther;
  final bool twoBoardsNeeded;
  final bool horizontal;
  CommunityCardsView({
    @required this.cards,
    this.cardsOther,
    this.twoBoardsNeeded,
    this.horizontal = true,
  });

  List<Widget> getCommunityCards(List<CardObject> cards,
      {bool dimBoard = false}) {
    List<CardObject> reversedList = cards?.toList() ?? [];

    /* if we do not have an already existing entry, then only go for the dummy card */
    if (!CommunityCardAttribute.hasEntry(0) && (cards?.isEmpty ?? true)) {
      /* if empty, make dummy cards to calculate positions */
      /* why I choose 17? No reason!!! */
      for (int i = 0; i < 5; i++) {
        final card = CardHelper.getCard(17);
        card.cardType = CardType.CommunityCard;
        if (dimBoard) {
          card.dimBoard = true;
        }
        reversedList.add(card);
      }
    } else {
      if (cards?.isEmpty ?? true) {
        // if we have no cards to show, add a dummy card
        final card = CardHelper.getCard(17);
        card.cardType = CardType.CommunityCard;
        reversedList.add(card);
      }
    }

    Map<int, GlobalKey> _globalKeys = Map();
    List<Widget> communityCards = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _globalKeys.forEach((idx, globalKey) {
        CommunityCardAttribute.addEntry(idx, globalKey);
      });
    });

    int idx = 4;
    for (var card in reversedList) {
      GlobalKey globalKey;
      card.dimBoard = false;
      if (dimBoard) {
        card.dimBoard = true;
      }
      if (!CommunityCardAttribute.hasEntry(idx)) {
        /* only add an entry, if there is no previous entry available */
        globalKey = GlobalKey();

        /* collect for offset calculation : offset is calculated post the widget tree is build */
        _globalKeys[idx] = globalKey;
      }

      log('Card dim 3: dimboard: ${card.dimBoard}');

      Widget communityCardView = Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5),
        child: CommunityCardView(
          key: globalKey,
          card: card,
        ),
      );
      communityCards.add(communityCardView);

      idx -= 1;
    }
    return communityCards.toList();
  }

  Widget buildSingleBoardCards(int boardNo, List<CardObject> boardCards,
      {bool dimBoard = false}) {
    log('CommunityCardsView board: ${boardNo} dimBoard: $dimBoard');
    /* we only need to show animation for the following 3 cases */
    if (boardCards?.length == 3)
      return FlopCommunityCards(
        flopCards: getCommunityCards(boardCards, dimBoard: dimBoard),
      );

    if (boardCards?.length == 4 || boardCards?.length == 5)
      return TurnOrRiverCommunityCards(
        key: ValueKey('$boardNo-${boardCards.length}'),
        riverOrTurnCards: getCommunityCards(boardCards, dimBoard: dimBoard),
      );

    /* default case - this is done to bake our data for animating in the future */
    return Opacity(
      /* if there are no community cards, do not show anything */
      opacity: (boardCards?.isEmpty ?? true) ? 0.0 : 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getCommunityCards(boardCards, dimBoard: dimBoard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('community cards');

    final gameState = GameState.getState(context);
    final tableState = gameState.getTableState(context);
    log('Table state: dim board1: ${tableState.dimBoard1} dim board2: ${tableState.dimBoard2}');

    if (twoBoardsNeeded ?? false) {
      return Transform.scale(
        alignment: Alignment.topCenter,
        scale: 0.70,
        child: Column(
          children: [
            /* board 1 cards */
            buildSingleBoardCards(1, cards, dimBoard: tableState.dimBoard1),

            /* divider */
            const SizedBox(height: 12.0),

            /* board 2 cards */
            buildSingleBoardCards(2, cardsOther,
                dimBoard: tableState.dimBoard2),
          ],
        ),
      );
    }

    return buildSingleBoardCards(1, cards);
  }
}
