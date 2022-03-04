import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/utils.dart';
import 'package:pokerapp/widgets/cards/player_hole_card_view.dart';
import 'package:pokerapp/widgets/page_curl/page_curl.dart';
import 'package:provider/provider.dart';

class HoleStackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool deactivated;
  final bool isCardVisible;

  HoleStackCardView({
    @required this.cards,
    this.deactivated = false,
    this.isCardVisible = false,
  });

  Size _getTotalCardsSize(BuildContext context, double displacementValue) {
    final gameState = GameState.getState(context);
    final double sch = gameState.gameUIState.cardSize.height;
    final double scw = gameState.gameUIState.cardSize.width;

    final double tw = scw + displacementValue * (cards.length - 1);

    return Size(tw, sch);
  }

  List<Widget> _getChildren({
    @required BuildContext context,
    @required int mid,
    @required MarkedCards markedCards,
    @required double displacementValue,
    bool isCardVisible = false,
    bool fanOut = false,
  }) {
    List<Widget> children = List.generate(
      cards.length,
      (i) {
        final offsetInX = -(i - mid) * displacementValue;

        final card = Transform.translate(
          offset: Offset(offsetInX, 0),
          child: Builder(
            builder: (context) => PlayerHoleCardView(
              marked: markedCards.isMarked(cards[i]),
              onMarkTapCallback: () {
                final gameState = GameState.getState(context);
                markedCards.mark(
                    cards[i], gameState.handState == HandState.RESULT);
              },
              card: cards[i],
              dim: deactivated,
              isCardVisible: isCardVisible,
            ),
          ),
        );
        if (fanOut) {
          double m = cards.length == 2 ? 0.50 : mid.toDouble();

          return Transform.rotate(
            alignment: Screen.isLargeScreen
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            origin: Offset(0, 0),
            angle: -((i - m) * 0.10),
            child: card,
          );
        } else {
          return card;
        }
      },
    );

    final totalCardSize = _getTotalCardsSize(context, displacementValue);

    // this empty container makes sure that HIT TEST (tappings) works
    // this container is used to expand the width of the stack
    children.add(Container(
      color: Colors.transparent,
      width: totalCardSize.width,
      height: totalCardSize.height,
    ));

    return children.reversed.toList();
  }

  Widget _buildCardWidget({
    @required BuildContext context,
    @required double xOffset,
    @required int mid,
    @required MarkedCards markedCards,
    @required double displacementValue,
    bool isCardVisible = false,
  }) {
    return FittedBox(
      child: Transform.translate(
        offset: Offset(xOffset, 0.0),
        child: Stack(
          alignment: Alignment.center,
          children: _getChildren(
            context: context,
            mid: mid,
            markedCards: markedCards,
            displacementValue: displacementValue,
            isCardVisible: isCardVisible,
          ),
        ),
      ),
    );
  }

  Widget _buildFannedCards({
    @required BuildContext context,
    @required double xOffset,
    @required int mid,
    @required MarkedCards markedCards,
    @required double displacementValue,
  }) {
    return FittedBox(
      child: Transform.translate(
        offset: Offset(xOffset, 0.0),
        child: Stack(
          alignment: Alignment.center,
          children: _getChildren(
            context: context,
            mid: mid,
            markedCards: markedCards,
            displacementValue: displacementValue,
            isCardVisible: isCardVisible,
            fanOut: true,
          ),
        ),
      ),
    );
  }

  double getEvenNoDisplacement(double displacementValue) {
    if (cards.length % 2 == 0) return -displacementValue / 2;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final GameState gameState = GameState.getState(context);
    final MarkedCards markedCards = gameState.markedCardsState;
    if (cards == null || cards.isEmpty) {
      // log('Customize: HoleCards: build cards are empty. $cards');
      return const SizedBox.shrink();
    }
    int mid = (cards.length ~/ 2);
    gameState.gameUIState.calculateCardSize(context, gameState, cards.length);

    double displacementValue = gameState.gameUIState.cardsDisplacement;
    print(displacementValue);

    final double evenNoDisplacement = getEvenNoDisplacement(displacementValue);

    final Widget frontCardsView = _buildCardWidget(
      context: context,
      xOffset: evenNoDisplacement,
      mid: mid,
      markedCards: markedCards,
      displacementValue: displacementValue,
      isCardVisible: true,
    );

    final Widget backCardsView = _buildCardWidget(
      context: context,
      xOffset: evenNoDisplacement,
      mid: mid,
      markedCards: markedCards,
      displacementValue: displacementValue,
      isCardVisible: false,
    );

    // if need to show front card, do not procced to build the page curling effect
    if (isCardVisible) {
      return GestureDetector(
        onHorizontalDragEnd: (e) {
          log('onHorizontalDragEnd. ${e.velocity}');
          int i = 1;
          if (e.velocity.pixelsPerSecond.dx < 0) {
            i = -1;
          }
          gameState.changeHoleCardOrder(inc: i);
        },
        child: _buildFannedCards(
          context: context,
          xOffset: evenNoDisplacement,
          mid: mid,
          markedCards: markedCards,
          displacementValue: displacementValue,
        ),
      );
    }

    final tcs = _getTotalCardsSize(context, displacementValue);

    return PageCurl(
      back: Transform.rotate(angle: math.pi, child: frontCardsView),
      front: backCardsView,
      size: tcs,
    );
  }
}
