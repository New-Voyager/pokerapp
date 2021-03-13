import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/screens/game_play_screen/game_card/game_card_widget.dart';
import 'package:pokerapp/widgets/card_view.dart';

const double pullUpOffset = -15.0;
const kDisplacementConstant = 15.0;

class HoleStackCardView extends StatefulWidget {
  final List<CardObject> cards;
  final bool deactivated;
  final bool horizontal;

  HoleStackCardView({
    @required this.cards,
    this.deactivated = false,
    this.horizontal = true,
  });

  @override
  _HoleStackCardViewState createState() => _HoleStackCardViewState();
}

class _HoleStackCardViewState extends State<HoleStackCardView> {
  bool isCardVisible;

  _HoleStackCardViewState({this.isCardVisible = false});

  @override
  Widget build(BuildContext context) {
    if (widget.cards == null || widget.cards.isEmpty) return const SizedBox.shrink();
    double mid = (widget.cards.length / 2);

    return GestureDetector(
      onTap: () => setState(()=> isCardVisible = !isCardVisible),
      child: AnimatedContainer(
        duration: Duration(milliseconds:800 ),
        child: Transform.translate(
          offset: Offset(-15,0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: List.generate(
              widget.cards.length,
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
                      widget.cards[i].highlight ? pullUpOffset : 0.0,
                    ),
                    child: widget.deactivated
                        ? GameCardWidget(card: widget.cards[i], grayOut: true,isCardVisible: isCardVisible,)
                        : GameCardWidget(card: widget.cards[i],isCardVisible: isCardVisible),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.cards.isEmpty
          ? [SizedBox.shrink()]
          : widget.cards.reversed
              .toList()
              .map(
                (c) => Transform.translate(
                  offset: Offset(
                    0.0,
                    c.highlight ? pullUpOffset : 0.0,
                  ),
                  child: widget.deactivated
                      ? CardView(card: c, grayOut: true)
                      : CardView(card: c),
                ),
              )
              .toList()
              .reversed
              .toList(),
    );
  }
}
