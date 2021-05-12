import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/cards/player_hole_card_view.dart';
import 'package:provider/provider.dart';

class HoleStackCardView2 extends StatelessWidget {
  final List<CardObject> cards;
  final bool deactivated;
  final bool horizontal;
  final bool isCardVisible;

  HoleStackCardView2({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true,
    this.isCardVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final footerStatus = Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value;

    if (footerStatus == FooterStatus.Result) return SizedBox.shrink();
    final GameState gameState = GameState.getState(context);

    final MarkedCards markedCards = gameState.getMarkedCards(
      context,
      listen: true,
    );

    // final BoardAttributesObject boardAttributesObject =
    //     gameState.getBoardAttributes(
    //   context,
    // );

    if (cards == null || cards.isEmpty) return const SizedBox.shrink();
    int mid = (cards.length ~/ 2);

    final double kDisplacementConstant =
        BoardAttributesObject.holeCardViewDisplacementConstant;
    final double kAngleConstant =
        BoardAttributesObject.holeCardViewAngleConstant;

    double getEvenNoDisplacement() {
      if (cards.length % 2 == 0) return -kDisplacementConstant / 2;

      return 0.0;
    }

    return FittedBox(
      child: Transform.translate(
        offset: Offset(
          getEvenNoDisplacement(),
          0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            cards.length,
            (i) {
              return Transform.translate(
                offset: Offset(
                  -(i - mid) * kDisplacementConstant,
                  0,
                ),
                child: Transform.rotate(
                  alignment: Alignment.bottomCenter,
                  angle: (i - mid) * kAngleConstant,
                  child: deactivated
                      ? PlayerHoleCardView(
                          marked: markedCards.isMarked(cards[i]),
                          onMarkTapCallback: () => markedCards.mark(cards[i]),
                          card: cards[i],
                          dim: true,
                          isCardVisible: isCardVisible,
                        )
                      : PlayerHoleCardView(
                          marked: markedCards.isMarked(cards[i]),
                          onMarkTapCallback: () => markedCards.mark(cards[i]),
                          card: cards[i],
                          isCardVisible: isCardVisible,
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
