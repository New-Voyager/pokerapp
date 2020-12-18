import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class StackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool center;
  final bool deactivated;

  StackCardView({
    @required this.cards,
    this.center = false,
    this.deactivated = false,
  });

  @override
  Widget build(BuildContext context) {
    int n = center ? cards.length : 0;
    double ctr = center ? AppDimensions.cardWidth / 2 : 0;

    return Stack(
      alignment: Alignment.center,
      children: cards.isEmpty
          ? [SizedBox.shrink()]
          : cards.reversed
              .toList()
              .asMap()
              .entries
              .map(
                (c) => Transform.translate(
                  offset: Offset(
                    -AppDimensions.cardWidth * (c.key - n / 2) - ctr,
                    0.0,
                  ),
                  child: deactivated ? c.value.grayedWidget : c.value.widget,
                ),
              )
              .toList()
              .reversed
              .toList(),
    );
  }
}
