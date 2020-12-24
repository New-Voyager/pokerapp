import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

class StackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool center;
  final bool deactivated;
  final bool isCommunity;

  StackCardView({
    @required this.cards,
    this.center = false,
    this.deactivated = false,
    this.isCommunity = false,
  });

  @override
  Widget build(BuildContext context) {
    if (cards == null) return const SizedBox.shrink();

    if (isCommunity)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cards.isEmpty
            ? [SizedBox.shrink()]
            : cards.reversed
                .toList()
                .map(
                  (c) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    child: deactivated ? c.grayedWidget : c.widget,
                  ),
                )
                .toList()
                .reversed
                .toList(),
      );

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
