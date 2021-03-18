import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/game_card/game_card_widget.dart';
import 'package:pokerapp/widgets/card_view.dart';

const double pullUpOffset = -15.0;
const kDisplacementConstant = 15.0;

class HoleStackCardView extends StatelessWidget {

  final List<CardObject> cards;
  final bool deactivated;
  final bool horizontal;
  final bool isCardVisible;

  HoleStackCardView({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true, this.isCardVisible = false,
  });


  @override
  Widget build(BuildContext context) {
    if (cards == null || cards.isEmpty) return const SizedBox.shrink();
    double mid = (cards.length / 2);

    return Container(
      child: Transform.translate(
        offset: Offset(-15,30),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: List.generate(
            cards.length,
                (i) => Transform.translate(
              offset: Offset(
                kDisplacementConstant * i,
                -i * 1.50,
              ),
              child: Transform.rotate(
                alignment: Alignment.bottomLeft,
                angle: (i - mid) * 0.20,
                child:Transform.translate(
                  offset: Offset(
                    0.0,
                    cards[i].highlight ? pullUpOffset : 0.0,
                  ),
                  child: deactivated
                      ? GameCardWidget(card: cards[i], grayOut: true,isCardVisible: isCardVisible)
                      : GameCardWidget(card: cards[i],isCardVisible: isCardVisible,),
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
