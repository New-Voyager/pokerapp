import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/card_view.dart';

class StackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool deactivated;
  final bool horizontal;

  StackCardView({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (cards == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: cards.isEmpty
          ? [SizedBox.shrink()]
          : cards.reversed
              .toList()
              .map(
                (c) => deactivated
                    ? CardView(card: c, grayOut: true)
                    : CardView(card: c),
              )
              .toList()
              .reversed
              .toList(),
    );
  }
}
