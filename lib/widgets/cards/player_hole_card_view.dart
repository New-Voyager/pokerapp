import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
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
    return Stack(
      children: [
        /* center suit */
        Align(
          child: Text(
            card.suit ?? AppConstants.redHeart,
            style: suitTextStyle,
          ),
        ),

        /* top left suit */
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
              ),
              Text(
                card.suit ?? AppConstants.redHeart,
                style: suitTextStyle.copyWith(fontSize: 11),
              ),
            ],
          ),
          top: 5,
          left: 5,
        ),

        /* bottom right suit */
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
              ),
              Text(
                card.suit ?? AppConstants.redHeart,
                style: suitTextStyle.copyWith(fontSize: 11),
              ),
            ],
          ),
          bottom: 5,
          right: 5,
        ),

        /* visible marker */
        Positioned(
          bottom: 5,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardBuilderWidget(
      card: card,
      dim: dim,
      shadow: true,
      isCardVisible: isCardVisible,
      cardBuilder: _buildCardUI,
      cardFace: isCardVisible ? CardFace.FRONT : CardFace.BACK,
    );
  }
}
