import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class StackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool center;

  StackCardView({
    @required this.cards,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    int n = center ? cards.length : 0;
    double ctr = center ? AppDimensions.cardWidth / 2 : 0;

    return Stack(
      alignment: Alignment.center,
      children: cards.isEmpty
          ? [SizedBox.shrink()]
          : cards
              .asMap()
              .entries
              .map(
                (c) => Transform.translate(
                  offset: Offset(
                    -AppDimensions.cardWidth * (c.key - n / 2) - ctr,
                    0.0,
                  ),
                  child: c.value.widget,
                ),
              )
              .toList()
              .reversed
              .toList(),
    );
  }
}
