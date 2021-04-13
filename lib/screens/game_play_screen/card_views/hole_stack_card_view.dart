import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/marked_cards.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/game_card/game_card_widget.dart';
import 'package:provider/provider.dart';

const double pullUpOffset = -15.0;
const kDisplacementConstant = 40.0;
const kAngleConstant = 0.05;

class HoleStackCardView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final footerStatus = Provider.of<ValueNotifier<FooterStatus>>(
      context,
      listen: false,
    ).value;

    if (footerStatus == FooterStatus.Result) return SizedBox.shrink();

    final MarkedCards markedCards = GameState.getState(context).getMarkedCards(
      context,
      listen: true,
    );

    if (cards == null || cards.isEmpty) return const SizedBox.shrink();
    int mid = (cards.length ~/ 2);

    return Container(
      child: Transform.translate(
        offset: Offset(-15, 30),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: List.generate(
            cards.length,
            (i) => Transform.translate(
              offset: Offset(
                (i + 1 - mid) * kDisplacementConstant,
                0,
              ),
              child: Transform.rotate(
                alignment: Alignment.bottomLeft,
                angle: (i - mid) * kAngleConstant,
                child: Transform.translate(
                  offset: Offset(
                    0.0,
                    cards[i].highlight ? pullUpOffset : 0.0,
                  ),
                  child: deactivated
                      ? GameCardWidget(
                          marked: markedCards.isMarked(cards[i]),
                          onMarkTapCallback: () => markedCards.mark(cards[i]),
                          card: cards[i],
                          grayOut: true,
                          isCardVisible: isCardVisible,
                        )
                      : GameCardWidget(
                          marked: markedCards.isMarked(cards[i]),
                          onMarkTapCallback: () => markedCards.mark(cards[i]),
                          card: cards[i],
                          isCardVisible: isCardVisible,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
