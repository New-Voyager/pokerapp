import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';

class PlayerHoleCardView extends StatelessWidget {
  final CardObject card;
  final bool dim;
  final bool isCardVisible;
  final bool marked;
  final Function onMarkTapCallback;

  PlayerHoleCardView({
    @required this.card,
    this.onMarkTapCallback,
    this.marked = false,
    this.dim = false,
    this.isCardVisible = false,
  });

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
  ) {
    return Stack(fit: StackFit.expand, children: [
      SvgPicture.asset('assets/images/card_face/${card.cardNum}.svg'),
      /* visible marker */
      Positioned(
        top: 40,
        left: 5,
        child: marked
            ? Icon(
                Icons.visibility,
                color: Colors.green,
              )
            : const SizedBox.shrink(),
      ),

      /* tap widget */
      Positioned(
        top: 0,
        left: 0,
        bottom: 0,
        width: 30,
        child: GestureDetector(
          onTap: onMarkTapCallback,
        ),
      )
    ]);
    //return Image.asset('assets/images/card_face/${card.cardNum}.png');
  }

  @override
  Widget build(BuildContext context) {
    return CardBuilderWidget(
      highlight: false,
      card: card,
      dim: dim,
      shadow: true,
      isCardVisible: isCardVisible,
      cardBuilder: _buildCardUI,
      cardFace: isCardVisible ? CardFace.FRONT : CardFace.BACK,
    );
  }
}
