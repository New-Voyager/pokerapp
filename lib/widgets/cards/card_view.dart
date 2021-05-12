import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/widgets/cards/card_builder_widget.dart';

final cardBackImage = new Image(
  image: AssetImage('assets/images/card_back/set2/Asset 6.png'),
);

class CardView extends StatelessWidget {
  final CardObject card;

  CardView({
    @required this.card,
  });

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: FittedBox(
              child: Text(
                card.label == 'T' ? '10' : card.label,
                style: cardTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: FittedBox(
              child: RichText(
                text: TextSpan(
                  text: card.suit ?? AppConstants.redHeart,
                  style: suitTextStyle,
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return CardBuilderWidget(
      card: card,
      dim: card.dim,
      isCardVisible: true,
      cardBuilder: _buildCardUI,
      roundRadius: 2.5,
    );
  }
}
