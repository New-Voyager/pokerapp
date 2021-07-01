import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/page_curl/page_curl.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';
import 'package:pokerapp/widgets/cards/player_hole_card_view.dart';
import 'package:provider/provider.dart';

class HoleStackCardView extends StatefulWidget {
  final List<CardObject> cards;
  final bool deactivated;
  final bool horizontal;
  final bool isCardVisible;

  HoleStackCardView({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true,
    this.isCardVisible = false,
  });

  @override
  _HoleStackCardViewState createState() => _HoleStackCardViewState();
}

class _HoleStackCardViewState extends State<HoleStackCardView> {
  GlobalKey _cardsGlobalKey = GlobalKey();
  Size size;
  double totalOffsetValue = 0.0;

  Widget _buildCardWidget({
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
            // mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.cards.length,
              (i) {
                final offsetInX = -(i - mid) * displacementValue;
                totalOffsetValue += offsetInX;

                return Transform.translate(
                  offset: Offset(offsetInX, 0),
                  child: Builder(
                    builder: (context) => PlayerHoleCardView(
                      marked: markedCards.isMarked(widget.cards[i]),
                      onMarkTapCallback: () => markedCards.mark(
                        widget.cards[i],
                        context.read<ValueNotifier<FooterStatus>>().value ==
                            FooterStatus.Result,
                      ),
                      card: widget.cards[i],
                      dim: widget.deactivated,
                      isCardVisible: isCardVisible,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

  double getEvenNoDisplacement(double kDisplacementConstant) {
    if (widget.cards.length % 2 == 0) return -kDisplacementConstant / 2;
    return 0.0;
  }

  void _captureSize(Duration _) async {
    final RenderRepaintBoundary boundary = _cardsGlobalKey.currentContext
        .findRenderObject() as RenderRepaintBoundary;
    if (boundary.debugNeedsPaint || !boundary.hasSize) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _captureSize(_);
    }

    setState(() => size = boundary.size);

    print("we got the size: $size");
  }

  @override
  Widget build(BuildContext context) {
    final GameState gameState = GameState.getState(context);

    final MarkedCards markedCards = gameState.getMarkedCards(
      context,
      listen: true,
    );

    if (widget.cards == null || widget.cards.isEmpty)
      return const SizedBox.shrink();
    int mid = (widget.cards.length ~/ 2);

    final double displacementValue =
        BoardAttributesObject.holeCardViewDisplacementConstant;

    final Widget frontCardsView = _buildCardWidget(
      xOffset: getEvenNoDisplacement(displacementValue),
      mid: mid,
      markedCards: markedCards,
      displacementValue: displacementValue,
      isCardVisible: true,
    );

    final Widget backCardsView = _buildCardWidget(
      xOffset: getEvenNoDisplacement(displacementValue),
      mid: mid,
      markedCards: markedCards,
      displacementValue: displacementValue,
      isCardVisible: false,
    );

    if (size == null) {
      WidgetsBinding.instance.addPostFrameCallback(_captureSize);

      return RepaintBoundary(
        key: _cardsGlobalKey,
        child: backCardsView,
      );
    }

    final double singleCardWidth = AppDimensions.cardWidth *
        CardBuilderWidget.getCardRatioFromCardType(
          CardType.HoleCard,
          context,
        );

    final double totalWidth = singleCardWidth * widget.cards.length;

    print('single card width: $singleCardWidth');
    print('total Length: $totalWidth');
    print('total offset value: $totalOffsetValue');

    print('\n\nbuilding PAGE CURL\n\n');
    final width = singleCardWidth - 24;
    final height = size.height;
    return Container(
      color: Colors.white12,
      // child: backCardsView,
      child: PageCurl(
        key: UniqueKey(),
        vertical: true,
        back: Transform.rotate(angle: pi, child: frontCardsView),
        front: backCardsView,
        size: Size(width, height),
      ),
    );

    // return FittedBox(
    //   child: Transform.translate(
    //     offset: Offset(
    //       getEvenNoDisplacement(),
    //       0.0,
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       children: List.generate(
    //         cards.length,
    //         (i) {
    //           return Transform.translate(
    //             offset: Offset(
    //               -(i - mid) * displacementValue,
    //               0,
    //             ),
    //             child: Transform.rotate(
    //               alignment: Alignment.bottomCenter,
    //               angle: (i - mid) * kAngleConstant,
    //               child: PlayerHoleCardView(
    //                 marked: markedCards.isMarked(cards[i]),
    //                 onMarkTapCallback: () => markedCards.mark(
    //                   cards[i],
    //                   context.read<ValueNotifier<FooterStatus>>().value ==
    //                       FooterStatus.Result,
    //                 ),
    //                 card: cards[i],
    //                 dim: deactivated,
    //                 isCardVisible: true,
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
