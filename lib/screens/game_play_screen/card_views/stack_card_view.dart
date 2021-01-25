import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_dimensions.dart';

const double pullUpOffset = -15.0;

class StackCardView extends StatelessWidget {
  final List<CardObject> cards;
  final bool center;
  final bool deactivated;
  final bool isCommunity;
  final bool horizontal;

  StackCardView({
    @required this.cards,
    this.center = false,
    this.deactivated = false,
    this.isCommunity = false,
    this.horizontal = true,
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
                  (c) => Transform.translate(
                    offset: Offset(
                      0.0,
                      c.highlight ? pullUpOffset : 0.0,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: deactivated ? c.grayedWidget : c.widget,
                    ),
                  ),
                )
                .toList()
                .reversed
                .toList(),
      );

    int n = center ? cards.length : 0;
    double ctr = center ? AppDimensions.cardWidth / 2 : 0;

    /* MY CARDS */
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
                    /* TODO: MY CARD  */
                    -AppDimensions.cardWidth * 1.2 * (c.key - n / 2) - ctr,
                    c.value.highlight ? pullUpOffset : 0.0,
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
