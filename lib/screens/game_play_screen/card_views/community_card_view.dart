import 'dart:developer';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
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

    int idx = 0;
    List<Widget> communityCards = [];
    for (var card in reversedList) {
      final GlobalKey globalKey = GlobalKey();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (cards?.isEmpty ?? true)
          CommunityCardAttribute.addEntry(idx, globalKey);
      });

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
            child: CommunityCardView(key: globalKey, card: card),
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
      return RiverOrFlopCommunityCards(
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

/*
*
* FLOP CARD VIEW (ANIMATION & FLOP CARDS DISPLAY)
*
* */

class FlopCommunityCards extends StatefulWidget {
  final List<Widget> flopCards;

  FlopCommunityCards({
    @required this.flopCards,
  });

  @override
  _FlopCommunityCardsState createState() => _FlopCommunityCardsState();
}

class _FlopCommunityCardsState extends State<FlopCommunityCards> {
  @override
  void initState() {
    print('\n\n\n\noffset positions:\n'
        '${CommunityCardAttribute.cardOffsets}\n'
        '\n\n\n\n');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.flopCards,
    );
  }
}

/*
*
* RIVER / TURN CARD ANIMATIONS & DISPLAY
*
* */
class RiverOrFlopCommunityCards extends StatefulWidget {
  final List<Widget> riverOrTurnCards;

  RiverOrFlopCommunityCards({
    Key key,
    @required this.riverOrTurnCards,
  }) : super(key: key);

  @override
  _RiverOrFlopCommunityCardsState createState() =>
      _RiverOrFlopCommunityCardsState();
}

class _RiverOrFlopCommunityCardsState extends State<RiverOrFlopCommunityCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.riverOrTurnCards,
    );
  }
}

/*
* 
* community card view (SINGLE CARD)
* 
* */
class CommunityCardView extends StatelessWidget {
  final CardObject card;

  CommunityCardView({
    Key key,
    @required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final CardView cardView = CardView(
      card: card,
      grayOut: false,
      widthRatio: 1.5,
    );
    final Widget cardWidget = cardView.buildCardWidget(context);
    /* for visible cards, the smaller card size is shown to the left of user,
    * and the bigger size is shown as the community card */

    // String cardBackAsset = CardBackAssets.asset1_1;
    // TODO:  WAY TO GET THE CARD BACK ASSET FOR CURRENT SETTINGS
    // try {
    //   cardBackAsset =
    //       Provider.of<ValueNotifier<String>>(context, listen: false).value;
    // } catch (_) {}

    return Transform.scale(
      scale: 1.2,
      child: Container(
        key: key,
        height: cardView.height,
        width: cardView.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.0)),
        child: cardWidget,
        // child: FlipCard(
        //   flipOnTouch: false,
        //   // key: cardKey,
        //   back: SizedBox(
        //     height: AppDimensions.cardHeight * 1.3,
        //     width: AppDimensions.cardWidth * 1.3,
        //     child: Image.asset(
        //       cardBackAsset,
        //       fit: BoxFit.fitHeight,
        //     ),
        //   ),
        //   front: cardWidget,
        // ),
      ),
    );
  }
}
