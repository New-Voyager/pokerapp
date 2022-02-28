import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';
import 'package:pokerapp/widgets/cards/player_hole_card_view.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
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
    // double holeCardRatio = CardBuilderWidget.getCardRatioFromCardType(
    //   CardType.HoleCard,
    //   context,
    // );

    final gameState = GameState.getState(context);
    // double holeCardsViewWidth = gameState.holeCardsViewSize.width;

    // double ratioo = 1;

    // if (cards.length == 2) {
    //   ratioo = 1.45;
    // } else if (cards.length == 4) {
    //   ratioo = 1.85;
    // } else if (cards.length == 5) {
    //   ratioo = 1.85;
    // } else if (cards.length == 6) {
    //   ratioo = 2.2;
    // }

    // ratioo

    // gameState.cardsSizeRatio = ratioo;

    // double cardWidth = holeCardsViewWidth / ratioo;
    // double cardWidth = holeCardsViewWidth - (displacementValue * cards.length);
    // double cardWidth = holeCardsViewWidth / (cards.length / 3);
    // gameState.cardWidth = cardWidth;
    final double sch = gameState.cardWidth * 38 / 30;
    final double scw = gameState.cardWidth;

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
        var offsetInX = -(i - mid) * displacementValue;

        if (cards.length.isEven) {
          offsetInX = offsetInX - displacementValue / 2;
        } else {
          offsetInX = offsetInX;
        }
        final card = Transform.translate(
          offset: Offset(offsetInX, 0),
          child: Builder(
            builder: (context) => DebugBorderWidget(
              child: PlayerHoleCardView(
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
          ),
        );
        if (fanOut) {
          double m = cards.length == 2 ? 0.50 : mid.toDouble();

          int ss = context.read<BoardAttributesObject>().screenDiagnolSize;

          Alignment _getAlignment(int ss) {
            if (ss <= 7) return Alignment.bottomCenter;

            return Alignment.topCenter;
          }

          return Transform.rotate(
            alignment: _getAlignment(ss),
            // 6 inch: 0.25
            // 10 inch: 0.10
            origin: Offset(0, 0),
            // angle: -((i - m) * 0.10),
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
    return Stack(
      alignment: Alignment.center,
      children: _getChildren(
        context: context,
        mid: mid,
        markedCards: markedCards,
        displacementValue: displacementValue,
        isCardVisible: isCardVisible,
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
    context.read<BoardAttributesObject>().noOfCards = cards?.length ?? 0;
    final GameState gameState = GameState.getState(context);
    final boardAttributes = gameState.getBoardAttributes(context);

    final MarkedCards markedCards = gameState.markedCardsState;
    //log('HoleCards: build cards: $cards');
    if (cards == null || cards.isEmpty) {
      // log('Customize: HoleCards: build cards are empty. $cards');
      return const SizedBox.shrink();
    }
    int mid = (cards.length ~/ 2);

    double displacementValue = boardAttributes.getHoleCardDisplacement(
      noOfCards: cards.length,
      isCardVisible: isCardVisible,
    );

    // if (cards.length == 2) {
    //   displacementValue = 2 * displacementValue;
    // }

    double cardWidth = gameState.holeCardsViewSize.width / 3;

    if (cards.length == 2) {
      displacementValue = gameState.holeCardsViewSize.width / 5;
      if (context.read<BoardAttributesObject>().screenDiagnolSize >= 7) {
        displacementValue = gameState.holeCardsViewSize.width * 0.25;
      }
      // cardWidth = gameState.holeCardsViewSize.width / cards.length;
    } else if (cards.length == 3) {
      displacementValue = gameState.holeCardsViewSize.width / 8;
      if (context.read<BoardAttributesObject>().screenDiagnolSize >= 7) {
        displacementValue = gameState.holeCardsViewSize.width * 0.17;
      }
      // cardWidth = gameState.holeCardsViewSize.width / cards.length;
    } else if (cards.length == 4) {
      displacementValue = gameState.holeCardsViewSize.width / 10;
      if (context.read<BoardAttributesObject>().screenDiagnolSize >= 7) {
        displacementValue = gameState.holeCardsViewSize.width * 0.14;
      }
      // cardWidth = gameState.holeCardsViewSize.width / cards.length;
    } else if (cards.length == 5) {
      displacementValue = gameState.holeCardsViewSize.width / 15;
      if (context.read<BoardAttributesObject>().screenDiagnolSize >= 7) {
        displacementValue = gameState.holeCardsViewSize.width * 0.12;
      }
      // cardWidth = gameState.holeCardsViewSize.width / cards.length;
    } else if (cards.length == 6) {
      displacementValue = gameState.holeCardsViewSize.width / 20;
      if (context.read<BoardAttributesObject>().screenDiagnolSize >= 7) {
        displacementValue = gameState.holeCardsViewSize.width * 0.1;
      }
      // cardWidth = gameState.holeCardsViewSize.width / cards.length;
    }

    displacementValue = 35;

    // print(displacementValue);

    // double maxCardWidth = gameState.holeCardsViewSize.width / 1.6;
    // double cardWidth = (gameState.holeCardsViewSize.width / cards.length);
    // double overlapValue = gameState.holeCardsViewSize.width / (cards.length);
    // cardWidth += overlapValue;
    // if (cardWidth > maxCardWidth) {
    //   cardWidth = maxCardWidth;
    // }
    cardWidth =
        gameState.holeCardsViewSize.width - (displacementValue * cards.length);
    gameState.cardWidth = cardWidth;

    // print(cardWidth);

    // double minDisplacementValue = 20;

    // displacementValue = cardWidth / (1 * cards.length);
    // if (displacementValue < minDisplacementValue) {
    //   displacementValue = minDisplacementValue;
    // }

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
