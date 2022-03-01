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

class CommunityCardsView extends StatefulWidget {
  final List<CardObject> cards;
  final List<CardObject> cardsOther;
  final bool twoBoardsNeeded;
  final bool horizontal;

  CommunityCardsView({
    Key key,
    @required this.cards,
    this.cardsOther,
    this.twoBoardsNeeded,
    this.horizontal = true,
  }) : super(key: key);

  @override
  State<CommunityCardsView> createState() => _CommunityCardsViewState();
}

class _CommunityCardsViewState extends State<CommunityCardsView> {
  final Map<int, GlobalKey> _globalKeys = Map();

  List<Widget> getCommunityCards(
    List<CardObject> cards, {
    bool dimBoard = false,
  }) {
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

    final List<Widget> communityCards = [];

    int idx = 4;
    for (var card in reversedList) {
      GlobalKey globalKey;

      card.dimBoard = false;
      if (dimBoard) {
        card.dimBoard = true;
      }
      if (widget.twoBoardsNeeded) {
        card.doubleBoard = true;
      }

      if (!CommunityCardAttribute.hasEntry(idx)) {
        print('community cards: No previous entry for $idx\'s position');
        /* only add an entry, if there is no previous entry available */
        globalKey = GlobalKey();

        /* collect for offset calculation : offset is calculated post the widget tree is build */
        _globalKeys[idx] = globalKey;
      }

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

    return communityCards;
  }

  Widget buildSingleBoardCards(
    int boardNo,
    List<CardObject> boardCards, {
    bool dimBoard = false,
  }) {
    /* we only need to show animation for the following 3 cases */
    if (boardCards?.length == 3)
      return FlopCommunityCards(
        flopCards: getCommunityCards(boardCards, dimBoard: dimBoard),
        twoBoards: widget.twoBoardsNeeded ?? false,
      );

    if (boardCards?.length == 4 || boardCards?.length == 5)
      return TurnOrRiverCommunityCards(
        key: ValueKey('$boardNo-${boardCards.length}'),
        riverOrTurnCards: getCommunityCards(boardCards, dimBoard: dimBoard),
        twoBoards: widget.twoBoardsNeeded ?? false,
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

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _globalKeys.forEach((idx, globalKey) {
        CommunityCardAttribute.addEntry(idx, globalKey);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final tableState = gameState.tableState;

    if (widget.twoBoardsNeeded ?? false) {
      return Column(
        children: [
          /* board 1 cards */
          buildSingleBoardCards(
            1,
            widget.cards,
            dimBoard: tableState.dimBoard1,
          ),

          /* divider */
          const SizedBox(height: 2.0),

          /* board 2 cards */
          buildSingleBoardCards(
            2,
            widget.cardsOther,
            dimBoard: tableState.dimBoard2,
          ),
        ],
      );
    }

    return buildSingleBoardCards(1, widget.cards);
  }
}
