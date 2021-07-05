import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';
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
    double holeCardRatio = CardBuilderWidget.getCardRatioFromCardType(
      CardType.HoleCard,
      context,
    );

    final double sch = AppDimensions.cardHeight * holeCardRatio;
    final double scw = AppDimensions.cardWidth * holeCardRatio;
    final double tw = scw + displacementValue * (cards.length - 1);

    return Size(tw, sch);
  }

  List<Widget> _getChildren({
    @required BuildContext context,
    @required int mid,
    @required MarkedCards markedCards,
    @required double displacementValue,
    bool isCardVisible = false,
  }) {
    List<Widget> children = List.generate(
      cards.length,
      (i) {
        final offsetInX = -(i - mid) * displacementValue;
        return Transform.translate(
          offset: Offset(offsetInX, 0),
          child: Builder(
            builder: (context) => PlayerHoleCardView(
              marked: markedCards.isMarked(cards[i]),
              onMarkTapCallback: () => markedCards.mark(
                cards[i],
                context.read<ValueNotifier<FooterStatus>>().value ==
                    FooterStatus.Result,
              ),
              card: cards[i],
              dim: deactivated,
              isCardVisible: isCardVisible,
            ),
          ),
        );
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
  }) =>
      FittedBox(
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

  double getEvenNoDisplacement(double displacementValue) {
    if (cards.length % 2 == 0) return -displacementValue / 2;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    print('isCardVisible: $isCardVisible');

    final GameState gameState = GameState.getState(context);

    final MarkedCards markedCards = gameState.getMarkedCards(
      context,
      listen: true,
    );

    if (cards == null || cards.isEmpty) return const SizedBox.shrink();
    int mid = (cards.length ~/ 2);

    final double displacementValue =
        BoardAttributesObject.holeCardViewDisplacementConstant;

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
    if (isCardVisible) return frontCardsView;

    final tcs = _getTotalCardsSize(context, displacementValue);

    return PageCurl(
      back: Transform.rotate(angle: pi, child: frontCardsView),
      front: backCardsView,
      size: tcs,
    );
  }
}
